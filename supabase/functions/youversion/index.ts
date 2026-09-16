// eslint-disable-next-line import/no-unresolved -- URL imports are resolved by the Deno runtime.
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { createYouVersionHandler } from './handler.ts';

Deno.serve(
  createYouVersionHandler({
    appKey: Deno.env.get('YOUVERSION_APP_KEY') ?? '',
    allowedBibleIds: (Deno.env.get('YOUVERSION_BIBLE_IDS') ?? '')
      .split(',')
      .map((id) => id.trim())
      .filter(Boolean),
    fetch,
    authorize: async (token) => {
      const url = Deno.env.get('SUPABASE_URL');
      const key =
        Deno.env.get('SUPABASE_ANON_KEY') ??
        Deno.env.get('SUPABASE_PUBLISHABLE_KEY') ??
        Deno.env.get('SB_PUBLISHABLE_KEY') ??
        JSON.parse(Deno.env.get('SUPABASE_PUBLISHABLE_KEYS') ?? '{}').default;
      if (!url || !key) throw new Error('Missing Supabase configuration');
      const client = createClient(url, key, {
        auth: { persistSession: false, autoRefreshToken: false },
        global: {
          fetch: (input, init) => fetch(input, { ...init, signal: AbortSignal.timeout(10000) }),
        },
      });
      const { data, error } = await client.auth.getUser(token);
      return !error && Boolean(data.user);
    },
  }),
);
