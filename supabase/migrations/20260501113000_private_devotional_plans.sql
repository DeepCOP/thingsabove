alter table public.devotional_plans
  add column if not exists visibility text;

update public.devotional_plans
set visibility = 'public'
where visibility is null;

alter table public.devotional_plans
  alter column visibility set default 'public',
  alter column visibility set not null;

alter table public.devotional_plans
  drop constraint if exists devotional_plans_visibility_check;

alter table public.devotional_plans
  add constraint devotional_plans_visibility_check
  check (visibility in ('public', 'private'));

create or replace function public.is_accepted_group_member(p_group_id uuid)
returns boolean
language sql
security definer
stable
set search_path = pg_catalog, public
as $$
  select exists (
    select 1
    from public.plan_group_members pgm
    where pgm.group_id = p_group_id
      and pgm.user_id = auth.uid()
      and pgm.status = 'accepted'
  );
$$;

create or replace function public.can_access_plan(p_plan_id uuid)
returns boolean
language sql
security definer
stable
set search_path = pg_catalog, public
as $$
  select exists (
    select 1
    from public.devotional_plans p
    where p.id = p_plan_id
      and (
        (
          p.status = 'published'
          and coalesce(p.visibility, 'public') = 'public'
        )
        or p.author_id = auth.uid()
        or exists (
          select 1
          from public.plan_progress pp
          where pp.plan_id = p.id
            and pp.user_id = auth.uid()
        )
        or exists (
          select 1
          from public.plan_group_members pgm
          join public.plan_groups pg
            on pg.id = pgm.group_id
          where pg.plan_id = p.id
            and pgm.user_id = auth.uid()
            and pgm.status = 'accepted'
        )
      )
  );
$$;

drop policy if exists "plans are viewable by everyone" on public.devotional_plans;

create policy "plans are viewable when accessible"
  on public.devotional_plans
  for select
  using (public.can_access_plan(id));

drop policy if exists "devotional_days are public read" on public.devotional_days;

create policy "devotional_days are readable when plan is accessible"
  on public.devotional_days
  for select
  using (public.can_access_plan(plan_id));

drop policy if exists "comments readable by everyone" on public.comments;
drop policy if exists "logged in users can insert comments" on public.comments;
drop policy if exists "comment owners can update" on public.comments;
drop policy if exists "comment owners can delete" on public.comments;

create policy "accepted group members can read comments"
  on public.comments
  for select
  using (public.is_accepted_group_member(group_id));

create policy "accepted group members can insert comments"
  on public.comments
  for insert
  with check (
    auth.uid() = user_id
    and public.is_accepted_group_member(group_id)
  );

create policy "comment owners can update while in the group"
  on public.comments
  for update
  using (
    auth.uid() = user_id
    and public.is_accepted_group_member(group_id)
  )
  with check (
    auth.uid() = user_id
    and public.is_accepted_group_member(group_id)
  );

create policy "comment owners can delete while in the group"
  on public.comments
  for delete
  using (
    auth.uid() = user_id
    and public.is_accepted_group_member(group_id)
  );

drop function if exists public.search_plans(text, integer, timestamp with time zone, uuid);
drop view if exists public.devotional_plans_view;


create or replace view public.devotional_plans_view
with (security_invoker = true)
as
select
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
  p.visibility,
  (
    select count(*)
    from public.plan_reactions r
    where r.plan_id = p.id
      and r.reaction_type = 'helpful'
  ) as helpful_count,
  (
    select r.reaction_type
    from public.plan_reactions r
    where r.plan_id = p.id
      and r.user_id = auth.uid()
      and r.reaction_type = 'helpful'
    limit 1
  ) as user_reaction,
  (
    select coalesce(avg(pr.rating)::float, 0)
    from public.plan_ratings pr
    where pr.plan_id = p.id
  ) as rating_avg,
  (
    select count(*)
    from public.plan_ratings pr
    where pr.plan_id = p.id
  ) as rating_count
from public.devotional_plans p;

DROP FUNCTION IF EXISTS public.get_my_devotional_plans();


create or replace function public.get_my_devotional_plans()
returns table (
  id uuid,
  title text,
  status text,
  visibility text,
  description text,
  total_days int,
  cover_image text,
  created_at timestamptz,
  helpful_count int
)
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
begin
  return query
  select
    p.id,
    p.title,
    p.status,
    p.visibility,
    p.description,
    p.total_days,
    p.cover_image,
    p.created_at,
    count(*) filter (where r.reaction_type = 'helpful')::int as helpful_count
  from public.devotional_plans p
  left join public.plan_reactions r
    on r.plan_id = p.id
  where p.author_id = auth.uid()
  group by p.id
  order by p.created_at desc;
end;
$$;

create or replace function public.search_plans(
  search_query text,
  limit_count int default 20,
  cursor_created_at timestamptz default null,
  cursor_id uuid default null
)
returns setof devotional_plans_view
language sql
stable
as $$
  select *
  from devotional_plans_view
  where status = 'published'
    and visibility = 'public'
    and (
      cursor_created_at is null
      or (
        created_at < cursor_created_at
        or (created_at = cursor_created_at and id < cursor_id)
      )
    )
    and (
      lower(title) like lower(search_query) || '%'
      or lower(description) like lower(search_query) || '%'
      or lower(public.tags_to_text(tags)) like '%' || lower(search_query) || '%'
      or similarity(lower(title), lower(search_query)) > 0.2
      or similarity(lower(description), lower(search_query)) > 0.2
      or similarity(lower(public.tags_to_text(tags)), lower(search_query)) > 0.2
    )
  order by
    created_at desc,
    id desc
  limit limit_count;
$$;

create or replace function public.start_plan_progress(
  p_user_id uuid,
  p_plan_id uuid,
  p_group_id uuid default null,
  p_start_date timestamptz default now()
)
returns public.plan_progress
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_plan public.devotional_plans%rowtype;
  v_progress_id uuid;
  v_progress public.plan_progress;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  if auth.uid() <> p_user_id then
    raise exception 'You can only start plans for yourself';
  end if;

  select *
  into v_plan
  from public.devotional_plans
  where id = p_plan_id;

  if not found or v_plan.status <> 'published' then
    raise exception 'Plan not found';
  end if;

  if coalesce(v_plan.visibility, 'public') = 'private'
     and v_plan.author_id is distinct from auth.uid() then
    raise exception 'Only the plan author can start a private plan';
  end if;

  if p_group_id is not null then
    if not exists (
      select 1
      from public.plan_groups pg
      where pg.id = p_group_id
        and pg.plan_id = p_plan_id
    ) then
      raise exception 'Plan group not found';
    end if;

    if not public.is_accepted_group_member(p_group_id) then
      raise exception 'You must join the group before starting this plan';
    end if;
  end if;

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

  select *
  into v_progress
  from public.plan_progress
  where id = v_progress_id;

  return v_progress;
end;
$$;

create or replace function public.create_plan_group(
  p_user_id uuid,
  p_plan_id uuid,
  p_start_date date,
  p_friends_ids uuid[]
)
returns public.plan_progress
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_plan public.devotional_plans%rowtype;
  v_group_id uuid;
  v_progress_id uuid;
  v_progress public.plan_progress;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  if auth.uid() <> p_user_id then
    raise exception 'You can only create plan groups for yourself';
  end if;

  select *
  into v_plan
  from public.devotional_plans
  where id = p_plan_id;

  if not found or v_plan.status <> 'published' then
    raise exception 'Plan not found';
  end if;

  if coalesce(v_plan.visibility, 'public') = 'private'
     and v_plan.author_id is distinct from auth.uid() then
    raise exception 'Only the plan author can create a private group';
  end if;

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

  select *
  into v_progress
  from plan_progress
  where id = v_progress_id;

  return v_progress;
end;
$$;

create or replace function public.add_user_to_existing_plan_group(
  p_group_id uuid,
  p_friends_ids uuid[]
)
returns void
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_plan_id uuid;
  v_created_by uuid;
  v_visibility text;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  select
    pg.plan_id,
    pg.created_by,
    dp.visibility
  into
    v_plan_id,
    v_created_by,
    v_visibility
  from public.plan_groups pg
  join public.devotional_plans dp
    on dp.id = pg.plan_id
  where pg.id = p_group_id;

  if not found then
    raise exception 'Plan group not found';
  end if;

  if coalesce(v_visibility, 'public') = 'private'
     and v_created_by <> auth.uid() then
    raise exception 'Only the group organizer can invite others to a private plan';
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

create or replace function public.add_plan_day_comment(
  p_plan_id uuid,
  p_day_id uuid,
  p_content text,
  p_group_id uuid default null
)
returns void
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  if p_group_id is null then
    raise exception 'Comments require a group plan';
  end if;

  if not public.is_accepted_group_member(p_group_id) then
    raise exception 'Only accepted group members can comment';
  end if;

  if not exists (
    select 1
    from public.plan_groups pg
    where pg.id = p_group_id
      and pg.plan_id = p_plan_id
  ) then
    raise exception 'Plan group not found';
  end if;

  if not exists (
    select 1
    from public.devotional_days d
    where d.id = p_day_id
      and d.plan_id = p_plan_id
  ) then
    raise exception 'Plan day not found';
  end if;

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

DROP FUNCTION IF EXISTS public.get_plan_group_invitation(p_group_id uuid);


create or replace function public.get_plan_group_invitation(p_group_id uuid)
returns table(
  id uuid,
  created_by uuid,
  start_date date,
  plan_id uuid,
  max_members integer,
  completed_days integer,
  created_at timestamptz,
  inviter_id uuid,
  inviter_first_name text,
  inviter_last_name text,
  inviter_avatar_url text,
  plan_title text,
  plan_cover_image text,
  plan_total_days integer,
  plan_visibility text
)
language sql
security definer
set search_path = pg_catalog, public
as $$
  select
    pg.id,
    pg.created_by,
    pg.start_date,
    pg.plan_id,
    pg.max_members,
    pg.completed_days,
    pg.created_at,
    p.id as inviter_id,
    p.first_name as inviter_first_name,
    p.last_name as inviter_last_name,
    p.avatar_url as inviter_avatar_url,
    dp.title as plan_title,
    dp.cover_image as plan_cover_image,
    dp.total_days as plan_total_days,
    dp.visibility as plan_visibility
  from public.plan_groups pg
  join public.profiles p
    on p.id = pg.created_by
  join public.devotional_plans dp
    on dp.id = pg.plan_id
  where pg.id = p_group_id
    and dp.status = 'published';
$$;
DROP FUNCTION IF EXISTS public.get_my_saved_plans();

create or replace function public.get_my_saved_plans()
returns table (
  id uuid,
  title text,
  total_days int,
  description text,
  cover_image text,
  completions int,
  tags text[],
  author_id uuid,
  created_at timestamptz,
  status text,
  visibility text,
  updated_at timestamptz,
  helpful_count bigint,
  user_reaction text,
  rating_avg numeric,
  rating_count int,
  saved_at timestamptz
)
language sql
security invoker
stable
as $$
  select
    dpv.id,
    dpv.title,
    dpv.total_days,
    dpv.description,
    dpv.cover_image,
    dpv.completions,
    dpv.tags,
    dpv.author_id,
    dpv.created_at,
    dpv.status,
    dpv.visibility,
    dpv.updated_at,
    dpv.helpful_count,
    dpv.user_reaction,
    dpv.rating_avg,
    dpv.rating_count,
    sp.created_at as saved_at
  from public.saved_plans sp
  join public.devotional_plans_view dpv
    on dpv.id = sp.plan_id
  where sp.user_id = auth.uid()
    and dpv.status = 'published'
  order by sp.created_at desc;
$$;

DROP FUNCTION IF EXISTS public.get_my_plan_progress_plans();


create or replace function public.get_my_plan_progress_plans()
returns table (
  id uuid,
  title text,
  total_days int,
  description text,
  cover_image text,
  completions int,
  tags text[],
  author_id uuid,
  created_at timestamptz,
  status text,
  visibility text,
  updated_at timestamptz,
  helpful_count bigint,
  user_reaction text,
  rating_avg numeric,
  rating_count int,
  progress_id uuid,
  started_at timestamptz,
  group_id uuid,
  completed_days int,
  completed_once boolean
)
language sql
security invoker
stable
as $$
  select
    dpv.id,
    dpv.title,
    dpv.total_days,
    dpv.description,
    dpv.cover_image,
    dpv.completions,
    dpv.tags,
    dpv.author_id,
    dpv.created_at,
    dpv.status,
    dpv.visibility,
    dpv.updated_at,
    dpv.helpful_count,
    dpv.user_reaction,
    dpv.rating_avg,
    dpv.rating_count,
    pp.id as progress_id,
    coalesce(pp.created_at, pp.start_date) as started_at,
    pp.group_id,
    coalesce(array_length(pp.completed_days, 1), 0) as completed_days,
    coalesce(pp.completed_once, false) as completed_once
  from public.plan_progress pp
  join public.devotional_plans_view dpv
    on dpv.id = pp.plan_id
  where pp.user_id = auth.uid()
    and dpv.status = 'published'
  order by
    coalesce(pp.created_at, pp.start_date) desc,
    pp.id desc;
$$;
