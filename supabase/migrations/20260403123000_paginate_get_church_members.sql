create or replace function public.get_church_members(
  p_church_id uuid,
  p_limit integer default 20,
  p_offset integer default 0,
  p_search text default null
)
returns table (
  id uuid,
  first_name text,
  last_name text,
  avatar_url text,
  church_joined_at timestamptz
)
language plpgsql
security definer
set search_path = pg_catalog, public
stable
as $$
declare
  v_viewer_church_id uuid;
  v_limit integer := greatest(coalesce(p_limit, 20), 1);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
  v_search text := nullif(trim(coalesce(p_search, '')), '');
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  select church_id
    into v_viewer_church_id
  from public.profiles
  where profiles.id = auth.uid();


  return query
    with church_members as (
      select
        p.id,
        p.first_name,
        p.last_name,
        p.avatar_url,
        p.church_joined_at
      from public.profiles p
      where p.church_id = p_church_id
        and (
          v_search is null
          or concat_ws(' ', coalesce(p.first_name, ''), coalesce(p.last_name, '')) ilike '%' || v_search || '%'
          or coalesce(p.first_name, '') ilike '%' || v_search || '%'
          or coalesce(p.last_name, '') ilike '%' || v_search || '%'
          or coalesce(p.email, '') ilike '%' || v_search || '%'
        )
    )
    select
      cm.id,
      cm.first_name,
      cm.last_name,
      cm.avatar_url,
      cm.church_joined_at
    from church_members cm
    order by
      lower(coalesce(cm.first_name, '')) asc,
      lower(coalesce(cm.last_name, '')) asc,
      cm.id asc
    limit v_limit
    offset v_offset;
end;
$$;
