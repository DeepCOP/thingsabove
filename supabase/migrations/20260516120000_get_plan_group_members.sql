create or replace function public.get_plan_group_members(p_group_id uuid)
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
stable
security invoker
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
