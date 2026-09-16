create or replace function public.plan_tags()
returns text[]
language sql
immutable
set search_path = pg_catalog, public
as $$
  select array[
    'prayer',
    'faith',
    'hope',
    'healing',
    'gratitude',
    'peace',
    'wisdom',
    'discipleship',
    'family',
    'leadership',
    'knowledge',
    'virtue',
    'fellowship',
    'obedience',
    'walking',
    'covenants',
    'reading'
  ]::text[];
$$;

update public.devotional_plans dp
set tags = (
  select coalesce(array_agg(lower(tag.value) order by tag.ordinality), '{}'::text[])
  from unnest(dp.tags) with ordinality as tag(value, ordinality)
)
where dp.tags is not null;

update public.plan_submissions ps
set
  submitted_tags = normalized.tags,
  submitted_payload = jsonb_set(
    ps.submitted_payload,
    '{plan,tags}',
    to_jsonb(normalized.tags),
    true
  )
from (
  select
    id,
    coalesce(array_agg(lower(tag.value) order by tag.ordinality), '{}'::text[]) as tags
  from public.plan_submissions
  cross join lateral unnest(submitted_tags) with ordinality as tag(value, ordinality)
  group by id
) normalized
where ps.id = normalized.id;
