import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
);

const EXPO_ACCESS_TOKEN = Deno.env.get('EXPO_ACCESS_TOKEN');
const NOTIFICATION_TITLE = 'A moment with God';

const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

Deno.serve(async () => {
  const { data: triggers, error } = await supabase
    .from('ai_triggers')
    .select(
      `
      id,
      generated_title,
      generated_message,
      priority,
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
    .order('priority', { ascending: true })
    .order('created_at', { ascending: true })
    .limit(1000);

  if (error || !triggers?.length) {
    return new Response('No notifications', { status: 200 });
  }

  const eligible = triggers.filter((trigger) => trigger.profiles?.expo_push_token);
  const messages = eligible.map((trigger) => ({
    id: trigger.id,
    to: trigger.profiles!.expo_push_token!,
    sound: 'default',
    title:
      typeof trigger.generated_title === 'string' && trigger.generated_title.trim()
        ? trigger.generated_title.trim()
        : NOTIFICATION_TITLE,
    body: trigger.generated_message,
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
    data.forEach((ticket: any, index: number) => {
      if (ticket.status === 'ok') {
        successfulIds.push(batch[index].id);
      }
    });

    await sleep(200);
  }

  if (successfulIds.length > 0) {
    await supabase
      .from('ai_triggers')
      .update({ sent: true, sent_at: new Date().toISOString() })
      .in('id', successfulIds);
  }

  return new Response(`Push sent ${successfulIds.length}/${messages.length}`, {
    status: 200,
  });
});
