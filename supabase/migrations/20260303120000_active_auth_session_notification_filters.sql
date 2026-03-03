create or replace function public.user_has_active_auth_session(
  p_user_id uuid
)
returns boolean
language sql
security definer
set search_path = public, auth
as $$
  select exists (
    select 1
    from auth.sessions s
    where s.user_id = p_user_id
      and coalesce((to_jsonb(s)->>'not_after')::timestamptz, now() + interval '100 years') > now()
  );
$$;

create or replace function queue_daily_notifications()
returns void
language plpgsql
security definer
as $$
declare
  send_hour int := 7;
begin
  insert into ai_notifications (
    user_id,
    message_id,
    type,
    content,
    scheduled_for
  )
  select
    np.user_id,
    dm.id,
    'daily',
    dm.content,
    (
      (current_date + make_interval(hours => send_hour))
        at time zone coalesce(p.timezone, 'UTC')
    ) at time zone 'UTC'
  from notification_preferences np
  join public.profiles p on p.id = np.user_id
  join ai_daily_messages dm
    on dm.message_date = current_date
  where
    np.daily = true
    and public.user_has_active_auth_session(np.user_id)
    and p.expo_push_token is not null
    and not exists (
      select 1
      from ai_notifications n
      where n.user_id = np.user_id
        and n.message_id = dm.id
    );
end;
$$;

create or replace function generate_ai_triggers()
returns void
language plpgsql
security definer
as $$
begin
  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'plan_completion',
    'User completed a devotional plan',
    1,
    jsonb_build_object(
      'plans_completed', u.plans_completed,
      'max_days_completed', u.max_days_completed
    )
  from user_behavior_snapshot u
  where
    public.user_has_active_auth_session(u.user_id)
    and u.plans_completed > 0
    and u.last_activity_at > now() - interval '1 day'
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'plan_completion'
        and t.created_at > now() - interval '3 days'
    );

  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'welcome_back',
    'User returned after long inactivity',
    2,
    jsonb_build_object(
      'time_since_last_seen', u.time_since_last_seen
    )
  from user_behavior_snapshot u
  where
    public.user_has_active_auth_session(u.user_id)
    and u.time_since_last_seen > interval '5 days'
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 2
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'welcome_back'
        and t.created_at > now() - interval '14 days'
    );

  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'friend_invite_nudge',
    'Active user with no friends',
    3,
    jsonb_build_object(
      'plans_started', u.plans_started,
      'commented_recently', u.commented_recently
    )
  from user_behavior_snapshot u
  where
    public.user_has_active_auth_session(u.user_id)
    and u.has_friends = false
    and u.plans_started > 0
    and u.time_since_last_activity < interval '3 days'
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 3
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'friend_invite_nudge'
        and t.created_at > now() - interval '14 days'
    );

  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'inactivity_nudge',
    'User inactive for more than 5 days',
    4,
    jsonb_build_object(
      'time_since_last_activity', u.time_since_last_activity,
      'active_plans', u.active_plans
    )
  from user_behavior_snapshot u
  where
    public.user_has_active_auth_session(u.user_id)
    and u.time_since_last_activity > interval '5 days'
    and u.active_plans > 0
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 4
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'inactivity_nudge'
        and t.created_at > now() - interval '7 days'
    );

  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'streak_encouragement',
    'User is building a steady devotional rhythm',
    5,
    jsonb_build_object(
      'max_days_completed', u.max_days_completed,
      'active_plans', u.active_plans
    )
  from user_behavior_snapshot u
  where
    public.user_has_active_auth_session(u.user_id)
    and u.max_days_completed >= 3
    and u.last_activity_at > now() - interval '1 day'
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 5
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'streak_encouragement'
        and t.created_at > now() - interval '7 days'
    );

  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'abandoned_plan',
    'User has an inactive plan that was not completed',
    6,
    jsonb_build_object(
      'abandoned_plans', u.abandoned_plans,
      'active_plans', u.active_plans,
      'time_since_last_activity', u.time_since_last_activity
    )
  from user_behavior_snapshot u
  where
    public.user_has_active_auth_session(u.user_id)
    and u.abandoned_plans > 0
    and u.time_since_last_activity < interval '3 days'
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 6
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'abandoned_plan'
        and t.created_at > now() - interval '10 days'
    );

  insert into ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'social_prompt',
    'Active user with friends but no recent comments',
    7,
    jsonb_build_object(
      'commented_recently', u.commented_recently,
      'has_friends', u.has_friends,
      'plans_started', u.plans_started
    )
  from user_behavior_snapshot u
  where
    public.user_has_active_auth_session(u.user_id)
    and u.has_friends = true
    and u.commented_recently = false
    and u.has_group_plan = true
    and u.time_since_last_activity < interval '3 days'
    and u.plans_started > 0
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 7
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1 from ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'social_prompt'
        and t.created_at > now() - interval '14 days'
    );
end;
$$;
