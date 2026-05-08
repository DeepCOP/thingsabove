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
            'planner_category', ranked.planner_category,
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
  ),
  notification_state as (
    select
      t.user_id,
      max(t.sent_at) filter (where t.sent_at is not null) as last_sent_at,
      bool_or(
        t.sent = false
        and coalesce(t.scheduled_for, t.created_at) > now() - interval '7 days'
      ) as has_pending_trigger
    from public.ai_triggers t
    group by t.user_id
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
        'notification_language', jsonb_build_object(
          'language_tag', coalesce(nullif(trim(p.device_language_tag), ''), 'en'),
          'language_code', coalesce(nullif(trim(p.device_language_code), ''), 'en'),
          'source', case
            when nullif(trim(p.device_language_tag), '') is not null
              or nullif(trim(p.device_language_code), '') is not null then 'device'
            else 'fallback'
          end
        ),
        'notification_score', u.notification_score,
        'notification_score_breakdown', coalesce(u.notification_score_breakdown, '{}'::jsonb),
        'recent_notifications', coalesce(rh.items, '[]'::jsonb),
        'local_now', timezone(
          coalesce(nullif(trim(u.timezone), ''), nullif(trim(p.timezone), ''), 'UTC'),
          now()
        ),
        'notification_timing', jsonb_strip_nulls(
          jsonb_build_object(
            'last_sent_at', ns.last_sent_at,
            'next_notification_due_at', ns.last_sent_at + interval '36 hours',
            'latest_send_at', ns.last_sent_at + interval '36 hours'
          )
        ),
        'allowed_schedule', jsonb_build_object(
          'day_offsets', jsonb_build_array(0, 1),
          'local_hour_min', 8,
          'local_hour_max', 20
        )
      )
    ) as planning_context
  from public.user_behavior_scored u
  join public.profiles p on p.id = u.user_id
  left join public.notification_preferences np on np.user_id = u.user_id
  left join recent_history rh on rh.user_id = u.user_id
  left join notification_state ns on ns.user_id = u.user_id
  where
    public.user_has_active_auth_session(u.user_id)
    and nullif(trim(coalesce(p.expo_push_token, '')), '') is not null
    and coalesce(np.daily, true)
    and not coalesce(ns.has_pending_trigger, false)
    and coalesce(ns.last_sent_at + interval '36 hours', now()) <= now() + interval '24 hours'
  order by
    coalesce(ns.last_sent_at + interval '36 hours', now()) asc,
    u.notification_score desc,
    coalesce(u.last_activity_at, u.profile_created_at) asc,
    coalesce(u.last_seen, u.profile_created_at) asc
  limit greatest(coalesce(p_limit, 12), 1);
$$;
