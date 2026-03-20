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

  now() - p.last_seen as time_since_last_seen,

  max(pp.updated_at) as last_activity_at,
  now() - max(pp.updated_at) as time_since_last_activity,

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

  exists (
    select 1
    from public.comments c
    where c.user_id = p.id
      and c.created_at > now() - interval '7 days'
  ) as commented_recently,

  coalesce(gps.group_plans_count, 0) > 0 as has_group_plan,
  coalesce(fs.friends_count, 0) > 0 as has_friends,
  coalesce(fs.friends_count, 0) as friends_count,
  coalesce(gps.group_plans_count, 0) as group_plans_count

from public.profiles p
left join public.plan_progress pp on pp.user_id = p.id
left join public.devotional_plans dp on dp.id = pp.plan_id
left join public.churches ch on ch.id = p.church_id
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


alter table public.ai_triggers
  drop constraint if exists ai_triggers_trigger_type_check;

alter table public.ai_triggers
  add constraint ai_triggers_trigger_type_check check (
    trigger_type in (
      'inactivity_nudge',
      'abandoned_plan',
      'plan_completion',
      'streak_encouragement',
      'friend_invite_nudge',
      'social_prompt',
      'welcome_back',
      'church_connection_nudge',
      'service_prompt',
      'prayer_prompt',
      'gospel_prompt'
    )
  );


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
    jsonb_build_object(
      'plans_completed', u.plans_completed,
      'plans_completed_recently', u.plans_completed_recently,
      'max_days_completed', u.max_days_completed
    )
  from public.user_behavior_snapshot u
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
    jsonb_build_object(
      'time_since_last_seen', u.time_since_last_seen,
      'time_since_last_activity', u.time_since_last_activity,
      'active_plans', u.active_plans
    )
  from public.user_behavior_snapshot u
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
    jsonb_build_object(
      'time_since_last_activity', u.time_since_last_activity,
      'active_plans', u.active_plans,
      'max_days_completed', u.max_days_completed
    )
  from public.user_behavior_snapshot u
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
  'User could be encouraged to invite others into the experience',
  4,
  jsonb_build_object(
    'friends_count', u.friends_count,
    'group_plans_count', u.group_plans_count,
    'active_plans', u.active_plans,
    'church_id', u.church_id,
    'church_name', u.church_name
  )
from public.user_behavior_snapshot u
where
  public.user_has_active_auth_session(u.user_id)
  and u.last_seen > now() - interval '5 days'

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

  -- cooldown for this trigger
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
    jsonb_build_object(
      'max_days_completed', u.max_days_completed,
      'active_plans', u.active_plans
    )
  from public.user_behavior_snapshot u
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
    jsonb_build_object(
      'friends_count', u.friends_count,
      'group_plans_count', u.group_plans_count,
      'church_id', u.church_id,
      'church_name', u.church_name,
      'church_address', u.church_address,
      'church_website_url', u.church_website_url
    )
  from public.user_behavior_snapshot u
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
    jsonb_build_object(
      'friends_count', u.friends_count,
      'group_plans_count', u.group_plans_count
    )
  from public.user_behavior_snapshot u
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
    jsonb_build_object(
      'abandoned_plans', u.abandoned_plans,
      'active_plans', u.active_plans,
      'time_since_last_activity', u.time_since_last_activity
    )
  from public.user_behavior_snapshot u
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
    jsonb_build_object(
      'active_plans', u.active_plans,
      'max_days_completed', u.max_days_completed,
      'friends_count', u.friends_count
    )
  from public.user_behavior_snapshot u
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
    jsonb_build_object(
      'active_plans', u.active_plans,
      'friends_count', u.friends_count,
      'group_plans_count', u.group_plans_count
    )
  from public.user_behavior_snapshot u
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
    jsonb_build_object(
      'active_plans', u.active_plans,
      'friends_count', u.friends_count
    )
  from public.user_behavior_snapshot u
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
