import type { BibleVersionManifestEntry } from './types';
import type { TFunction } from 'i18next';

/** Translate UI errors without modifying persisted errors or provider responses. */
export const localizeBibleError = (
  message: string | null | undefined,
  t: TFunction<'bible'>,
  language?: string,
  fallback: 'loadError' | 'actionError' = 'loadError',
) => {
  if (!message) return '';
  if (!language || language.startsWith('en')) return message;
  if (message.includes('Please download it again.')) return t('downloadError');
  if (message === 'Sign in to use online Bible versions.') return t('signInError');
  if (message === 'This translation is available for online reading only.')
    return t('onlineOnlyError');
  if (message === 'This version is being removed. Please try again.')
    return t('removalInProgressError');
  if (message === 'Wait for this version to finish downloading before removing it.')
    return t('downloadInProgressError');
  const versionError = message.match(
    /^(.+) is (not available right now|not installed yet|missing from device storage)\.$/,
  );
  if (versionError) {
    const key =
      versionError[2] === 'not available right now'
        ? 'notAvailableError'
        : versionError[2] === 'not installed yet'
          ? 'notInstalledError'
          : 'missingFileError';
    return t(key, { version: versionError[1] });
  }
  const busyError = message.match(
    /^(YouVersion|ESV|API\.Bible) is busy\. Try again in (\d+) seconds\.$/,
  );
  if (busyError) return t('providerBusyError', { provider: busyError[1], seconds: busyError[2] });
  const connectionError = message.match(
    /^Unable to connect to (YouVersion|ESV|API\.Bible)\. Please try again\.$/,
  );
  if (connectionError) return t('providerConnectionError', { provider: connectionError[1] });
  const providerError = message.match(/^(YouVersion|ESV|API\.Bible) (?:returned|did not return)/);
  if (providerError) return t('providerResponseError', { provider: providerError[1] });
  if (message === 'Unable to download this version.') return t('downloadError');
  return t(fallback);
};

export const getVersionLanguage = (version: BibleVersionManifestEntry) => {
  const value = version.language?.trim() ?? '';
  if (/^(en|eng)(-|$)|english/i.test(value) || version.id === 'KJV')
    return { key: 'en', label: 'English' };
  if (
    /^(zh|zho|cmn|yue)(-|$)|chinese|中文/i.test(value) ||
    /chinese|中文/i.test(version.label) ||
    /^CUV/i.test(version.shortLabel)
  )
    return { key: 'zh', label: '中文 · Chinese' };
  if (/^(es|spa)(-|$)|spanish|español/i.test(value)) return { key: 'es', label: 'Spanish' };
  return { key: value.toLowerCase() || 'unspecified', label: value || 'Other languages' };
};

const searchable = (text: string) =>
  text
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '');

export const matchesVersionSearch = (version: BibleVersionManifestEntry, query: string) => {
  const versionLanguage = getVersionLanguage(version);
  const text = searchable(
    `${version.shortLabel} ${version.label} ${version.language ?? ''} ${versionLanguage.label}`,
  );
  return searchable(query)
    .trim()
    .split(/\s+/)
    .every((word) => text.includes(word));
};
