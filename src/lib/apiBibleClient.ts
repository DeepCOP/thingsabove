import type { ApiBibleRequest } from '@/src/bible/adapters/apiBible';
import type { BibleVersionManifestEntry } from '@/src/bible/types';
import { supabase } from './supabaseClient';

export const API_BIBLE_ENABLED = process.env.EXPO_PUBLIC_API_BIBLE_ENABLED === 'true';
let retryAfter = 0;

const invokeApiBible = async (body: Parameters<ApiBibleRequest>[0] | { action: 'catalog' }) => {
  if (Date.now() < retryAfter) {
    throw new Error(
      `API.Bible is busy. Try again in ${Math.ceil((retryAfter - Date.now()) / 1000)} seconds.`,
    );
  }
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 20_000);
  try {
    const { data, error } = await supabase.functions.invoke('api-bible', {
      body,
      signal: controller.signal,
    });
    if (error) {
      const response =
        'context' in error && error.context instanceof Response ? error.context : null;
      const details = response
        ? await response
            .clone()
            .json()
            .catch(() => null)
        : null;
      if (response?.status === 429) {
        const seconds = Number(response.headers.get('Retry-After') ?? 60);
        retryAfter =
          Date.now() +
          (Number.isFinite(seconds) ? Math.max(1, Math.min(seconds, 86_400)) : 60) * 1000;
      }
      throw new Error(
        response?.status === 401
          ? 'Sign in to use online Bible versions.'
          : typeof details?.error === 'string'
            ? details.error
            : 'Unable to connect to API.Bible. Please try again.',
      );
    }
    if (!data || typeof data !== 'object' || !('data' in data)) {
      throw new Error('API.Bible returned an invalid response.');
    }
    return data;
  } finally {
    clearTimeout(timeout);
  }
};

const record = (value: unknown): Record<string, unknown> | null =>
  value && typeof value === 'object' && !Array.isArray(value)
    ? (value as Record<string, unknown>)
    : null;
const providerId = (value: unknown) =>
  typeof value === 'string' && /^[A-Za-z0-9][A-Za-z0-9-]{0,127}$/.test(value) ? value : null;
const shortText = (value: unknown, maxLength = 200) =>
  typeof value === 'string' && value.trim() && value.trim().length <= maxLength
    ? value.trim()
    : null;

export const requestApiBible: ApiBibleRequest = invokeApiBible;

export const fetchApiBibleCatalog = async (): Promise<BibleVersionManifestEntry[]> => {
  if (!API_BIBLE_ENABLED) return [];
  const response = await invokeApiBible({ action: 'catalog' });
  if (!Array.isArray(response.data))
    throw new Error('API.Bible returned an invalid version catalog.');

  const versions = new Map<string, BibleVersionManifestEntry>();
  for (const value of response.data) {
    const entry = record(value);
    const id = providerId(entry?.id);
    const label = shortText(entry?.name) ?? shortText(entry?.nameLocal);
    const shortLabel =
      shortText(entry?.abbreviation, 50) ?? shortText(entry?.abbreviationLocal, 50);
    const language = record(entry?.language);
    const languageName = shortText(language?.name, 100) ?? shortText(language?.nameLocal, 100);
    if (!id || !label || !shortLabel) {
      throw new Error('API.Bible returned invalid version metadata.');
    }
    const appId = `API_BIBLE_${id.toUpperCase()}`;
    versions.set(appId, {
      id: appId,
      source: 'apiBible',
      providerBibleId: id,
      shortLabel,
      label,
      description: shortText(entry?.description, 500) ?? 'Read online with API.Bible.',
      language: languageName ?? undefined,
      isBundled: false,
      sizeBytes: 0,
      localFilename: '',
    });
  }
  return [...versions.values()];
};
