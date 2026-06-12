create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_metadata jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
  v_full_name text := nullif(trim(coalesce(
    v_metadata->>'full_name',
    v_metadata->>'name',
    v_metadata->>'user_name',
    v_metadata->>'preferred_username'
  )), '');
  v_first_name text := nullif(trim(coalesce(
    v_metadata->>'first_name',
    v_metadata->>'given_name'
  )), '');
  v_last_name text := nullif(trim(coalesce(
    v_metadata->>'last_name',
    v_metadata->>'family_name'
  )), '');
  v_avatar_url text := nullif(trim(coalesce(
    v_metadata->>'avatar_url',
    v_metadata->>'picture',
    v_metadata->>'photo_url'
  )), '');
  v_year_believed integer := nullif(trim(v_metadata->>'year_believed'), '')::integer;
  v_year_baptized integer := nullif(trim(v_metadata->>'year_baptized'), '')::integer;
  v_church_id uuid;
begin
  if v_first_name is null and v_full_name is not null then
    v_first_name := nullif(trim(split_part(v_full_name, ' ', 1)), '');
  end if;

  if v_last_name is null and v_full_name is not null then
    v_last_name := nullif(trim(regexp_replace(v_full_name, '^\S+\s*', '')), '');
  end if;

  v_first_name := left(coalesce(v_first_name, 'Member'), 50);
  v_last_name := left(coalesce(v_last_name, 'Member'), 50);

  if length(v_first_name) < 2 then
    v_first_name := 'Member';
  end if;

  if length(v_last_name) < 2 then
    v_last_name := 'Member';
  end if;

  perform public.assert_valid_profile_restrictions(
    v_first_name,
    v_last_name,
    null,
    v_year_believed,
    v_year_baptized,
    true
  );

  v_church_id := public.find_or_create_church(
    v_metadata->>'church_name',
    v_metadata->>'church_address',
    v_metadata->>'church_website_url'
  );

  insert into public.profiles (
    id,
    first_name,
    last_name,
    email,
    avatar_url,
    year_believed,
    year_baptized,
    church_id
  )
  values (
    new.id,
    v_first_name,
    v_last_name,
    new.email,
    v_avatar_url,
    v_year_believed,
    v_year_baptized,
    v_church_id
  );

  return new;
end;
$$;
