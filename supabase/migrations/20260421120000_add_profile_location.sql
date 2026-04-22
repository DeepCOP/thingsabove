alter table public.profiles
  add column if not exists location jsonb;

create or replace function public.get_profile(p_user_id uuid)
returns jsonb
language sql
security invoker
set search_path = pg_catalog, public
stable
as $$
  select jsonb_build_object(
    'id', p.id,
    'email', p.email,
    'first_name', p.first_name,
    'last_name', p.last_name,
    'avatar_url', p.avatar_url,
    'bio', p.bio,
    'year_believed', p.year_believed,
    'year_baptized', p.year_baptized,
    'location', p.location,
    'church',
      case
        when c.id is null then null
        else jsonb_build_object(
          'id', c.id,
          'name', c.name,
          'address', c.address,
          'website_url', c.website_url
        )
      end
  )
  from public.profiles p
  left join public.churches c
    on c.id = p.church_id
  where p.id = p_user_id;
$$;
