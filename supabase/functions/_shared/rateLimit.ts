type RateLimitOptions = {
  key: string;
  limit: number;
  windowSeconds: number;
};

const getRequiredEnvironmentVariable = (name: string) => {
  const value = Deno.env.get(name)?.trim();
  if (!value) throw new Error(`Missing ${name} for Edge Function rate limiting.`);
  return value;
};

const hashKey = async (key: string, secret: string) => {
  const encoder = new TextEncoder();
  const signingKey = await crypto.subtle.importKey(
    'raw',
    encoder.encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const digest = await crypto.subtle.sign('HMAC', signingKey, encoder.encode(key));
  return Array.from(new Uint8Array(digest), (byte) => byte.toString(16).padStart(2, '0')).join('');
};

const normalizeIp = (value: string | null) => {
  const candidate = value?.trim();
  if (
    !candidate ||
    candidate.toLowerCase() === 'unknown' ||
    candidate.length > 128 ||
    /[\u0000-\u001f\u007f]/.test(candidate)
  ) {
    return null;
  }
  return candidate;
};

/** Returns the client address forwarded by the Supabase Edge gateway. */
export const getClientIp = (request: Request) => {
  const forwardedFor = request.headers.get('x-forwarded-for');
  if (forwardedFor) {
    for (const value of forwardedFor.split(',')) {
      const candidate = normalizeIp(value);
      if (candidate) return candidate;
    }
  }

  return (
    normalizeIp(request.headers.get('x-real-ip')) ??
    normalizeIp(request.headers.get('cf-connecting-ip'))
  );
};

/**
 * Uses an atomic Postgres RPC so the limit is shared by every Edge Function
 * isolate. The raw client key is hashed before it leaves the function.
 */
export const checkRateLimit = async ({ key, limit, windowSeconds }: RateLimitOptions) => {
  if (!key.trim() || key.length > 256) throw new Error('A valid rate-limit key is required.');
  if (!Number.isInteger(limit) || limit < 1) throw new Error('Rate-limit must be positive.');
  if (!Number.isInteger(windowSeconds) || windowSeconds < 1 || windowSeconds > 86_400) {
    throw new Error('Rate-limit window is invalid.');
  }

  const supabaseUrl = getRequiredEnvironmentVariable('SUPABASE_URL');
  const serviceRoleKey = getRequiredEnvironmentVariable('SUPABASE_SERVICE_ROLE_KEY');
  const endpoint = new URL('/rest/v1/rpc/check_edge_function_rate_limit', supabaseUrl);
  const response = await fetch(endpoint, {
    method: 'POST',
    signal: AbortSignal.timeout(5_000),
    headers: {
      apikey: serviceRoleKey,
      Authorization: `Bearer ${serviceRoleKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      p_key: await hashKey(key, serviceRoleKey),
      p_limit: limit,
      p_window_seconds: windowSeconds,
    }),
  });

  if (!response.ok) {
    await response.body?.cancel();
    throw new Error(`Rate-limit service returned ${response.status}.`);
  }

  const allowed: unknown = await response.json();
  if (typeof allowed !== 'boolean') throw new Error('Rate-limit service returned invalid data.');
  return allowed;
};
