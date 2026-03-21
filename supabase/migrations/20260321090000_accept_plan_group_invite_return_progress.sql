drop function if exists public.accept_plan_group_invite(uuid, uuid, date);

create or replace function public.accept_plan_group_invite(
  p_group_id uuid,
  p_plan_id uuid,
  p_start_date date
)
returns public.plan_progress
language plpgsql
as $$
declare
  v_progress public.plan_progress;
begin
  update plan_group_members
  set status = 'accepted',
      joined_at = now()
  where group_id = p_group_id
    and user_id = auth.uid();

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
