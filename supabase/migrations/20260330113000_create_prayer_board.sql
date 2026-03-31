create table if not exists public.prayer_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  church_id uuid references public.churches(id) on delete set null,
  scope text not null check (scope in ('public', 'church')),
  category text not null check (category in ('Health', 'Family', 'Work', 'Spiritual', 'Other')),
  content text not null check (char_length(btrim(content)) between 1 and 500),
  is_anonymous boolean not null default false,
  is_urgent boolean not null default false,
  allow_comments boolean not null default true,
  is_answered boolean not null default false,
  answered_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint prayer_requests_answered_at_consistency check (
    (not is_answered and answered_at is null) or is_answered
  )
);

create index if not exists idx_prayer_requests_scope_created_at
  on public.prayer_requests(scope, created_at desc);

create index if not exists idx_prayer_requests_church_id_created_at
  on public.prayer_requests(church_id, created_at desc);

create index if not exists idx_prayer_requests_user_id_created_at
  on public.prayer_requests(user_id, created_at desc);

create index if not exists idx_prayer_requests_answered
  on public.prayer_requests(is_answered, created_at desc);

drop trigger if exists set_prayer_requests_updated_at on public.prayer_requests;
create trigger set_prayer_requests_updated_at
  before update on public.prayer_requests
  for each row
  execute procedure public.set_updated_at();

create table if not exists public.prayer_request_prayers (
  request_id uuid not null references public.prayer_requests(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (request_id, user_id)
);

create index if not exists idx_prayer_request_prayers_user_id
  on public.prayer_request_prayers(user_id, created_at desc);

create table if not exists public.prayer_request_encouragements (
  id uuid primary key default gen_random_uuid(),
  request_id uuid not null references public.prayer_requests(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  content text not null check (char_length(btrim(content)) between 1 and 300),
  created_at timestamptz not null default now()
);

create index if not exists idx_prayer_request_encouragements_request_id_created_at
  on public.prayer_request_encouragements(request_id, created_at desc);

create or replace function public.current_user_church_id()
returns uuid
language sql
stable
as $$
  select church_id
  from public.profiles
  where id = auth.uid()
$$;

create or replace function public.can_access_prayer_scope(
  p_scope text,
  p_church_id uuid
)
returns boolean
language sql
stable
as $$
  select auth.uid() is not null
    and (
      p_scope = 'public'
      or (
        p_scope = 'church'
        and p_church_id is not null
        and p_church_id = public.current_user_church_id()
      )
    )
$$;

alter table public.prayer_requests enable row level security;
alter table public.prayer_request_prayers enable row level security;
alter table public.prayer_request_encouragements enable row level security;

drop policy if exists "Prayer requests: select visible requests" on public.prayer_requests;
create policy "Prayer requests: select visible requests"
  on public.prayer_requests
  for select
  using (public.can_access_prayer_scope(scope, church_id));

drop policy if exists "Prayer requests: insert own requests" on public.prayer_requests;
create policy "Prayer requests: insert own requests"
  on public.prayer_requests
  for insert
  with check (
    auth.uid() = user_id
    and (
      (
        scope = 'public'
        and (church_id is null or church_id = public.current_user_church_id())
      )
      or (
        scope = 'church'
        and church_id is not null
        and church_id = public.current_user_church_id()
      )
    )
  );

drop policy if exists "Prayer requests: update own requests" on public.prayer_requests;
create policy "Prayer requests: update own requests"
  on public.prayer_requests
  for update
  using (auth.uid() = user_id)
  with check (
    auth.uid() = user_id
    and (
      (
        scope = 'public'
        and (church_id is null or church_id = public.current_user_church_id())
      )
      or (
        scope = 'church'
        and church_id is not null
        and church_id = public.current_user_church_id()
      )
    )
  );

drop policy if exists "Prayer requests: delete own requests" on public.prayer_requests;
create policy "Prayer requests: delete own requests"
  on public.prayer_requests
  for delete
  using (auth.uid() = user_id);

drop policy if exists "Prayer request prayers: select visible prayers" on public.prayer_request_prayers;
create policy "Prayer request prayers: select visible prayers"
  on public.prayer_request_prayers
  for select
  using (
    exists (
      select 1
      from public.prayer_requests pr
      where pr.id = request_id
        and public.can_access_prayer_scope(pr.scope, pr.church_id)
    )
  );

drop policy if exists "Prayer request prayers: insert own support" on public.prayer_request_prayers;
create policy "Prayer request prayers: insert own support"
  on public.prayer_request_prayers
  for insert
  with check (
    auth.uid() = user_id
    and exists (
      select 1
      from public.prayer_requests pr
      where pr.id = request_id
        and public.can_access_prayer_scope(pr.scope, pr.church_id)
    )
  );

drop policy if exists "Prayer request prayers: delete own support" on public.prayer_request_prayers;
create policy "Prayer request prayers: delete own support"
  on public.prayer_request_prayers
  for delete
  using (auth.uid() = user_id);

drop policy if exists "Prayer encouragements: select visible encouragements" on public.prayer_request_encouragements;
create policy "Prayer encouragements: select visible encouragements"
  on public.prayer_request_encouragements
  for select
  using (
    exists (
      select 1
      from public.prayer_requests pr
      where pr.id = request_id
        and public.can_access_prayer_scope(pr.scope, pr.church_id)
    )
  );

drop policy if exists "Prayer encouragements: insert own encouragements" on public.prayer_request_encouragements;
create policy "Prayer encouragements: insert own encouragements"
  on public.prayer_request_encouragements
  for insert
  with check (
    auth.uid() = user_id
    and exists (
      select 1
      from public.prayer_requests pr
      where pr.id = request_id
        and pr.allow_comments
        and public.can_access_prayer_scope(pr.scope, pr.church_id)
    )
  );

drop policy if exists "Prayer encouragements: delete own encouragements" on public.prayer_request_encouragements;
create policy "Prayer encouragements: delete own encouragements"
  on public.prayer_request_encouragements
  for delete
  using (auth.uid() = user_id);

create or replace function public.create_prayer_request(
  p_scope text,
  p_category text,
  p_content text,
  p_is_anonymous boolean default false,
  p_is_urgent boolean default false,
  p_allow_comments boolean default true
)
returns uuid
language plpgsql
security invoker
as $$
declare
  v_user_id uuid := auth.uid();
  v_church_id uuid;
  v_content text := btrim(coalesce(p_content, ''));
  v_request_id uuid;
begin
  if v_user_id is null then
    raise exception 'Authentication required';
  end if;

  if p_scope not in ('public', 'church') then
    raise exception 'Invalid prayer scope';
  end if;

  if p_category not in ('Health', 'Family', 'Work', 'Spiritual', 'Other') then
    raise exception 'Invalid prayer category';
  end if;

  if v_content = '' then
    raise exception 'Prayer request cannot be empty';
  end if;

  if char_length(v_content) > 500 then
    raise exception 'Prayer request must be 500 characters or fewer';
  end if;

  select church_id
    into v_church_id
  from public.profiles
  where id = v_user_id;

  if p_scope = 'church' and v_church_id is null then
    raise exception 'Add your church in Profile first';
  end if;

  insert into public.prayer_requests (
    user_id,
    church_id,
    scope,
    category,
    content,
    is_anonymous,
    is_urgent,
    allow_comments
  )
  values (
    v_user_id,
    v_church_id,
    p_scope,
    p_category,
    v_content,
    coalesce(p_is_anonymous, false),
    coalesce(p_is_urgent, false),
    coalesce(p_allow_comments, true)
  )
  returning id into v_request_id;

  return v_request_id;
end;
$$;

create or replace function public.add_prayer_request_encouragement(
  p_request_id uuid,
  p_content text
)
returns uuid
language plpgsql
security invoker
as $$
declare
  v_user_id uuid := auth.uid();
  v_content text := btrim(coalesce(p_content, ''));
  v_encouragement_id uuid;
begin
  if v_user_id is null then
    raise exception 'Authentication required';
  end if;

  if v_content = '' then
    raise exception 'Encouragement cannot be empty';
  end if;

  if char_length(v_content) > 300 then
    raise exception 'Encouragement must be 300 characters or fewer';
  end if;

  if not exists (
    select 1
    from public.prayer_requests pr
    where pr.id = p_request_id
      and pr.allow_comments
      and public.can_access_prayer_scope(pr.scope, pr.church_id)
  ) then
    raise exception 'Prayer request not found';
  end if;

  insert into public.prayer_request_encouragements (request_id, user_id, content)
  values (p_request_id, v_user_id, v_content)
  returning id into v_encouragement_id;

  return v_encouragement_id;
end;
$$;

create or replace function public.update_prayer_request(
  p_request_id uuid,
  p_scope text,
  p_category text,
  p_content text,
  p_is_anonymous boolean default false,
  p_is_urgent boolean default false,
  p_allow_comments boolean default true
)
returns uuid
language plpgsql
security invoker
as $$
declare
  v_user_id uuid := auth.uid();
  v_church_id uuid;
  v_content text := btrim(coalesce(p_content, ''));
  v_request_id uuid;
begin
  if v_user_id is null then
    raise exception 'Authentication required';
  end if;

  if p_scope not in ('public', 'church') then
    raise exception 'Invalid prayer scope';
  end if;

  if p_category not in ('Health', 'Family', 'Work', 'Spiritual', 'Other') then
    raise exception 'Invalid prayer category';
  end if;

  if v_content = '' then
    raise exception 'Prayer request cannot be empty';
  end if;

  if char_length(v_content) > 500 then
    raise exception 'Prayer request must be 500 characters or fewer';
  end if;

  select church_id
    into v_church_id
  from public.profiles
  where id = v_user_id;

  if p_scope = 'church' and v_church_id is null then
    raise exception 'Add your church in Profile first';
  end if;

  update public.prayer_requests
  set
    church_id = v_church_id,
    scope = p_scope,
    category = p_category,
    content = v_content,
    is_anonymous = coalesce(p_is_anonymous, false),
    is_urgent = coalesce(p_is_urgent, false),
    allow_comments = coalesce(p_allow_comments, true)
  where id = p_request_id
    and user_id = v_user_id
  returning id into v_request_id;

  if v_request_id is null then
    raise exception 'Prayer request not found';
  end if;

  return v_request_id;
end;
$$;

create or replace function public.mark_prayer_request_answered(
  p_request_id uuid,
  p_is_answered boolean default true
)
returns void
language plpgsql
security invoker
as $$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    raise exception 'Authentication required';
  end if;

  update public.prayer_requests
  set
    is_answered = coalesce(p_is_answered, true),
    answered_at = case
      when coalesce(p_is_answered, true) then coalesce(answered_at, now())
      else null
    end
  where id = p_request_id
    and user_id = v_user_id;

  if not found then
    raise exception 'Prayer request not found';
  end if;
end;
$$;

create or replace function public.toggle_prayer_request_support(
  p_request_id uuid
)
returns boolean
language plpgsql
security invoker
as $$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    raise exception 'Authentication required';
  end if;

  if not exists (
    select 1
    from public.prayer_requests pr
    where pr.id = p_request_id
      and public.can_access_prayer_scope(pr.scope, pr.church_id)
  ) then
    raise exception 'Prayer request not found';
  end if;

  if exists (
    select 1
    from public.prayer_request_prayers prp
    where prp.request_id = p_request_id
      and prp.user_id = v_user_id
  ) then
    delete from public.prayer_request_prayers
    where request_id = p_request_id
      and user_id = v_user_id;

    return false;
  end if;

  insert into public.prayer_request_prayers (request_id, user_id)
  values (p_request_id, v_user_id);

  return true;
end;
$$;

create or replace function public.get_prayer_requests(
  p_scope text default 'public',
  p_filter text default 'all'
)
returns table (
  id uuid,
  user_id uuid,
  church_id uuid,
  church_name text,
  scope text,
  category text,
  content text,
  is_anonymous boolean,
  is_urgent boolean,
  allow_comments boolean,
  is_answered boolean,
  answered_at timestamptz,
  created_at timestamptz,
  updated_at timestamptz,
  author_first_name text,
  author_last_name text,
  author_avatar_url text,
  prayer_count integer,
  encouragement_count integer,
  viewer_has_prayed boolean,
  viewer_is_owner boolean
)
language sql
stable
security invoker
as $$
  with filtered_requests as (
    select pr.*
    from public.prayer_requests pr
    where pr.scope = p_scope
      and public.can_access_prayer_scope(pr.scope, pr.church_id)
      and (
        p_filter = 'all'
        or (p_filter = 'urgent' and pr.is_urgent)
        or (p_filter = 'answered' and pr.is_answered)
        or (p_filter = 'mine' and pr.user_id = auth.uid())
      )
  ),
  prayer_counts as (
    select request_id, count(*)::int as prayer_count
    from public.prayer_request_prayers
    group by request_id
  ),
  encouragement_counts as (
    select request_id, count(*)::int as encouragement_count
    from public.prayer_request_encouragements
    group by request_id
  )
  select
    fr.id,
    fr.user_id,
    fr.church_id,
    ch.name as church_name,
    fr.scope,
    fr.category,
    fr.content,
    fr.is_anonymous,
    fr.is_urgent,
    fr.allow_comments,
    fr.is_answered,
    fr.answered_at,
    fr.created_at,
    fr.updated_at,
    p.first_name as author_first_name,
    p.last_name as author_last_name,
    p.avatar_url as author_avatar_url,
    coalesce(pc.prayer_count, 0) as prayer_count,
    coalesce(ec.encouragement_count, 0) as encouragement_count,
    exists (
      select 1
      from public.prayer_request_prayers prp
      where prp.request_id = fr.id
        and prp.user_id = auth.uid()
    ) as viewer_has_prayed,
    fr.user_id = auth.uid() as viewer_is_owner
  from filtered_requests fr
  join public.profiles p on p.id = fr.user_id
  left join public.churches ch on ch.id = fr.church_id
  left join prayer_counts pc on pc.request_id = fr.id
  left join encouragement_counts ec on ec.request_id = fr.id
  order by fr.is_urgent desc, fr.created_at desc
$$;

create or replace function public.get_prayer_request_detail(
  p_request_id uuid
)
returns table (
  id uuid,
  user_id uuid,
  church_id uuid,
  church_name text,
  scope text,
  category text,
  content text,
  is_anonymous boolean,
  is_urgent boolean,
  allow_comments boolean,
  is_answered boolean,
  answered_at timestamptz,
  created_at timestamptz,
  updated_at timestamptz,
  author_first_name text,
  author_last_name text,
  author_avatar_url text,
  prayer_count integer,
  encouragement_count integer,
  viewer_has_prayed boolean,
  viewer_is_owner boolean
)
language sql
stable
security invoker
as $$
  select *
  from public.get_prayer_requests(
    coalesce((select scope from public.prayer_requests where id = p_request_id), 'public'),
    'all'
  )
  where id = p_request_id
  limit 1
$$;
