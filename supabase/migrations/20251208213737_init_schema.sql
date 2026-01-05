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


--comments
create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  content text not null,
  entity_type text check (entity_type in ('plan', 'day')),
  entity_id uuid not null,
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


create index if not exists idx_comments_entity 
  on public.comments(entity_type, entity_id);

create index if not exists idx_comments_user_id 
  on public.comments(user_id);


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


-- Plan Progress
create table if not exists public.plan_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  current_day int not null default 1,
  completed_days int[] default '{}',
  updated_at timestamptz default now(),
  created_at timestamptz default now(),
  unique (user_id, plan_id)
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

  -- comments count
  (select count(*) from public.comments c 
   where c.entity_type = 'plan' and c.entity_id = p.id) as comments_count,

  -- like count
  (select count(*) from public.plan_reactions r 
   where r.plan_id = p.id and r.reaction_type = 'like') as likes_count,

  -- dislike count
  (select count(*) from public.plan_reactions r 
   where r.plan_id = p.id and r.reaction_type = 'dislike') as dislikes_count

from public.devotional_plans p;


--search
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


create table if not exists public.day_items_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  day_id uuid references public.devotional_days(id) on delete cascade,
  item_type text check (item_type in ('devotional', 'scripture')),
  item_key text, -- e.g. scripture reference or 'main'
  completed boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique (user_id, plan_id, day_id, item_type, item_key)
);


create or replace function public.ensure_day_items_exist(
  p_user_id uuid,
  p_plan_id uuid,
  p_day_id uuid
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
    user_id, plan_id, day_id, item_type, item_key
  )
  values (
    p_user_id, p_plan_id, p_day_id, 'devotional', 'main'
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
      user_id, plan_id, day_id, item_type, item_key
    )
    values (
      p_user_id, p_plan_id, p_day_id, 'scripture', ref
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
  p_completed boolean
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

  perform ensure_day_items_exist(p_user_id, p_plan_id, p_day_id);

  -- Upsert item progress
  insert into day_items_progress (user_id, plan_id, day_id, item_type, item_key, completed)
  values (p_user_id, p_plan_id, p_day_id, p_item_type, p_item_key, p_completed)
  on conflict (user_id, plan_id, day_id, item_type, item_key)
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
    and day_id = p_day_id;

  -- Count completed items
  select count(*) into v_completed_items
  from day_items_progress
  where user_id = p_user_id
    and plan_id = p_plan_id
    and day_id = p_day_id
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
    and plan_id = p_plan_id;

else
  update plan_progress
  set 
    completed_days = array_remove(completed_days, v_day_number),
    updated_at = now()
  where user_id = p_user_id
    and plan_id = p_plan_id;
end if;


end;
$$;


create or replace function public.toggle_day_completion(
  p_user_id uuid,
  p_plan_id uuid,
  p_day_id uuid,
  p_completed boolean
)
returns void
language plpgsql
as $$
declare
  v_day_number int;
begin
  -- Ensure items exist for the day
  perform ensure_day_items_exist(p_user_id, p_plan_id, p_day_id);

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
    and day_id = p_day_id;

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
      and plan_id = p_plan_id;
  else
    update plan_progress
    set
      completed_days = array_remove(completed_days, v_day_number),
      updated_at = now()
    where user_id = p_user_id
      and plan_id = p_plan_id;
  end if;

end;
$$;
