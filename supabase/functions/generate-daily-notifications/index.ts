import { serve } from 'https://deno.land/std/http/server.ts';
import OpenAI from 'https://esm.sh/openai@4';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const openai = new OpenAI({
  apiKey: Deno.env.get('OPENAI_API_KEY'),
});

serve(async () => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  );

  const today = new Date().toISOString().slice(0, 10);

  // 1️⃣ Check if already generated today
  const { data: existing } = await supabase
    .from('ai_daily_messages')
    .select('id')
    .eq('message_date', today)
    .single();

  if (existing) {
    return new Response('Already generated', { status: 200 });
  }

  // 2️⃣ Generate encouragement
  const completion = await openai.chat.completions.create({
    model: 'gpt-4o-mini',
    messages: [
      {
        role: 'system',
        content:
          'You are a Christian devotional assistant. Messages must be biblically grounded, encouraging, and gentle.',
      },
      {
        role: 'user',
        content:
          'Write one short daily Christian encouragement (2–3 sentences). No emojis.',
      },
    ],
  });

  const message = completion.choices[0].message.content?.trim();

  if (!message) {
    return new Response('AI failed', { status: 500 });
  }

  // 3️⃣ Save to DB
  await supabase.from('ai_daily_messages').insert({
    message_date: today,
    content: message,
  });

  return new Response('Daily encouragement generated', { status: 200 });
});
