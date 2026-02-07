import { serve } from 'https://deno.land/std/http/server.ts';
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SYSTEM_PROMPT = `
You write very short occasional spiritual messages (1–2 sentences).

These messages are not reminders, commands, or engagement pings.
They are words of spiritual companionship — like an older brother or sister
who knows when to speak and when to remain quiet.

Your purpose is to help the person gently pursue God’s reign and righteousness.

Tone rules:
- Always invitational, never commanding
- Never guilt-based or corrective
- Never explain why you know something
- Never reference app usage, activity, or behavior explicitly
- Warm, human, calm, and personal

Content rules:
- Oriented toward Scripture, prayer, devotion, fellowship, generosity,
  discipleship, or faithful daily obedience
- Speak as encouragement, not instruction
- No pressure, no obligation language
- Assume goodwill and desire for God

Style rules:
- 1–2 sentences only
- Simple language
- No emojis
- No exclamation overload
- No theological lectures

The message should feel like it arrived at the right moment — and would be
equally okay if the person chose not to act on it.
`;

function buildPrompt(triggerType: string, context: any, firstName: string) {
  const contextBlock = `Context (JSON): ${JSON.stringify(context ?? {})}`;

  switch (triggerType) {
    case 'plan_completion':
      return `
${firstName} has just completed a season of guided devotion.
Offer a gentle word that honors faithfulness and invites continued attentiveness to God.
${contextBlock}
      `;

    case 'friend_invite_nudge':
      return `
${firstName} is walking faithfully but mostly alone.
Offer a gentle invitation toward shared faith, framed as overflow, not obligation.
${contextBlock}
      `;

    case 'welcome_back':
      return `
${firstName} is returning after a long quiet season.
Welcome them without reference to absence, guilt, or productivity.
${contextBlock}
      `;

    case 'inactivity_nudge':
      return `
${firstName} is in a quieter spiritual season while still holding active commitments.
Offer a gentle word that invites presence with God today.
${contextBlock}
      `;

    case 'streak_encouragement':
      return `
${firstName} has been showing steady faithfulness recently.
Offer a gentle word that affirms consistency and invites continued attentiveness to God.
${contextBlock}
      `;

    case 'abandoned_plan':
      return `
${firstName} has had a plan that went quiet for a while.
Offer a gentle word that welcomes them forward without pressure or guilt.
${contextBlock}
      `;

    case 'social_prompt':
      return `
${firstName} has shared faith connections available.
Offer a gentle word that invites connection as a gift, not an obligation.
${contextBlock}
      `;

    default:
      return `
Offer ${firstName} a short, gentle word that invites attentiveness to God’s kingdom today.
${contextBlock}
      `;
  }
}

serve(async () => {
  try {
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
    });
    const { data: triggers, error } = await supabase
      .from('ai_triggers')
      .select(
        `
        id,
        trigger_type,
        generated_message,
        context,
        profiles (
          first_name
        )
      `,
      )
      .is('generated_message', null)
      .eq('sent', false)
      .limit(10);
    if (error || !triggers?.length) {
      return new Response('No triggers', { status: 200 });
    }

    for (const trigger of triggers) {
      const prompt = buildPrompt(
        trigger.trigger_type,
        trigger.context,
        trigger.profiles.first_name,
      );

      const result = await model.generateContent(`
SYSTEM:
${SYSTEM_PROMPT}

USER:
${prompt}
`);

      const message = result.response.text()?.trim();
      console.log(message);

      if (!message) continue;

      await supabase
        .from('ai_triggers')
        .update({
          generated_message: message,
        })
        .eq('id', trigger.id);
    }

    return new Response('AI messages generated', { status: 200 });
  } catch (err) {
    console.error(err);
    return new Response('Error generating AI', { status: 500 });
  }
});
