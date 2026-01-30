import { serve } from 'https://deno.land/std/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

serve(async () => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  );

  // fetch small batch
  const { data: notifications } = await supabase
    .from('ai_notifications')
    .select(`
      id,
      content,
      profiles ( expo_push_token )
    `)
    .is('sent_at', null)
    .limit(100);

  if (!notifications?.length) {
    return new Response('No pending notifications');
  }

  const messages = notifications
    .filter(n => n.profiles?.expo_push_token)
    .map(n => ({
      to: n.profiles.expo_push_token,
      title: 'Daily Encouragement',
      body: n.content,
      sound: 'default',
    }));

  if (messages.length) {
    await fetch('https://exp.host/--/api/v2/push/send', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(messages),
    });
  }

  // mark as sent
  await supabase
    .from('ai_notifications')
    .update({ sent_at: new Date().toISOString() })
    .in(
      'id',
      notifications.map(n => n.id)
    );

  return new Response(`Sent ${messages.length} notifications`);
});
