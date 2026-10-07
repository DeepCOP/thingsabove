export const SUPPORTED_LANGUAGES = ['en', 'zh-Hans'] as const;

export type AppLanguage = (typeof SUPPORTED_LANGUAGES)[number];
export type LanguagePreference = AppLanguage | 'system';

export const isLanguagePreference = (value: unknown): value is LanguagePreference =>
  value === 'system' || value === 'en' || value === 'zh-Hans';

export function resolveAppLanguage(
  preference: LanguagePreference,
  deviceLanguageTags: readonly string[],
): AppLanguage {
  if (preference !== 'system') return preference;

  for (const tag of deviceLanguageTags) {
    const normalized = tag.toLowerCase().replace(/_/g, '-');
    const language = normalized.split('-')[0];
    if (language === 'zh') {
      if (/-(hant|tw|hk|mo)(-|$)/.test(normalized)) continue;
      return 'zh-Hans';
    }
    if (language === 'en') return 'en';
  }

  return 'en';
}
