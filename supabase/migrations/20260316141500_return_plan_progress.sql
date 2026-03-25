drop function if exists public.start_plan_progress(uuid, uuid, uuid, timestamptz);

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
  v_progress_id uuid;
  v_progress public.plan_progress;
begin
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


drop function if exists public.create_plan_group(uuid, uuid, date, uuid[]);

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
  v_group_id uuid;
  v_progress_id uuid;
  v_progress public.plan_progress;
begin
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
