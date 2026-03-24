alter table public.ai_triggers
  add column if not exists scheduled_for timestamptz,
  add column if not exists planner_reason text,
  add column if not exists planner_payload jsonb not null default '{}'::jsonb,
  add column if not exists planning_model text;

update public.ai_triggers
set scheduled_for = created_at
where scheduled_for is null
  and sent = false
  and generated_message is not null;

create index if not exists idx_ai_triggers_pending_schedule
  on public.ai_triggers (scheduled_for, priority, created_at)
  where sent = false and scheduled_for is not null;

create index if not exists idx_ai_triggers_user_created_at
  on public.ai_triggers (user_id, created_at desc);


create or replace function public.resolve_ai_trigger_schedule(
  p_timezone text,
  p_day_offset integer,
  p_local_hour integer
)
returns timestamptz
language sql
stable
set search_path = pg_catalog, public
as $$
  with normalized as (
    select
      coalesce(nullif(trim(p_timezone), ''), 'UTC') as tz,
      greatest(least(coalesce(p_day_offset, 0), 2), 0) as day_offset,
      greatest(least(coalesce(p_local_hour, 9), 20), 8) as local_hour
  ),
  local_target as (
    select
      tz,
      (
        date_trunc('day', timezone(tz, now()))
        + make_interval(days => day_offset)
        + make_interval(hours => local_hour)
      ) as local_timestamp
    from normalized
  )
  select case
    when (local_timestamp at time zone tz) <= now() + interval '5 minutes'
      then ((local_timestamp + interval '1 day') at time zone tz)
    else (local_timestamp at time zone tz)
  end
  from local_target;
$$;


create or replace view public.user_behavior_scored as
with scored as (
  select
    u.*,
    (least(u.plans_completed_recently, 1) * 5)::numeric as score_plans_completed_recently,
    (least(u.active_plans, 3) * 3)::numeric as score_active_plans,
    (least(u.max_days_completed, 7) * 2)::numeric as score_max_days_completed,
    (
      -least(
        (
          extract(epoch from coalesce(u.time_since_last_activity, interval '0'))
          / 86400
        ) * 1.5,
        12
      )
    )::numeric as score_activity_recency,
    (least(u.abandoned_plans, 2) * 4)::numeric as score_abandoned_plans,
    (case when u.friends_count = 0 then 2 else 0 end)::numeric as score_social_isolation,
    (
      case
        when u.has_church and u.friends_count = 0 and u.group_plans_count = 0 then 1
        else 0
      end
    )::numeric as score_church_connection,
    (
      case
        when u.time_since_last_seen > interval '3 days' then 2
        when u.time_since_last_seen > interval '1 day' then 1
        else 0
      end
    )::numeric as score_seen_recency
  from public.user_behavior_snapshot u
)
select
  s.*,
  greatest(
    0::numeric,
    round(
      s.score_plans_completed_recently
      + s.score_active_plans
      + s.score_max_days_completed
      + s.score_activity_recency
      + s.score_abandoned_plans
      + s.score_social_isolation
      + s.score_church_connection
      + s.score_seen_recency,
      2
    )
  ) as notification_score,
  jsonb_strip_nulls(
    jsonb_build_object(
      'plans_completed_recently', case when s.score_plans_completed_recently <> 0 then s.score_plans_completed_recently end,
      'active_plans', case when s.score_active_plans <> 0 then s.score_active_plans end,
      'max_days_completed', case when s.score_max_days_completed <> 0 then s.score_max_days_completed end,
      'activity_recency', case when s.score_activity_recency <> 0 then s.score_activity_recency end,
      'abandoned_plans', case when s.score_abandoned_plans <> 0 then s.score_abandoned_plans end,
      'social_isolation', case when s.score_social_isolation <> 0 then s.score_social_isolation end,
      'church_connection', case when s.score_church_connection <> 0 then s.score_church_connection end,
      'seen_recency', case when s.score_seen_recency <> 0 then s.score_seen_recency end
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
            'trigger_type', ranked.trigger_type,
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
    where ranked.rn <= 5
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
          - 'score_plans_completed_recently'
          - 'score_active_plans'
          - 'score_max_days_completed'
          - 'score_activity_recency'
          - 'score_abandoned_plans'
          - 'score_social_isolation'
          - 'score_church_connection'
          - 'score_seen_recency'
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
    and u.notification_score >= 8
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
    greatest(
      coalesce(u.last_activity_at, 'epoch'::timestamptz),
      coalesce(u.last_seen, 'epoch'::timestamptz)
    ) desc
  limit greatest(coalesce(p_limit, 12), 1);
$$;
