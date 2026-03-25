import { serve } from 'https://deno.land/std/http/server.ts';
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const MODEL_NAME = 'gemini-2.5-flash';
const PLANNER_LIMIT = 12;
const PLANNER_REQUEST_DELAY_MS = 1200;

const SYSTEM_PROMPT = `
You are planning one occasional push notification for a Christian devotional app user.

Mission:
- The whole goal of using AI here is to help users pursue God's kingdom in daily life and to keep them meaningfully engaged with the app over time.
- Favor notifications that are spiritually faithful, genuinely helpful, and likely to draw the user back into prayer, Scripture, fellowship, service, or devotional practice.
- Never optimize engagement in a manipulative, fear-based, or merely attention-seeking way.

Your job is to decide:
- whether a notification should be sent in the next 48 hours
- what the notification title should say
- when to schedule it in the user's local time
- what the notification message should say

Scheduling rules:
- Return day_offset as 0, 1, or 2 only
- Return local_hour as an integer from 8 through 20 only
- Prefer natural waking hours and avoid late-night scheduling

Title rules:
- 2-5 words only
- short, natural, and warm
- avoid clickbait, urgency, or shame
- keep it concise enough for a push title

Message rules:
- 1-2 sentences only
- warm, calm, personal, and invitational
- never guilt-based, shaming, or corrective
- never mention analytics, tracking, app usage, or data collection
- keep it concise enough for a push notification
- stay rooted in Scripture, prayer, fellowship, church life, generosity, witness, or faithful daily obedience

Decision rules:
- If no occasional notification should be planned right now, return should_send: false
- Use the user's recent notification history to avoid repetition
- When there is a tradeoff, prefer the option that best serves spiritual good while also encouraging a meaningful return to the app

Return JSON only with this shape:
{
  "should_send": true,
  "title": "Short title here",
  "message": "Short message here.",
  "schedule": {
    "day_offset": 1,
    "local_hour": 19
  },
  "reason": "Short internal explanation."
}

If should_send is false, return:
{
  "should_send": false,
  "reason": "Short internal explanation."
}
`;

type PlannerDecision = {
  should_send: boolean;
  reason: string;
  title?: string;
  message?: string;
  schedule?: {
    day_offset: number;
    local_hour: number;
  };
};

const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

function buildPlannerPrompt(firstName: string, timezone: string, context: unknown) {
  const name = firstName.trim() || 'Friend';

  return `
Plan one occasional notification for ${name}.
User timezone: ${timezone || 'UTC'}

Planning context (JSON):
${JSON.stringify(context ?? {}, null, 2)}
`;
}

function buildPlannerContext(candidate: {
  planning_context?: unknown;
  bio?: string | null;
  year_believed?: number | null;
  year_baptized?: number | null;
}) {
  const planningContext =
    candidate.planning_context && typeof candidate.planning_context === 'object'
      ? (candidate.planning_context as Record<string, unknown>)
      : {};

  return {
    ...planningContext,
    user_profile: {
      bio: candidate.bio ?? null,
      year_believed: candidate.year_believed ?? null,
      year_baptized: candidate.year_baptized ?? null,
    },
  };
}

function extractJsonObject(text: string) {
  const start = text.indexOf('{');
  if (start === -1) return null;

  let depth = 0;
  let inString = false;
  let escaped = false;

  for (let index = start; index < text.length; index += 1) {
    const char = text[index];

    if (inString) {
      if (escaped) {
        escaped = false;
      } else if (char === '\\') {
        escaped = true;
      } else if (char === '"') {
        inString = false;
      }
      continue;
    }

    if (char === '"') {
      inString = true;
      continue;
    }

    if (char === '{') depth += 1;
    if (char === '}') depth -= 1;

    if (depth === 0) {
      return text.slice(start, index + 1);
    }
  }

  return null;
}

function normalizePlannerDecision(value: unknown): PlannerDecision | null {
  if (!value || typeof value !== 'object') return null;

  const record = value as Record<string, unknown>;
  const shouldSend = record.should_send === true;
  const reason =
    typeof record.reason === 'string' && record.reason.trim()
      ? record.reason.trim().slice(0, 240)
      : shouldSend
        ? 'Planner chose a notification for this user.'
        : 'Planner skipped this user for now.';

  if (!shouldSend) {
    return {
      should_send: false,
      reason,
    };
  }

  const title = typeof record.title === 'string' ? record.title.replace(/\s+/g, ' ').trim() : '';
  const message =
    typeof record.message === 'string' ? record.message.replace(/\s+/g, ' ').trim() : '';

  const schedule =
    record.schedule && typeof record.schedule === 'object'
      ? (record.schedule as Record<string, unknown>)
      : null;

  const dayOffset =
    schedule && Number.isInteger(schedule.day_offset) ? Number(schedule.day_offset) : Number.NaN;
  const localHour =
    schedule && Number.isInteger(schedule.local_hour) ? Number(schedule.local_hour) : Number.NaN;

  if (!title || title.length < 4 || title.length > 60) return null;
  if (!message || message.length < 12 || message.length > 240) return null;
  if (!Number.isInteger(dayOffset) || dayOffset < 0 || dayOffset > 2) return null;
  if (!Number.isInteger(localHour) || localHour < 8 || localHour > 20) return null;

  return {
    should_send: true,
    reason,
    title,
    message,
    schedule: {
      day_offset: dayOffset,
      local_hour: localHour,
    },
  };
}

function parsePlannerDecision(rawText: string) {
  const jsonText = extractJsonObject(rawText);
  if (!jsonText) return null;

  try {
    const parsed = JSON.parse(jsonText);
    return normalizePlannerDecision(parsed);
  } catch {
    return null;
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
    const model = genAI.getGenerativeModel({ model: MODEL_NAME });

    const { data: candidates, error: candidatesError } = await supabase.rpc(
      'list_ai_notification_planning_candidates',
      {
        p_limit: PLANNER_LIMIT,
      },
    );

    if (candidatesError) {
      console.error('Failed to load planning candidates', candidatesError);
      return new Response('Failed to load planning candidates', { status: 500 });
    }

    if (!candidates?.length) {
      return new Response('No planning candidates', { status: 200 });
    }

    let plannedCount = 0;

    for (const [index, candidate] of candidates.entries()) {
      try {
        if (index > 0) {
          await sleep(PLANNER_REQUEST_DELAY_MS);
        }

        const firstName =
          typeof candidate.first_name === 'string' && candidate.first_name.trim()
            ? candidate.first_name
            : 'Friend';
        const timezone =
          typeof candidate.timezone === 'string' && candidate.timezone.trim()
            ? candidate.timezone
            : 'UTC';
        const plannerContext = buildPlannerContext(candidate);

        const prompt = buildPlannerPrompt(firstName, timezone, plannerContext);
        const result = await model.generateContent(`
SYSTEM:
${SYSTEM_PROMPT}

USER:
${prompt}
`);

        const rawResponse = result.response.text()?.trim();
        if (!rawResponse) {
          continue;
        }

        const decision = parsePlannerDecision(rawResponse);
        if (!decision) {
          console.error('Planner returned invalid JSON', candidate.user_id, rawResponse);
          continue;
        }

        if (!decision.should_send || !decision.title || !decision.message || !decision.schedule) {
          continue;
        }

        const { data: scheduledFor, error: scheduleError } = await supabase.rpc(
          'resolve_ai_trigger_schedule',
          {
            p_timezone: timezone,
            p_day_offset: decision.schedule.day_offset,
            p_local_hour: decision.schedule.local_hour,
          },
        );

        if (scheduleError || !scheduledFor) {
          console.error('Failed to resolve AI trigger schedule', candidate.user_id, scheduleError);
          continue;
        }

        const nowIso = new Date().toISOString();
        const { error: insertError } = await supabase.from('ai_triggers').insert({
          user_id: candidate.user_id,
          trigger_reason: decision.reason,
          planner_reason: decision.reason,
          context: plannerContext,
          generated_title: decision.title,
          generated_message: decision.message,
          scheduled_for: scheduledFor,
          planner_payload: {
            decision,
            planned_at: nowIso,
            raw_response: rawResponse,
          },
          planning_model: MODEL_NAME,
        });

        if (insertError) {
          console.error('Failed to insert AI notification plan', candidate.user_id, insertError);
          continue;
        }

        plannedCount += 1;
      } catch (candidateError) {
        console.error(
          'Failed to plan notification for candidate',
          candidate.user_id,
          candidateError,
        );
      }
    }

    return new Response(`Planned ${plannedCount}/${candidates.length} notifications`, {
      status: 200,
    });
  } catch (err) {
    console.error(err);
    return new Response('Error planning notifications', { status: 500 });
  }
});
