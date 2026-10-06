import { useAppStore } from '@/src/state/useAppStore';
import { useLocales } from 'expo-localization';
import { type PropsWithChildren, useEffect, useState } from 'react';
import { I18nextProvider } from 'react-i18next';
import i18n from './index';
import { resolveAppLanguage } from './languages';

export default function LanguageProvider({ children }: PropsWithChildren) {
  const preference = useAppStore((state) => state.language);
  const locales = useLocales();
  const language = resolveAppLanguage(
    preference,
    locales.map((locale) => locale.languageTag),
  );
  const [hasHydrated, setHasHydrated] = useState(useAppStore.persist.hasHydrated());
  const [initialized, setInitialized] = useState(false);

  useEffect(() => {
    const unsubscribe = useAppStore.persist.onFinishHydration(() => setHasHydrated(true));
    setHasHydrated(useAppStore.persist.hasHydrated());
    return unsubscribe;
  }, []);

  useEffect(() => {
    if (!hasHydrated) return;
    let active = true;
    void i18n.changeLanguage(language).then(() => {
      if (active) setInitialized(true);
    });
    return () => {
      active = false;
    };
  }, [hasHydrated, language]);

  return <I18nextProvider i18n={i18n}>{initialized ? children : null}</I18nextProvider>;
}
