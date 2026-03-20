import { serve } from 'https://deno.land/std/http/server.ts';
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SYSTEM_PROMPT = `
You write very short occasional spiritual messages in 1-2 sentences.

These messages are gentle invitations and not commands.
They should sound like wise spiritual companionship: warm, calm, personal, and unforced.

Tone rules:
- Always invitational, never commanding
- Never guilt-based, corrective, or shaming
- Never mention app usage, analytics, or behavior tracking
- Never explain why you know something
- Warm, human, calm, and personal

Content rules:
- Stay rooted in Scripture, prayer, fellowship, church life, generosity, witness, or faithful daily obedience
- Encourage nearness to God, not productivity
- Assume goodwill and spiritual hunger
- When relevant, it is fine to mention church, serving, prayer, or sharing faith

Style rules:
- 1-2 sentences only
- Simple language
- No emojis
- No exclamation overload
- No sermons or theological lectures

The message should feel timely, gentle, and easy to receive.
`;

function buildPrompt(triggerType: string, context: unknown, firstName: string) {
  const name = firstName.trim() || 'Friend';
  const contextBlock = `Context (JSON): ${JSON.stringify(context ?? {})}`;

  switch (triggerType) {
    case 'plan_completion':
      return `
${name} has recently finished a meaningful season of devotion.
Offer a gentle word that honors faithfulness and invites continued nearness to God.
${contextBlock}
      `;

    case 'welcome_back':
      return `
${name} has stepped back into a spiritual rhythm after a quiet season.
Offer a warm welcome into God's presence without mentioning absence, guilt, or lost time.
${contextBlock}
      `;

    case 'inactivity_nudge':
      return `
${name} may need a gentle invitation back toward daily Scripture and prayer.
Offer a calm word that makes room for meeting God today without pressure.
${contextBlock}
      `;

    case 'friend_invite_nudge':
      return `
${name} could invite more people into devotion or Bible reading with them.
Offer a gentle word that frames shared faith as overflow and companionship, not obligation.
${contextBlock}
      `;

    case 'streak_encouragement':
      return `
${name} has been spending consistent time with God.
Offer a gentle word that affirms steady devotion and invites continued attentiveness.
${contextBlock}
      `;

    case 'church_connection_nudge':
      return `
${name} may need encouragement toward being rooted in a faithful local church.
Offer a gentle word about gathered worship, pastoral care, and not walking alone.
${contextBlock}
      `;

    case 'social_prompt':
      return `
${name} may need a stronger spiritual support group.
Offer a gentle word that invites honest fellowship, trusted support, and shared life in Christ.
${contextBlock}
      `;

    case 'abandoned_plan':
      return `
${name} has something spiritually meaningful that went quiet for a while.
Offer a gentle word that welcomes them forward without pressure, guilt, or striving.
${contextBlock}
      `;

    case 'service_prompt':
      return `
${name} could be encouraged toward a quiet act of love this week.
Offer a gentle word that invites generosity, mercy, or practical kindness.
${contextBlock}
      `;

    case 'prayer_prompt':
      return `
${name} could be encouraged to pray for someone this week.
Offer a gentle word that invites intercession, compassion, and carrying others before God.
${contextBlock}
      `;

    case 'gospel_prompt':
      return `
${name} could be encouraged to share the gospel with someone this week.
Offer a gentle word that invites courage, gentleness, and readiness to speak of Jesus in love.
${contextBlock}
      `;

    default:
      return `
Offer ${name} a short, gentle word that invites attentiveness to God's kingdom today.
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
        context,
        priority,
        created_at,
        profiles (
          first_name
        )
      `,
      )
      .is('generated_message', null)
      .eq('sent', false)
      .order('priority', { ascending: true })
      .order('created_at', { ascending: true })
      .limit(10);

    if (error || !triggers?.length) {
      return new Response('No triggers', { status: 200 });
    }

    for (const trigger of triggers) {
      try {
        const firstName = trigger.profiles?.first_name ?? 'Friend';
        const prompt = buildPrompt(trigger.trigger_type, trigger.context, firstName);

        const result = await model.generateContent(`
SYSTEM:
${SYSTEM_PROMPT}

USER:
${prompt}
`);

        const message = result.response.text()?.trim();
        if (!message) continue;

        await supabase
          .from('ai_triggers')
          .update({
            generated_message: message,
          })
          .eq('id', trigger.id);
      } catch (triggerError) {
        console.error('Failed to generate message for trigger', trigger.id, triggerError);
      }
    }

    return new Response('AI messages generated', { status: 200 });
  } catch (err) {
    console.error(err);
    return new Response('Error generating AI', { status: 500 });
  }
});
