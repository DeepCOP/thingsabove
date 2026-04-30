import { serve } from 'https://deno.land/std/http/server.ts';
import { GoogleGenerativeAI } from 'https://esm.sh/@google/generative-ai';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const MODEL_NAME = 'gemini-2.5-flash';
const PROMPT_VERSION = 'plan-screening-v1';
const REASON_CODES = [
  'incomplete',
  'irrelevant',
  'nicene_creed_conflict',
  'spam',
  'unsafe_content',
] as const;

type ReasonCode = (typeof REASON_CODES)[number];

type ScreeningDecision = {
  decision: 'pass' | 'reject';
  confidence: number;
  summary: string;
  reason_codes: ReasonCode[];
  scores: {
    completeness_score: number;
    relevance_score: number;
    nicene_creed_alignment_score: number;
    spam_risk: number;
    unsafe_content_risk: number;
  };
};

type DecisionParseResult =
  | {
      decision: ScreeningDecision;
      parseError: null;
    }
  | {
      decision: null;
      parseError: string;
    };

function logInfo(event: string, details: Record<string, unknown> = {}) {
  console.log(
    JSON.stringify({
      scope: 'screen-plan-submission',
      level: 'info',
      event,
      ...details,
    }),
  );
}

function logError(event: string, error: unknown, details: Record<string, unknown> = {}) {
  const normalizedError =
    error instanceof Error
      ? {
          name: error.name,
          message: error.message,
          stack: error.stack,
        }
      : {
          message: String(error),
        };

  console.error(
    JSON.stringify({
      scope: 'screen-plan-submission',
      level: 'error',
      event,
      ...details,
      error: normalizedError,
    }),
  );
}

function previewText(text: string, maxLength = 280) {
  return text.length > maxLength ? `${text.slice(0, maxLength)}...` : text;
}

const SYSTEM_PROMPT = `
You are screening a devotional plan submission for a Christian devotional app.

Your job is to make a binary moderation decision:
- pass: publishable now
- reject: should not be published; the author must edit and resubmit

Evaluate the plan using these dimensions:
1. completeness
2. relevance to a Christian devotional or Bible study app
3. alignment with the Nicene Creed
4. spam
5. unsafe or inappropriate content

Decision rules:
- Return pass only when the submission is complete enough to publish, clearly relevant to the app, not spam, not unsafe, and not in clear conflict with Nicene Christianity.
- Return reject if any one of those conditions fails badly enough that the plan should not be published.

Reject summary guidance:
- When the decision is reject, write the summary for the author in a gentle, encouraging, and constructive tone.
- Briefly explain what to improve without shaming or insulting the author.

Relevance guidance:
-The plan should clearly function as Christian devotional or Bible study content.
-Reject content that is mostly unrelated, generic filler, or not meaningfully devotional or Bible study–oriented.

Nicene Creed guidance:
- Focus on clear contradictions to core Nicene beliefs, not denominational differences.
- Do not reject for secondary disagreements, style differences, or missing theological vocabulary.
- Reject for explicit denial or advocacy against core Nicene beliefs such as:
  - the Father, Son, and Holy Spirit
  - Jesus Christ as truly divine
  - Jesus Christ truly becoming man
  - Christ's death, resurrection, and future return
- If the plan is merely simple, devotional, or not theologically detailed, that alone is not a Nicene conflict.

Completeness guidance:
- Look for a usable title, description, and day content that feels intentionally written.
- Reject if the content is obviously unfinished, placeholder-heavy, incoherent, or too thin to function as a devotional plan.

Safety guidance:
- Reject hateful, abusive, sexually explicit, exploitative, or dangerous content.

Spam guidance:
- Reject obvious keyword stuffing, repetitive filler, promotional copy, or generated nonsense.

Return JSON only in this exact shape:
{
  "decision": "pass",
  "confidence": 0.93,
  "summary": "Short explanation.",
  "reason_codes": [],
  "scores": {
    "completeness_score": 0.95,
    "relevance_score": 0.94,
    "nicene_creed_alignment_score": 0.9,
    "spam_risk": 0.02,
    "unsafe_content_risk": 0.01
  }
}

Rules for the response:
- confidence must be a number from 0 to 1
- all scores must be numbers from 0 to 1
- reason_codes must contain only these values when present:
  - incomplete
  - irrelevant
  - nicene_creed_conflict
  - spam
  - unsafe_content
- scores must include:
  - completeness_score
  - relevance_score
  - nicene_creed_alignment_score
  - spam_risk
  - unsafe_content_risk
- use an empty reason_codes array for pass
- use one or more reason codes for reject
`;

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

function clampScore(value: unknown) {
  if (typeof value !== 'number' || Number.isNaN(value)) return null;
  if (value < 0 || value > 1) return null;
  return Number(value.toFixed(4));
}

function normalizeDecision(value: unknown): DecisionParseResult {
  if (!value || typeof value !== 'object') {
    return { decision: null, parseError: 'Response is not an object.' };
  }

  const record = value as Record<string, unknown>;
  const decision =
    record.decision === 'pass' || record.decision === 'reject' ? record.decision : null;
  const confidence = clampScore(record.confidence);
  const summary =
    typeof record.summary === 'string' && record.summary.trim()
      ? record.summary.trim().slice(0, 500)
      : '';
  const reasonCodes = Array.isArray(record.reason_codes)
    ? record.reason_codes.filter(
        (code): code is ReasonCode =>
          typeof code === 'string' && REASON_CODES.includes(code as ReasonCode),
      )
    : [];

  const scores =
    record.scores && typeof record.scores === 'object'
      ? (record.scores as Record<string, unknown>)
      : null;

  if (!decision) {
    return { decision: null, parseError: 'decision must be pass or reject.' };
  }

  if (confidence === null) {
    return { decision: null, parseError: 'confidence must be a number between 0 and 1.' };
  }

  if (!summary) {
    return { decision: null, parseError: 'summary must be a non-empty string.' };
  }

  if (!scores) {
    return { decision: null, parseError: 'scores must be an object.' };
  }

  const normalizedScores = {
    completeness_score: clampScore(scores.completeness_score),
    relevance_score: clampScore(scores.relevance_score),
    nicene_creed_alignment_score: clampScore(scores.nicene_creed_alignment_score),
    spam_risk: clampScore(scores.spam_risk),
    unsafe_content_risk: clampScore(scores.unsafe_content_risk),
  };

  if (normalizedScores.completeness_score === null) {
    return {
      decision: null,
      parseError: 'scores.completeness_score must be a number between 0 and 1.',
    };
  }

  if (normalizedScores.relevance_score === null) {
    return {
      decision: null,
      parseError: 'scores.relevance_score must be a number between 0 and 1.',
    };
  }

  if (normalizedScores.nicene_creed_alignment_score === null) {
    return {
      decision: null,
      parseError: 'scores.nicene_creed_alignment_score must be a number between 0 and 1.',
    };
  }

  if (normalizedScores.spam_risk === null) {
    return {
      decision: null,
      parseError: 'scores.spam_risk must be a number between 0 and 1.',
    };
  }

  if (normalizedScores.unsafe_content_risk === null) {
    return {
      decision: null,
      parseError: 'scores.unsafe_content_risk must be a number between 0 and 1.',
    };
  }

  if (decision === 'pass' && reasonCodes.length > 0) {
    return { decision: null, parseError: 'Pass decisions must not include reason_codes.' };
  }

  if (decision === 'reject' && reasonCodes.length === 0) {
    return {
      decision: null,
      parseError: 'Reject decisions must include at least one reason code.',
    };
  }

  return {
    decision: {
      decision,
      confidence,
      summary,
      reason_codes: reasonCodes,
      scores: normalizedScores as ScreeningDecision['scores'],
    },
    parseError: null,
  };
}

function parseDecision(rawText: string): DecisionParseResult {
  const jsonText = extractJsonObject(rawText);
  if (!jsonText) {
    return { decision: null, parseError: 'No JSON object found in model response.' };
  }

  try {
    return normalizeDecision(JSON.parse(jsonText));
  } catch (error) {
    return {
      decision: null,
      parseError: error instanceof Error ? error.message : 'JSON parsing failed.',
    };
  }
}

function buildPrompt(submission: Record<string, unknown>) {
  return `
Screen this devotional plan submission.

Submission metadata:
${JSON.stringify(
  {
    submission_id: submission.id,
    plan_id: submission.plan_id,
    submission_number: submission.submission_number,
    title: submission.submitted_title,
    description: submission.submitted_description,
    total_days: submission.submitted_total_days,
    tags: submission.submitted_tags ?? [],
    payload: submission.submitted_payload,
  },
  null,
  2,
)}
`;
}

async function markFailed(
  supabase: ReturnType<typeof createClient>,
  submissionId: string,
  summary: string,
  rawResponse: Record<string, unknown>,
  logContext: Record<string, unknown> = {},
) {
  logInfo('mark_failed_started', {
    submission_id: submissionId,
    summary,
    ...logContext,
  });

  const completedAt = new Date().toISOString();

  const { error: runInsertError } = await supabase.from('plan_screening_runs').insert({
    submission_id: submissionId,
    provider: 'google',
    model: MODEL_NAME,
    prompt_version: PROMPT_VERSION,
    decision: 'error',
    summary,
    reason_codes: [],
    scores: {},
    raw_response: rawResponse,
    completed_at: completedAt,
  });

  if (runInsertError) {
    logError('mark_failed_run_insert_failed', runInsertError, {
      submission_id: submissionId,
      ...logContext,
    });
  } else {
    logInfo('mark_failed_run_inserted', {
      submission_id: submissionId,
      ...logContext,
    });
  }

  const { error: submissionUpdateError } = await supabase
    .from('plan_submissions')
    .update({
      status: 'failed',
      screening_decision: 'error',
      screening_summary: summary,
      screening_reason_codes: [],
      screening_confidence: null,
      screening_completed_at: completedAt,
    })
    .eq('id', submissionId);

  if (submissionUpdateError) {
    logError('mark_failed_submission_update_failed', submissionUpdateError, {
      submission_id: submissionId,
      ...logContext,
    });
    return;
  }

  logInfo('mark_failed_completed', {
    submission_id: submissionId,
    ...logContext,
  });
}

serve(async (req) => {
  const requestId = crypto.randomUUID();
  let supabase: ReturnType<typeof createClient> | null = null;
  let submissionId: string | null = null;

  logInfo('request_received', {
    request_id: requestId,
    method: req.method,
  });

  if (req.method !== 'POST') {
    logInfo('request_rejected_invalid_method', {
      request_id: requestId,
      method: req.method,
    });
    return new Response('Method not allowed', { status: 405 });
  }

  try {
    supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    );

    const googleApiKey = Deno.env.get('GOOGLE_API_KEY');
    if (!googleApiKey) {
      logError('missing_google_api_key', new Error('GOOGLE_API_KEY is not configured'), {
        request_id: requestId,
      });
      return new Response('Missing GOOGLE_API_KEY', { status: 500 });
    }

    const body = await req.json().catch(() => null);
    submissionId = body && typeof body.submission_id === 'string' ? body.submission_id.trim() : '';

    logInfo('request_parsed', {
      request_id: requestId,
      has_body: body !== null,
      submission_id: submissionId || null,
    });

    if (!submissionId) {
      logInfo('request_rejected_missing_submission_id', {
        request_id: requestId,
      });
      return new Response('submission_id is required', { status: 400 });
    }

    const { data: submission, error: submissionError } = await supabase
      .from('plan_submissions')
      .select(
        'id, plan_id, submission_number, status, submitted_title, submitted_description, submitted_tags, submitted_total_days, submitted_payload',
      )
      .eq('id', submissionId)
      .single();

    if (submissionError || !submission) {
      logError('submission_lookup_failed', submissionError ?? new Error('Submission not found'), {
        request_id: requestId,
        submission_id: submissionId,
      });
      return new Response('Submission not found', { status: 404 });
    }

    logInfo('submission_loaded', {
      request_id: requestId,
      submission_id: submissionId,
      plan_id: submission.plan_id,
      submission_number: submission.submission_number,
      current_status: submission.status,
    });

    if (!['submitted', 'failed'].includes(submission.status)) {
      logInfo('submission_not_ready_for_screening', {
        request_id: requestId,
        submission_id: submissionId,
        current_status: submission.status,
      });
      return new Response('Submission is not ready for screening', { status: 409 });
    }

    const { data: transitionedSubmission, error: transitionError } = await supabase
      .from('plan_submissions')
      .update({
        status: 'screening',
        screening_decision: null,
        screening_summary: null,
        screening_reason_codes: [],
        screening_confidence: null,
        screening_started_at: new Date().toISOString(),
        screening_completed_at: null,
        rejected_at: null,
      })
      .eq('id', submissionId)
      .in('status', ['submitted', 'failed'])
      .select(
        'id, plan_id, submission_number, status, submitted_title, submitted_description, submitted_tags, submitted_total_days, submitted_payload',
      )
      .maybeSingle();

    if (transitionError || !transitionedSubmission) {
      logError(
        'submission_transition_to_screening_failed',
        transitionError ?? new Error('Submission is already being screened'),
        {
          request_id: requestId,
          submission_id: submissionId,
        },
      );
      return new Response('Submission is already being screened', { status: 409 });
    }

    logInfo('submission_transitioned_to_screening', {
      request_id: requestId,
      submission_id: submissionId,
      plan_id: transitionedSubmission.plan_id,
      submission_number: transitionedSubmission.submission_number,
      total_days: transitionedSubmission.submitted_total_days,
    });

    const genAI = new GoogleGenerativeAI(googleApiKey);
    const model = genAI.getGenerativeModel({ model: MODEL_NAME });

    const prompt = buildPrompt(transitionedSubmission);
    logInfo('model_request_started', {
      request_id: requestId,
      submission_id: submissionId,
      model: MODEL_NAME,
      prompt_version: PROMPT_VERSION,
      prompt_length: prompt.length,
    });

    const result = await model.generateContent(`
SYSTEM:
${SYSTEM_PROMPT}

USER:
${prompt}
`);

    const rawText = result.response.text()?.trim() ?? '';
    const { decision: parsedDecision, parseError } = rawText
      ? parseDecision(rawText)
      : { decision: null, parseError: 'Model response was empty.' };

    logInfo('model_response_received', {
      request_id: requestId,
      submission_id: submissionId,
      raw_text_length: rawText.length,
      raw_text_preview: rawText ? previewText(rawText) : null,
      parsed: !!parsedDecision,
      parse_error: parseError,
    });

    if (!parsedDecision) {
      await markFailed(
        supabase,
        submissionId,
        'Failed to review the devotional plan submission, please try again later!',
        {
          raw_text: rawText,
          parse_error: parseError,
        },
        {
          request_id: requestId,
        },
      );
      return new Response('Invalid screening response', { status: 500 });
    }

    logInfo('screening_decision_parsed', {
      request_id: requestId,
      submission_id: submissionId,
      decision: parsedDecision.decision,
      confidence: parsedDecision.confidence,
      reason_codes: parsedDecision.reason_codes,
      summary_preview: previewText(parsedDecision.summary),
    });

    const completedAt = new Date().toISOString();

    const { error: runInsertError } = await supabase.from('plan_screening_runs').insert({
      submission_id: submissionId,
      provider: 'google',
      model: MODEL_NAME,
      prompt_version: PROMPT_VERSION,
      decision: parsedDecision.decision,
      confidence: parsedDecision.confidence,
      summary: parsedDecision.summary,
      reason_codes: parsedDecision.reason_codes,
      scores: parsedDecision.scores,
      raw_response: {
        raw_text: rawText,
        parsed_decision: parsedDecision,
      },
      completed_at: completedAt,
    });

    if (runInsertError) {
      logError('screening_run_insert_failed', runInsertError, {
        request_id: requestId,
        submission_id: submissionId,
      });
      await markFailed(
        supabase,
        submissionId,
        'Could not record screening result.',
        {
          raw_text: rawText,
          error: runInsertError.message,
        },
        {
          request_id: requestId,
        },
      );
      return new Response('Could not record screening result', { status: 500 });
    }

    logInfo('screening_run_inserted', {
      request_id: requestId,
      submission_id: submissionId,
      decision: parsedDecision.decision,
    });

    if (parsedDecision.decision === 'reject') {
      const { error: rejectError } = await supabase
        .from('plan_submissions')
        .update({
          status: 'rejected',
          screening_decision: 'reject',
          screening_summary: parsedDecision.summary,
          screening_reason_codes: parsedDecision.reason_codes,
          screening_confidence: parsedDecision.confidence,
          screening_completed_at: completedAt,
          rejected_at: completedAt,
        })
        .eq('id', submissionId);

      if (rejectError) {
        logError('submission_reject_update_failed', rejectError, {
          request_id: requestId,
          submission_id: submissionId,
        });
        return new Response('Could not update rejected submission', { status: 500 });
      }

      logInfo('submission_rejected', {
        request_id: requestId,
        submission_id: submissionId,
        reason_codes: parsedDecision.reason_codes,
      });

      return Response.json({
        submission_id: submissionId,
        status: 'rejected',
        decision: parsedDecision,
      });
    }

    const { error: passUpdateError } = await supabase
      .from('plan_submissions')
      .update({
        screening_decision: 'pass',
        screening_summary: parsedDecision.summary,
        screening_reason_codes: [],
        screening_confidence: parsedDecision.confidence,
        screening_completed_at: completedAt,
      })
      .eq('id', submissionId)
      .eq('status', 'screening');

    if (passUpdateError) {
      logError('submission_pass_update_failed', passUpdateError, {
        request_id: requestId,
        submission_id: submissionId,
      });
      await markFailed(
        supabase,
        submissionId,
        'Could not save pass decision.',
        {
          raw_text: rawText,
          error: passUpdateError.message,
        },
        {
          request_id: requestId,
        },
      );
      return new Response('Could not save pass decision', { status: 500 });
    }

    logInfo('submission_pass_recorded', {
      request_id: requestId,
      submission_id: submissionId,
    });

    logInfo('publish_started', {
      request_id: requestId,
      submission_id: submissionId,
    });
    const { error: publishError } = await supabase.rpc('publish_submitted_devotional_plan', {
      p_submission_id: submissionId,
    });

    if (publishError) {
      logError('publish_failed', publishError, {
        request_id: requestId,
        submission_id: submissionId,
      });
      await supabase
        .from('plan_submissions')
        .update({
          status: 'failed',
          screening_summary: parsedDecision.summary,
          screening_reason_codes: [],
          screening_confidence: parsedDecision.confidence,
          screening_completed_at: completedAt,
        })
        .eq('id', submissionId);

      return new Response(`Publish failed: ${publishError.message}`, { status: 500 });
    }

    logInfo('publish_succeeded', {
      request_id: requestId,
      submission_id: submissionId,
    });

    return Response.json({
      submission_id: submissionId,
      status: 'published',
      decision: parsedDecision,
    });
  } catch (error) {
    logError('unexpected_screening_error', error, {
      request_id: requestId,
      submission_id: submissionId,
    });

    if (supabase && submissionId) {
      const rawError =
        error instanceof Error
          ? {
              name: error.name,
              message: error.message,
              stack: error.stack,
            }
          : {
              message: String(error),
            };

      try {
        await markFailed(
          supabase,
          submissionId,
          'Failed to review the devotional plan submission, please try again later!',
          {
            error: rawError,
          },
          {
            request_id: requestId,
            source_event: 'unexpected_screening_error',
          },
        );
      } catch (markFailedError) {
        logError('unexpected_screening_error_mark_failed_failed', markFailedError, {
          request_id: requestId,
          submission_id: submissionId,
        });
      }
    }

    return new Response('Unexpected screening error', { status: 500 });
  }
});
