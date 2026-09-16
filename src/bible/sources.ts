import type { BibleVersionManifestEntry } from './types';

export const isOnlineBibleVersion = (version?: BibleVersionManifestEntry | null) =>
  version?.source === 'youversion' || version?.source === 'esv';

export const BIBLE_SOURCE_LABELS = {
  offline: 'Downloaded',
  youversion: 'YouVersion',
  esv: 'ESV.org',
} as const;
