import { getAuthenticatedUserId } from '../_shared/authenticatedUser.ts';
import { checkRateLimit, getClientIp } from '../_shared/rateLimit.ts';

type Dependencies = {
  apiKey: string;
  allowedBibleIds?: string[];
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
const isBibleId = (value: unknown): value is string =>
  typeof value === 'string' && /^[A-Za-z0-9][A-Za-z0-9-]{0,127}$/.test(value);
const isChapterId = (value: unknown): value is string =>
  typeof value === 'string' && /^[A-Z0-9]{2,12}\.[1-9]\d{0,2}$/.test(value);

class ProviderError extends Error {
  constructor(
    message: string,
    readonly status = 502,
    readonly headers: Record<string, string> = {},
  ) {
    super(message);
  }
}

const invalidResponse = () => new ProviderError('API.Bible returned an invalid response.');

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

export const createApiBibleHandler = (dependencies: Dependencies) => async (req: Request) => {
  if (req.method === 'OPTIONS') return new Response(null, { status: 204, headers: cors });
  if (req.method !== 'POST') return json({ error: 'Use POST for Bible requests.' }, 405);
  let authenticatedUserId: string | null;
  try {
    authenticatedUserId = await getAuthenticatedUserId(req);
  } catch (error) {
    console.error('API.Bible authentication check failed', error);
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
    console.error('API.Bible rate-limit check failed', error);
    return json({ error: 'Unable to validate the request limit. Please try again.' }, 503);
  }
  if (!dependencies.apiKey.trim()) {
    return json({ error: 'API.Bible has not been configured on the server.' }, 503);
  }
  const allowedIds = dependencies.allowedBibleIds?.map((id) => id.trim()).filter(Boolean) ?? [];
  if (allowedIds.some((id) => !isBibleId(id))) {
    return json({ error: 'API.Bible translations have not been configured correctly.' }, 503);
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

  let url: URL;
  if (body.action === 'catalog') {
    url = new URL('https://rest.api.bible/v1/bibles');
    url.searchParams.set('include-full-details', 'true');
  } else if (body.action === 'books') {
    if (!isBibleId(body.bibleId)) return json({ error: 'Invalid Bible identifier.' }, 400);
    if (allowedIds.length && !allowedIds.includes(body.bibleId)) {
      return json({ error: 'This translation is not enabled for this app.' }, 403);
    }
    url = new URL(`https://rest.api.bible/v1/bibles/${encodeURIComponent(body.bibleId)}/books`);
    url.searchParams.set('include-chapters', 'true');
  } else if (body.action === 'chapter') {
    if (!isBibleId(body.bibleId) || !isChapterId(body.chapterId)) {
      return json({ error: 'Invalid chapter reference.' }, 400);
    }
    if (allowedIds.length && !allowedIds.includes(body.bibleId)) {
      return json({ error: 'This translation is not enabled for this app.' }, 403);
    }
    url = new URL(
      `https://rest.api.bible/v1/bibles/${encodeURIComponent(body.bibleId)}/chapters/${encodeURIComponent(body.chapterId)}`,
    );
    url.searchParams.set('content-type', 'html');
    url.searchParams.set('include-notes', 'false');
    url.searchParams.set('include-titles', 'false');
    url.searchParams.set('include-chapter-numbers', 'false');
    url.searchParams.set('include-verse-numbers', 'true');
    url.searchParams.set('include-verse-spans', 'false');
    url.searchParams.set('fums-version', '3');
  } else {
    return json({ error: 'Unsupported Bible request.' }, 400);
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), 15_000);
  try {
    const response = await dependencies.fetch(url, {
      headers: { 'api-key': dependencies.apiKey, Accept: 'application/json' },
      signal: controller.signal,
      redirect: 'error',
    });
    if (!response.ok) {
      if (response.status === 429) {
        const retry = response.headers.get('Retry-After') ?? '60';
        const seconds = /^\d+$/.test(retry) ? Math.max(1, Math.min(Number(retry), 86_400)) : 60;
        throw new ProviderError(`API.Bible is busy. Try again in ${seconds} seconds.`, 429, {
          'Retry-After': String(seconds),
        });
      }
      if (response.status === 403) {
        throw new ProviderError(
          "This translation is not available with the app's API.Bible access.",
          403,
        );
      }
      if (response.status === 404) {
        throw new ProviderError('This Bible or chapter is no longer available.', 404);
      }
      if (response.status === 401) {
        throw new ProviderError('API.Bible credentials were rejected. Please contact support.');
      }
      throw new ProviderError('API.Bible is temporarily unavailable. Please try again.');
    }
    let payload: unknown;
    try {
      payload = await readJson(
        response.body,
        body.action === 'chapter' ? 2 * 1024 * 1024 : 8 * 1024 * 1024,
      );
    } catch {
      if (controller.signal.aborted) throw new Error('Timed out');
      throw invalidResponse();
    }
    if (!isRecord(payload)) throw invalidResponse();
    if (body.action === 'catalog') {
      if (!Array.isArray(payload.data)) throw invalidResponse();
      const data = allowedIds.length
        ? payload.data.filter((entry) => isRecord(entry) && allowedIds.includes(String(entry.id)))
        : payload.data;
      return json({ data });
    }
    if (body.action === 'books') {
      if (!Array.isArray(payload.data)) throw invalidResponse();
      return json({ data: { bibleId: body.bibleId, books: payload.data } });
    }
    const data = isRecord(payload.data) ? payload.data : null;
    const meta = isRecord(payload.meta) ? payload.meta : null;
    if (
      !data ||
      data.id !== body.chapterId ||
      data.bibleId !== body.bibleId ||
      typeof data.bookId !== 'string' ||
      typeof data.number !== 'string' ||
      typeof data.content !== 'string' ||
      !data.content.trim() ||
      typeof data.copyright !== 'string' ||
      !data.copyright.trim()
    ) {
      throw invalidResponse();
    }
    const fumsToken =
      typeof meta?.fumsToken === 'string' && meta.fumsToken.length <= 2048
        ? meta.fumsToken
        : undefined;
    return json({
      data: {
        id: data.id,
        bibleId: data.bibleId,
        bookId: data.bookId,
        number: data.number,
        content: data.content,
        copyright: data.copyright,
        ...(fumsToken ? { fumsToken } : {}),
      },
    });
  } catch (error) {
    if (error instanceof ProviderError) {
      return json({ error: error.message }, error.status, error.headers);
    }
    return json(
      {
        error: controller.signal.aborted
          ? 'API.Bible took too long to respond. Please try again.'
          : 'Unable to reach API.Bible. Please try again.',
      },
      502,
    );
  } finally {
    clearTimeout(timer);
  }
};
