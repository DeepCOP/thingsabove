import { createYouVersionHandler } from './handler.ts';

Deno.serve(
  createYouVersionHandler({
    appKey: Deno.env.get('YOUVERSION_APP_KEY') ?? '',
    allowedBibleIds: (Deno.env.get('YOUVERSION_BIBLE_IDS') ?? '')
      .split(',')
      .map((id) => id.trim())
      .filter(Boolean),
    fetch,
  }),
);
