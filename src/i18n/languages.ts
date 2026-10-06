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
    const language = tag.toLowerCase().split(/[-_]/)[0];
    if (language === 'zh') return 'zh-Hans';
    if (language === 'en') return 'en';
  }

  return 'en';
}
