import { getLocales } from 'expo-localization';
import { createInstance } from 'i18next';
import { initReactI18next } from 'react-i18next';
import { resolveAppLanguage, SUPPORTED_LANGUAGES } from './languages';
import enApp from './locales/en/app.json';
import enBible from './locales/en/bible.json';
import enCommunity from './locales/en/community.json';
import enPlans from './locales/en/plans.json';
import esApp from './locales/es/app.json';
import esBible from './locales/es/bible.json';
import esCommunity from './locales/es/community.json';
import esPlans from './locales/es/plans.json';
import ptApp from './locales/pt/app.json';
import ptBible from './locales/pt/bible.json';
import ptCommunity from './locales/pt/community.json';
import ptPlans from './locales/pt/plans.json';
import zhApp from './locales/zh-Hans/app.json';
import zhBible from './locales/zh-Hans/bible.json';
import zhCommunity from './locales/zh-Hans/community.json';
import zhPlans from './locales/zh-Hans/plans.json';
import zhHantApp from './locales/zh-Hant/app.json';
import zhHantBible from './locales/zh-Hant/bible.json';
import zhHantCommunity from './locales/zh-Hant/community.json';
import zhHantPlans from './locales/zh-Hant/plans.json';

const i18n = createInstance();
void i18n.use(initReactI18next).init({
  resources: {
    en: { app: enApp, bible: enBible, community: enCommunity, plans: enPlans },
    es: { app: esApp, bible: esBible, community: esCommunity, plans: esPlans },
    pt: { app: ptApp, bible: ptBible, community: ptCommunity, plans: ptPlans },
    'zh-Hans': { app: zhApp, bible: zhBible, community: zhCommunity, plans: zhPlans },
    'zh-Hant': {
      app: zhHantApp,
      bible: zhHantBible,
      community: zhHantCommunity,
      plans: zhHantPlans,
    },
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
