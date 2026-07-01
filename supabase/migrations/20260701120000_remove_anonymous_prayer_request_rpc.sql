drop function if exists public.get_prayer_request_detail(uuid);
drop function if exists public.get_prayer_requests(text, text, integer, boolean, timestamptz, uuid);

drop function if exists public.create_prayer_request(text, text, text, boolean, boolean, boolean);
drop function if exists public.update_prayer_request(uuid, text, text, text, boolean, boolean, boolean);

alter table public.prayer_requests
  drop column if exists is_anonymous;

create or replace function public.create_prayer_request(
  p_scope text,
  p_category text,
  p_content text,
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
    is_urgent,
    allow_comments
  )
  values (
    v_user_id,
    v_church_id,
    p_scope,
    p_category,
    v_content,
    coalesce(p_is_urgent, false),
    coalesce(p_allow_comments, true)
  )
  returning id into v_request_id;

  return v_request_id;
end;
$$;

create or replace function public.update_prayer_request(
  p_request_id uuid,
  p_scope text,
  p_category text,
  p_content text,
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

create or replace function public.get_prayer_requests(
  p_scope text default 'public',
  p_filter text default 'all',
  p_limit integer default 20,
  p_before_is_urgent boolean default null,
  p_before_created_at timestamptz default null,
  p_before_id uuid default null
)
returns table (
  id uuid,
  user_id uuid,
  church_id uuid,
  church_name text,
  scope text,
  category text,
  content text,
  testimony text,
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
      and pr.created_at >= (now() - interval '1 year')
      and (
        p_filter = 'all'
        or (p_filter = 'urgent' and pr.is_urgent)
        or (p_filter = 'answered' and pr.is_answered)
        or (p_filter = 'mine' and pr.user_id = auth.uid())
      )
      and (
        p_before_created_at is null
        or pr.is_urgent < p_before_is_urgent
        or (
          pr.is_urgent = p_before_is_urgent
          and pr.created_at < p_before_created_at
        )
        or (
          pr.is_urgent = p_before_is_urgent
          and pr.created_at = p_before_created_at
          and pr.id < p_before_id
        )
      )
    order by pr.is_urgent desc, pr.created_at desc, pr.id desc
    limit greatest(coalesce(p_limit, 20), 1)
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
    fr.testimony,
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
  order by fr.is_urgent desc, fr.created_at desc, fr.id desc
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
  testimony text,
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
    p_scope => coalesce((select scope from public.prayer_requests where id = p_request_id), 'public'),
    p_filter => 'all',
    p_limit => 1
  )
  where id = p_request_id
  limit 1
$$;
