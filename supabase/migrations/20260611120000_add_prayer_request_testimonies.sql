alter table public.prayer_requests
  add column if not exists testimony text;

alter table public.prayer_requests
  drop constraint if exists prayer_requests_testimony_length;

alter table public.prayer_requests
  add constraint prayer_requests_testimony_length
  check (
    testimony is null
    or char_length(btrim(testimony)) between 1 and 1000
  );

drop function if exists public.mark_prayer_request_answered(uuid, boolean);

create or replace function public.mark_prayer_request_answered(
  p_request_id uuid,
  p_is_answered boolean default true,
  p_testimony text default null
)
returns void
language plpgsql
security invoker
as $$
declare
  v_user_id uuid := auth.uid();
  v_is_answered boolean := coalesce(p_is_answered, true);
  v_testimony text := nullif(btrim(coalesce(p_testimony, '')), '');
begin
  if v_user_id is null then
    raise exception 'Authentication required';
  end if;

  if v_testimony is not null and char_length(v_testimony) > 1000 then
    raise exception 'Testimony must be 1000 characters or fewer';
  end if;

  update public.prayer_requests
  set
    is_answered = v_is_answered,
    answered_at = case
      when v_is_answered then coalesce(answered_at, now())
      else null
    end,
    testimony = case
      when v_is_answered then v_testimony
      else null
    end
  where id = p_request_id
    and user_id = v_user_id;

  if not found then
    raise exception 'Prayer request not found';
  end if;
end;
$$;

drop function if exists public.get_prayer_request_detail(uuid);
drop function if exists public.get_prayer_requests(text, text, integer, boolean, timestamptz, uuid);
drop function if exists public.get_prayer_requests(text, text);

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
    p_scope => coalesce((select scope from public.prayer_requests where id = p_request_id), 'public'),
    p_filter => 'all',
    p_limit => 1
  )
  where id = p_request_id
  limit 1
$$;
