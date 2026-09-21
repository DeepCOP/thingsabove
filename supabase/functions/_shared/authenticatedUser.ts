const getRequiredEnvironmentVariable = (name: string) => {
  const value = Deno.env.get(name)?.trim();
  if (!value) throw new Error(`Missing ${name} for Edge Function authentication.`);
  return value;
};

const isRecord = (value: unknown): value is Record<string, unknown> =>
  Boolean(value) && typeof value === 'object' && !Array.isArray(value);

/** Validates the caller's access token with Supabase Auth and returns its user ID. */
export const getAuthenticatedUserId = async (request: Request) => {
  const authorization = request.headers.get('authorization')?.trim();
  if (!authorization || !/^Bearer\s+\S+$/i.test(authorization)) return null;

  const supabaseUrl = getRequiredEnvironmentVariable('SUPABASE_URL');
  const serviceRoleKey = getRequiredEnvironmentVariable('SUPABASE_SERVICE_ROLE_KEY');
  const response = await fetch(new URL('/auth/v1/user', supabaseUrl), {
    headers: {
      apikey: serviceRoleKey,
      Authorization: authorization,
    },
    signal: AbortSignal.timeout(5_000),
  });

  if (response.status === 401 || response.status === 403) {
    await response.body?.cancel();
    return null;
  }
  if (!response.ok) {
    await response.body?.cancel();
    throw new Error(`Authentication service returned ${response.status}.`);
  }

  const user: unknown = await response.json();
  if (!isRecord(user) || typeof user.id !== 'string' || !user.id.trim()) {
    throw new Error('Authentication service returned invalid user data.');
  }
  return user.id;
};
