drop function if exists public.get_prayer_request_detail(uuid);

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
  select
    pr.id,
    pr.user_id,
    pr.church_id,
    ch.name as church_name,
    pr.scope,
    pr.category,
    pr.content,
    pr.testimony,
    pr.is_urgent,
    pr.allow_comments,
    pr.is_answered,
    pr.answered_at,
    pr.created_at,
    pr.updated_at,
    p.first_name as author_first_name,
    p.last_name as author_last_name,
    p.avatar_url as author_avatar_url,
    coalesce((
      select count(*)::int
      from public.prayer_request_prayers prp
      where prp.request_id = pr.id
    ), 0) as prayer_count,
    coalesce((
      select count(*)::int
      from public.prayer_request_encouragements pre
      where pre.request_id = pr.id
    ), 0) as encouragement_count,
    exists (
      select 1
      from public.prayer_request_prayers prp
      where prp.request_id = pr.id
        and prp.user_id = auth.uid()
    ) as viewer_has_prayed,
    pr.user_id = auth.uid() as viewer_is_owner
  from public.prayer_requests pr
  join public.profiles p on p.id = pr.user_id
  left join public.churches ch on ch.id = pr.church_id
  where pr.id = p_request_id
    and public.can_access_prayer_scope(pr.scope, pr.church_id)
    and pr.created_at >= (now() - interval '1 year')
  limit 1
$$;
