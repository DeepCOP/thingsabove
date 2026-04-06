alter table public.ai_triggers
  add column if not exists planner_category text;

update public.ai_triggers
set planner_category = planner_payload->'decision'->>'category'
where planner_category is null
  and planner_payload ? 'decision'
  and planner_payload->'decision'->>'category' is not null;

alter table public.ai_triggers
  drop constraint if exists ai_triggers_planner_category_check;

alter table public.ai_triggers
  add constraint ai_triggers_planner_category_check check (
    planner_category is null
    or planner_category in (
      'invite_friends',
      'church_attendance',
      'daily_devotion',
      'spiritual_support',
      'good_deed',
      'prayer_for_someone',
      'share_gospel'
    )
  );

drop function if exists public.list_ai_notification_planning_candidates(integer);

drop index if exists public.idx_ai_triggers_pending_schedule;

alter table public.ai_triggers
  drop column if exists priority,
  drop column if exists context,
  drop column if exists planner_reason,
  drop column if exists planner_payload,
  drop column if exists planning_model;

create index if not exists idx_ai_triggers_pending_schedule
  on public.ai_triggers (scheduled_for, created_at)
  where sent = false and scheduled_for is not null;


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
