import { getLocales } from 'expo-localization';
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import { resolveAppLanguage, SUPPORTED_LANGUAGES } from './languages';
import enApp from './locales/en/app.json';
import enBible from './locales/en/bible.json';
import enCommunity from './locales/en/community.json';
import enPlans from './locales/en/plans.json';
import zhApp from './locales/zh-Hans/app.json';
import zhBible from './locales/zh-Hans/bible.json';
import zhCommunity from './locales/zh-Hans/community.json';
import zhPlans from './locales/zh-Hans/plans.json';

// Bundle UI translations so language switching also works offline.
void i18n.use(initReactI18next).init({
  resources: {
    en: { app: enApp, bible: enBible, community: enCommunity, plans: enPlans },
    'zh-Hans': { app: zhApp, bible: zhBible, community: zhCommunity, plans: zhPlans },
  },
  lng: resolveAppLanguage(
    'system',
    getLocales().map((locale) => locale.languageTag),
  ),
  fallbackLng: 'en',
  supportedLngs: [...SUPPORTED_LANGUAGES],
  load: 'currentOnly',
  defaultNS: 'app',
  interpolation: { escapeValue: false },
  react: { useSuspense: false },
});

export default i18n;
