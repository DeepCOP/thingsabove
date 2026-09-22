create index if not exists idx_profiles_first_name_trgm
  on public.profiles using gin (lower(first_name) gin_trgm_ops);

create index if not exists idx_profiles_last_name_trgm
  on public.profiles using gin (lower(last_name) gin_trgm_ops);

create or replace function public.search_users_by_name(
  p_query text,
  p_limit integer default 20
)
returns table (
  id uuid,
  first_name text,
  last_name text,
  avatar_url text,
  church_id uuid,
  church_name text,
  friendship_status text,
  requester_id uuid,
  receiver_id uuid
)
language sql
stable
security definer
set search_path = pg_catalog, public
as $$
  with normalized_search_input as (
    select lower(
      trim(
        regexp_replace(coalesce(p_query, ''), '\s+', ' ', 'g')
      )
    ) as term
  ),
  search_input as (
    select
      term,
      replace(
        replace(
          replace(term, '\', '\\'),
          '%',
          '\%'
        ),
        '_',
        '\_'
      ) as pattern
    from normalized_search_input
  )
  select
    p.id,
    p.first_name,
    p.last_name,
    p.avatar_url,
    c.id as church_id,
    c.name as church_name,
    f.status as friendship_status,
    f.requester_id,
    f.receiver_id
  from public.profiles p
  cross join search_input s
  left join public.churches c on c.id = p.church_id
  left join public.friends f
    on (
      (f.requester_id = auth.uid() and f.receiver_id = p.id)
      or (f.receiver_id = auth.uid() and f.requester_id = p.id)
    )
  where auth.uid() is not null
    and p.id <> auth.uid()
    and length(s.term) >= 2
    and (
      lower(p.first_name) like ('%' || s.pattern || '%') escape '\'
      or lower(p.last_name) like ('%' || s.pattern || '%') escape '\'
      or p.email = s.term
    )
  order by
    case
      when lower(p.first_name) = s.term
        or lower(p.last_name) = s.term
        or p.email = s.term then 0
      when strpos(lower(p.first_name), s.term) = 1
        or strpos(lower(p.last_name), s.term) = 1 then 1
      else 2
    end,
    lower(p.first_name),
    lower(p.last_name),
    p.id
  limit least(greatest(coalesce(p_limit, 20), 1), 50);
$$;

revoke all on function public.search_users_by_name(text, integer) from public;
grant execute on function public.search_users_by_name(text, integer) to authenticated;
