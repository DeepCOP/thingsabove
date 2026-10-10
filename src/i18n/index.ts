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
import filApp from './locales/fil/app.json';
import filBible from './locales/fil/bible.json';
import filCommunity from './locales/fil/community.json';
import filPlans from './locales/fil/plans.json';
import frApp from './locales/fr/app.json';
import frBible from './locales/fr/bible.json';
import frCommunity from './locales/fr/community.json';
import frPlans from './locales/fr/plans.json';
import hiApp from './locales/hi/app.json';
import hiBible from './locales/hi/bible.json';
import hiCommunity from './locales/hi/community.json';
import hiPlans from './locales/hi/plans.json';
import idApp from './locales/id/app.json';
import idBible from './locales/id/bible.json';
import idCommunity from './locales/id/community.json';
import idPlans from './locales/id/plans.json';
import koApp from './locales/ko/app.json';
import koBible from './locales/ko/bible.json';
import koCommunity from './locales/ko/community.json';
import koPlans from './locales/ko/plans.json';
import ptApp from './locales/pt/app.json';
import ptBible from './locales/pt/bible.json';
import ptCommunity from './locales/pt/community.json';
import ptPlans from './locales/pt/plans.json';
import swApp from './locales/sw/app.json';
import swBible from './locales/sw/bible.json';
import swCommunity from './locales/sw/community.json';
import swPlans from './locales/sw/plans.json';
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
    fr: { app: frApp, bible: frBible, community: frCommunity, plans: frPlans },
    id: { app: idApp, bible: idBible, community: idCommunity, plans: idPlans },
    ko: { app: koApp, bible: koBible, community: koCommunity, plans: koPlans },
    fil: { app: filApp, bible: filBible, community: filCommunity, plans: filPlans },
    sw: { app: swApp, bible: swBible, community: swCommunity, plans: swPlans },
    hi: { app: hiApp, bible: hiBible, community: hiCommunity, plans: hiPlans },
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
