-- Sample prayer-board content for yordanoslemmawork54@gmail.com.
-- If the account/profile does not exist, this migration succeeds without inserting rows.
-- Church requests are inserted only when the profile is linked to a church.

with target_profile as (
  select
    p.id,
    p.church_id
  from auth.users u
  join public.profiles p on p.id = u.id
  where lower(u.email) = lower('yordanoslemmawork54@gmail.com')
  limit 1
),
samples (
  id,
  category,
  content,
  is_urgent,
  allow_comments,
  is_answered,
  testimony,
  created_age,
  answered_age
) as (
  values
    (
      'd07a0000-0000-4000-8000-000000000001'::uuid,
      'Health',
      'Please pray for a family member who is having an important medical procedure today. Pray for peace, wisdom for the doctors, and a smooth recovery.',
      true,
      true,
      false,
      null::text,
      interval '45 minutes',
      null::interval
    ),
    (
      'd07a0000-0000-4000-8000-000000000002'::uuid,
      'Family',
      'Please pray for patience, understanding, and healing in my family as we work through a difficult season together.',
      false,
      true,
      false,
      null::text,
      interval '3 hours',
      null::interval
    ),
    (
      'd07a0000-0000-4000-8000-000000000003'::uuid,
      'Work',
      'I have a big decision to make about work. Please pray that God gives me clarity and courage to choose the right path.',
      false,
      true,
      false,
      null::text,
      interval '1 day',
      null::interval
    ),
    (
      'd07a0000-0000-4000-8000-000000000004'::uuid,
      'Spiritual',
      'Pray that I remain consistent in Scripture and prayer, especially on busy days when it is easy to lose focus.',
      false,
      true,
      true,
      'God helped me establish a simple morning rhythm, and I have been able to keep it consistently this week.',
      interval '4 days',
      interval '1 day'
    ),
    (
      'd07a0000-0000-4000-8000-000000000005'::uuid,
      'Other',
      'Please pray for wisdom and provision as I prepare for a major transition in the coming weeks.',
      false,
      false,
      false,
      null::text,
      interval '2 days',
      null::interval
    ),
    (
      'd07a0000-0000-4000-8000-000000000006'::uuid,
      'Health',
      'Please pray for renewed strength and restful sleep after several exhausting weeks.',
      false,
      true,
      true,
      'Thank you for praying. My sleep has improved, and I am feeling stronger and more hopeful each day.',
      interval '10 days',
      interval '6 days'
    )
)
insert into public.prayer_requests (
  id,
  user_id,
  church_id,
  scope,
  category,
  content,
  is_urgent,
  allow_comments,
  is_answered,
  answered_at,
  testimony,
  created_at,
  updated_at
)
select
  s.id,
  p.id,
  p.church_id,
  'public',
  s.category,
  s.content,
  s.is_urgent,
  s.allow_comments,
  s.is_answered,
  case when s.is_answered then now() - s.answered_age else null end,
  s.testimony,
  now() - s.created_age,
  case
    when s.is_answered then now() - s.answered_age
    else now() - s.created_age
  end
from samples s
cross join target_profile p
on conflict (id) do nothing;

with target_profile as (
  select
    p.id,
    p.church_id
  from auth.users u
  join public.profiles p on p.id = u.id
  where lower(u.email) = lower('yordanoslemmawork54@gmail.com')
    and p.church_id is not null
  limit 1
),
samples (
  id,
  category,
  content,
  is_urgent,
  allow_comments,
  is_answered,
  testimony,
  created_age,
  answered_age
) as (
  values
    (
      'd07a0000-0000-4000-8000-000000000007'::uuid,
      'Family',
      'Please pray for the families in our church who are caring for loved ones. May they receive strength, practical help, and encouragement.',
      true,
      true,
      false,
      null::text,
      interval '2 hours',
      null::interval
    ),
    (
      'd07a0000-0000-4000-8000-000000000008'::uuid,
      'Spiritual',
      'Please pray that our church grows in unity and serves our neighbors with humility, generosity, and genuine love.',
      false,
      true,
      true,
      'God opened a new opportunity for our church to serve nearby families, and volunteers responded with generosity and joy.',
      interval '8 days',
      interval '2 days'
    )
)
insert into public.prayer_requests (
  id,
  user_id,
  church_id,
  scope,
  category,
  content,
  is_urgent,
  allow_comments,
  is_answered,
  answered_at,
  testimony,
  created_at,
  updated_at
)
select
  s.id,
  p.id,
  p.church_id,
  'church',
  s.category,
  s.content,
  s.is_urgent,
  s.allow_comments,
  s.is_answered,
  case when s.is_answered then now() - s.answered_age else null end,
  s.testimony,
  now() - s.created_age,
  case
    when s.is_answered then now() - s.answered_age
    else now() - s.created_age
  end
from samples s
cross join target_profile p
on conflict (id) do nothing;
