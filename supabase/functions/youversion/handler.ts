import { getAuthenticatedUserId } from '../_shared/authenticatedUser.ts';
import { checkRateLimit, getClientIp } from '../_shared/rateLimit.ts';

type Dependencies = {
  appKey: string;
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
  typeof value === 'string' && /^[1-9]\d{0,9}$/.test(value) && Number(value) <= 2147483647;

class ProviderError extends Error {
  constructor(
    message: string,
    readonly status = 502,
    readonly headers: Record<string, string> = {},
  ) {
    super(message);
  }
}

const invalidResponse = () => new ProviderError('YouVersion returned an invalid response.');

// Both incoming JSON and provider responses are bounded before they are parsed.
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

export const createYouVersionHandler = (dependencies: Dependencies) => async (req: Request) => {
  if (req.method === 'OPTIONS') return new Response(null, { status: 204, headers: cors });
  if (req.method !== 'POST') return json({ error: 'Use POST for Bible requests.' }, 405);
  let authenticatedUserId: string | null;
  try {
    authenticatedUserId = await getAuthenticatedUserId(req);
  } catch (error) {
    console.error('YouVersion authentication check failed', error);
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
    console.error('YouVersion rate-limit check failed', error);
    return json({ error: 'Unable to validate the request limit. Please try again.' }, 503);
  }
  if (!dependencies.appKey) {
    return json({ error: 'YouVersion has not been configured on the server.' }, 503);
  }
  const allowedIds = dependencies.allowedBibleIds?.map((id) => id.trim()).filter(Boolean) ?? [];
  if (allowedIds.some((id) => !isBibleId(id))) {
    return json({ error: 'YouVersion translations have not been configured correctly.' }, 503);
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

  const url = new URL('https://api.youversion.com/v1/bibles');
  if (body.action === 'catalog') {
    if (
      body.pageToken !== undefined &&
      (typeof body.pageToken !== 'string' ||
        !body.pageToken.length ||
        body.pageToken.length > 1024 ||
        /[\u0000-\u001f\u007f]/.test(body.pageToken))
    ) {
      return json({ error: 'Invalid catalog page token.' }, 400);
    }
    url.searchParams.set('language_ranges[]', '*');
    url.searchParams.set('page_size', '99');
    // Leave all_available disabled: only return translations licensed to this app.
    if (typeof body.pageToken === 'string') url.searchParams.set('page_token', body.pageToken);
  } else if (body.action === 'metadata' || body.action === 'books' || body.action === 'chapter') {
    if (!isBibleId(body.bibleId)) return json({ error: 'Invalid Bible identifier.' }, 400);
    if (allowedIds.length && !allowedIds.includes(body.bibleId)) {
      return json({ error: 'This translation is not enabled for this app.' }, 403);
    }
    url.pathname += `/${body.bibleId}`;
    if (body.action === 'books') {
      url.pathname += '/index';
    } else if (body.action === 'chapter') {
      if (
        typeof body.chapterId !== 'string' ||
        !/^[A-Z0-9]{3}\.[1-9]\d{0,2}$/.test(body.chapterId)
      ) {
        return json({ error: 'Invalid chapter identifier.' }, 400);
      }
      url.pathname += `/passages/${body.chapterId}`;
      url.searchParams.set('format', 'html');
      url.searchParams.set('include_headings', 'false');
      url.searchParams.set('include_notes', 'false');
    }
  } else {
    return json({ error: 'Unsupported Bible request.' }, 400);
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), 15000);
  const requestResource = async (resource: URL): Promise<Record<string, unknown>> => {
    const response = await dependencies.fetch(resource, {
      headers: { 'X-YVP-App-Key': dependencies.appKey, Accept: 'application/json' },
      signal: controller.signal,
      redirect: 'error',
    });
    if (!response.ok) {
      if (response.status === 429) {
        const retry = response.headers.get('Retry-After') ?? '60';
        const seconds = /^\d+$/.test(retry) ? Math.max(1, Math.min(Number(retry), 86400)) : 60;
        throw new ProviderError(`YouVersion is busy. Try again in ${seconds} seconds.`, 429, {
          'Retry-After': String(seconds),
        });
      }
      if (response.status === 403) {
        throw new ProviderError(
          "This translation is not available with the app's YouVersion access.",
          403,
        );
      }
      if (response.status === 404) {
        throw new ProviderError('This Bible or chapter is no longer available.', 404);
      }
      if (response.status === 401) {
        throw new ProviderError('YouVersion credentials were rejected. Please contact support.');
      }
      throw new ProviderError('YouVersion is temporarily unavailable. Please try again.');
    }
    if (response.status === 204 && body.action === 'catalog') return { data: [] };
    try {
      const payload = await readJson(response.body, 8 * 1024 * 1024);
      if (!isRecord(payload)) throw invalidResponse();
      return payload;
    } catch {
      if (controller.signal.aborted) throw new Error('Timed out');
      throw invalidResponse();
    }
  };

  try {
    if (body.action === 'metadata') {
      const metadata = await requestResource(url);
      if (
        String(metadata.id) !== body.bibleId ||
        typeof metadata.copyright !== 'string' ||
        !metadata.copyright.trim()
      ) {
        throw invalidResponse();
      }
      return json({
        data: {
          bibleId: body.bibleId,
          copyright: metadata.copyright,
        },
      });
    }
    if (body.action === 'books') {
      const metadataUrl = new URL(`https://api.youversion.com/v1/bibles/${body.bibleId}`);
      const results = await Promise.allSettled([
        requestResource(url),
        requestResource(metadataUrl),
      ]);
      for (const result of results) {
        if (result.status === 'rejected') throw result.reason;
      }
      const [index, metadata] = results.map((result) =>
        result.status === 'fulfilled' ? result.value : {},
      );
      if (
        !Array.isArray(index.books) ||
        String(metadata.id) !== body.bibleId ||
        typeof metadata.copyright !== 'string' ||
        !metadata.copyright.trim()
      ) {
        throw invalidResponse();
      }
      return json({
        data: {
          books: index.books,
          text_direction: index.text_direction,
          bibleId: body.bibleId,
          copyright: metadata.copyright,
          youversion_deep_link: metadata.youversion_deep_link,
          publisher_url: metadata.publisher_url,
        },
      });
    }
    const payload = await requestResource(url);
    if (body.action === 'catalog') {
      if (
        !Array.isArray(payload.data) ||
        (payload.next_page_token != null && typeof payload.next_page_token !== 'string')
      ) {
        throw invalidResponse();
      }
      if (allowedIds.length) {
        payload.data = payload.data.filter(
          (bible) => isRecord(bible) && allowedIds.includes(String(bible.id)),
        );
        // The provider's count includes versions excluded by the app allowlist.
        delete payload.total_size;
      }
      return json(payload);
    }
    if (payload.id !== body.chapterId || typeof payload.content !== 'string') {
      throw invalidResponse();
    }
    return json({ data: { ...payload, bibleId: body.bibleId } });
  } catch (error) {
    if (error instanceof ProviderError) {
      return json({ error: error.message }, error.status, error.headers);
    }
    return json(
      {
        error: controller.signal.aborted
          ? 'YouVersion took too long to respond. Please try again.'
          : 'Unable to reach YouVersion. Please try again.',
      },
      502,
    );
  } finally {
    clearTimeout(timer);
  }
};
