import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
);

const EXPO_ACCESS_TOKEN = Deno.env.get('EXPO_ACCESS_TOKEN');

function notificationTitle(type: string) {
  switch (type) {
    case 'plan_completion':
      return '🎉 Well done!';
    case 'friend_invite_nudge':
      return '👥 Grow together';
    case 'welcome_back':
      return '🙏 Welcome back';
    default:
      return '📖 Daily encouragement';
  }
}

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

Deno.serve(async () => {
  const { data: triggers, error } = await supabase
    .from('ai_triggers')
    .select(
      `
      id,
      trigger_type,
      generated_message,
      profiles ( expo_push_token )
    `,
    )
    .eq('sent', false)
    .not('generated_message', 'is', null)
    .limit(1000);

  if (error || !triggers?.length) {
    return new Response('No notifications', { status: 200 });
  }

  const messages = triggers
    .filter((t) => t.profiles?.expo_push_token)
    .map((t) => ({
      to: t.profiles.expo_push_token,
      sound: 'default',
      title: notificationTitle(t.trigger_type),
      body: t.generated_message,
      data: { triggerType: t.trigger_type },
    }));

  // 🔹 Expo limit: 100 per request
  const chunk = <T>(arr: T[], size: number) =>
    Array.from({ length: Math.ceil(arr.length / size) }, (_, i) =>
      arr.slice(i * size, i * size + size),
    );

  for (const batch of chunk(messages, 100)) {
    const res = await fetch('https://exp.host/--/api/v2/push/send', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${EXPO_ACCESS_TOKEN}`,
      },
      body: JSON.stringify(batch),
    });

    const result = await res.json();
    console.log('Expo batch:', result);

    // 🛑 rate-limit safe
    await sleep(200);
  }

  await supabase
    .from('ai_triggers')
    .update({ sent: true, sent_at: new Date().toISOString() })
    .in(
      'id',
      triggers.map((t) => t.id),
    );

  return new Response('Push sent', { status: 200 });
});
