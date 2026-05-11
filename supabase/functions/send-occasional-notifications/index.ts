import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
);

const EXPO_ACCESS_TOKEN = Deno.env.get('EXPO_ACCESS_TOKEN');
const NOTIFICATION_TITLE = 'A moment with God';
const AI_NOTIFICATION_TYPE = 'ai_notification';
const NOTIFICATIONS_ROUTE = '/notifications';

const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

async function createInAppNotificationsForTriggers(
  triggersById: Map<string, any>,
  triggerIds: string[],
  createdAt: string,
) {
  if (triggerIds.length === 0) return;

  const existingTriggerIds = new Set<string>();
  const { data: existingNotifications, error: existingNotificationsError } = await supabase
    .from('notifications')
    .select('data')
    .eq('type', AI_NOTIFICATION_TYPE)
    .in('data->>ai_trigger_id', triggerIds);

  if (existingNotificationsError) {
    console.error('Failed to check existing AI notifications', existingNotificationsError);
  } else {
    existingNotifications?.forEach((notification: any) => {
      const triggerId = notification?.data?.ai_trigger_id;
      if (typeof triggerId === 'string') {
        existingTriggerIds.add(triggerId);
      }
    });
  }

  const rows = triggerIds
    .map((id) => triggersById.get(id))
    .filter((trigger) => trigger && !existingTriggerIds.has(trigger.id))
    .map((trigger) => ({
      user_id: trigger.user_id,
      type: AI_NOTIFICATION_TYPE,
      title:
        typeof trigger.generated_title === 'string' && trigger.generated_title.trim()
          ? trigger.generated_title.trim()
          : NOTIFICATION_TITLE,
      body: trigger.generated_message,
      data: {
        ai_trigger_id: trigger.id,
        planner_category: trigger.planner_category,
        route: NOTIFICATIONS_ROUTE,
        scheduled_for: trigger.scheduled_for,
      },
      created_at: createdAt,
    }));

  if (rows.length === 0) return;

  const { error } = await supabase.from('notifications').insert(rows);
  if (error) {
    console.error('Failed to create in-app AI notifications', error);
  }
}

Deno.serve(async () => {
  const { data: triggers, error } = await supabase
    .from('ai_triggers')
    .select(
      `
      id,
      user_id,
      generated_title,
      generated_message,
      planner_category,
      scheduled_for,
      created_at,
      profiles ( expo_push_token )
    `,
    )
    .eq('sent', false)
    .not('generated_message', 'is', null)
    .not('scheduled_for', 'is', null)
    .lte('scheduled_for', new Date().toISOString())
    .order('scheduled_for', { ascending: true })
    .order('created_at', { ascending: true })
    .limit(1000);

  if (error || !triggers?.length) {
    return new Response('No notifications', { status: 200 });
  }

  const userIds = Array.from(new Set(triggers.map((trigger) => trigger.user_id).filter(Boolean)));
  const { data: preferences, error: preferencesError } = userIds.length
    ? await supabase
        .from('notification_preferences')
        .select('user_id, daily')
        .in('user_id', userIds)
    : {
        data: [] as { user_id: string; daily: boolean | null }[],
        error: null,
      };

  if (preferencesError) {
    console.error('Failed to load notification preferences', preferencesError);
  }

  const preferenceByUserId = new Map(
    (preferencesError ? [] : (preferences ?? [])).map((preference) => [
      preference.user_id,
      preference.daily,
    ]),
  );

  const disabledTriggerIds = triggers
    .filter((trigger) => preferenceByUserId.get(trigger.user_id) === false)
    .map((trigger) => trigger.id);

  if (disabledTriggerIds.length > 0) {
    await supabase.from('ai_triggers').update({ sent: true }).in('id', disabledTriggerIds);
  }

  const eligible = triggers.filter(
    (trigger) =>
      trigger.profiles?.expo_push_token && preferenceByUserId.get(trigger.user_id) !== false,
  );
  const triggersById = new Map(eligible.map((trigger) => [trigger.id, trigger]));
  const messages = eligible.map((trigger) => ({
    id: trigger.id,
    to: trigger.profiles!.expo_push_token!,
    sound: 'default',
    title:
      typeof trigger.generated_title === 'string' && trigger.generated_title.trim()
        ? trigger.generated_title.trim()
        : NOTIFICATION_TITLE,
    body: trigger.generated_message,
    data: {
      ai_trigger_id: trigger.id,
      route: NOTIFICATIONS_ROUTE,
      type: AI_NOTIFICATION_TYPE,
    },
  }));

  const chunk = <T>(arr: T[], size: number) =>
    Array.from({ length: Math.ceil(arr.length / size) }, (_, index) =>
      arr.slice(index * size, index * size + size),
    );

  const successfulIds: string[] = [];

  for (const batch of chunk(messages, 100)) {
    const response = await fetch('https://exp.host/--/api/v2/push/send', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${EXPO_ACCESS_TOKEN}`,
      },
      body: JSON.stringify(batch),
    });

    const result = await response.json();
    console.log('Expo batch:', result);

    const data = result?.data ?? [];
    const successfulBatchIds: string[] = [];

    data.forEach((ticket: any, index: number) => {
      if (ticket.status === 'ok') {
        successfulBatchIds.push(batch[index].id);
      }
    });

    if (successfulBatchIds.length > 0) {
      const sentAt = new Date().toISOString();

      await createInAppNotificationsForTriggers(triggersById, successfulBatchIds, sentAt);

      const { error: updateError } = await supabase
        .from('ai_triggers')
        .update({ sent: true, sent_at: sentAt })
        .in('id', successfulBatchIds);

      if (updateError) {
        console.error('Failed to mark AI triggers sent', updateError);
      }

      successfulIds.push(...successfulBatchIds);
    }

    await sleep(200);
  }

  return new Response(`Push sent ${successfulIds.length}/${messages.length}`, {
    status: 200,
  });
});
