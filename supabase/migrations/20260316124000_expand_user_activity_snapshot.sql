create or replace view public.user_behavior_snapshot as
with friend_stats as (
  select
    f.user_id,
    count(*)::int as friends_count
  from (
    select requester_id as user_id
    from public.friends
    where status = 'accepted'

    union all

    select receiver_id as user_id
    from public.friends
    where status = 'accepted'
  ) f
  group by f.user_id
),
group_plan_stats as (
  select
    gp.user_id,
    count(distinct gp.group_id)::int as group_plans_count
  from (
    select pgm.user_id, pgm.group_id
    from public.plan_group_members pgm
    where pgm.status = 'accepted'

    union

    select pg.created_by as user_id, pg.id as group_id
    from public.plan_groups pg
  ) gp
  group by gp.user_id
),
day_item_stats as (
  select
    dip.user_id,
    max(dip.updated_at) as last_day_item_at
  from public.day_items_progress dip
  group by dip.user_id
),
comment_stats as (
  select
    c.user_id,
    max(c.updated_at) as last_comment_at
  from public.comments c
  group by c.user_id
)
select
  p.id as user_id,
  p.timezone,
  p.last_seen,
  p.church_id,
  ch.name as church_name,
  ch.address as church_address,
  ch.website_url as church_website_url,
  (p.church_id is not null) as has_church,
  max(p.updated_at) as profile_updated_at,
  max(pp.updated_at) as last_plan_progress_at,
  max(dis.last_day_item_at) as last_day_item_at,
  max(cs.last_comment_at) as last_comment_at,

  now() - p.last_seen as time_since_last_seen,

  greatest(
    coalesce(max(pp.updated_at), 'epoch'::timestamptz),
    coalesce(max(dis.last_day_item_at), 'epoch'::timestamptz),
    coalesce(max(cs.last_comment_at), 'epoch'::timestamptz),
    coalesce(max(p.updated_at), 'epoch'::timestamptz)
  ) as last_activity_at,
  now() - greatest(
    coalesce(max(pp.updated_at), 'epoch'::timestamptz),
    coalesce(max(dis.last_day_item_at), 'epoch'::timestamptz),
    coalesce(max(cs.last_comment_at), 'epoch'::timestamptz),
    coalesce(max(p.updated_at), 'epoch'::timestamptz)
  ) as time_since_last_activity,

  count(distinct pp.plan_id) as plans_started,

  count(distinct pp.plan_id) filter (
    where coalesce(pp.completed_once, false) = true
  ) as plans_completed,

  count(distinct pp.plan_id) filter (
    where coalesce(pp.completed_once, false) = true
      and coalesce(array_length(pp.completed_days, 1), 0) = dp.total_days
      and pp.updated_at > now() - interval '1 day'
  ) as plans_completed_recently,

  count(distinct pp.plan_id) filter (
    where coalesce(array_length(pp.completed_days, 1), 0) < dp.total_days
  ) as active_plans,

  count(distinct pp.plan_id) filter (
    where pp.updated_at < now() - interval '5 days'
      and coalesce(array_length(pp.completed_days, 1), 0) < dp.total_days
  ) as abandoned_plans,

  coalesce(max(coalesce(array_length(pp.completed_days, 1), 0)), 0) as max_days_completed,

  coalesce(max(cs.last_comment_at), 'epoch'::timestamptz) > now() - interval '7 days'
    as commented_recently,

  coalesce(gps.group_plans_count, 0) > 0 as has_group_plan,
  coalesce(fs.friends_count, 0) > 0 as has_friends,
  coalesce(fs.friends_count, 0) as friends_count,
  coalesce(gps.group_plans_count, 0) as group_plans_count

from public.profiles p
left join public.plan_progress pp on pp.user_id = p.id
left join public.devotional_plans dp on dp.id = pp.plan_id
left join public.churches ch on ch.id = p.church_id
left join day_item_stats dis on dis.user_id = p.id
left join comment_stats cs on cs.user_id = p.id
left join friend_stats fs on fs.user_id = p.id
left join group_plan_stats gps on gps.user_id = p.id
group by
  p.id,
  p.church_id,
  ch.name,
  ch.address,
  ch.website_url,
  fs.friends_count,
  gps.group_plans_count;


