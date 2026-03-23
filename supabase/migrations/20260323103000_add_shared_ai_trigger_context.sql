create or replace function public.build_ai_trigger_shared_context(p_user_id uuid)
returns jsonb
language sql
stable
set search_path = pg_catalog, public
as $$
  select jsonb_build_object(
    'user_profile',
    jsonb_strip_nulls(
      jsonb_build_object(
        'user_id', p.id,
        'first_name', nullif(trim(p.first_name), ''),
        'last_name', nullif(trim(p.last_name), ''),
        'full_name', nullif(trim(concat_ws(' ', p.first_name, p.last_name)), ''),
        'bio', nullif(trim(p.bio), ''),
        'timezone', p.timezone,
        'year_believed', p.year_believed,
        'year_baptized', p.year_baptized,
        'last_seen', p.last_seen,
        'profile_updated_at', p.updated_at
      )
    ),
    'church',
    coalesce(
      (
        case
          when ch.id is null then null
          else jsonb_strip_nulls(
            jsonb_build_object(
              'church_id', ch.id,
              'name', ch.name,
              'address', ch.address,
              'website_url', ch.website_url,
              'updated_at', ch.updated_at
            )
          )
        end
      ),
      'null'::jsonb
    ),
    'has_church', p.church_id is not null
  )
  from public.profiles p
  left join public.churches ch on ch.id = p.church_id
  where p.id = p_user_id;
$$;


create or replace function public.generate_ai_triggers()
returns void
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
begin

  insert into public.ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'plan_completion',
    'User completed a devotional plan recently',
    1,
    shared.shared_context || jsonb_build_object(
      'plans_completed', u.plans_completed,
      'plans_completed_recently', u.plans_completed_recently,
      'max_days_completed', u.max_days_completed,
      'last_activity_at', u.last_activity_at,
      'last_plan_progress_at', u.last_plan_progress_at,
      'last_day_item_at', u.last_day_item_at,
      'last_comment_at', u.last_comment_at,
      'profile_updated_at', u.profile_updated_at
    )
  from public.user_behavior_snapshot u
  cross join lateral (
    select coalesce(public.build_ai_trigger_shared_context(u.user_id), '{}'::jsonb) as shared_context
  ) shared
  where
    public.user_has_active_auth_session(u.user_id)
    and u.plans_completed_recently > 0
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'plan_completion'
        and t.created_at > now() - interval '3 days'
    );

  insert into public.ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'welcome_back',
    'User opened the app after a long devotional quiet season',
    2,
    shared.shared_context || jsonb_build_object(
      'time_since_last_seen', u.time_since_last_seen,
      'time_since_last_activity', u.time_since_last_activity,
      'active_plans', u.active_plans,
      'last_activity_at', u.last_activity_at,
      'last_plan_progress_at', u.last_plan_progress_at,
      'last_day_item_at', u.last_day_item_at,
      'last_comment_at', u.last_comment_at,
      'profile_updated_at', u.profile_updated_at
    )
  from public.user_behavior_snapshot u
  cross join lateral (
    select coalesce(public.build_ai_trigger_shared_context(u.user_id), '{}'::jsonb) as shared_context
  ) shared
  where
    public.user_has_active_auth_session(u.user_id)
    and u.last_seen > now() - interval '1 day'
    and u.last_activity_at is not null
    and u.last_activity_at < now() - interval '7 days'
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 2
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'welcome_back'
        and t.created_at > now() - interval '21 days'
    );

  insert into public.ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'inactivity_nudge',
    'User has active devotion progress but has been quiet for a few days',
    3,
    shared.shared_context || jsonb_build_object(
      'time_since_last_activity', u.time_since_last_activity,
      'active_plans', u.active_plans,
      'max_days_completed', u.max_days_completed,
      'last_activity_at', u.last_activity_at,
      'last_plan_progress_at', u.last_plan_progress_at,
      'last_day_item_at', u.last_day_item_at,
      'last_comment_at', u.last_comment_at,
      'profile_updated_at', u.profile_updated_at
    )
  from public.user_behavior_snapshot u
  cross join lateral (
    select coalesce(public.build_ai_trigger_shared_context(u.user_id), '{}'::jsonb) as shared_context
  ) shared
  where
    public.user_has_active_auth_session(u.user_id)
    and u.active_plans > 0
    and u.last_activity_at is not null
    and u.last_activity_at < now() - interval '2 days'
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 3
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'inactivity_nudge'
        and t.created_at > now() - interval '7 days'
    );

  insert into public.ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'friend_invite_nudge',
    'User is active and could invite more people into reading with them',
    4,
    shared.shared_context || jsonb_build_object(
      'friends_count', u.friends_count,
      'group_plans_count', u.group_plans_count,
      'active_plans', u.active_plans,
      'church_id', u.church_id,
      'church_name', u.church_name,
      'last_activity_at', u.last_activity_at,
      'last_plan_progress_at', u.last_plan_progress_at,
      'last_day_item_at', u.last_day_item_at,
      'last_comment_at', u.last_comment_at,
      'profile_updated_at', u.profile_updated_at
    )
  from public.user_behavior_snapshot u
  cross join lateral (
    select coalesce(public.build_ai_trigger_shared_context(u.user_id), '{}'::jsonb) as shared_context
  ) shared
  where
    public.user_has_active_auth_session(u.user_id)
    and u.active_plans > 0
    and u.last_activity_at > now() - interval '3 days'
    and (u.friends_count < 2 or u.group_plans_count = 0)
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 4
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'friend_invite_nudge'
        and t.created_at > now() - interval '14 days'
    );

  insert into public.ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'streak_encouragement',
    'User is keeping a steady rhythm of time with God',
    5,
    shared.shared_context || jsonb_build_object(
      'max_days_completed', u.max_days_completed,
      'active_plans', u.active_plans,
      'last_activity_at', u.last_activity_at,
      'last_plan_progress_at', u.last_plan_progress_at,
      'last_day_item_at', u.last_day_item_at,
      'last_comment_at', u.last_comment_at,
      'profile_updated_at', u.profile_updated_at
    )
  from public.user_behavior_snapshot u
  cross join lateral (
    select coalesce(public.build_ai_trigger_shared_context(u.user_id), '{}'::jsonb) as shared_context
  ) shared
  where
    public.user_has_active_auth_session(u.user_id)
    and u.max_days_completed >= 3
    and u.last_activity_at > now() - interval '1 day'
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 5
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'streak_encouragement'
        and t.created_at > now() - interval '7 days'
    );

  insert into public.ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'church_connection_nudge',
    'User has a church listed and may welcome community connection',
    6,
    shared.shared_context || jsonb_build_object(
      'friends_count', u.friends_count,
      'group_plans_count', u.group_plans_count,
      'church_id', u.church_id,
      'church_name', u.church_name,
      'church_address', u.church_address,
      'church_website_url', u.church_website_url,
      'last_activity_at', u.last_activity_at,
      'last_plan_progress_at', u.last_plan_progress_at,
      'last_day_item_at', u.last_day_item_at,
      'last_comment_at', u.last_comment_at,
      'profile_updated_at', u.profile_updated_at
    )
  from public.user_behavior_snapshot u
  cross join lateral (
    select coalesce(public.build_ai_trigger_shared_context(u.user_id), '{}'::jsonb) as shared_context
  ) shared
  where
    public.user_has_active_auth_session(u.user_id)
    and u.last_seen > now() - interval '5 days'
    and u.has_church
    and u.friends_count = 0
    and u.group_plans_count = 0
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 6
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'church_connection_nudge'
        and t.created_at > now() - interval '30 days'
    );

  insert into public.ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'social_prompt',
    'User appears spiritually isolated and may need a support group',
    7,
    shared.shared_context || jsonb_build_object(
      'friends_count', u.friends_count,
      'group_plans_count', u.group_plans_count,
      'last_activity_at', u.last_activity_at,
      'last_plan_progress_at', u.last_plan_progress_at,
      'last_day_item_at', u.last_day_item_at,
      'last_comment_at', u.last_comment_at,
      'profile_updated_at', u.profile_updated_at
    )
  from public.user_behavior_snapshot u
  cross join lateral (
    select coalesce(public.build_ai_trigger_shared_context(u.user_id), '{}'::jsonb) as shared_context
  ) shared
  where
    public.user_has_active_auth_session(u.user_id)
    and u.last_seen > now() - interval '5 days'
    and u.friends_count = 0
    and u.group_plans_count = 0
    and not u.has_church
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 7
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'social_prompt'
        and t.created_at > now() - interval '30 days'
    );

  insert into public.ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'abandoned_plan',
    'User has a previous plan that has gone quiet',
    8,
    shared.shared_context || jsonb_build_object(
      'abandoned_plans', u.abandoned_plans,
      'active_plans', u.active_plans,
      'time_since_last_activity', u.time_since_last_activity,
      'last_activity_at', u.last_activity_at,
      'last_plan_progress_at', u.last_plan_progress_at,
      'last_day_item_at', u.last_day_item_at,
      'last_comment_at', u.last_comment_at,
      'profile_updated_at', u.profile_updated_at
    )
  from public.user_behavior_snapshot u
  cross join lateral (
    select coalesce(public.build_ai_trigger_shared_context(u.user_id), '{}'::jsonb) as shared_context
  ) shared
  where
    public.user_has_active_auth_session(u.user_id)
    and u.abandoned_plans > 0
    and u.last_activity_at > now() - interval '3 days'
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 8
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'abandoned_plan'
        and t.created_at > now() - interval '14 days'
    );

  insert into public.ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'service_prompt',
    'User is active and could be encouraged toward a good deed this week',
    9,
    shared.shared_context || jsonb_build_object(
      'active_plans', u.active_plans,
      'max_days_completed', u.max_days_completed,
      'friends_count', u.friends_count,
      'last_activity_at', u.last_activity_at,
      'last_plan_progress_at', u.last_plan_progress_at,
      'last_day_item_at', u.last_day_item_at,
      'last_comment_at', u.last_comment_at,
      'profile_updated_at', u.profile_updated_at
    )
  from public.user_behavior_snapshot u
  cross join lateral (
    select coalesce(public.build_ai_trigger_shared_context(u.user_id), '{}'::jsonb) as shared_context
  ) shared
  where
    public.user_has_active_auth_session(u.user_id)
    and u.last_seen > now() - interval '5 days'
    and (u.active_plans > 0 or u.max_days_completed >= 3)
    and extract(isodow from timezone(coalesce(u.timezone, 'UTC'), now())) = 2
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 9
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type in ('service_prompt', 'prayer_prompt', 'gospel_prompt')
        and t.created_at > now() - interval '7 days'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'service_prompt'
        and t.created_at > now() - interval '21 days'
    );

  insert into public.ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'prayer_prompt',
    'User is active and could be encouraged to pray for someone this week',
    10,
    shared.shared_context || jsonb_build_object(
      'active_plans', u.active_plans,
      'friends_count', u.friends_count,
      'group_plans_count', u.group_plans_count,
      'last_activity_at', u.last_activity_at,
      'last_plan_progress_at', u.last_plan_progress_at,
      'last_day_item_at', u.last_day_item_at,
      'last_comment_at', u.last_comment_at,
      'profile_updated_at', u.profile_updated_at
    )
  from public.user_behavior_snapshot u
  cross join lateral (
    select coalesce(public.build_ai_trigger_shared_context(u.user_id), '{}'::jsonb) as shared_context
  ) shared
  where
    public.user_has_active_auth_session(u.user_id)
    and u.last_seen > now() - interval '5 days'
    and (u.active_plans > 0 or u.max_days_completed >= 2)
    and extract(isodow from timezone(coalesce(u.timezone, 'UTC'), now())) = 4
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 10
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type in ('service_prompt', 'prayer_prompt', 'gospel_prompt')
        and t.created_at > now() - interval '7 days'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'prayer_prompt'
        and t.created_at > now() - interval '21 days'
    );

  insert into public.ai_triggers (
    user_id,
    trigger_type,
    trigger_reason,
    priority,
    context
  )
  select
    u.user_id,
    'gospel_prompt',
    'User is active and could be encouraged to share the gospel this week',
    11,
    shared.shared_context || jsonb_build_object(
      'active_plans', u.active_plans,
      'friends_count', u.friends_count,
      'last_activity_at', u.last_activity_at,
      'last_plan_progress_at', u.last_plan_progress_at,
      'last_day_item_at', u.last_day_item_at,
      'last_comment_at', u.last_comment_at,
      'profile_updated_at', u.profile_updated_at
    )
  from public.user_behavior_snapshot u
  cross join lateral (
    select coalesce(public.build_ai_trigger_shared_context(u.user_id), '{}'::jsonb) as shared_context
  ) shared
  where
    public.user_has_active_auth_session(u.user_id)
    and u.last_seen > now() - interval '5 days'
    and (u.active_plans > 0 or u.max_days_completed >= 3)
    and extract(isodow from timezone(coalesce(u.timezone, 'UTC'), now())) = 5
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.created_at > now() - interval '48 hours'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.priority < 11
        and t.created_at > now() - interval '1 day'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type in ('service_prompt', 'prayer_prompt', 'gospel_prompt')
        and t.created_at > now() - interval '7 days'
    )
    and not exists (
      select 1
      from public.ai_triggers t
      where t.user_id = u.user_id
        and t.trigger_type = 'gospel_prompt'
        and t.created_at > now() - interval '21 days'
    );
end;
$$;
