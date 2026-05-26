-- Run completion writes with definer privileges so the aggregate plan completion
-- counter can bypass devotional_plans RLS, while explicitly constraining callers
-- to their own plan_progress row.

create or replace function public.sync_plan_completion(
  p_user_id uuid,
  p_plan_id uuid,
  p_progress_id uuid,
  p_group_id uuid,
  p_day_number int,
  p_day_completed boolean
)
returns void
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_plan_total_days int;
  v_is_plan_complete boolean;
  v_progress_plan_id uuid;
  v_progress_group_id uuid;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  if p_user_id is distinct from auth.uid() then
    raise exception 'Cannot update another user''s plan progress';
  end if;

  if p_day_number is null then
    raise exception 'Day number is required';
  end if;

  select pp.plan_id, pp.group_id
  into v_progress_plan_id, v_progress_group_id
  from public.plan_progress pp
  where pp.id = p_progress_id
    and pp.user_id = p_user_id
  for update;

  if not found then
    raise exception 'Plan progress not found for current user';
  end if;

  if v_progress_plan_id is distinct from p_plan_id then
    raise exception 'Plan progress does not match plan';
  end if;

  if v_progress_group_id is distinct from p_group_id then
    raise exception 'Plan progress does not match group';
  end if;

  if not exists (
    select 1
    from public.devotional_days dd
    where dd.plan_id = p_plan_id
      and dd.day_number = p_day_number
  ) then
    raise exception 'Day not found for plan';
  end if;

  if coalesce(p_day_completed, false) then
    update public.plan_progress
    set completed_days = case
      when not (p_day_number = any(coalesce(completed_days, '{}'::int[])))
        then array_append(coalesce(completed_days, '{}'::int[]), p_day_number)
      else coalesce(completed_days, '{}'::int[])
    end,
    updated_at = now()
    where user_id = p_user_id
      and id = p_progress_id
      and plan_id = p_plan_id
      and (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );
  else
    update public.plan_progress
    set completed_days = array_remove(coalesce(completed_days, '{}'::int[]), p_day_number),
        updated_at = now()
    where user_id = p_user_id
      and id = p_progress_id
      and plan_id = p_plan_id
      and (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );
  end if;

  select dp.total_days
  into v_plan_total_days
  from public.devotional_plans dp
  where dp.id = p_plan_id;

  if v_plan_total_days is null then
    raise exception 'Plan not found';
  end if;

  select (
    coalesce(array_length(coalesce(pp.completed_days, '{}'::int[]), 1), 0) >= v_plan_total_days
  )
  into v_is_plan_complete
  from public.plan_progress pp
  where pp.id = p_progress_id
    and pp.user_id = p_user_id
    and pp.plan_id = p_plan_id
    and (
      (p_group_id is null and pp.group_id is null)
      or pp.group_id = p_group_id
    );

  if v_is_plan_complete is true then
    update public.plan_progress
    set completed_once = true,
        updated_at = now()
    where id = p_progress_id
      and user_id = p_user_id
      and plan_id = p_plan_id
      and coalesce(completed_once, false) = false
      and (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );

    if found then
      update public.devotional_plans
      set completions = coalesce(completions, 0) + 1,
          updated_at = now()
      where id = p_plan_id;
    end if;
  end if;
end;
$$;

revoke execute on function public.sync_plan_completion(uuid, uuid, uuid, uuid, integer, boolean)
from public;

create or replace function public.resolve_plan_progress_day_number(
  p_user_id uuid,
  p_plan_id uuid,
  p_progress_id uuid,
  p_group_id uuid,
  p_day_id uuid,
  p_item_type text default null,
  p_item_key text default null
)
returns int
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_day_number int;
  v_progress_plan_id uuid;
  v_progress_group_id uuid;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  if p_user_id is distinct from auth.uid() then
    raise exception 'Cannot update another user''s plan progress';
  end if;

  select pp.plan_id, pp.group_id
  into v_progress_plan_id, v_progress_group_id
  from public.plan_progress pp
  where pp.id = p_progress_id
    and pp.user_id = p_user_id
  for update;

  if not found then
    raise exception 'Plan progress not found for current user';
  end if;

  if v_progress_plan_id is distinct from p_plan_id then
    raise exception 'Plan progress does not match plan';
  end if;

  if v_progress_group_id is distinct from p_group_id then
    raise exception 'Plan progress does not match group';
  end if;

  select dd.day_number
  into v_day_number
  from public.devotional_days dd
  where dd.id = p_day_id
    and dd.plan_id = p_plan_id;

  if v_day_number is null then
    raise exception 'Day not found for plan';
  end if;

  if (p_item_type is null) is distinct from (p_item_key is null) then
    raise exception 'Day item type and key must be provided together';
  end if;

  if p_item_type is not null and not exists (
    select 1
    from public.get_day_item_templates(p_plan_id, p_day_id, p_group_id) item
    where item.item_type = p_item_type
      and item.item_key = p_item_key
  ) then
    raise exception 'Day item not found for plan day';
  end if;

  return v_day_number;
end;
$$;

revoke execute on function public.resolve_plan_progress_day_number(
  uuid,
  uuid,
  uuid,
  uuid,
  uuid,
  text,
  text
)
from public;

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
security definer
set search_path = pg_catalog, public
as $$
declare
  v_day_number int;
  v_total_items int;
  v_completed_items int;
begin
  v_day_number := public.resolve_plan_progress_day_number(
    p_user_id,
    p_plan_id,
    p_progress_id,
    p_group_id,
    p_day_id,
    p_item_type,
    p_item_key
  );

  if p_completed then
    insert into public.day_items_progress (
      user_id,
      progress_id,
      plan_id,
      day_id,
      item_type,
      item_key,
      completed,
      group_id
    )
    values (
      p_user_id,
      p_progress_id,
      p_plan_id,
      p_day_id,
      p_item_type,
      p_item_key,
      true,
      p_group_id
    )
    on conflict (progress_id, day_id, item_type, item_key)
    do update
    set user_id = excluded.user_id,
        plan_id = excluded.plan_id,
        group_id = excluded.group_id,
        completed = true,
        updated_at = now();
  else
    delete from public.day_items_progress dip
    where dip.user_id = p_user_id
      and dip.progress_id = p_progress_id
      and dip.day_id = p_day_id
      and dip.item_type = p_item_type
      and dip.item_key = p_item_key;
  end if;

  select count(*)
  into v_total_items
  from public.get_day_item_templates(p_plan_id, p_day_id, p_group_id);

  select count(*)
  into v_completed_items
  from public.get_day_item_templates(p_plan_id, p_day_id, p_group_id) item
  join public.day_items_progress dip
    on dip.user_id = p_user_id
   and dip.progress_id = p_progress_id
   and dip.plan_id = p_plan_id
   and dip.day_id = p_day_id
   and dip.item_type = item.item_type
   and dip.item_key = item.item_key
   and dip.completed is true;

  perform public.sync_plan_completion(
    p_user_id,
    p_plan_id,
    p_progress_id,
    p_group_id,
    v_day_number,
    v_total_items > 0 and v_completed_items = v_total_items
  );
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
security definer
set search_path = pg_catalog, public
as $$
declare
  v_day_number int;
  v_total_items int;
begin
  v_day_number := public.resolve_plan_progress_day_number(
    p_user_id,
    p_plan_id,
    p_progress_id,
    p_group_id,
    p_day_id
  );

  select count(*)
  into v_total_items
  from public.get_day_item_templates(p_plan_id, p_day_id, p_group_id);

  if v_total_items = 0 then
    raise exception 'No day items found for plan day';
  end if;

  if p_completed then
    insert into public.day_items_progress (
      user_id,
      progress_id,
      plan_id,
      day_id,
      item_type,
      item_key,
      completed,
      group_id
    )
    select
      p_user_id,
      p_progress_id,
      p_plan_id,
      p_day_id,
      item.item_type,
      item.item_key,
      true,
      p_group_id
    from public.get_day_item_templates(p_plan_id, p_day_id, p_group_id) item
    on conflict (progress_id, day_id, item_type, item_key)
    do update
    set user_id = excluded.user_id,
        plan_id = excluded.plan_id,
        group_id = excluded.group_id,
        completed = true,
        updated_at = now();
  else
    delete from public.day_items_progress dip
    using public.get_day_item_templates(p_plan_id, p_day_id, p_group_id) item
    where dip.user_id = p_user_id
      and dip.progress_id = p_progress_id
      and dip.plan_id = p_plan_id
      and dip.day_id = p_day_id
      and dip.item_type = item.item_type
      and dip.item_key = item.item_key;
  end if;

  perform public.sync_plan_completion(
    p_user_id,
    p_plan_id,
    p_progress_id,
    p_group_id,
    v_day_number,
    p_completed
  );
end;
$$;
