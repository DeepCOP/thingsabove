create or replace function public.devotional_plan_allowed_tags()
returns text[]
language sql
immutable
set search_path = pg_catalog, public
as $$
  select array[
    'Prayer',
    'Faith',
    'Hope',
    'Healing',
    'Gratitude',
    'Peace',
    'Wisdom',
    'Discipleship',
    'Family',
    'Leadership',
    'Knowledge',
    'Virtue',
    'Fellowship'
  ]::text[];
$$;


