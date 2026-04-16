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
  inviter_avatar_url text
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
    p.avatar_url as inviter_avatar_url
  from public.plan_groups pg
  join public.profiles p on p.id = pg.created_by
  where pg.id = p_group_id;
$$;

create or replace function public.get_plan_group_invitation_members(p_group_id uuid)
returns table(
  id uuid,
  status text,
  joined_at timestamptz,
  user_id uuid,
  profile_id uuid,
  first_name text,
  last_name text,
  avatar_url text
)
language sql
security definer
set search_path = pg_catalog, public
as $$
  select
    pgm.id,
    pgm.status,
    pgm.joined_at,
    pgm.user_id,
    p.id as profile_id,
    p.first_name,
    p.last_name,
    p.avatar_url
  from public.plan_group_members pgm
  join public.profiles p on p.id = pgm.user_id
  where pgm.group_id = p_group_id
    and pgm.status = 'accepted'
  order by pgm.joined_at asc nulls last;
$$;

drop function if exists public.accept_plan_group_invite(uuid, uuid, date);

create or replace function public.accept_plan_group_invite(
  p_group_id uuid,
  p_plan_id uuid,
  p_start_date date
)
returns public.plan_progress
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_progress public.plan_progress;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;
  if not exists (
    select 1
    from public.plan_groups pg
    where pg.id = p_group_id
      and pg.plan_id = p_plan_id
  ) then
    raise exception 'Plan group not found';
  end if;

  insert into plan_group_members (
    group_id,
    user_id,
    status,
    joined_at
  )
  values (
    p_group_id,
    auth.uid(),
    'accepted',
    now()
  )
  on conflict (group_id, user_id) do update
  set status = 'accepted',
      joined_at = coalesce(plan_group_members.joined_at, excluded.joined_at);

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

  select *
  into v_progress
  from plan_progress
  where user_id = auth.uid()
    and plan_id = p_plan_id
    and group_id = p_group_id;

  return v_progress;
end;
$$;
