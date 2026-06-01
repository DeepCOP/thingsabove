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
  where btrim(coalesce(db.devotional_content, '')) <> ''

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
  from day_base db;
$$;
