import { serve } from 'https://deno.land/std/http/server.ts';
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

serve(async () => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  );

  const genAI = new GoogleGenerativeAI(
    Deno.env.get('GEMINI_API_KEY')!
  );

  const model = genAI.getGenerativeModel({
    model: 'gemini-2.5-flash',
    systemInstruction: `
You are a Christian devotional assistant.

Your goal is to encourage users toward God’s reign and righteousness.
Your tone must be invitational, gentle, and Scripture-centered.

Rules:
- Never use guilt or shame
- Never command
- Never claim divine authority
- Keep messages short (1–2 sentences)

`,
  });

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
  const result = await model.generateContent({
    contents: [
      {
        role: 'user',
        parts: [
          {
            text: `
Write a daily Christian encouragement notification.

Requirements:
- 1–2 short sentences
- Invitational tone
- Scripture-centered (verse reference optional)
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

  // 3️⃣ Save to DB
  await supabase.from('ai_daily_messages').insert({
    message_date: today,
    content: message,
    type: 'daily'
  });

  return new Response('Daily encouragement generated', { status: 200 });
});
