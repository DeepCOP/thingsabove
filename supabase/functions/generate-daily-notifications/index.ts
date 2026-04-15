import { serve } from 'https://deno.land/std/http/server.ts';
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

serve(async () => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  const googleApiKey = Deno.env.get('GOOGLE_API_KEY');
  if (!googleApiKey) {
    return new Response('Missing GOOGLE_API_KEY', { status: 500 });
  }

  const genAI = new GoogleGenerativeAI(googleApiKey);

  const model = genAI.getGenerativeModel({
    model: 'gemini-2.5-flash',
    systemInstruction: `
You are a Christian devotional assistant.

Your goal is to encourage users toward God's reign and righteousness.
Your tone must be invitational, gentle, and Scripture-centered.

Rules:
- Never use guilt or shame
- Never command
- Never claim divine authority
- Keep messages short and natural for a push notification
- Every message must begin with a warm encouragement to the user, then include a related Bible verse excerpt or faithful paraphrase with its reference
- Format the message as: main message first, then a newline, then the verse on its own line in quotes with the reference
- Example shape only: "Take a quiet moment with God today and let Him steady your heart.\n\"Be still, and know that I am God\" (Psalm 46:10)."

`,
  });

  const today = new Date().toISOString().slice(0, 10);

  // Check if already generated today.
  const { data: existing } = await supabase
    .from('ai_daily_messages')
    .select('id')
    .eq('message_date', today)
    .single();

  if (existing) {
    return new Response('Already generated', { status: 200 });
  }

  // Generate encouragement.
  const result = await model.generateContent({
    contents: [
      {
        role: 'user',
        parts: [
          {
            text: `
Write a daily Christian encouragement notification.

Requirements:
- 1-2 short sentences before the verse line
- Invitational tone
- Include a related Bible verse excerpt or faithful paraphrase with its reference
- Put the verse on a new line in quotes
- Calm and hopeful
`,
          },
        ],
      },
    ],
  });

  const message = result.response.text()?.trim();

  if (!message) {
    return new Response('AI failed', { status: 500 });
  }

  // Save to DB.
  await supabase.from('ai_daily_messages').insert({
    message_date: today,
    content: message,
    type: 'daily',
  });

  return new Response('Daily encouragement generated', { status: 200 });
});
