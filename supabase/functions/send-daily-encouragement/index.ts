import { serve } from 'https://deno.land/std/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

serve(async () => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );
  const EXPO_ACCESS_TOKEN = Deno.env.get('EXPO_ACCESS_TOKEN');

  // fetch small batch
  const { data: notifications, error } = await supabase
    .from('ai_notifications')
    .select(
      `
      id,
      content,
      profiles ( expo_push_token, first_name, last_name )
    `,
    )
    .is('sent_at', null)
    .eq('type', 'daily')
    .lte('scheduled_for', new Date().toISOString())
    .limit(1000);

  if (!notifications?.length) {
    console.error('Error fetching notifications:', error);
    return new Response('No pending notifications');
  }

  function chunk<T>(arr: T[], size: number) {
    const chunks: T[][] = [];
    for (let i = 0; i < arr.length; i += size) {
      chunks.push(arr.slice(i, i + size));
    }
    return chunks;
  }

  const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

  const eligible = notifications.filter((n) => n.profiles?.expo_push_token);

  const messages = eligible.map((n) => {
    const firstName = n.profiles?.first_name?.trim();
    const name = firstName || 'Friend';

    return {
      id: n.id,
      to: n.profiles!.expo_push_token!,
      title: `${name}, a word for today`,
      body: n.content,
      sound: 'default',
    };
  });

  const batches = chunk(messages, 100);
  const successfulIds: string[] = [];

  for (const batch of batches) {
    const res = await fetch('https://exp.host/--/api/v2/push/send', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${EXPO_ACCESS_TOKEN}`,
      },
      body: JSON.stringify(batch),
    });

    const { data } = await res.json();

    data.forEach((ticket: any, idx: number) => {
      if (ticket.status === 'ok') {
        successfulIds.push(batch[idx].id);
      }
    });
    await sleep(200);
  }

  // mark as sent
  if (successfulIds.length > 0) {
    await supabase
      .from('ai_notifications')
      .update({ sent_at: new Date().toISOString() })
      .in('id', successfulIds);
  }

  return new Response(`Sent ${messages.length} notifications`);
});
