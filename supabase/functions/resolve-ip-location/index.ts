import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

type IpWhoIsResponse = {
  success?: boolean;
  city?: string | null;
  region?: string | null;
  country?: string | null;
  country_code?: string | null;
  latitude?: number | null;
  longitude?: number | null;
  timezone?: { id?: string | null } | string | null;
  message?: string;
};

const getClientIp = (req: Request) => {
  const forwardedFor = req.headers.get('x-forwarded-for');

  if (forwardedFor) {
    const firstForwardedIp = forwardedFor
      .split(',')
      .map((value) => value.trim())
      .find((value) => value && value.toLowerCase() !== 'unknown');

    if (firstForwardedIp) {
      return firstForwardedIp;
    }
  }

  return req.headers.get('x-real-ip') ?? req.headers.get('cf-connecting-ip');
};

const buildProviderUrl = (clientIp: string) => {
  const providerUrlTemplate = Deno.env.get('IP_GEOLOOKUP_URL') ?? 'https://ipwho.is/';

  if (providerUrlTemplate.includes('{ip}')) {
    return providerUrlTemplate.replaceAll('{ip}', encodeURIComponent(clientIp));
  }

  return `${providerUrlTemplate.replace(/\/+$/, '')}/${encodeURIComponent(clientIp)}`;
};

const jsonResponse = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      'Content-Type': 'application/json',
    },
  });

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get('authorization') ?? req.headers.get('Authorization');

    if (!authHeader) {
      return jsonResponse({ error: 'Missing authorization header' }, 401);
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? '';
    const supabaseAnonKey =
      Deno.env.get('SUPABASE_ANON_KEY') ?? Deno.env.get('SB_PUBLISHABLE_KEY') ?? '';

    if (!supabaseUrl || !supabaseAnonKey) {
      throw new Error('Missing Supabase edge function environment variables.');
    }

    const supabase = createClient(supabaseUrl, supabaseAnonKey, {
      global: {
        headers: { Authorization: authHeader },
      },
    });

    const token = authHeader.replace(/^Bearer\s+/i, '');
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser(token);

    if (authError || !user) {
      return jsonResponse({ error: 'Unauthorized' }, 401);
    }

    const clientIp = getClientIp(req);

    if (!clientIp) {
      return jsonResponse({ error: 'Client IP not available in forwarded headers' }, 400);
    }

    const providerUrl = buildProviderUrl(clientIp);
    const providerResponse = await fetch(providerUrl, {
      headers: { Accept: 'application/json' },
    });

    if (!providerResponse.ok) {
      throw new Error(`IP geolocation provider returned ${providerResponse.status}.`);
    }

    const payload = (await providerResponse.json()) as IpWhoIsResponse;

    if (payload.success === false) {
      throw new Error(payload.message || 'IP geolocation provider lookup failed.');
    }

    const timezone =
      typeof payload.timezone === 'string' ? payload.timezone : (payload.timezone?.id ?? null);

    return jsonResponse({
      location: {
        source: 'ip',
        latitude: typeof payload.latitude === 'number' ? payload.latitude : null,
        longitude: typeof payload.longitude === 'number' ? payload.longitude : null,
        accuracy_meters: null,
        city: payload.city ?? null,
        region: payload.region ?? null,
        country: payload.country ?? null,
        country_code: payload.country_code ?? null,
        timezone,
        captured_at: new Date().toISOString(),
      },
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unable to resolve IP location.';
    return jsonResponse({ error: message }, 500);
  }
});
