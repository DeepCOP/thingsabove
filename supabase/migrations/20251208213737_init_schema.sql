--Profiles
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text not null,
  last_name text not null,
  email text unique not null,
  avatar_url text,
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


--Devotional days
create table if not exists public.devotional_days (
  id uuid primary key default gen_random_uuid(),
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  day_number int not null,
  content text not null,
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




-- Reports
create table if not exists public.reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  reason text not null,
  created_at timestamptz default now()
);


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


create or replace function public.toggle_reaction(
  p_plan_id uuid,
  p_user_id uuid,
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
    and user_id = p_user_id
    and reaction_type = 'like'
  limit 1;

  select id into existing_dislike
  from public.plan_reactions
  where plan_id = p_plan_id
    and user_id = p_user_id
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
  values (p_plan_id, p_user_id, p_reaction_type);

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


create policy "users can upload their own avatar"
on storage.objects
for insert
with check (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
);


create policy "users can update their own avatar"
on storage.objects
for update
using (
  auth.uid() = owner
)
with check  (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
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

create policy "authors upload plan images"
on storage.objects
for insert
with check (
  bucket_id = 'plan_images'
  and exists (
    select 1
    from public.devotional_plans p
    where p.id::text = (storage.foldername(name))[1]
    and p.author_id = auth.uid()
  )
);


create policy "authors delete cover images"
on storage.objects
for delete
using (
  bucket_id = 'plan_images'
  and exists (
    select 1
    from public.devotional_plans p
    where p.id::text = (storage.foldername(name))[1]
    and p.author_id = auth.uid()
  )
);

create policy "authors update cover images"
on storage.objects
for update
using (
  bucket_id = 'plan_images'
  and exists (
    select 1
    from public.devotional_plans p
    where p.id::text = (storage.foldername(name))[1]
    and p.author_id = auth.uid()
  )
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

create or replace view public.plan_day_view as
select 
    d.id as day_id,
    d.plan_id,
    d.day_number,
    d.content as devotional_content,
    (select r.reference 
     from scripture_references r
     where r.day_id = d.id) as scripture_refs
from devotional_days d
order by d.day_number;



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
  friendship_status text
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
    f.status as friendship_status
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
  invite_code text unique,
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
  v_invite_code text;
begin
  -- Generate a short invite code
  v_invite_code := substr(encode(gen_random_bytes(6), 'hex'), 1, 8);

  -- 1️⃣ Create plan group
  insert into plan_groups (
    plan_id,
    created_by,
    start_date,
    invite_code
  )
  values (
    p_plan_id,
    p_user_id,
    p_start_date,
    v_invite_code
  )
  returning id into v_group_id;

  -- 2️⃣ Add creator as accepted member
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

  -- 3️⃣ Create plan progress for creator (group-aware)
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

  -- 4️⃣ Return the group id
  return v_group_id;
end;
$$;


create or replace function public.accept_plan_group_invite(
  p_group_id uuid,
  p_plan_id uuid,
  p_start_date date
)
returns void
language plpgsql
as $$
begin

  update plan_group_members
  set status = 'accepted',
      joined_at = now()
  where group_id = p_group_id
    and user_id = auth.uid();

    
  -- 3️⃣ Create plan progress for creator (group-aware)
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
end;
$$;

create or replace function public.invite_friends_to_plan_group(
  p_group_id uuid,
  p_user_ids uuid[]
)
returns void
language plpgsql
security definer
as $$
begin
  insert into plan_group_members (group_id, user_id, status)
  select p_group_id, unnest(p_user_ids), 'pending'
  on conflict (group_id, user_id) do nothing;
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
  start_date timestamptz default now(),
  updated_at timestamptz default now(),
  created_at timestamptz default now(),
  unique (user_id, plan_id, group_id)
);

alter table public.plan_progress enable row level security;


create policy "users can view their own progress"
  on public.plan_progress
  for select
  using (auth.uid() = user_id);


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



create table if not exists public.day_items_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  day_id uuid references public.devotional_days(id) on delete cascade,
  item_type text check (item_type in ('devotional', 'scripture')),
  item_key text, -- e.g. scripture reference or 'main'
  group_id uuid references public.plan_groups(id) on delete cascade,
  completed boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique (user_id, plan_id, day_id, item_type, item_key, group_id)
);


create or replace function public.ensure_day_items_exist(
  p_user_id uuid,
  p_plan_id uuid,
  p_day_id uuid,
  p_group_id uuid default null
)
returns void
language plpgsql
as $$
declare
  refs text[];
  ref text;
begin
  -- 1️⃣ Ensure devotional item
  insert into day_items_progress (
    user_id, plan_id, day_id, item_type, item_key, group_id
  )
  values (
    p_user_id, p_plan_id, p_day_id, 'devotional', 'main', p_group_id
  )
  on conflict do nothing;

  -- 2️⃣ Load scripture references (text[])
  select reference
  into refs
  from scripture_references
  where day_id = p_day_id
  limit 1;

  if refs is null then
    return;
  end if;

  -- 3️⃣ Ensure one item per scripture ref
  foreach ref in array refs loop
    insert into day_items_progress (
      user_id, plan_id, day_id, item_type, item_key, group_id
    )
    values (
      p_user_id, p_plan_id, p_day_id, 'scripture', ref, p_group_id
    )
    on conflict do nothing;
  end loop;
end;
$$;


create or replace function public.toggle_item_completion(
  p_user_id uuid,
  p_plan_id uuid,
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
  v_total_days int;
begin

  perform ensure_day_items_exist(p_user_id, p_plan_id, p_day_id, p_group_id);

  -- Upsert item progress
  insert into day_items_progress (user_id, plan_id, day_id, item_type, item_key, completed, group_id)
  values (p_user_id, p_plan_id, p_day_id, p_item_type, p_item_key, p_completed, p_group_id)
  on conflict (user_id, plan_id, day_id, item_type, item_key, group_id)
  do update set completed = p_completed, updated_at = now();

  -- Get day number
  select day_number into v_day_number
  from devotional_days
  where id = p_day_id;

  -- Get total days in plan
  select total_days into v_total_days
  from devotional_plans
  where id = p_plan_id;


  -- Count total items for the day (devotional + scripture)
  select count(*) into v_total_items
  from day_items_progress
  where user_id = p_user_id
    and plan_id = p_plan_id
    and group_id = p_group_id
    and day_id = p_day_id;

  -- Count completed items
  select count(*) into v_completed_items
  from day_items_progress
  where user_id = p_user_id
    and plan_id = p_plan_id
    and day_id = p_day_id
    and group_id = p_group_id
    and completed = true;

  -- Update plan_progress.completed_days safely
-- Update plan_progress.completed_days safely
if v_completed_items = v_total_items then
  update plan_progress
  set 
    completed_days = case
      when not (v_day_number = ANY(completed_days))
        then array_append(completed_days, v_day_number)
      else completed_days
    end,
    updated_at = now()
  where user_id = p_user_id
    and plan_id = p_plan_id
    and group_id = p_group_id;

else
  update plan_progress
  set 
    completed_days = array_remove(completed_days, v_day_number),
    updated_at = now()
  where user_id = p_user_id
    and plan_id = p_plan_id
    and group_id = p_group_id;
end if;


end;
$$;


create or replace function public.toggle_day_completion(
  p_user_id uuid,
  p_plan_id uuid,
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
  perform ensure_day_items_exist(p_user_id, p_plan_id, p_day_id, p_group_id);

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
    and plan_id = p_plan_id
    and day_id = p_day_id
    and group_id = p_group_id;


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
      and plan_id = p_plan_id
      and group_id = p_group_id;
  else
    update plan_progress
    set
      completed_days = array_remove(completed_days, v_day_number),
      updated_at = now()
    where user_id = p_user_id
      and plan_id = p_plan_id
      and group_id = p_group_id;
  end if;

end;
$$;


--comments
create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  plan_id uuid not null references devotional_plans(id) on delete cascade,
  day_id uuid not null references devotional_days(id) on delete cascade,
  group_id uuid references public.plan_groups(id) on delete cascade,
  content text not null check (length(trim(content)) > 0),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);


alter table public.comments enable row level security;


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
