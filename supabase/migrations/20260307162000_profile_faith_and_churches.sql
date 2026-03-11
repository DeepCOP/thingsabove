create or replace function public.normalize_church_text(p_value text)
returns text
language sql
immutable
as $$
  select nullif(regexp_replace(lower(trim(p_value)), '\s+', ' ', 'g'), '')
$$;

create or replace function public.normalize_church_website_url(p_value text)
returns text
language sql
immutable
as $$
  select nullif(
    regexp_replace(
      regexp_replace(lower(trim(p_value)), '^https?://', ''),
      '/+$',
      ''
    ),
    ''
  )
$$;

create table if not exists public.churches (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  address text,
  website_url text,
  normalized_name text generated always as (public.normalize_church_text(name)) stored,
  normalized_address text generated always as (public.normalize_church_text(address)) stored,
  normalized_website_url text generated always as (
    public.normalize_church_website_url(website_url)
  ) stored,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint churches_name_not_blank check (length(trim(name)) > 0)
);

create unique index if not exists idx_churches_normalized_website_url
  on public.churches (normalized_website_url)
  where normalized_website_url is not null;

create unique index if not exists idx_churches_normalized_name_address
  on public.churches (normalized_name, normalized_address)
  where normalized_address is not null;

create unique index if not exists idx_churches_normalized_name_without_details
  on public.churches (normalized_name)
  where normalized_address is null and normalized_website_url is null;

alter table public.churches enable row level security;

create policy "churches are viewable by everyone"
  on public.churches
  for select
  using (true);

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
  if v_normalized_name is null then
    return null;
  end if;

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
  v_should_update_church boolean := p_clear_church
    or p_church_id is not null
    or nullif(trim(coalesce(p_church_name, '')), '') is not null;
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
        p_church_name,
        p_church_address,
        p_church_website_url
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
  v_should_update_church boolean := p_clear_church
    or p_church_id is not null
    or nullif(trim(coalesce(p_church_name, '')), '') is not null;
  v_church_id uuid;
begin
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
        p_church_name,
        p_church_address,
        p_church_website_url
      );
    end if;
  end if;

  update public.profiles
  set
    first_name = coalesce(nullif(trim(p_first_name), ''), first_name),
    last_name = coalesce(nullif(trim(p_last_name), ''), last_name),
    avatar_url = coalesce(p_avatar_url, avatar_url),
    bio = coalesce(p_bio, bio),
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



alter table public.profiles
  add column if not exists year_believed integer,
  add column if not exists year_baptized integer,
  add column if not exists church_id uuid references public.churches(id) on delete set null;

create index if not exists idx_profiles_church_id on public.profiles(church_id);

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
    coalesce(v_first_name, 'Friend'),
    coalesce(v_last_name, ''),
    new.email,
    v_year_believed,
    v_year_baptized,
    v_church_id
  );

  return new;
end;
$$;
