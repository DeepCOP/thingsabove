alter table public.day_items_progress
drop constraint if exists day_items_progress_item_type_check;

alter table public.day_items_progress
add constraint day_items_progress_item_type_check
check (item_type in ('devotional', 'scripture', 'comment'));

alter table public.day_items_progress
alter column progress_id set not null;

alter table public.day_items_progress
alter column day_id set not null;

alter table public.day_items_progress
alter column item_type set not null;

alter table public.day_items_progress
alter column item_key set not null;

drop index if exists public.uniq_day_items_personal;

drop index if exists public.uniq_day_items_group;

delete from public.day_items_progress dip
using (
  select
    id,
    row_number() over (
      partition by progress_id, day_id, item_type, item_key
      order by updated_at desc nulls last, created_at desc nulls last, id desc
    ) as duplicate_rank
  from public.day_items_progress
) duplicates
where dip.id = duplicates.id
  and duplicates.duplicate_rank > 1;

create unique index if not exists uniq_day_items_progress_identity
on public.day_items_progress (progress_id, day_id, item_type, item_key);

create or replace function public.day_item_stable_id(
  p_progress_id uuid,
  p_day_id uuid,
  p_item_type text,
  p_item_key text
)
returns uuid
language sql
immutable
as $$
  with digest as (
    select md5(
      concat_ws(
        ':',
        p_progress_id::text,
        p_day_id::text,
        coalesce(p_item_type, ''),
        coalesce(p_item_key, '')
      )
    ) as hex
  )
  select (
    substr(hex, 1, 8) || '-' ||
    substr(hex, 9, 4) || '-' ||
    substr(hex, 13, 4) || '-' ||
    substr(hex, 17, 4) || '-' ||
    substr(hex, 21, 12)
  )::uuid
  from digest;
$$;

create or replace function public.get_day_item_templates(
  p_plan_id uuid,
  p_day_id uuid,
  p_group_id uuid default null
)
returns table (
  item_type text,
  item_key text,
  devotional_content text,
  day_number int,
  title text
)
language sql
stable
as $$
  with day_base as (
    select
      dd.content as devotional_content,
      dd.day_number,
      dd.title
    from public.devotional_days dd
    where dd.id = p_day_id
      and dd.plan_id = p_plan_id
  ),
  scripture_items as (
    select distinct trim(refs.ref) as item_key
    from public.scripture_references sr
    cross join lateral unnest(coalesce(sr.reference, '{}'::text[])) as refs(ref)
    where sr.day_id = p_day_id
      and nullif(trim(refs.ref), '') is not null
  )
  select
    'devotional'::text as item_type,
    'main'::text as item_key,
    db.devotional_content,
    db.day_number,
    db.title
  from day_base db

  union all

  select
    'scripture'::text as item_type,
    si.item_key,
    null::text as devotional_content,
    db.day_number,
    db.title
  from day_base db
  join scripture_items si on true

  union all

  select
    'comment'::text as item_type,
    'comment'::text as item_key,
    null::text as devotional_content,
    db.day_number,
    db.title
  from day_base db
  where p_group_id is not null;
$$;

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
begin
  -- Day items are now derived from source tables at read time.
  return;
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
  v_day_number int;
  v_total_items int;
  v_completed_items int;
  v_plan_total_days int;
  v_is_plan_complete boolean;
begin
  if not exists (
    select 1
    from public.get_day_item_templates(p_plan_id, p_day_id, p_group_id) item
    where item.item_type = p_item_type
      and item.item_key = p_item_key
  ) then
    return;
  end if;

  select dd.day_number
  into v_day_number
  from public.devotional_days dd
  where dd.id = p_day_id
    and dd.plan_id = p_plan_id;

  if v_day_number is null then
    return;
  end if;

  select dp.total_days
  into v_plan_total_days
  from public.plan_progress pp
  join public.devotional_plans dp on dp.id = pp.plan_id
  where pp.id = p_progress_id
    and pp.user_id = p_user_id
    and (
      (p_group_id is null and pp.group_id is null)
      or pp.group_id = p_group_id
    );

  if v_plan_total_days is null then
    return;
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
    where dip.progress_id = p_progress_id
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
    on dip.progress_id = p_progress_id
   and dip.day_id = p_day_id
   and dip.item_type = item.item_type
   and dip.item_key = item.item_key
   and dip.completed is true;

  if v_total_items > 0 and v_completed_items = v_total_items then
    update public.plan_progress
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
    update public.plan_progress
    set completed_days = array_remove(coalesce(completed_days, '{}'::int[]), v_day_number),
        updated_at = now()
    where user_id = p_user_id
      and id = p_progress_id
      and (
        (p_group_id is null and group_id is null)
        or group_id = p_group_id
      );
  end if;

  select (
    coalesce(array_length(coalesce(pp.completed_days, '{}'::int[]), 1), 0) >= v_plan_total_days
  )
  into v_is_plan_complete
  from public.plan_progress pp
  where pp.id = p_progress_id
    and pp.user_id = p_user_id
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
  v_total_items int;
  v_plan_total_days int;
  v_is_plan_complete boolean;
begin
  select dd.day_number
  into v_day_number
  from public.devotional_days dd
  where dd.id = p_day_id
    and dd.plan_id = p_plan_id;

  if v_day_number is null then
    return;
  end if;

  select count(*)
  into v_total_items
  from public.get_day_item_templates(p_plan_id, p_day_id, p_group_id);

  if v_total_items = 0 then
    return;
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
    where dip.progress_id = p_progress_id
      and dip.day_id = p_day_id
      and dip.item_type = item.item_type
      and dip.item_key = item.item_key;
  end if;

  if p_completed then
    update public.plan_progress
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
    update public.plan_progress
    set completed_days = array_remove(coalesce(completed_days, '{}'::int[]), v_day_number),
        updated_at = now()
    where user_id = p_user_id
      and id = p_progress_id
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
    return;
  end if;

  select (
    coalesce(array_length(coalesce(pp.completed_days, '{}'::int[]), 1), 0) >= v_plan_total_days
  )
  into v_is_plan_complete
  from public.plan_progress pp
  where pp.id = p_progress_id
    and pp.user_id = p_user_id
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

create or replace function public.get_day_items_progress(
  p_user_id uuid,
  p_plan_id uuid,
  p_progress_id uuid,
  p_day_id uuid,
  p_group_id uuid default null
)
returns setof public.day_items_progress
language sql
stable
as $$
  with template_items as (
    select *
    from public.get_day_item_templates(p_plan_id, p_day_id, p_group_id)
  )
  select
    public.day_item_stable_id(p_progress_id, p_day_id, item.item_type, item.item_key) as id,
    p_user_id as user_id,
    p_plan_id as plan_id,
    p_progress_id as progress_id,
    p_day_id as day_id,
    item.item_type,
    item.item_key,
    item.devotional_content,
    item.day_number,
    item.title,
    p_group_id as group_id,
    coalesce(dip.completed, false) as completed,
    dip.created_at,
    dip.updated_at
  from template_items item
  left join public.day_items_progress dip
    on dip.progress_id = p_progress_id
   and dip.day_id = p_day_id
   and dip.item_type = item.item_type
   and dip.item_key = item.item_key
  order by
    case item.item_type
      when 'devotional' then 0
      when 'scripture' then 1
      when 'comment' then 2
      else 3
    end,
    item.item_key;
$$;
