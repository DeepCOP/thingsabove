import type { EsvRequest } from '@/src/bible/adapters/esv';
import type { BibleVersionManifestEntry } from '@/src/bible/types';
import { supabase } from './supabaseClient';

export const ESV_ENABLED = process.env.EXPO_PUBLIC_ESV_ENABLED === 'true';
const ESV_COPYRIGHT =
  'Scripture quotations are from the ESV\u00ae Bible (The Holy Bible, English Standard Version\u00ae), \u00a9 2001 by Crossway, a publishing ministry of Good News Publishers. Used by permission. All rights reserved.';
let retryAfter = 0;

const invokeEsv = async (body: Parameters<EsvRequest>[0] | { action: 'catalog' }) => {
  if (Date.now() < retryAfter)
    throw new Error(
      `ESV is busy. Try again in ${Math.ceil((retryAfter - Date.now()) / 1000)} seconds.`,
    );
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 20000);
  try {
    const { data, error } = await supabase.functions.invoke('esv', {
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
            : 'Unable to connect to ESV. Please try again.',
      );
    }
    if (!data || typeof data !== 'object' || !('data' in data)) {
      throw new Error('ESV returned an invalid response.');
    }
    return data;
  } finally {
    clearTimeout(timeout);
  }
};

export const requestEsv: EsvRequest = invokeEsv;

export const fetchEsvCatalog = async (): Promise<BibleVersionManifestEntry[]> => {
  if (!ESV_ENABLED) return [];
  const response = await invokeEsv({ action: 'catalog' });
  if (
    !Array.isArray(response.data) ||
    response.data.length !== 1 ||
    response.data[0]?.id !== 'ESV' ||
    response.data[0]?.abbreviation !== 'ESV' ||
    typeof response.data[0]?.name !== 'string' ||
    !response.data[0].name.trim()
  ) {
    throw new Error('ESV returned an invalid version catalog.');
  }
  return [
    {
      // Distinct from ESV translations offered by other providers or downloaded files.
      id: 'ESV_API',
      source: 'esv',
      providerBibleId: 'ESV',
      shortLabel: 'ESV',
      label: response.data[0].name,
      description: 'Read online with ESV.org.',
      copyright: ESV_COPYRIGHT,
      attributionUrl: 'https://www.esv.org/',
      language: 'English',
      isBundled: false,
      sizeBytes: 0,
      localFilename: '',
    },
  ];
};
