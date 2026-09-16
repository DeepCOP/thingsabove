import { createApiBibleHandler } from './handler.ts';

Deno.serve(
  createApiBibleHandler({
    apiKey: Deno.env.get('API_BIBLE_API_KEY') ?? '',
    allowedBibleIds: (Deno.env.get('API_BIBLE_BIBLE_IDS') ?? '')
      .split(',')
      .map((id) => id.trim())
      .filter(Boolean),
    fetch,
  }),
);
