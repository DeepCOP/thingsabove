import type { YouVersionRequest } from '@/src/bible/adapters/youversion';
import type { BibleVersionManifestEntry } from '@/src/bible/types';
import { supabase } from './supabaseClient';

export const YOUVERSION_ENABLED = process.env.EXPO_PUBLIC_YOUVERSION_ENABLED === 'true';
let retryAfter = 0;

const invokeYouVersion = async (
  body: Parameters<YouVersionRequest>[0] | { action: 'catalog'; pageToken?: string },
) => {
  if (Date.now() < retryAfter)
    throw new Error(
      `YouVersion is busy. Try again in ${Math.ceil((retryAfter - Date.now()) / 1000)} seconds.`,
    );
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 20000);
  try {
    const { data, error } = await supabase.functions.invoke('youversion', {
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
          (Number.isFinite(seconds) ? Math.max(1, Math.min(seconds, 86400)) : 60) * 1000;
      }
      throw new Error(
        typeof details?.error === 'string'
          ? details.error
          : 'Unable to connect to YouVersion. Please try again.',
      );
    }
    if (!data || typeof data !== 'object' || !('data' in data)) {
      throw new Error('YouVersion returned an invalid response.');
    }
    return data;
  } finally {
    clearTimeout(timeout);
  }
};

export const requestYouVersion: YouVersionRequest = invokeYouVersion;

export const fetchYouVersionCatalog = async (): Promise<BibleVersionManifestEntry[]> => {
  if (!YOUVERSION_ENABLED) return [];
  const versions = new Map<string, BibleVersionManifestEntry>();
  const pageTokens = new Set<string>();
  let pageToken: string | undefined;
  for (let page = 0; page < 100; page++) {
    const response = await invokeYouVersion({
      action: 'catalog',
      ...(pageToken ? { pageToken } : {}),
    });
    if (!Array.isArray(response.data))
      throw new Error('YouVersion returned an invalid version catalog.');
    for (const entry of response.data) {
      if (
        !entry ||
        typeof entry !== 'object' ||
        !Number.isInteger(entry.id) ||
        entry.id <= 0 ||
        entry.id > 2147483647 ||
        typeof entry.title !== 'string' ||
        !entry.title.trim() ||
        typeof entry.abbreviation !== 'string' ||
        !entry.abbreviation.trim()
      ) {
        throw new Error('YouVersion returned invalid version metadata.');
      }
      const providerBibleId = String(entry.id);
      const id = `YOUVERSION_${providerBibleId}`;
      versions.set(id, {
        id,
        source: 'youversion',
        providerBibleId,
        shortLabel: entry.abbreviation,
        label: entry.title,
        description: 'Read online with YouVersion.',
        language: typeof entry.language_tag === 'string' ? entry.language_tag : undefined,
        isBundled: false,
        sizeBytes: 0,
        localFilename: '',
      });
    }
    const nextPageToken: unknown = response.next_page_token;
    if (nextPageToken == null || nextPageToken === '') return [...versions.values()];
    if (
      typeof nextPageToken !== 'string' ||
      nextPageToken.length > 1024 ||
      /[\u0000-\u001f\u007f]/.test(nextPageToken) ||
      pageTokens.has(nextPageToken)
    ) {
      throw new Error('YouVersion returned an invalid catalog page token.');
    }
    pageToken = nextPageToken;
    pageTokens.add(pageToken);
  }
  throw new Error('YouVersion returned too many catalog pages. Please try again.');
};
