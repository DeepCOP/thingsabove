create index if not exists idx_notifications_ai_trigger_id
on public.notifications ((data->>'ai_trigger_id'))
where type = 'ai_notification' and data ? 'ai_trigger_id';

insert into public.notifications (
  user_id,
  type,
  title,
  body,
  data,
  is_read,
  created_at
)
select
  t.user_id,
  'ai_notification',
  coalesce(nullif(trim(t.generated_title), ''), 'A moment with God'),
  t.generated_message,
  jsonb_strip_nulls(
    jsonb_build_object(
      'ai_trigger_id', t.id,
      'planner_category', t.planner_category,
      'route', '/notifications',
      'scheduled_for', t.scheduled_for
    )
  ),
  false,
  coalesce(t.sent_at, t.scheduled_for, t.created_at, now())
from public.ai_triggers t
where t.sent = true
  and t.generated_message is not null
  and not exists (
    select 1
    from public.notifications n
    where n.type = 'ai_notification'
      and n.data->>'ai_trigger_id' = t.id::text
  );
