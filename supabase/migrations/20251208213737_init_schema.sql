--Profiles
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text not null,
  last_seen timestamptz default now(),
  last_name text not null,
  email text unique not null,
  avatar_url text,
  expo_push_token text,
  timezone text default 'UTC',
  bio text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);


create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
as $$
begin
  insert into public.profiles (id, first_name,last_name, email)
  values (new.id, new.raw_user_meta_data->>'first_name',new.raw_user_meta_data->>'last_name', new.email);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

create or replace function public.update_profile(
  p_first_name text default null,
  p_last_name text default null,
  p_avatar_url text default null,
  p_bio text default null
)
returns void
language plpgsql
security definer
as $$
begin
  update public.profiles
  set
    first_name = coalesce(p_first_name, first_name),
    last_name  = coalesce(p_last_name, last_name),
    avatar_url = coalesce(p_avatar_url, avatar_url),
    bio        = coalesce(p_bio, bio),
    updated_at = now()
  where id = auth.uid();

  if not found then
    raise exception 'Profile not found for user %', auth.uid();
  end if;
end;
$$;



alter table public.profiles enable row level security;


create policy "profiles are viewable by everyone"
  on public.profiles
  for select
  using (true);

create policy "users can insert their own profile"
  on public.profiles
  for insert
  with check (auth.uid() = id);

create policy "users can update their own profile"
  on public.profiles
  for update
  using (auth.uid() = id)
  with check (auth.uid() = id);


create index if not exists idx_profiles_email on public.profiles(email);



-- Devotional Plans
create table if not exists public.devotional_plans (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text not null,
  cover_image text,
  completions int default 0,
  tags text,
  status text check (status in ('draft', 'published')) default 'draft',
  total_days int not null default 1,
  author_id uuid references auth.users(id) on delete set null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()

);


alter table public.devotional_plans enable row level security;



create policy "plans are viewable by everyone"
  on public.devotional_plans
  for select
  using (true);


create policy "only authenticated users can create plans"
  on public.devotional_plans
  for insert
  with check (auth.uid() = author_id);

create policy "authors can update their plans"
  on public.devotional_plans
  for update
  using (auth.uid() = author_id)
  with check (auth.uid() = author_id);

create policy "authors can delete their plans"
  on public.devotional_plans
  for delete
  using (auth.uid() = author_id);


  create index if not exists idx_devotional_plans_author_id on public.devotional_plans(author_id);
  create index if not exists idx_devotional_plans_id on public.devotional_plans(id);

create or replace function save_devotional_draft(
  _plan_id uuid,
  _days jsonb
)
returns void
language plpgsql
security definer
as $$
begin
  -- Insert / update days
  insert into public.devotional_days_draft (plan_id, day_number, content, title)
  select
    _plan_id,
    (d->>'day_number')::int,
    d->>'content',
    d->>'title'
  from jsonb_array_elements(_days) d
  on conflict (plan_id, day_number)
  do update set
    content = excluded.content,
    title = excluded.title,
    updated_at = now();

  -- Replace scriptures
  delete from public.scripture_references_draft
  where day_id in (
    select id from public.devotional_days_draft
    where plan_id = _plan_id
  );

  insert into public.scripture_references_draft (day_id, reference)
  select
    dd.id,
    array(
      select jsonb_array_elements_text(d->'scriptures')
    )
  from jsonb_array_elements(_days) d
  join public.devotional_days_draft dd
    on dd.plan_id = _plan_id
   and dd.day_number = (d->>'day_number')::int;
end;
$$;


create or replace function get_devotional_drafts(
  _plan_id uuid
)
returns table (
  day_id uuid,
  day_number int,
  content text,
  title text,
  scriptures text[]
)
language plpgsql
security definer
as $$
begin
  return query
  select
    d.id,
    d.day_number,
    d.content,
    d.title,
    coalesce(s.reference, '{}')
  from public.devotional_days_draft d
  left join public.scripture_references_draft s
    on s.day_id = d.id
  where d.plan_id = _plan_id
    and exists (
      select 1
      from public.devotional_plans p
      where p.id = d.plan_id
        and p.author_id = auth.uid()
    )
  order by d.day_number;
end;
$$;



create or replace function public.publish_devotional_plan(
  p_plan_id uuid,
  p_days jsonb
)
returns void
language plpgsql
security definer
as $$
declare
  day_item jsonb;
  upserted_day_id uuid;
  draft_day_id uuid;
  published_days_count int;
begin
  -- Auth check
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;

  -- Ownership check
  if not exists (
    select 1
    from public.devotional_plans
    where id = p_plan_id
      and author_id = auth.uid()
  ) then
    raise exception 'Not authorized';
  end if;

  -- Count valid days
  select count(*)
  into published_days_count
  from jsonb_array_elements(p_days) d
  where trim(coalesce(d ->> 'content', '')) <> '';

  -- ?? Exit if no valid content
  if published_days_count = 0 then
    raise exception 'No content found';
  end if;

  -- Loop only over valid days
  for day_item in
    select d
    from jsonb_array_elements(p_days) d
    where trim(coalesce(d ->> 'content', '')) <> ''
  loop

    -- Get draft day id
    select id
    into draft_day_id
    from public.devotional_days_draft
    where plan_id = p_plan_id
      and day_number = (day_item ->> 'day_number')::int;

    -- Upsert published day
    insert into public.devotional_days (
      id,
      plan_id,
      day_number,
      content,
      title
    )
    values (
      (day_item ->> 'id')::uuid,
      p_plan_id,
      (day_item ->> 'day_number')::int,
      day_item ->> 'content',
      day_item ->> 'title'
    )
    on conflict (plan_id, day_number)
    do update set
      content = excluded.content,
      title = excluded.title,
      updated_at = now()
    returning id into upserted_day_id;

    -- Replace scriptures
    delete from public.scripture_references
    where day_id = upserted_day_id;

    if jsonb_array_length(coalesce(day_item -> 'scriptures', '[]'::jsonb)) > 0 then
      insert into public.scripture_references (day_id, reference)
      select
        upserted_day_id,
        array_agg(value)
      from jsonb_array_elements_text(day_item -> 'scriptures');
    end if;

    -- Cleanup draft
    if draft_day_id is not null then
      delete from public.scripture_references_draft
      where day_id = draft_day_id;

      delete from public.devotional_days_draft
      where plan_id = p_plan_id;
    end if;

  end loop;

  -- Update plan
  update public.devotional_plans
  set
    status = 'published',
    total_days = published_days_count,
    updated_at = now()
  where id = p_plan_id
    and author_id = auth.uid();

end;
$$;

create or replace function public.get_devotional_days_with_scriptures(
  p_plan_id uuid
)
returns table (
  day_id uuid,
  day_number int,
  content text,
  title text,
  scriptures text[]
)
language plpgsql
as $$
begin
  return query
  select
    d.id,
    d.day_number,
    d.content,
    d.title,
    coalesce(s.reference, '{}')
  from public.devotional_days d
  left join public.scripture_references s
    on s.day_id = d.id
  where d.plan_id = p_plan_id
    and exists (
      select 1
      from public.devotional_plans p
      where p.id = d.plan_id
        and p.author_id = auth.uid()
    )
  order by d.day_number;
end;
$$;



--Devotional days
create table if not exists public.devotional_days (
  id uuid primary key default gen_random_uuid(),
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  day_number int not null,
  content text not null,
  title text,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique (plan_id, day_number)
);


alter table public.devotional_days enable row level security;


create policy "devotional_days are public read"
  on public.devotional_days
  for select
  using (true);

create policy "authors insert days"
  on public.devotional_days
  for insert
  with check (
    exists (
      select 1
      from public.devotional_plans p
      where p.id = plan_id 
      and p.author_id = auth.uid()
    )
  );

create policy "authors update days"
  on public.devotional_days
  for update
  using (
    exists (
      select 1
      from public.devotional_plans p
      where p.id = plan_id 
      and p.author_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from public.devotional_plans p
      where p.id = plan_id 
      and p.author_id = auth.uid()
    )
  );

create policy "authors delete days"
  on public.devotional_days
  for delete
  using (
    exists (
      select 1
      from public.devotional_plans p
      where p.id = plan_id 
      and p.author_id = auth.uid()
    )
  );


create index if not exists idx_devotional_days
  on public.devotional_days(plan_id, day_number);

--Devotional days
create table if not exists public.devotional_days_draft (
  id uuid primary key default gen_random_uuid(),
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  day_number int not null,
  content text not null,
  title text,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique (plan_id, day_number)
);

alter table public.devotional_days_draft enable row level security;


create policy "devotional_days_draft are not public read"
  on public.devotional_days_draft
  for select
  using (
    exists (
      select 1
      from public.devotional_plans p
      where p.id = plan_id 
      and p.author_id = auth.uid()
    )
  );
create policy "authors insert days"
  on public.devotional_days_draft
  for insert
  with check (
    exists (
      select 1
      from public.devotional_plans p
      where p.id = plan_id 
      and p.author_id = auth.uid()
    )
  );

create policy "authors update days"
  on public.devotional_days_draft
  for update
  using (
    exists (
      select 1
      from public.devotional_plans p
      where p.id = plan_id 
      and p.author_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from public.devotional_plans p
      where p.id = plan_id 
      and p.author_id = auth.uid()
    )
  );

create policy "authors delete days"
  on public.devotional_days_draft
  for delete
  using (
    exists (
      select 1
      from public.devotional_plans p
      where p.id = plan_id 
      and p.author_id = auth.uid()
    )
  );


create index if not exists idx_devotional_days_draft
  on public.devotional_days_draft(plan_id, day_number);

create or replace function get_my_devotional_plans()
returns table (
  id uuid,
  title text,
  status text,
  description text,
  total_days int,
  cover_image text,
  created_at timestamptz,
  likes_count int,
  dislikes_count int
)
language plpgsql
security definer
as $$
begin
  return query
  select
    p.id,
    p.title,
    p.status,
    p.description,
    p.total_days,
    p.cover_image,
    p.created_at,

    -- ?? likes
    count(*) filter (where r.reaction_type = 'like')::int as likes_count,

    -- ?? dislikes
    count(*) filter (where r.reaction_type = 'dislike')::int as dislikes_count

  from public.devotional_plans p
  left join public.plan_reactions r
    on r.plan_id = p.id
  where p.author_id = auth.uid()
  group by p.id
  order by p.created_at desc;
end;
$$;



--Scripture references
create table if not exists public.scripture_references (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  day_id uuid references public.devotional_days(id) on delete cascade,
  reference text[] default '{}',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);


alter table public.scripture_references enable row level security;


create policy "scripture refs public read"
  on public.scripture_references
  for select using (true);


create policy "authors manage scripture refs"
  on public.scripture_references
  for all
  using (
    exists (
      select 1
      from public.devotional_days d
      join public.devotional_plans p on d.plan_id = p.id
      where d.id = day_id
      and p.author_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from public.devotional_days d
      join public.devotional_plans p on d.plan_id = p.id
      where d.id = day_id
      and p.author_id = auth.uid()
    )
  );


  create index if not exists idx_scripture_refs_user_id 
  on public.scripture_references(user_id);



create table if not exists public.scripture_references_draft (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  day_id uuid references public.devotional_days_draft(id) on delete cascade,
  reference text[] default '{}',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);


alter table public.scripture_references_draft enable row level security;


create policy "scripture refs public read"
  on public.scripture_references_draft
  for select
  using (
    exists (
      select 1
      from public.devotional_days_draft d
      join public.devotional_plans p on d.plan_id = p.id
      where d.id = day_id
      and p.author_id = auth.uid()
    )
  );


create policy "authors manage scripture refs"
  on public.scripture_references_draft
  for all
  using (
    exists (
      select 1
      from public.devotional_days_draft d
      join public.devotional_plans p on d.plan_id = p.id
      where d.id = day_id
      and p.author_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from public.devotional_days_draft d
      join public.devotional_plans p on d.plan_id = p.id
      where d.id = day_id
      and p.author_id = auth.uid()
    )
  );


  create index if not exists idx_scripture_refs_draft_user_id 
  on public.scripture_references_draft(user_id);


-- Reports
create table if not exists public.reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  reason text not null,
  created_at timestamptz default now()
);

create or replace function public.report_plan(
  p_plan_id uuid,
  p_reason text
)
returns void
language plpgsql
security definer
as $$
begin
  insert into reports (user_id, plan_id, reason)
  values (auth.uid(), p_plan_id, p_reason);
end;
$$;


alter table public.reports enable row level security;


create policy "admins can view reports"
  on public.reports
  for select
  using (auth.jwt() ->> 'role' = 'admin');

create policy "users can insert their own reports"
  on public.reports
  for insert
  with check (auth.uid() = user_id);

create policy "no updates on reports"
  on public.reports
  for update
  using (false);

create policy "no deletes on reports"
  on public.reports
  for delete
  using (false);


create index if not exists idx_reports_user_id 
  on public.reports(user_id);

create index if not exists idx_reports_plan_id 
  on public.reports(plan_id);






-- Reactions: like / dislike
create table if not exists public.plan_reactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  reaction_type text check (reaction_type in ('like', 'dislike')),
  created_at timestamptz default now(),
  unique (user_id, plan_id)
);


create or replace function public.get_plan_reaction_summary(
  p_plan_id uuid
)
returns table (
  likes int,
  dislikes int,
  user_reaction text
)
language plpgsql
security definer
as $$
begin
  return query
  select
    count(*) filter (where reaction_type = 'like')::int as likes,
    count(*) filter (where reaction_type = 'dislike')::int as dislikes,
    (
      select reaction_type
      from plan_reactions
      where plan_id = p_plan_id
        and user_id = auth.uid()
      limit 1
    ) as user_reaction
  from plan_reactions
  where plan_id = p_plan_id;
end;
$$;



create or replace function public.toggle_reaction(
  p_plan_id uuid,
  p_reaction_type text
)
returns text
language plpgsql
as $$
declare
  existing_like uuid;
  existing_dislike uuid;
begin
  if p_reaction_type not in ('like', 'dislike') then
    return 'invalid reaction type';
  end if;

  -- Check existing reactions
  select id into existing_like
  from public.plan_reactions
  where plan_id = p_plan_id
    and user_id = auth.uid()
    and reaction_type = 'like'
  limit 1;

  select id into existing_dislike
  from public.plan_reactions
  where plan_id = p_plan_id
    and user_id = auth.uid()
    and reaction_type = 'dislike'
  limit 1;

  -- CASE 1: Toggle off (remove)
  if (p_reaction_type = 'like' and existing_like is not null) or
     (p_reaction_type = 'dislike' and existing_dislike is not null)
  then
    delete from public.plan_reactions where id = coalesce(existing_like, existing_dislike);
    return 'removed';
  end if;

  -- CASE 2: Switch from like -> dislike OR dislike -> like
  if existing_like is not null and p_reaction_type = 'dislike' then
    delete from public.plan_reactions where id = existing_like;
  elsif existing_dislike is not null and p_reaction_type = 'like' then
    delete from public.plan_reactions where id = existing_dislike;
  end if;

  -- CASE 3: Insert new reaction
  insert into public.plan_reactions (plan_id, user_id, reaction_type)
  values (p_plan_id, auth.uid(), p_reaction_type);

  return 'added';
end;
$$;


alter table public.plan_reactions enable row level security;



create policy "users can view reactions"
  on public.plan_reactions
  for select
  using (true);

create policy "users can insert reactions"
  on public.plan_reactions
  for insert
  with check (auth.uid() = user_id);

create policy "users can update own reactions"
  on public.plan_reactions
  for update
  using (auth.uid() = user_id);

create policy "users can delete own reactions"
  on public.plan_reactions
  for delete
  using (auth.uid() = user_id);

create index if not exists idx_reactions_plan on public.plan_reactions(plan_id);
create index if not exists idx_reactions_user on public.plan_reactions(user_id);
create index if not exists idx_reactions_plan_user on public.plan_reactions(plan_id, user_id);



--avatar bucket.

insert into storage.buckets
  (id, name, public)
values
  ('avatars', 'avatars', true)
on conflict (id) do nothing;


create policy "avatars are publicly accessible"
on storage.objects
for select using (bucket_id = 'avatars');


create policy "authenticated users can upload avatars"
on storage.objects
for insert
with check (
  bucket_id = 'avatars'
  and auth.uid() is not null
);


create policy "users can update their own avatar"
on storage.objects
for update
using (
  bucket_id = 'avatars'
  and owner = auth.uid()
)
with check (
  bucket_id = 'avatars'
  and owner = auth.uid()
);

create policy "users can delete their own avatar"
on storage.objects
for delete
using (
  auth.uid() = owner
  and bucket_id = 'avatars'
);

-- -- plan images
insert into storage.buckets
  (id, name, public)
values
  ('plan_images', 'plan_images', true)
on conflict (id) do nothing;


create policy "plan images publicly accessible"
on storage.objects
for select
using (bucket_id = 'plan_images');

create policy "users upload own plan images"
on storage.objects
for insert
with check (
  bucket_id = 'plan_images'
  and auth.uid()::text = (storage.foldername(name))[1]
);



create policy "users delete own plan images"
on storage.objects
for delete
using (
  bucket_id = 'plan_images'
  and auth.uid()::text = (storage.foldername(name))[1]
);


create policy "users update own plan images"
on storage.objects
for update
using (
  bucket_id = 'plan_images'
  and auth.uid()::text = (storage.foldername(name))[1]
);



--plan_view
create or replace view public.devotional_plans_view
with(security_invoker = true)
as select
  p.id,
  p.title,
  p.total_days,
  p.description,
  p.cover_image,
  p.completions,
  p.tags,
  p.author_id,
  p.created_at,
  p.status,
  p.updated_at,

  -- like count
  (select count(*) from public.plan_reactions r 
   where r.plan_id = p.id and r.reaction_type = 'like') as likes_count,

  -- dislike count
  (select count(*) from public.plan_reactions r 
   where r.plan_id = p.id and r.reaction_type = 'dislike') as dislikes_count

from public.devotional_plans p;


--searchbu
create extension if not exists pg_trgm;


create index if not exists idx_plans_title_trgm
  on public.devotional_plans using gin (title gin_trgm_ops);

create index if not exists idx_plans_description_trgm
  on public.devotional_plans using gin (description gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_plans_tags_trgm
ON public.devotional_plans
USING gin (tags gin_trgm_ops);


create or replace function search_plans(
  search_query text,
  limit_count int default 20,
  cursor_created_at timestamptz default null,
  cursor_id uuid default null
)
returns setof devotional_plans_view
language sql
as $$
  select *
  from devotional_plans_view
  where
    -- cursor filtering FIRST
    (
      cursor_created_at is null
      or (
          created_at < cursor_created_at
          or (created_at = cursor_created_at and id < cursor_id)
      )
    )

    and (
      -- prefix search
      lower(title) like lower(search_query) || '%'
      or lower(description) like lower(search_query) || '%'
      or lower(tags) like lower(search_query) || '%'

      -- fuzzy search
      or similarity(lower(title), lower(search_query)) > 0.2
      or similarity(lower(description), lower(search_query)) > 0.2
      or similarity(lower(tags), lower(search_query)) > 0.2
    )

  order by
    created_at desc,
    id desc
  limit limit_count;
$$;




create table friends (
  id uuid primary key default gen_random_uuid(),
  requester_id uuid not null references public.profiles(id),
  receiver_id uuid not null references public.profiles(id),
  status text check (status in ('pending', 'accepted')) not null,
  created_at timestamptz default now(),
  unique (requester_id, receiver_id)
);


alter publication supabase_realtime
add table friends;

create or replace function public.send_friend_request(
  p_receiver_id uuid
)
returns void
language plpgsql
security definer
as $$
begin
  -- Prevent self request
  if auth.uid() = p_receiver_id then
    raise exception 'Cannot send friend request to yourself';
  end if;

  -- Prevent duplicate (both directions)
  if exists (
    select 1 from friends
    where 
      (requester_id = auth.uid() and receiver_id = p_receiver_id)
      or
      (requester_id = p_receiver_id and receiver_id = auth.uid())
  ) then
    raise exception 'Friend request already exists';
  end if;

  insert into friends (requester_id, receiver_id, status)
  values (auth.uid(), p_receiver_id, 'pending');

  perform create_notification(
    ARRAY[p_receiver_id], 
    'friend_request',
    'New Friend Request',
    'You have a new friend request',
    jsonb_build_object(
      'requester_id', auth.uid()
    )
  );
end;
$$;



create or replace function public.accept_friend_request(
  p_requester_id uuid
)
returns void
language plpgsql
security definer
as $$
begin
  update friends
  set status = 'accepted'
  where requester_id = p_requester_id
    and receiver_id = auth.uid()
    and status = 'pending';

  if not found then
    raise exception 'Friend request not found or already handled';
  end if;
end;
$$;


create or replace function public.decline_friend_request(
  p_requester_id uuid
)
returns void
language plpgsql
security definer
as $$
begin
  delete from friends
  where requester_id = p_requester_id
    and receiver_id = auth.uid()
    and status = 'pending';

  if not found then
    raise exception 'Friend request not found or already handled';
  end if;
end;
$$;



create or replace function public.get_user_by_email(
  p_email text
)
returns table (
  id uuid,
  email text,
  first_name text,
  last_name text,
  avatar_url text,
  friendship_status text,
  requester_id uuid,
  receiver_id uuid
)
security definer
language plpgsql
as $$
begin
  return query
  select
    p.id,
    p.email,
    p.first_name,
    p.last_name,
    p.avatar_url,
    f.status as friendship_status,
    f.requester_id as requester_id,
    f.receiver_id as receiver_id
  from profiles p
  left join friends f
    on (
      (f.requester_id = auth.uid() and f.receiver_id = p.id)
      or
      (f.receiver_id = auth.uid() and f.requester_id = p.id)
    )
  where p.email = p_email
    and p.id <> auth.uid();
end;
$$;

create or replace function public.get_pending_friend_requests()
returns table (
  id uuid,
  requester_id uuid,
  first_name text,
  last_name text,
  avatar_url text,
  created_at timestamptz
)
language sql
security definer
as $$
  select
    f.id,
    p.id as requester_id,
    p.first_name,
    p.last_name,
    p.avatar_url,
    f.created_at
  from friends f
  join profiles p on p.id = f.requester_id
  where f.receiver_id = auth.uid()
    and f.status = 'pending'
  order by f.created_at desc;
$$;




create table plan_groups (
  id uuid primary key default gen_random_uuid(),
  created_by uuid not null references public.profiles(id),
  start_date date not null,
  plan_id uuid not null references devotional_plans(id) on delete cascade,
  max_members int default 150,
  completed_days int default 0,
  created_at timestamptz default now()
);


create table plan_group_members (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references plan_groups(id) on delete cascade,
  user_id uuid not null references profiles(id),
  status text check (status in ('pending', 'accepted')) default 'pending',
  joined_at timestamptz,
  unique (group_id, user_id)
);


create or replace function public.create_plan_group(
  p_user_id uuid,
  p_plan_id uuid,
  p_start_date date,
  p_friends_ids uuid[]
)
returns uuid
language plpgsql
security definer
as $$
declare
  v_group_id uuid;
  v_progress_id uuid;
begin

  -- 1 Create plan group
  insert into plan_groups (
    plan_id,
    created_by,
    start_date
  )
  values (
    p_plan_id,
    p_user_id,
    p_start_date
  )
  returning id into v_group_id;

  -- 2?? Add creator as accepted member
  insert into plan_group_members (
    group_id,
    user_id,
    status,
    joined_at
  )
  values (
    v_group_id,
    p_user_id,
    'accepted',
    now()
  );

  -- 3?? Create plan progress
  insert into plan_progress (
    user_id,
    plan_id,
    group_id,
    current_day,
    completed_days,
    start_date
  )
  values (
    p_user_id,
    p_plan_id,
    v_group_id,
    1,
    '{}',
    p_start_date
  )
  on conflict (user_id, plan_id, group_id) do nothing;

  select id into v_progress_id
  from plan_progress
  where user_id = p_user_id
    and plan_id = p_plan_id
    and group_id = v_group_id;

  insert into plan_group_members (group_id, user_id, status)
  select v_group_id, unnest(p_friends_ids), 'pending'
  on conflict (group_id, user_id) do nothing;

  perform create_notification(
    p_friends_ids,
    'plan_invite',
    'Plan Invitation',
    'You were invited to read a plan with friends',
    jsonb_build_object(
      'plan_id', p_plan_id,
      'group_id', v_group_id,
      'invited_by', auth.uid()
    )
  );

  -- 4?? Return the group id
  return v_progress_id;
end;
$$;



create or replace function public.add_user_to_existing_plan_group(
  p_group_id uuid,
  p_friends_ids uuid[]
)
returns void
language plpgsql
security definer
as $$
declare
  v_plan_id uuid;
begin
  -- Ensure group exists and fetch plan data
  select plan_id
  into v_plan_id
  from plan_groups
  where id = p_group_id;

  if not found then
    raise exception 'Plan group not found';
  end if;

  insert into plan_group_members (group_id, user_id, status)
  select p_group_id, unnest(p_friends_ids), 'pending'
  on conflict (group_id, user_id) do nothing;

    perform create_notification(
    p_friends_ids,
    'plan_invite',
    'Plan Invitation',
    'You were invited to read a plan with friends',
    jsonb_build_object(
      'plan_id', v_plan_id,
      'group_id', p_group_id,
      'invited_by', auth.uid()
    )
  );
end;
$$;


create or replace function public.accept_plan_group_invite(
  p_group_id uuid,
  p_plan_id uuid,
  p_start_date date
)
returns uuid
language plpgsql
as $$
declare
  v_progress_id uuid;
begin

  update plan_group_members
  set status = 'accepted',
      joined_at = now()
  where group_id = p_group_id
    and user_id = auth.uid();

    
  -- 3?? Create plan progress for creator (group-aware)
  insert into plan_progress (
    user_id,
    plan_id,
    group_id,
    current_day,
    completed_days,
    start_date
  )
  values (
    auth.uid(),
    p_plan_id,
    p_group_id,
    1,
    '{}',
    p_start_date
  )
  on conflict (user_id, plan_id, group_id) do nothing;

  select id into v_progress_id
  from plan_progress
  where user_id = auth.uid()
    and plan_id = p_plan_id
    and group_id = p_group_id;

  return v_progress_id;
end;
$$;


-- Plan Progress
create table if not exists public.plan_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  current_day int not null default 1,
  group_id uuid references public.plan_groups(id) on delete cascade,
  completed_days int[] default '{}',
  completed_once boolean default false,
  start_date timestamptz default now(),
  updated_at timestamptz default now(),
  created_at timestamptz default now(),
  unique (user_id, plan_id, group_id)
);

alter table public.plan_progress enable row level security;


create policy "users can view own or group members progress"
on public.plan_progress
for select
using (
  -- Can always see your own progress
  auth.uid() = user_id

  OR

  -- Can see progress of members in same plan group
  (
    group_id IS NOT NULL
    AND exists (
      select 1
      from plan_group_members pgm
      where pgm.group_id = plan_progress.group_id
        and pgm.user_id = auth.uid()
        and pgm.status = 'accepted'
    )
  )
);


create policy "users can insert their own progress"
  on public.plan_progress
  for insert
  with check (auth.uid() = user_id);

create policy "users can update their own progress"
  on public.plan_progress
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create index if not exists idx_progress_user on public.plan_progress(user_id);
create index if not exists idx_progress_plan on public.plan_progress(plan_id);


create or replace function public.start_plan_progress(
  p_user_id uuid,
  p_plan_id uuid,
  p_group_id uuid default null,
  p_start_date timestamptz default now()
)
returns uuid
language plpgsql
security definer
as $$
declare
  v_progress_id uuid;
begin
  -- Insert plan progress
  insert into public.plan_progress (
    user_id,
    plan_id,
    group_id,
    current_day,
    completed_days,
    start_date
  )
  values (
    p_user_id,
    p_plan_id,
    p_group_id,
    1,
    '{}',
    p_start_date
  )
  on conflict (user_id, plan_id, group_id)
  do update
    set updated_at = now()
  returning id into v_progress_id;

  return v_progress_id;
end;
$$;




create table if not exists public.day_items_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  progress_id uuid references public.plan_progress(id) on delete cascade,
  day_id uuid references public.devotional_days(id) on delete cascade,
  item_type text check (item_type in ('devotional', 'scripture')),
  item_key text, -- e.g. scripture reference or 'main'
  devotional_content text,
  day_number int,
  title text,
  group_id uuid references public.plan_groups(id) on delete cascade,
  completed boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Personal plan (no group)
create unique index uniq_day_items_personal
on day_items_progress (user_id, progress_id, day_id, item_type, item_key)
where group_id is null;

-- Group plan
create unique index uniq_day_items_group
on day_items_progress (user_id, progress_id, day_id, item_type, item_key, group_id)
where group_id is not null;


create or replace function public.ensure_day_items_exist(
  p_user_id uuid,
  p_plan_id uuid,
  p_progress_id uuid,
  p_day_id uuid,
  p_group_id uuid default null
)
returns void
language plpgsql
as $$
declare
  refs text[];
  v_devotional_content text;
  v_day_number int;
  v_day_title text;
  ref text;
begin

  select content, day_number, title
  into v_devotional_content, v_day_number, v_day_title
  from devotional_days
  where id = p_day_id;


  -- Ensure devotional item
  if p_group_id is null then
    insert into day_items_progress (
      user_id,
      progress_id,
      plan_id,
      day_id,
      item_type,
      item_key,
      devotional_content,
      day_number,
      title,
      group_id
    )
    values (
      p_user_id,
      p_progress_id,
      p_plan_id,
      p_day_id,
      'devotional',
      'main',
      v_devotional_content,
      v_day_number,
      v_day_title,
      null
    )
    on conflict (user_id, progress_id, day_id, item_type, item_key)
    where group_id is null
    do update
    set devotional_content = excluded.devotional_content,
        day_number = excluded.day_number,
        title = excluded.title,
        updated_at = now();
  else
    insert into day_items_progress (
      user_id,
      progress_id,
      plan_id,
      day_id,
      item_type,
      item_key,
      devotional_content,
      day_number,
      title,
      group_id
    )
    values (
      p_user_id,
      p_progress_id,
      p_plan_id,
      p_day_id,
      'devotional',
      'main',
      v_devotional_content,
      v_day_number,
      v_day_title,
      p_group_id
    )
    on conflict (user_id, progress_id, day_id, item_type, item_key, group_id)
    where group_id is not null
    do update
    set devotional_content = excluded.devotional_content,
        day_number = excluded.day_number,
        title = excluded.title,
        updated_at = now();
  end if;

  -- Load scripture references (text[])
  select reference
  into refs
  from scripture_references
  where day_id = p_day_id
  limit 1;

  if refs is null then
    return;
  end if;

  -- Ensure one item per scripture ref
  foreach ref in array refs loop
    if p_group_id is null then
      insert into day_items_progress (
        user_id,
        progress_id,
        plan_id,
        day_id,
        item_type,
        item_key,
        group_id,
        day_number,
        title
      )
      values (
        p_user_id,
        p_progress_id,
        p_plan_id,
        p_day_id,
        'scripture',
        ref,
        null,
        v_day_number,
        v_day_title
      )
      on conflict (user_id, progress_id, day_id, item_type, item_key)
      where group_id is null
      do update
      set day_number = excluded.day_number,
          title = excluded.title,
          updated_at = now();
    else
      insert into day_items_progress (
        user_id,
        progress_id,
        plan_id,
        day_id,
        item_type,
        item_key,
        group_id,
        day_number,
        title
      )
      values (
        p_user_id,
        p_progress_id,
        p_plan_id,
        p_day_id,
        'scripture',
        ref,
        p_group_id,
        v_day_number,
        v_day_title
      )
      on conflict (user_id, progress_id, day_id, item_type, item_key, group_id)
      where group_id is not null
      do update
      set day_number = excluded.day_number,
          title = excluded.title,
          updated_at = now();
    end if;
  end loop;
end;
$$;

create or replace function public.get_day_items_progress(
  p_user_id uuid,
  p_plan_id uuid,
  p_progress_id uuid,
  p_day_id uuid,
  p_group_id uuid default null
)
returns setof public.day_items_progress
language plpgsql
as $$
begin
  perform ensure_day_items_exist(
    p_user_id,
    p_plan_id,
    p_progress_id,
    p_day_id,
    p_group_id
  );

  return query
  select *
  from public.day_items_progress
  where user_id = p_user_id
    and progress_id = p_progress_id
    and day_id = p_day_id
    and (
      (p_group_id is null and group_id is null)
      or group_id = p_group_id
    )
  order by item_type, item_key;
end;
$$;


create or replace function public.toggle_item_completion(
  p_user_id uuid,
  p_plan_id uuid,
  p_progress_id uuid,
  p_day_id uuid,
  p_item_type text,
  p_item_key text,
  p_completed boolean,
  p_group_id uuid default null
)
returns void
language plpgsql
as $$
declare
  v_total_items int;
  v_completed_items int;
  v_day_number int;
  v_plan_total_days int;
  v_completed_once boolean;
  v_is_plan_complete boolean;
begin
  -- Check completion state before updates
  select dp.total_days,
         coalesce(pp.completed_once, false)
  into v_plan_total_days, v_completed_once
  from plan_progress pp
  join devotional_plans dp on dp.id = pp.plan_id
  where pp.id = p_progress_id
    and pp.user_id = p_user_id
    and (
      (p_group_id is null and pp.group_id is null)
      or pp.group_id = p_group_id
    );

  -- Insert if missing (partial index safe)
  insert into day_items_progress (
    user_id, progress_id, plan_id, day_id, item_type, item_key, completed, group_id
  )
  values (
    p_user_id, p_progress_id, p_plan_id, p_day_id, p_item_type, p_item_key, p_completed, p_group_id
  )
  on conflict do nothing;

  -- Update item (NULL-safe)
  update day_items_progress
  set completed = p_completed,
      updated_at = now()
  where user_id = p_user_id
    and progress_id = p_progress_id
    and day_id = p_day_id
    and item_type = p_item_type
    and item_key = p_item_key
    and (
      (p_group_id is null and group_id is null)
      or group_id = p_group_id
    );

  -- Get day number
  select day_number
  into v_day_number
  from devotional_days
  where id = p_day_id;

  -- Count total items
  select count(*)
  into v_total_items
  from day_items_progress
  where user_id = p_user_id
    and progress_id = p_progress_id
    and day_id = p_day_id
    and (
      (p_group_id is null and group_id is null)
      or group_id = p_group_id
    );

  -- Count completed items
  select count(*)
  into v_completed_items
  from day_items_progress
  where user_id = p_user_id
    and progress_id = p_progress_id
    and day_id = p_day_id
    and completed = true
    and (
      (p_group_id is null and group_id is null)
      or group_id = p_group_id
    );

  -- Update completed_days
if v_total_items > 0 and v_completed_items = v_total_items then
    update plan_progress
    set completed_days = case
      when not (v_day_number = any(completed_days))
        then array_append(completed_days, v_day_number)
      else completed_days
    end,
    updated_at = now()
    where user_id = p_user_id
      and id = p_progress_id
      and (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );
  else
    update plan_progress
    set completed_days = array_remove(completed_days, v_day_number),
        updated_at = now()
    where user_id = p_user_id
      and id = p_progress_id
      and (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );
  end if;

  -- Increment completions when a plan is completed for the first time
  select (coalesce(array_length(pp.completed_days, 1), 0) >= v_plan_total_days)
  into v_is_plan_complete
  from plan_progress pp
  where pp.id = p_progress_id
    and pp.user_id = p_user_id
    and (
      (p_group_id is null and pp.group_id is null)
      or pp.group_id = p_group_id
    );

  if v_completed_once is not true and v_is_plan_complete is true then
    update devotional_plans
    set completions = coalesce(completions, 0) + 1,
        updated_at = now()
    where id = p_plan_id;

    update plan_progress
    set completed_once = true,
        updated_at = now()
    where id = p_progress_id
      and user_id = p_user_id
      and (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );
  end if;
end;
$$;



create or replace function public.toggle_day_completion(
  p_user_id uuid,
  p_plan_id uuid,
  p_progress_id uuid,
  p_day_id uuid,
  p_completed boolean,
  p_group_id uuid default null
)
returns void
language plpgsql
as $$
declare
  v_day_number int;
begin
  -- Ensure items exist for the day
  perform ensure_day_items_exist(p_user_id, p_plan_id, p_progress_id, p_day_id, p_group_id);

  -- Get day number
  select day_number
  into v_day_number
  from devotional_days
  where id = p_day_id;

  -- Toggle ALL items for that day
  update day_items_progress
  set completed = p_completed,
      updated_at = now()
  where user_id = p_user_id
    and progress_id = p_progress_id
    and day_id = p_day_id
    and  (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );


  -- Update completed_days array
  if p_completed then
    update plan_progress
    set
      completed_days = case
        when not (v_day_number = any(completed_days))
          then array_append(completed_days, v_day_number)
        else completed_days
      end,
      updated_at = now()
    where user_id = p_user_id
      and id = p_progress_id
      and  (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );
  else
    update plan_progress
    set
      completed_days = array_remove(completed_days, v_day_number),
      updated_at = now()
    where user_id = p_user_id
      and id = p_progress_id
      and  (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );
  end if;

end;
$$;


--comments
create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  plan_id uuid not null references devotional_plans(id) on delete cascade,
  day_id uuid not null references devotional_days(id) on delete cascade,
  group_id uuid not null references public.plan_groups(id) on delete cascade,
  content text not null check (length(trim(content)) > 0),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);


alter table public.comments enable row level security;

alter publication supabase_realtime
add table comments;


create policy "comments readable by everyone"
  on public.comments
  for select
  using (true);

create policy "logged in users can insert comments"
  on public.comments
  for insert
  with check (auth.uid() = user_id);

create policy "comment owners can update"
  on public.comments
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


create policy "comment owners can delete"
  on public.comments
  for delete
  using (auth.uid() = user_id);

create index idx_plan_day_comments_plan_day
  on comments (plan_id, day_id);

create index idx_plan_day_comments_user
  on comments (user_id);

create index idx_plan_day_comments_parent
  on comments (group_id);


create or replace function public.add_plan_day_comment(
  p_plan_id uuid,
  p_day_id uuid,
  p_content text,
  p_group_id uuid default null
)
returns void
language plpgsql
security definer
as $$
begin
  insert into comments (
    plan_id,
    day_id,
    user_id,
    group_id,
    content
  )
  values (
    p_plan_id,
    p_day_id,
    auth.uid(),
    p_group_id,
    trim(p_content)
  );
end;
$$;

create or replace function public.get_plan_day_comments(
  p_plan_id uuid,
  p_day_id uuid,
  p_group_id uuid default null
)
returns table (
  id uuid,
  user_id uuid,
  group_id uuid,
  content text,
  created_at timestamptz,
  first_name text,
  last_name text,
  avatar_url text
)
language sql
stable
as $$
  select
    c.id,
    c.user_id,
    c.group_id,
    c.content,
    c.created_at,
    p.first_name,
    p.last_name,
    p.avatar_url
  from comments c
  join profiles p on p.id = c.user_id
  where c.plan_id = p_plan_id
    and c.day_id = p_day_id
    and c.group_id = p_group_id
  order by c.created_at asc;
$$;


create table notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,

  type text not null,
  title text not null,
  body text,

  data jsonb, 

  is_read boolean default false,
  created_at timestamptz default now()
);

create index idx_notifications_user on notifications(user_id);
create index idx_notifications_unread on notifications(user_id, is_read);


create or replace function public.create_notification(
  p_user_ids uuid[],
  p_type text,
  p_title text,
  p_body text,
  p_data jsonb default '{}'::jsonb
)
returns void
language plpgsql
as $$
begin
  insert into notifications (user_id, type, title, body, data)
  select unnest(p_user_ids), p_type, p_title, p_body, p_data;
end;
$$;


create or replace function public.get_my_notifications()
returns table (
  id uuid,
  type text,
  title text,
  body text,
  data jsonb,
  is_read boolean,
  created_at timestamptz
)
language sql
stable
as $$
  select
    id,
    type,
    title,
    body,
    data,
    is_read,
    created_at
  from notifications
  where user_id = auth.uid()
  order by created_at desc;
$$;



create or replace function public.mark_notification_read(
  p_notification_id uuid
)
returns void
language sql
as $$
  update notifications
  set is_read = true
  where id = p_notification_id
    and user_id = auth.uid();
$$;


alter table public.notifications
enable row level security;

create policy "Users can read their own notifications"
on public.notifications
for select
using (
  auth.uid() = user_id
);


create policy "Users can update their own notifications"
on public.notifications
for update
using (
  auth.uid() = user_id
)
with check (
  auth.uid() = user_id
);


alter publication supabase_realtime
add table notifications;


create or replace function unread_notifications_count()
returns integer
language sql
security definer
as $$
  select count(*)
  from notifications
  where user_id = auth.uid()
    and is_read = false;
$$;



alter table public.friends enable row level security;
alter table public.day_items_progress enable row level security;
alter table public.plan_group_members enable row level security;
alter table public.plan_groups enable row level security;

create or replace function public.is_group_member(p_group_id uuid)
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1
    from plan_group_members
    where group_id = p_group_id
      and user_id = auth.uid()
  );
$$;


create policy "Friends: select own friendships"
on public.friends
for select
using (
  requester_id = auth.uid()
  or receiver_id = auth.uid()
);


create policy "Friends: send request"
on public.friends
for insert
with check (
  requester_id = auth.uid()
  and requester_id <> receiver_id
);


create policy "Friends: update status"
on public.friends
for update
using (
  requester_id = auth.uid()
  or receiver_id = auth.uid()
);


create policy "Friends: delete friendship"
on public.friends
for delete
using (
  requester_id = auth.uid()
  or receiver_id = auth.uid()
);


create policy "Plan groups: view group"
on public.plan_groups
for select
using (
  created_by = auth.uid()
  or public.is_group_member(id)
);

create policy "Plan groups: create group"
on public.plan_groups
for insert
with check (
  created_by = auth.uid()
);


create policy "Plan groups: update group"
on public.plan_groups
for update
using (
  created_by = auth.uid()
);


create policy "Plan groups: delete group"
on public.plan_groups
for delete
using (
  created_by = auth.uid()
);


create policy "Group members: view members"
on public.plan_group_members
for select
using (
  public.is_group_member(group_id)
);


create policy "Group members: join group"
on public.plan_group_members
for insert
with check (
  user_id = auth.uid()
  or exists (
    select 1
    from plan_groups pg
    where pg.id = group_id
      and pg.created_by = auth.uid()
  )
);


create policy "Group members: update status"
on public.plan_group_members
for update
using (
  user_id = auth.uid()
  or exists (
    select 1
    from plan_groups pg
    where pg.id = group_id
      and pg.created_by = auth.uid()
  )
);


create policy "Group members: leave or remove"
on public.plan_group_members
for delete
using (
  user_id = auth.uid()
  or exists (
    select 1
    from plan_groups pg
    where pg.id = group_id
      and pg.created_by = auth.uid()
  )
);


create policy "Day progress: view group progress"
on public.day_items_progress
for select
using (
  user_id = auth.uid()
  or exists (
    select 1
    from plan_group_members pgm
    where pgm.group_id = group_id
      and pgm.user_id = auth.uid()
      and pgm.status = 'accepted'
  )
);

create policy "Day progress: insert own"
on public.day_items_progress
for insert
with check (
  user_id = auth.uid()
);

create policy "Day progress: update own"
on public.day_items_progress
for update
using (
  user_id = auth.uid()
);


create policy "Day progress: delete own"
on public.day_items_progress
for delete
using (
  user_id = auth.uid()
);



create table if not exists ai_daily_messages (
  id uuid primary key default gen_random_uuid(),
  message_date date unique not null,
  content text not null,
  type text not null,
  created_at timestamptz default now()
);

alter table public.ai_daily_messages
enable row level security;


create table if not exists ai_notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade,
  message_id uuid references public.ai_daily_messages(id),
  type text,
  content text,
  scheduled_for timestamptz,
  sent_at timestamptz,
  created_at timestamptz default now(),
  unique (user_id, message_id)
);

alter table public.ai_notifications
enable row level security;

create or replace function queue_daily_notifications()
returns void
language plpgsql
security definer
as $$
declare
  send_hour int := 7; -- 7 AM local time
begin
  insert into ai_notifications (
    user_id,
    message_id,
    type,
    content,
    scheduled_for
  )
  select
    np.user_id,
    dm.id,
    'daily',
    dm.content,
    (
      (current_date + make_interval(hours => send_hour))
        at time zone p.timezone
    ) at time zone 'UTC'
  from notification_preferences np
  join public.profiles p on p.id = np.user_id
  join ai_daily_messages dm
    on dm.message_date = current_date
  where
    np.daily = true
    and p.expo_push_token is not null
    and not exists (
      select 1
      from ai_notifications n
      where n.user_id = np.user_id
        and n.message_id = dm.id
    );
end;
$$;


create table if not exists notification_preferences (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  daily boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.notification_preferences
enable row level security;

create policy "Users can view their notification preferences"
  on public.notification_preferences
  for select
  using (auth.uid() = user_id);

create policy "Users can insert their notification preferences"
  on public.notification_preferences
  for insert
  with check (auth.uid() = user_id);

create policy "Users can update their notification preferences"
  on public.notification_preferences
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


create or replace function upsert_push_notification_setup(
  p_expo_push_token text,
  p_timezone text
)
returns void
language plpgsql
security definer
as $$
begin
  -- 1?? Update profile
  update public.profiles
  set
    expo_push_token = p_expo_push_token,
    timezone = p_timezone
  where id = auth.uid();

  -- 2?? Ensure notification preferences exist
  insert into public.notification_preferences (user_id, daily)
  values (auth.uid(), true)
  on conflict (user_id)
  do nothing;
end;
$$;


create or replace view user_behavior_snapshot as
select
  p.id as user_id,
  p.timezone,
  p.last_seen,

  now() - p.last_seen as time_since_last_seen,

  -- ACTIVITY
  max(pp.updated_at) as last_activity_at,
  now() - max(pp.updated_at) as time_since_last_activity,

  -- PLANS
  count(distinct pp.plan_id) as plans_started,

  count(distinct pp.plan_id) filter (
    where array_length(pp.completed_days, 1) = dp.total_days
  ) as plans_completed,

  count(distinct pp.plan_id) filter (
    where array_length(pp.completed_days, 1) < dp.total_days
  ) as active_plans,

  count(distinct pp.plan_id) filter (
    where pp.updated_at < now() - interval '5 days'
      and array_length(pp.completed_days, 1) < dp.total_days
  ) as abandoned_plans,

  -- STREAK (simple version)
  max(array_length(pp.completed_days, 1)) as max_days_completed,

  -- SOCIAL
  exists (
    select 1 from comments c
    where c.user_id = p.id
      and c.created_at > now() - interval '7 days'
  ) as commented_recently,

  (
    exists (
      select 1
      from plan_group_members pgm
      join plan_groups pg on pg.id = pgm.group_id
      where pgm.user_id = p.id
        and pgm.status = 'accepted'
    )
    or exists (
      select 1
      from plan_groups pg
      where pg.created_by = p.id
    )
  ) as has_group_plan,

  exists (
    select 1 from friends f
    where (f.requester_id = p.id or f.receiver_id = p.id)
      and f.status = 'accepted'
  ) as has_friends

from profiles p
left join plan_progress pp on pp.user_id = p.id
left join devotional_plans dp on dp.id = pp.plan_id
group by p.id;


create table if not exists public.ai_triggers (
  id uuid primary key default gen_random_uuid(),
  priority int default 10,
  user_id uuid not null
    references public.profiles(id) on delete cascade,

  trigger_type text not null check (
    trigger_type in (
      'inactivity_nudge',
      'abandoned_plan',
      'plan_completion',
      'streak_encouragement',
      'friend_invite_nudge',
      'social_prompt',
      'welcome_back'
    )
  ),

  trigger_reason text not null,
  -- human-readable explanation
  -- e.g. "No activity for 6 days, 1 active plan"

  context jsonb not null default '{}',
  -- snapshot of metrics at trigger time
  -- used by AI to craft message

  generated_message text,
  -- optional: stored AI message (for auditing / reuse)

  sent boolean default false,
  sent_at timestamptz,

  created_at timestamptz default now(),

  -- spam protection
  unique (user_id, trigger_type, created_at)
);

alter table public.ai_triggers
enable row level security;




create or replace function generate_ai_triggers()
returns void
language plpgsql
security definer
as $$
begin
  /* =====================================================
     ?? PLAN COMPLETION (Priority 1)
     ===================================================== */
  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'plan_completion',
    'User completed a devotional plan',
    1,
    jsonb_build_object(
      'plans_completed', u.plans_completed,
      'max_days_completed', u.max_days_completed
    )
  from user_behavior_snapshot u
  where
    u.plans_completed > 0
    and u.last_activity_at > now() - interval '1 day'

    -- GLOBAL COOLDOWN (no spam)2.
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )

    -- PER-TRIGGER COOLDOWN
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'plan_completion'
        and t.created_at > now() - interval '3 days'
    );

  /* =====================================================
     ?? WELCOME BACK (Priority 2)
     ===================================================== */
  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'welcome_back',
    'User returned after long inactivity',
    2,
    jsonb_build_object(
      'time_since_last_seen', u.time_since_last_seen
    )
  from user_behavior_snapshot u
  where
    u.time_since_last_seen > interval '5 days'

    -- GLOBAL COOLDOWN
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )

    -- BLOCK IF HIGHER PRIORITY EXISTS
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 2
        and t.created_at > now() - interval '1 day'
    )

    -- PER-TRIGGER COOLDOWN
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'welcome_back'
        and t.created_at > now() - interval '14 days'
    );

  /* =====================================================
     ?? FRIEND INVITE NUDGE (Priority 3)
     ===================================================== */
  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'friend_invite_nudge',
    'Active user with no friends',
    3,
    jsonb_build_object(
      'plans_started', u.plans_started,
      'commented_recently', u.commented_recently
    )
  from user_behavior_snapshot u
  where
    u.has_friends = false
    and u.plans_started > 0
    and u.time_since_last_activity < interval '3 days'

    -- GLOBAL COOLDOWN
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )

    -- BLOCK IF HIGHER PRIORITY EXISTS
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 3
        and t.created_at > now() - interval '1 day'
    )

    -- PER-TRIGGER COOLDOWN
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'friend_invite_nudge'
        and t.created_at > now() - interval '14 days'
    );

  /* =====================================================
     ?? INACTIVITY NUDGE (Priority 4)
     ===================================================== */
  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'inactivity_nudge',
    'User inactive for more than 5 days',
    4,
    jsonb_build_object(
      'time_since_last_activity', u.time_since_last_activity,
      'active_plans', u.active_plans
    )
  from user_behavior_snapshot u
  where
    u.time_since_last_activity > interval '5 days'
    and u.active_plans > 0

    -- GLOBAL COOLDOWN
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )

    -- BLOCK IF ANY HIGHER PRIORITY EXISTS
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 4
        and t.created_at > now() - interval '1 day'
    )

    -- PER-TRIGGER COOLDOWN
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'inactivity_nudge'
        and t.created_at > now() - interval '7 days'
    );

  /* =====================================================
     ?? STREAK ENCOURAGEMENT (Priority 5)
     ===================================================== */
  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'streak_encouragement',
    'User is building a steady devotional rhythm',
    5,
    jsonb_build_object(
      'max_days_completed', u.max_days_completed,
      'active_plans', u.active_plans
    )
  from user_behavior_snapshot u
  where
    u.max_days_completed >= 3
    and u.last_activity_at > now() - interval '1 day'

    -- GLOBAL COOLDOWN
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )

    -- BLOCK IF ANY HIGHER PRIORITY EXISTS
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 5
        and t.created_at > now() - interval '1 day'
    )

    -- PER-TRIGGER COOLDOWN
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'streak_encouragement'
        and t.created_at > now() - interval '7 days'
    );

  /* =====================================================
     ?? ABANDONED PLAN (Priority 6)
     ===================================================== */
  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'abandoned_plan',
    'User has an inactive plan that was not completed',
    6,
    jsonb_build_object(
      'abandoned_plans', u.abandoned_plans,
      'active_plans', u.active_plans,
      'time_since_last_activity', u.time_since_last_activity
    )
  from user_behavior_snapshot u
  where
    u.abandoned_plans > 0
    and u.time_since_last_activity < interval '3 days'

    -- GLOBAL COOLDOWN
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )

    -- BLOCK IF ANY HIGHER PRIORITY EXISTS
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 6
        and t.created_at > now() - interval '1 day'
    )

    -- PER-TRIGGER COOLDOWN
    and not exists (
      select 1 from ai_triggers 
      where t.user_id = u.user_id
        and t.trigger_type = 'abandoned_plan'
        and t.created_at > now() - interval '10 days'
    );

  /* =====================================================
     ?? SOCIAL PROMPT (Priority 7)
     ===================================================== */
  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'social_prompt',
    'Active user with friends but no recent comments',
    7,
    jsonb_build_object(
      'commented_recently', u.commented_recently,
      'has_friends', u.has_friends,
      'plans_started', u.plans_started
    )
  from user_behavior_snapshot u
  where
    u.has_friends = true
    and u.commented_recently = false
    and u.has_group_plan = true
    and u.time_since_last_activity < interval '3 days'
    and u.plans_started > 0

    -- GLOBAL COOLDOWN
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )

    -- BLOCK IF ANY HIGHER PRIORITY EXISTS
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 7
        and t.created_at > now() - interval '1 day'
    )

    -- PER-TRIGGER COOLDOWN
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'social_prompt'
        and t.created_at > now() - interval '14 days'
    );

end;
$$;
t

