import { parseYouVersionCopyright, type YouVersionRequest } from '@/src/bible/adapters/youversion';
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
        response?.status === 401
          ? 'Sign in to use online Bible versions.'
          : typeof details?.error === 'string'
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

export type YouVersionAttribution = {
  copyright: string;
  attributionUrl: 'https://www.bible.com/';
};

export const fetchYouVersionAttribution = async (
  bibleId: string,
): Promise<YouVersionAttribution> => {
  if (!/^[1-9]\d{0,9}$/.test(bibleId) || Number(bibleId) > 2147483647) {
    throw new Error('Invalid YouVersion Bible identifier.');
  }
  const response = await invokeYouVersion({ action: 'metadata', bibleId });
  const data = response.data;
  if (
    !data ||
    typeof data !== 'object' ||
    data.bibleId !== bibleId ||
    typeof data.copyright !== 'string' ||
    data.copyright.length > 20_000
  ) {
    throw new Error('YouVersion returned invalid attribution metadata.');
  }
  const copyright = parseYouVersionCopyright(data.copyright);
  if (!copyright) throw new Error('YouVersion did not return a copyright notice for this Bible.');
  return { copyright, attributionUrl: 'https://www.bible.com/' };
};

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
      const copyright =
        typeof entry.copyright === 'string' && entry.copyright.length <= 20_000
          ? parseYouVersionCopyright(entry.copyright)
          : undefined;
      versions.set(id, {
        id,
        source: 'youversion',
        providerBibleId,
        shortLabel: entry.abbreviation,
        label: entry.title,
        description: 'Read online with YouVersion.',
        copyright: copyright || undefined,
        attributionUrl: 'https://www.bible.com/',
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
