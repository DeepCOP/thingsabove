import { useAuth } from '@/src/state/AuthContext';
import * as Device from 'expo-device';
import { useEffect, useRef } from 'react';
import { AppState, AppStateStatus, Platform } from 'react-native';
import { syncProfilePresence } from '../api/queries';

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
        deviceOs: Device.osName ?? Platform.OS,
        deviceOsVersion: Device.osVersion ?? null,
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
