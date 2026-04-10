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
