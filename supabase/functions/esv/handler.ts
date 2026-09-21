import { esvBooks } from '../_shared/esvBooks.ts';
import { getAuthenticatedUserId } from '../_shared/authenticatedUser.ts';
import { checkRateLimit, getClientIp } from '../_shared/rateLimit.ts';

type Dependencies = {
  apiKey: string;
  fetch: typeof fetch;
};

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Expose-Headers': 'Retry-After',
};
const json = (body: unknown, status = 200, headers: Record<string, string> = {}) =>
  new Response(JSON.stringify(body), {
    status,
    headers: {
      ...cors,
      'Content-Type': 'application/json',
      'Cache-Control': 'no-store',
      ...headers,
    },
  });
const isRecord = (value: unknown): value is Record<string, unknown> =>
  Boolean(value) && typeof value === 'object' && !Array.isArray(value);

class ProviderError extends Error {
  constructor(
    message: string,
    readonly status = 502,
    readonly headers: Record<string, string> = {},
  ) {
    super(message);
  }
}

const invalidResponse = () => new ProviderError('ESV returned an invalid response.');

const readJson = async (body: ReadableStream<Uint8Array> | null, limit: number) => {
  const reader = body?.getReader();
  if (!reader) throw new Error('Missing body');
  const decoder = new TextDecoder();
  let bytes = 0;
  let text = '';
  while (true) {
    const chunk = await reader.read();
    if (chunk.done) break;
    bytes += chunk.value.length;
    if (bytes > limit) {
      await reader.cancel();
      throw new RangeError('Body is too large');
    }
    text += decoder.decode(chunk.value, { stream: true });
  }
  text += decoder.decode();
  return JSON.parse(text) as unknown;
};

export const createEsvHandler = (dependencies: Dependencies) => async (req: Request) => {
  if (req.method === 'OPTIONS') return new Response(null, { status: 204, headers: cors });
  if (req.method !== 'POST') return json({ error: 'Use POST for Bible requests.' }, 405);
  let authenticatedUserId: string | null;
  try {
    authenticatedUserId = await getAuthenticatedUserId(req);
  } catch (error) {
    console.error('ESV authentication check failed', error);
    return json({ error: 'Unable to validate your session. Please try again.' }, 503);
  }
  if (!authenticatedUserId) {
    return json({ error: 'Sign in to use online Bible versions.' }, 401);
  }
  try {
    const allowed = await checkRateLimit({
      key: `online-bible:${getClientIp(req) ?? `user:${authenticatedUserId}`}`,
      limit: 30,
      windowSeconds: 60,
    });
    if (!allowed) {
      return json({ error: 'Too many requests.' }, 429, { 'Retry-After': '60' });
    }
  } catch (error) {
    console.error('ESV rate-limit check failed', error);
    return json({ error: 'Unable to validate the request limit. Please try again.' }, 503);
  }
  if (!dependencies.apiKey.trim()) {
    return json({ error: 'ESV has not been configured on the server.' }, 503);
  }

  let body: Record<string, unknown>;
  try {
    const parsed = await readJson(req.body, 4096);
    if (!isRecord(parsed)) throw new Error('Invalid request');
    body = parsed;
  } catch (error) {
    return error instanceof RangeError
      ? json({ error: 'Request body is too large.' }, 413)
      : json({ error: 'A valid JSON request is required.' }, 400);
  }

  if (body.action === 'catalog') {
    return json({
      data: [{ id: 'ESV', name: 'English Standard Version', abbreviation: 'ESV' }],
    });
  }
  if (body.action !== 'chapter') return json({ error: 'Unsupported Bible request.' }, 400);
  const book = esvBooks.find((candidate) => candidate.id === body.bookId);
  const chapterNumber = body.chapterNumber;
  if (
    !book ||
    typeof chapterNumber !== 'number' ||
    !Number.isInteger(chapterNumber) ||
    chapterNumber < 1 ||
    chapterNumber > book.chapterCount
  ) {
    return json({ error: 'Invalid chapter reference.' }, 400);
  }

  // Only a validated, complete chapter can be requested. No client query, URL, or
  // formatting options are forwarded to the provider.
  const url = new URL('https://api.esv.org/v3/passage/html/');
  // In a single-chapter book, e.g. "Philemon 1", the number can mean verse 1.
  url.searchParams.set('q', book.chapterCount === 1 ? book.name : `${book.name} ${chapterNumber}`);
  const options = {
    'include-passage-references': false,
    'include-verse-numbers': true,
    'include-first-verse-numbers': true,
    'include-footnotes': false,
    'include-footnote-body': false,
    'include-headings': false,
    'include-subheadings': false,
    'include-short-copyright': false,
    'include-copyright': true,
    'include-css-link': false,
    'inline-styles': false,
    'wrapping-div': false,
    'include-book-titles': false,
    'include-verse-anchors': false,
    'include-chapter-numbers': false,
    'include-crossrefs': false,
    'include-surrounding-chapters': false,
    'include-surrounding-chapters-below': false,
    'include-audio-link': false,
  };
  for (const [key, value] of Object.entries(options)) url.searchParams.set(key, String(value));

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), 15000);
  try {
    const response = await dependencies.fetch(url, {
      headers: { Authorization: `Token ${dependencies.apiKey}`, Accept: 'application/json' },
      signal: controller.signal,
      redirect: 'error',
    });
    if (!response.ok) {
      if (response.status === 429) {
        const retry = response.headers.get('Retry-After') ?? '60';
        const seconds = /^\d+$/.test(retry) ? Math.max(1, Math.min(Number(retry), 86400)) : 60;
        throw new ProviderError(`ESV is busy. Try again in ${seconds} seconds.`, 429, {
          'Retry-After': String(seconds),
        });
      }
      if (response.status === 403) {
        throw new ProviderError("ESV is not available with the app's current access.", 403);
      }
      if (response.status === 404) throw new ProviderError('This chapter is unavailable.', 404);
      if (response.status === 401) {
        throw new ProviderError('ESV credentials were rejected. Please contact support.');
      }
      throw new ProviderError('ESV is temporarily unavailable. Please try again.');
    }
    let payload: unknown;
    try {
      payload = await readJson(response.body, 2 * 1024 * 1024);
    } catch {
      if (controller.signal.aborted) throw new Error('Timed out');
      throw invalidResponse();
    }
    if (
      !isRecord(payload) ||
      typeof payload.canonical !== 'string' ||
      !payload.canonical.trim() ||
      !Array.isArray(payload.parsed) ||
      payload.parsed.length !== 1 ||
      !Array.isArray(payload.passage_meta) ||
      payload.passage_meta.length !== 1 ||
      !isRecord(payload.passage_meta[0]) ||
      !Array.isArray(payload.passages) ||
      payload.passages.length !== 1 ||
      typeof payload.passages[0] !== 'string' ||
      !payload.passages[0].trim()
    ) {
      throw invalidResponse();
    }
    const range = payload.parsed[0];
    const start = book.ordinal * 1000000 + chapterNumber * 1000 + 1;
    if (
      !Array.isArray(range) ||
      range.length !== 2 ||
      range[0] !== start ||
      !Number.isInteger(range[1]) ||
      range[1] < start ||
      range[1] >= start + 500
    ) {
      throw invalidResponse();
    }
    // Reject truncated or cross-chapter responses before they reach the reader.
    const metadata = payload.passage_meta[0];
    for (const bounds of [metadata.chapter_start, metadata.chapter_end]) {
      if (
        !Array.isArray(bounds) ||
        bounds.length !== 2 ||
        bounds[0] !== range[0] ||
        bounds[1] !== range[1]
      ) {
        throw invalidResponse();
      }
    }
    return json({
      data: {
        bookId: book.id,
        chapterNumber,
        canonical: payload.canonical,
        parsed: payload.parsed,
        passage_meta: payload.passage_meta,
        passages: payload.passages,
      },
    });
  } catch (error) {
    if (error instanceof ProviderError) {
      return json({ error: error.message }, error.status, error.headers);
    }
    return json(
      {
        error: controller.signal.aborted
          ? 'ESV took too long to respond. Please try again.'
          : 'Unable to reach ESV. Please try again.',
      },
      502,
    );
  } finally {
    clearTimeout(timer);
  }
};
