import { createEsvHandler } from './handler.ts';

Deno.serve(
  createEsvHandler({
    apiKey: Deno.env.get('ESV_API_KEY') ?? '',
    fetch,
  }),
);
