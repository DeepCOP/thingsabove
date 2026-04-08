create or replace function public.assert_valid_profile_restrictions(
  p_first_name text default null,
  p_last_name text default null,
  p_bio text default null,
  p_year_believed integer default null,
  p_year_baptized integer default null,
  p_require_name boolean default false
)
returns void
language plpgsql
set search_path = pg_catalog, public
as $$
declare
  v_first_name text := nullif(trim(coalesce(p_first_name, '')), '');
  v_last_name text := nullif(trim(coalesce(p_last_name, '')), '');
  v_bio text := nullif(trim(coalesce(p_bio, '')), '');
  v_current_year integer := extract(year from current_date)::integer;
begin
  if p_require_name or p_first_name is not null then
    if v_first_name is null or length(v_first_name) < 2 or length(v_first_name) > 50 then
      raise exception 'First name must be 2-50 characters.';
    end if;
  end if;

  if p_require_name or p_last_name is not null then
    if v_last_name is null or length(v_last_name) < 2 or length(v_last_name) > 50 then
      raise exception 'Last name must be 2-50 characters.';
    end if;
  end if;

  if p_bio is not null and v_bio is not null and length(v_bio) > 280 then
    raise exception 'Bio or favorite verse must be 280 characters or fewer.';
  end if;

  if p_year_believed is not null and (p_year_believed < 1900 or p_year_believed > v_current_year) then
    raise exception 'Enter a valid year between 1900 and %.', v_current_year;
  end if;

  if p_year_baptized is not null and (p_year_baptized < 1900 or p_year_baptized > v_current_year) then
    raise exception 'Enter a valid year between 1900 and %.', v_current_year;
  end if;

  if p_year_believed is not null
    and p_year_baptized is not null
    and p_year_baptized < p_year_believed then
    raise exception 'Year baptized cannot be earlier than year believed.';
  end if;
end;
$$;

create or replace function public.assert_valid_church_restrictions(
  p_name text default null,
  p_address text default null,
  p_website_url text default null,
  p_require_name boolean default false
)
returns void
language plpgsql
set search_path = pg_catalog, public
as $$
declare
  v_name text := nullif(trim(coalesce(p_name, '')), '');
  v_address text := nullif(trim(coalesce(p_address, '')), '');
  v_website_url text := nullif(trim(coalesce(p_website_url, '')), '');
  v_normalized_website_url text := public.normalize_church_website_url(v_website_url);
  v_website_host text;
begin
  if p_require_name and v_name is null then
    raise exception 'Enter your church name.';
  end if;

  if v_name is not null and length(v_name) > 100 then
    raise exception 'Church name must be 100 characters or fewer.';
  end if;

  if v_address is not null and length(v_address) > 200 then
    raise exception 'Church address must be 200 characters or fewer.';
  end if;

  if v_website_url is not null then
    if length(v_website_url) > 255 then
      raise exception 'Church website URL must be 255 characters or fewer.';
    end if;

    v_website_host := split_part(coalesce(v_normalized_website_url, ''), '/', 1);

    if v_website_host = ''
      or v_website_host ~ '\s'
      or position('.' in v_website_host) = 0 then
      raise exception 'Enter a valid church website URL.';
    end if;
  end if;
end;
$$;

create or replace function public.validate_profile_restrictions()
returns trigger
language plpgsql
set search_path = pg_catalog, public
as $$
begin
  new.first_name := trim(new.first_name);
  new.last_name := trim(new.last_name);
  new.bio := nullif(trim(coalesce(new.bio, '')), '');

  if tg_op = 'INSERT' then
    perform public.assert_valid_profile_restrictions(
      new.first_name,
      new.last_name,
      new.bio,
      new.year_believed,
      new.year_baptized,
      true
    );
  else
    if new.first_name is distinct from old.first_name then
      if new.first_name is null
        or length(new.first_name) < 2
        or length(new.first_name) > 50 then
        raise exception 'First name must be 2-50 characters.';
      end if;
    end if;

    if new.last_name is distinct from old.last_name then
      if new.last_name is null
        or length(new.last_name) < 2
        or length(new.last_name) > 50 then
        raise exception 'Last name must be 2-50 characters.';
      end if;
    end if;

    if new.bio is distinct from old.bio
      and new.bio is not null
      and length(new.bio) > 280 then
      raise exception 'Bio or favorite verse must be 280 characters or fewer.';
    end if;

    if new.year_believed is distinct from old.year_believed
      or new.year_baptized is distinct from old.year_baptized then
      perform public.assert_valid_profile_restrictions(
        null,
        null,
        null,
        new.year_believed,
        new.year_baptized,
        false
      );
    end if;
  end if;

  return new;
end;
$$;

drop trigger if exists validate_profiles_before_write on public.profiles;

create trigger validate_profiles_before_write
  before insert or update on public.profiles
  for each row execute procedure public.validate_profile_restrictions();

create or replace function public.validate_church_restrictions()
returns trigger
language plpgsql
set search_path = pg_catalog, public
as $$
begin
  new.name := trim(new.name);
  new.address := nullif(trim(coalesce(new.address, '')), '');
  new.website_url := nullif(trim(coalesce(new.website_url, '')), '');

  if tg_op = 'INSERT'
    or new.name is distinct from old.name
    or new.address is distinct from old.address
    or new.website_url is distinct from old.website_url then
    perform public.assert_valid_church_restrictions(
      new.name,
      new.address,
      new.website_url,
      true
    );
  end if;

  return new;
end;
$$;

drop trigger if exists validate_churches_before_write on public.churches;

create trigger validate_churches_before_write
  before insert or update on public.churches
  for each row execute procedure public.validate_church_restrictions();

create or replace function public.find_or_create_church(
  p_name text default null,
  p_address text default null,
  p_website_url text default null
)
returns uuid
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_name text := nullif(trim(p_name), '');
  v_address text := nullif(trim(p_address), '');
  v_website_url text := nullif(trim(p_website_url), '');
  v_normalized_name text := public.normalize_church_text(v_name);
  v_normalized_address text := public.normalize_church_text(v_address);
  v_normalized_website_url text := public.normalize_church_website_url(v_website_url);
  v_church_id uuid;
begin
  if v_name is null and v_address is null and v_website_url is null then
    return null;
  end if;

  perform public.assert_valid_church_restrictions(
    v_name,
    v_address,
    v_website_url,
    true
  );

  if v_normalized_website_url is not null then
    select id
      into v_church_id
    from public.churches
    where normalized_website_url = v_normalized_website_url
    limit 1;
  end if;

  if v_church_id is null and v_normalized_address is not null then
    select id
      into v_church_id
    from public.churches
    where normalized_name = v_normalized_name
      and normalized_address = v_normalized_address
    limit 1;
  end if;

  if v_church_id is null and v_normalized_address is null and v_normalized_website_url is null then
    select id
      into v_church_id
    from public.churches
    where normalized_name = v_normalized_name
      and normalized_address is null
      and normalized_website_url is null
    limit 1;
  end if;

  if v_church_id is not null then
    update public.churches
    set
      address = coalesce(address, v_address),
      website_url = coalesce(website_url, v_website_url),
      updated_at = case
        when (address is null and v_address is not null)
          or (website_url is null and v_website_url is not null) then now()
        else updated_at
      end
    where id = v_church_id;

    return v_church_id;
  end if;

  begin
    insert into public.churches (name, address, website_url)
    values (v_name, v_address, v_website_url)
    returning id into v_church_id;
  exception
    when unique_violation then
      if v_normalized_website_url is not null then
        select id
          into v_church_id
        from public.churches
        where normalized_website_url = v_normalized_website_url
        limit 1;
      end if;

      if v_church_id is null and v_normalized_address is not null then
        select id
          into v_church_id
        from public.churches
        where normalized_name = v_normalized_name
          and normalized_address = v_normalized_address
        limit 1;
      end if;

      if v_church_id is null and v_normalized_address is null and v_normalized_website_url is null then
        select id
          into v_church_id
        from public.churches
        where normalized_name = v_normalized_name
          and normalized_address is null
          and normalized_website_url is null
        limit 1;
      end if;
  end;

  return v_church_id;
end;
$$;

create or replace function public.save_signup_about_details(
  p_user_id uuid,
  p_email text,
  p_year_believed integer default null,
  p_year_baptized integer default null,
  p_church_id uuid default null,
  p_church_name text default null,
  p_church_address text default null,
  p_church_website_url text default null,
  p_clear_church boolean default false
)
returns void
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_church_name text := nullif(trim(coalesce(p_church_name, '')), '');
  v_church_address text := nullif(trim(coalesce(p_church_address, '')), '');
  v_church_website_url text := nullif(trim(coalesce(p_church_website_url, '')), '');
  v_has_church_details boolean := p_church_id is not null
    or v_church_name is not null
    or v_church_address is not null
    or v_church_website_url is not null;
  v_should_update_church boolean := p_clear_church or v_has_church_details;
  v_church_id uuid;
  v_user_email text;
begin
  if p_user_id is null then
    raise exception 'User id required';
  end if;

  if auth.uid() is not null and auth.uid() <> p_user_id then
    raise exception 'Not authorized';
  end if;

  if auth.uid() is null then
    select email
      into v_user_email
    from auth.users
    where id = p_user_id;

    if v_user_email is null or p_email is null then
      raise exception 'Invalid signup user';
    end if;

    if lower(v_user_email) <> lower(trim(p_email)) then
      raise exception 'Invalid signup user';
    end if;
  end if;

  if not p_clear_church and p_church_id is null and v_has_church_details then
    perform public.assert_valid_church_restrictions(
      v_church_name,
      v_church_address,
      v_church_website_url,
      true
    );
  end if;

  if v_should_update_church then
    if p_clear_church then
      v_church_id := null;
    elsif p_church_id is not null then
      select id
        into v_church_id
      from public.churches
      where id = p_church_id;

      if v_church_id is null then
        raise exception 'Church not found';
      end if;
    else
      v_church_id := public.find_or_create_church(
        v_church_name,
        v_church_address,
        v_church_website_url
      );
    end if;
  end if;

  update public.profiles
  set
    year_believed = coalesce(p_year_believed, year_believed),
    year_baptized = coalesce(p_year_baptized, year_baptized),
    church_id = case
      when v_should_update_church then v_church_id
      else church_id
    end,
    updated_at = now()
  where id = p_user_id;

  if not found then
    raise exception 'Profile not found for user %', p_user_id;
  end if;
end;
$$;

create or replace function public.update_profile(
  p_first_name text default null,
  p_last_name text default null,
  p_avatar_url text default null,
  p_bio text default null,
  p_year_believed integer default null,
  p_year_baptized integer default null,
  p_church_id uuid default null,
  p_church_name text default null,
  p_church_address text default null,
  p_church_website_url text default null,
  p_clear_church boolean default false
)
returns void
language plpgsql
as $$
declare
  v_church_name text := nullif(trim(coalesce(p_church_name, '')), '');
  v_church_address text := nullif(trim(coalesce(p_church_address, '')), '');
  v_church_website_url text := nullif(trim(coalesce(p_church_website_url, '')), '');
  v_has_church_details boolean := p_church_id is not null
    or v_church_name is not null
    or v_church_address is not null
    or v_church_website_url is not null;
  v_should_update_church boolean := p_clear_church or v_has_church_details;
  v_church_id uuid;
begin
  if not p_clear_church and p_church_id is null and v_has_church_details then
    perform public.assert_valid_church_restrictions(
      v_church_name,
      v_church_address,
      v_church_website_url,
      true
    );
  end if;

  if v_should_update_church then
    if p_clear_church then
      v_church_id := null;
    elsif p_church_id is not null then
      select id
        into v_church_id
      from public.churches
      where id = p_church_id;

      if v_church_id is null then
        raise exception 'Church not found';
      end if;
    else
      v_church_id := public.find_or_create_church(
        v_church_name,
        v_church_address,
        v_church_website_url
      );
    end if;
  end if;

  update public.profiles
  set
    first_name = case
      when p_first_name is not null then trim(p_first_name)
      else first_name
    end,
    last_name = case
      when p_last_name is not null then trim(p_last_name)
      else last_name
    end,
    avatar_url = coalesce(p_avatar_url, avatar_url),
    bio = case
      when p_bio is not null then nullif(trim(p_bio), '')
      else bio
    end,
    year_believed = coalesce(p_year_believed, year_believed),
    year_baptized = coalesce(p_year_baptized, year_baptized),
    church_id = case
      when v_should_update_church then v_church_id
      else church_id
    end,
    updated_at = now()
  where id = auth.uid();

  if not found then
    raise exception 'Profile not found for user %', auth.uid();
  end if;
end;
$$;

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
    church_id
  )
  values (
    new.id,
    v_first_name,
    v_last_name,
    new.email,
    v_year_believed,
    v_year_baptized,
    v_church_id
  );

  return new;
end;
$$;
