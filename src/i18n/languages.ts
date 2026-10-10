export const SUPPORTED_LANGUAGES = [
  'en',
  'es',
  'pt',
  'zh-Hans',
  'zh-Hant',
  'fr',
  'id',
  'ko',
  'fil',
  'sw',
  'hi',
] as const;

export type AppLanguage = (typeof SUPPORTED_LANGUAGES)[number];
export type LanguagePreference = AppLanguage | 'system';

export const isLanguagePreference = (value: unknown): value is LanguagePreference =>
  value === 'system' || SUPPORTED_LANGUAGES.some((language) => language === value);

export function resolveAppLanguage(
  preference: LanguagePreference,
  deviceLanguageTags: readonly string[],
): AppLanguage {
  if (preference !== 'system') return preference;

  const normalized = deviceLanguageTags[0]?.trim().toLowerCase().replace(/_/g, '-') ?? '';
  const subtags = normalized.split('-');
  const language = subtags[0];
  if (language === 'zh') {
    if (subtags.includes('hant')) return 'zh-Hant';
    if (subtags.includes('hans')) return 'zh-Hans';
    if (subtags.some((subtag) => ['tw', 'hk', 'mo'].includes(subtag))) return 'zh-Hant';
    return 'zh-Hans';
  }
  if (language === 'es') return 'es';
  if (language === 'fil' || language === 'tl') return 'fil';
  if (language === 'fr') return 'fr';
  if (language === 'hi') return 'hi';
  if (language === 'id' || language === 'in') return 'id';
  if (language === 'ko') return 'ko';
  if (language === 'pt') return 'pt';
  if (language === 'sw') return 'sw';
  if (language === 'en') return 'en';

  return 'en';
}
