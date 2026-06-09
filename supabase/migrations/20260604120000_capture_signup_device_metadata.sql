create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_metadata jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
  v_first_name text := nullif(trim(v_metadata->>'first_name'), '');
  v_last_name text := nullif(trim(v_metadata->>'last_name'), '');
  v_year_believed integer := nullif(trim(v_metadata->>'year_believed'), '')::integer;
  v_year_baptized integer := nullif(trim(v_metadata->>'year_baptized'), '')::integer;
  v_church_id uuid;
  v_app_version text := nullif(trim(v_metadata->>'app_version'), '');
  v_device_os text := nullif(trim(v_metadata->>'device_os'), '');
  v_device_os_version text := nullif(trim(v_metadata->>'device_os_version'), '');
  v_device_language_tag text := nullif(trim(v_metadata->>'device_language_tag'), '');
  v_device_language_code text := nullif(trim(v_metadata->>'device_language_code'), '');
begin
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
    year_believed,
    year_baptized,
    church_id,
    app_version,
    device_os,
    device_os_version,
    device_language_tag,
    device_language_code
  )
  values (
    new.id,
    v_first_name,
    v_last_name,
    new.email,
    v_year_believed,
    v_year_baptized,
    v_church_id,
    v_app_version,
    v_device_os,
    v_device_os_version,
    v_device_language_tag,
    v_device_language_code
  );

  return new;
end;
$$;
