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


