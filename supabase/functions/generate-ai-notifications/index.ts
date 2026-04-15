import { serve } from 'https://deno.land/std/http/server.ts';
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const MODEL_NAME = 'gemini-2.5-flash';
const PLANNER_LIMIT = 12;
const PLANNER_REQUEST_DELAY_MS = 1200;

const ALLOWED_CATEGORIES = [
  'invite_friends',
  'church_attendance',
  'daily_devotion',
  'spiritual_support',
  'good_deed',
  'prayer_for_someone',
  'share_gospel',
  'encouragement',
  'serve_at_church',
  'cheering_up_with_humor',
] as const;

type PlannerCategory = (typeof ALLOWED_CATEGORIES)[number];

const SYSTEM_PROMPT = `
You are planning one occasional push notification for a Christian devotional app user.

Mission:
- The whole goal of using AI here is to help users pursue God's kingdom in daily life and to keep them meaningfully engaged with the app over time.
- Favor notifications that are spiritually faithful, genuinely helpful, and likely to draw the user back into prayer, Scripture, fellowship, service, or devotional practice.
- Never optimize engagement in a manipulative, fear-based, or merely attention-seeking way.

Your job is to decide:
- whether a notification should be sent in the next 48 hours
- which ministry category it belongs to
- what the notification title should say
- when to schedule it in the user's local time
- what the notification message should say

Allowed categories:
- invite_friends: invite the user to invite more friends to join them in devotions or Bible reading by using the app
- church_attendance: encourage regular church attendance or reconnecting with a faithful local church
- serve_at_church: encourage the user to serve in their local church with humility, faithfulness, and love
- daily_devotion: encourage daily devotions or Bible reading to spend time with God
- spiritual_support: encourage the user to build or lean on a healthy spiritual support group
- encouragement: encourage the user with hopeful, Scripture-rooted reassurance when they may need strength, peace, or perseverance
- good_deed: encourage the user to do some good deed this week
- prayer_for_someone: encourage the user to pray for someone this week
- share_gospel: encourage the user to share the gospel with someone this week
- cheering_up_with_humor: offer light, clean, warm humor that cheers the user up without being flippant, irreverent, or insensitive

Category rules:
- Every planned notification must fit exactly one allowed category
- Choose the category that best matches the user's context and recent history
- Use the user's history to judge whether daily_devotion is especially needed
- Do not repeatedly use the same category for the same user unless the context strongly justifies it
- For church_attendance or spiritual_support, do not falsely imply the app knows what happened offline; use invitational wording unless the context clearly supports a stronger inference
- For serve_at_church, do not falsely imply the app knows the user's current level of church involvement; use invitational wording
- For cheering_up_with_humor, keep the humor gentle and wholesome; never mock, trivialize suffering, or undermine spiritual seriousness

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
- 2-3 short sentences only
- warm, calm, personal, and invitational
- never guilt-based, shaming, or corrective
- never mention analytics, tracking, app usage, or data collection
- keep it concise enough for a push notification
- stay rooted in Scripture, prayer, fellowship, church life, generosity, witness, or faithful daily obedience
- Every message must first speak directly to the user, then include a related Bible verse excerpt or faithful paraphrase with its reference
- Format the message as: main message first, then a newline, then the verse on its own line in quotes with the reference
- The main message should lead, and the verse should support or reinforce that message
- Keep the verse connected to the invitation, encouragement, or challenge you are giving
- Example shape only: "Take a few quiet minutes with God today and let Him steady your heart.\n\"Be still, and know that I am God\" (Psalm 46:10)."

Decision rules:
- If no occasional notification should be planned right now, return should_send: false
- Use the user's recent notification history to avoid repetition
- When there is a tradeoff, prefer the option that best serves spiritual good while also encouraging a meaningful return to the app

Return JSON only with this shape:
{
  "should_send": true,
  "category": "daily_devotion",
  "title": "Short title here",
  "message": "Warm message here.\n\"Related verse here\" (Reference here).",
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
  category?: PlannerCategory;
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
  const category =
    typeof record.category === 'string' &&
    ALLOWED_CATEGORIES.includes(record.category as PlannerCategory)
      ? (record.category as PlannerCategory)
      : null;

  const schedule =
    record.schedule && typeof record.schedule === 'object'
      ? (record.schedule as Record<string, unknown>)
      : null;

  const dayOffset =
    schedule && Number.isInteger(schedule.day_offset) ? Number(schedule.day_offset) : Number.NaN;
  const localHour =
    schedule && Number.isInteger(schedule.local_hour) ? Number(schedule.local_hour) : Number.NaN;

  if (!category) return null;
  if (!title || title.length < 4 || title.length > 60) return null;
  if (!message || message.length < 12 || message.length > 320) return null;
  if (!Number.isInteger(dayOffset) || dayOffset < 0 || dayOffset > 2) return null;
  if (!Number.isInteger(localHour) || localHour < 8 || localHour > 20) return null;

  return {
    should_send: true,
    reason,
    category,
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

        if (
          !decision.should_send ||
          !decision.category ||
          !decision.title ||
          !decision.message ||
          !decision.schedule
        ) {
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

        const { error: insertError } = await supabase.from('ai_triggers').insert({
          user_id: candidate.user_id,
          trigger_reason: decision.reason,
          planner_category: decision.category,
          context: plannerContext,
          generated_title: decision.title,
          generated_message: decision.message,
          scheduled_for: scheduledFor,
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
