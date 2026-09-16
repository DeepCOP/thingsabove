import { createOfflineBibleAdapter } from '@/src/bible/adapters/offline';
import { createYouVersionAdapter, type YouVersionRequest } from '@/src/bible/adapters/youversion';
import { createEsvAdapter, type EsvRequest } from '@/src/bible/adapters/esv';
import { createApiBibleAdapter, type ApiBibleRequest } from '@/src/bible/adapters/apiBible';
import type { BibleReadingAdapter } from '@/src/bible/adapters/types';
import type { BibleVersionInstallState, BibleVersionManifestEntry } from '@/src/bible/types';
import { loadBibleVersion } from './bibleVersionService';

/** Selects the reading source; installation remains a separate operation. */
export const createBibleReadingAdapter = (
  version: BibleVersionManifestEntry,
  state?: BibleVersionInstallState,
  requests: { youVersion?: YouVersionRequest; esv?: EsvRequest; apiBible?: ApiBibleRequest } = {},
): BibleReadingAdapter => {
  if (version.source === 'youversion') {
    if (!version.providerBibleId) throw new Error('Missing YouVersion translation identifier.');
    if (!requests.youVersion) throw new Error('YouVersion is not configured.');
    return createYouVersionAdapter(version.id, version.providerBibleId, requests.youVersion);
  }
  if (version.source === 'esv') {
    if (!requests.esv) throw new Error('ESV is not configured.');
    return createEsvAdapter(version.id, requests.esv);
  }
  if (version.source === 'apiBible') {
    if (!version.providerBibleId) throw new Error('Missing API.Bible translation identifier.');
    if (!requests.apiBible) throw new Error('API.Bible is not configured.');
    return createApiBibleAdapter(version.id, version.providerBibleId, requests.apiBible);
  }
  return createOfflineBibleAdapter(version.id, () => loadBibleVersion(version, state));
};
