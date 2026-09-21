import type { BibleVersionManifestEntry } from './types';

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
