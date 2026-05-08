import { useAuth } from '@/src/state/AuthContext';
import * as Application from 'expo-application';
import Constants from 'expo-constants';
import * as Device from 'expo-device';
import { getLocales } from 'expo-localization';
import { useEffect, useRef } from 'react';
import { AppState, AppStateStatus, Platform } from 'react-native';
import { syncProfilePresence } from '../api/queries';

const getPrimaryDeviceLocale = () => {
  const locale = getLocales()[0];

  return {
    deviceLanguageCode: locale?.languageCode ?? null,
    deviceLanguageTag: locale?.languageTag ?? null,
  };
};

export function useLastSeenTracker() {
  const { session } = useAuth();
  const appState = useRef<AppStateStatus>(AppState.currentState);

  useEffect(() => {
    if (!session?.user?.id) return;
    let lastPing = 0;

    const update = async () => {
      const now = Date.now();
      if (now - lastPing < 60_000) return;
      lastPing = now;

      await syncProfilePresence({
        userId: session.user.id,
        appVersion: Application.nativeApplicationVersion ?? Constants.expoConfig?.version ?? null,
        deviceOs: Device.osName ?? Platform.OS,
        deviceOsVersion: Device.osVersion ?? null,
        ...getPrimaryDeviceLocale(),
      });
    };

    // mark active immediately
    update();

    const sub = AppState.addEventListener('change', (nextState) => {
      if (appState.current.match(/inactive|background/) && nextState === 'active') {
        update();
      }
      appState.current = nextState;
    });

    return () => sub.remove();
  }, [session?.user?.id]);
}
