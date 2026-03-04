-- Fix plan completion counting:
-- 1) Ensure day items exist before item-level completion checks.
-- 2) Increment devotional_plans.completions exactly once using completed_once gate.
-- 3) Apply the same first-time completion increment logic to toggle_day_completion.

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
  v_is_plan_complete boolean;
begin
  -- Ensure we are counting against the full set of day items
  perform ensure_day_items_exist(p_user_id, p_plan_id, p_progress_id, p_day_id, p_group_id);

  -- Read plan length
  select dp.total_days
  into v_plan_total_days
  from plan_progress pp
  join devotional_plans dp on dp.id = pp.plan_id
  where pp.id = p_progress_id
  and pp.user_id = p_user_id
    and (
      (p_group_id is null and pp.group_id is null)
      or pp.group_id = p_group_id
    );

  if v_plan_total_days is null then
    return;
  end if;

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
      when not (v_day_number = any(coalesce(completed_days, '{}'::int[])))
        then array_append(coalesce(completed_days, '{}'::int[]), v_day_number)
      else coalesce(completed_days, '{}'::int[])
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
    set completed_days = array_remove(coalesce(completed_days, '{}'::int[]), v_day_number),
        updated_at = now()
    where user_id = p_user_id
      and id = p_progress_id
      and (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );
  end if;

  -- Increment completions when a plan is completed for the first time
  select (coalesce(array_length(coalesce(pp.completed_days, '{}'::int[]), 1), 0) >= v_plan_total_days)
  into v_is_plan_complete
  from plan_progress pp
  where pp.id = p_progress_id
    and pp.user_id = p_user_id
    and (
      (p_group_id is null and pp.group_id is null)
      or pp.group_id = p_group_id
    );

  if v_is_plan_complete is true then
    -- Flip completed_once exactly once; only then bump plan completions.
    update plan_progress
    set completed_once = true,
        updated_at = now()
    where id = p_progress_id
      and user_id = p_user_id
      and coalesce(completed_once, false) = false
      and (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );

    if found then
      update devotional_plans
      set completions = coalesce(completions, 0) + 1,
          updated_at = now()
      where id = p_plan_id;
    end if;
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
  v_plan_total_days int;
  v_is_plan_complete boolean;
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
        when not (v_day_number = any(coalesce(completed_days, '{}'::int[])))
          then array_append(coalesce(completed_days, '{}'::int[]), v_day_number)
        else coalesce(completed_days, '{}'::int[])
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
    set
      completed_days = array_remove(coalesce(completed_days, '{}'::int[]), v_day_number),
      updated_at = now()
    where user_id = p_user_id
      and id = p_progress_id
      and (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );
  end if;

  -- If plan is now complete, increment completions exactly once.
  select dp.total_days
  into v_plan_total_days
  from devotional_plans dp
  where dp.id = p_plan_id;

  if v_plan_total_days is null then
    return;
  end if;

  select (coalesce(array_length(coalesce(pp.completed_days, '{}'::int[]), 1), 0) >= v_plan_total_days)
  into v_is_plan_complete
  from plan_progress pp
  where pp.id = p_progress_id
    and pp.user_id = p_user_id
    and (
      (p_group_id is null and pp.group_id is null)
      or pp.group_id = p_group_id
    );

  if v_is_plan_complete is true then
    update plan_progress
    set completed_once = true,
        updated_at = now()
    where id = p_progress_id
      and user_id = p_user_id
      and coalesce(completed_once, false) = false
      and (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );

    if found then
      update devotional_plans
      set completions = coalesce(completions, 0) + 1,
          updated_at = now()
      where id = p_plan_id;
    end if;
  end if;
end;
$$;
