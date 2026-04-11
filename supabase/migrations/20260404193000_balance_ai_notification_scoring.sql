drop function if exists public.list_ai_notification_planning_candidates(integer);
drop view if exists public.user_behavior_scored;
drop view if exists public.user_behavior_snapshot;

create view public.user_behavior_snapshot as
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
  max(p.created_at) as profile_created_at,
  max(p.updated_at) as profile_updated_at,
  max(pp.updated_at) as last_plan_progress_at,
  max(dis.last_day_item_at) as last_day_item_at,
  max(cs.last_comment_at) as last_comment_at,

  now() - p.last_seen as time_since_last_seen,

  case
    when max(pp.updated_at) is null
      and max(dis.last_day_item_at) is null
      and max(cs.last_comment_at) is null then null
    else greatest(
      coalesce(max(pp.updated_at), 'epoch'::timestamptz),
      coalesce(max(dis.last_day_item_at), 'epoch'::timestamptz),
      coalesce(max(cs.last_comment_at), 'epoch'::timestamptz)
    )
  end as last_activity_at,
  case
    when max(pp.updated_at) is null
      and max(dis.last_day_item_at) is null
      and max(cs.last_comment_at) is null then null
    else now() - greatest(
      coalesce(max(pp.updated_at), 'epoch'::timestamptz),
      coalesce(max(dis.last_day_item_at), 'epoch'::timestamptz),
      coalesce(max(cs.last_comment_at), 'epoch'::timestamptz)
    )
  end as time_since_last_activity,

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


create view public.user_behavior_scored as
with scored as (
  select
    u.*,
    (least(u.plans_completed_recently, 1) * 1)::numeric as score_recent_completion,
    (least(u.active_plans, 2) * 1)::numeric as score_active_plans,
    (
      case
        when u.max_days_completed >= 7 then 1.5
        when u.max_days_completed >= 3 then 1
        when u.max_days_completed >= 1 then 0.5
        else 0
      end
    )::numeric as score_consistency,
    (
      case
        when u.last_activity_at is null
          and u.profile_created_at <= now() - interval '7 days' then 3
        when u.last_activity_at is null
          and u.profile_created_at <= now() - interval '3 days' then 1.5
        when u.time_since_last_activity > interval '10 days' then 4
        when u.time_since_last_activity > interval '5 days' then 3
        when u.time_since_last_activity > interval '2 days' then 1.5
        when u.time_since_last_activity < interval '12 hours' then -1.5
        else 0
      end
    )::numeric as score_activity_need,
    (least(u.abandoned_plans, 2) * 2.5)::numeric as score_abandoned_plans,
    (case when u.friends_count = 0 then 2 else 0 end)::numeric as score_social_isolation,
    (
      case
        when u.has_church and u.friends_count = 0 and u.group_plans_count = 0 then 1.5
        else 0
      end
    )::numeric as score_church_connection,
    (
      case
        when u.time_since_last_seen > interval '7 days' then 2
        when u.time_since_last_seen > interval '3 days' then 1
        when u.time_since_last_seen > interval '1 day' then 0.5
        else 0
      end
    )::numeric as score_seen_recency,
    (
      case
        when u.plans_started = 0
          and u.profile_created_at <= now() - interval '7 days' then 1.5
        when u.plans_started <= 1
          and u.max_days_completed <= 2
          and u.active_plans = 0
          and u.profile_created_at <= now() - interval '5 days' then 1
        else 0
      end
    )::numeric as score_light_engagement
  from public.user_behavior_snapshot u
)
select
  s.*,
  greatest(
    0::numeric,
    round(
      s.score_recent_completion
      + s.score_active_plans
      + s.score_consistency
      + s.score_activity_need
      + s.score_abandoned_plans
      + s.score_social_isolation
      + s.score_church_connection
      + s.score_seen_recency
      + s.score_light_engagement,
      2
    )
  ) as notification_score,
  jsonb_strip_nulls(
    jsonb_build_object(
      'recent_completion', case when s.score_recent_completion <> 0 then s.score_recent_completion end,
      'active_plans', case when s.score_active_plans <> 0 then s.score_active_plans end,
      'consistency', case when s.score_consistency <> 0 then s.score_consistency end,
      'activity_need', case when s.score_activity_need <> 0 then s.score_activity_need end,
      'abandoned_plans', case when s.score_abandoned_plans <> 0 then s.score_abandoned_plans end,
      'social_isolation', case when s.score_social_isolation <> 0 then s.score_social_isolation end,
      'church_connection', case when s.score_church_connection <> 0 then s.score_church_connection end,
      'seen_recency', case when s.score_seen_recency <> 0 then s.score_seen_recency end,
      'light_engagement', case when s.score_light_engagement <> 0 then s.score_light_engagement end
    )
  ) as notification_score_breakdown
from scored s;


create or replace function public.list_ai_notification_planning_candidates(
  p_limit integer default 12
)
returns table (
  user_id uuid,
  first_name text,
  bio text,
  year_believed integer,
  year_baptized integer,
  timezone text,
  planning_context jsonb
)
language sql
security definer
set search_path = pg_catalog, public
as $$
  with recent_history as (
    select
      ranked.user_id,
      jsonb_agg(
        jsonb_strip_nulls(
          jsonb_build_object(
            'trigger_reason', ranked.trigger_reason,
            'planner_reason', ranked.planner_reason,
            'scheduled_for', ranked.scheduled_for,
            'sent', ranked.sent,
            'sent_at', ranked.sent_at,
            'created_at', ranked.created_at
          )
        )
        order by ranked.created_at desc
      ) as items
    from (
      select
        t.*,
        row_number() over (
          partition by t.user_id
          order by t.created_at desc
        ) as rn
      from public.ai_triggers t
      where t.created_at > now() - interval '30 days'
    ) ranked
    where ranked.rn <= 15
    group by ranked.user_id
  )
  select
    u.user_id,
    p.first_name,
    nullif(trim(p.bio), '') as bio,
    p.year_believed,
    p.year_baptized,
    coalesce(nullif(trim(u.timezone), ''), nullif(trim(p.timezone), ''), 'UTC') as timezone,
    jsonb_strip_nulls(
      jsonb_build_object(
        'behavior_snapshot', jsonb_strip_nulls(
          to_jsonb(u)
          - 'notification_score'
          - 'notification_score_breakdown'
          - 'score_recent_completion'
          - 'score_active_plans'
          - 'score_consistency'
          - 'score_activity_need'
          - 'score_abandoned_plans'
          - 'score_social_isolation'
          - 'score_church_connection'
          - 'score_seen_recency'
          - 'score_light_engagement'
        ),
        'notification_score', u.notification_score,
        'notification_score_breakdown', coalesce(u.notification_score_breakdown, '{}'::jsonb),
        'recent_notifications', coalesce(rh.items, '[]'::jsonb),
        'local_now', timezone(
          coalesce(nullif(trim(u.timezone), ''), nullif(trim(p.timezone), ''), 'UTC'),
          now()
        ),
        'allowed_schedule', jsonb_build_object(
          'day_offsets', jsonb_build_array(0, 1, 2),
          'local_hour_min', 8,
          'local_hour_max', 20
        )
      )
    ) as planning_context
  from public.user_behavior_scored u
  join public.profiles p on p.id = u.user_id
  left join recent_history rh on rh.user_id = u.user_id
  where
    public.user_has_active_auth_session(u.user_id)
    and nullif(trim(coalesce(p.expo_push_token, '')), '') is not null
    and u.notification_score >= 5
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and (
          (t.sent = false and coalesce(t.scheduled_for, t.created_at) > now() - interval '7 days')
          or (t.sent_at is not null and t.sent_at > now() - interval '48 hours')
        )
    )
  order by
    u.notification_score desc,
    coalesce(u.last_activity_at, u.profile_created_at) asc,
    coalesce(u.last_seen, u.profile_created_at) asc
  limit greatest(coalesce(p_limit, 12), 1);
$$;
