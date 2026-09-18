import type { BibleVersionManifestEntry } from './types';

export const isOnlineBibleVersion = (version?: BibleVersionManifestEntry | null) =>
  version?.source === 'youversion' || version?.source === 'esv' || version?.source === 'apiBible';

export const BIBLE_SOURCE_LABELS = {
  offline: 'Downloaded',
  youversion: 'YouVersion',
  esv: 'ESV.org',
  apiBible: 'API.Bible',
} as const;
