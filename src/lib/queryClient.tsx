import AsyncStorage from '@react-native-async-storage/async-storage';
import NetInfo from '@react-native-community/netinfo';
import { focusManager, onlineManager } from '@tanstack/react-query';
import { PersistQueryClientProvider } from '@tanstack/react-query-persist-client';
import React, { useEffect, useState } from 'react';
import { AppState, Platform } from 'react-native';
import { useAuth } from '../state/AuthContext';
import { createAccountQueryCacheFactory } from './queryCache';

const createAccountQueryCache = createAccountQueryCacheFactory(AsyncStorage);

function AccountQueryProvider({
  accountId,
  children,
}: {
  accountId: string;
  children: React.ReactNode;
}) {
  const [cache] = useState(() => createAccountQueryCache(accountId));

  useEffect(() => {
    cache.activate();
    return () => {
      void cache.deactivate();
    };
  }, [cache]);

  return (
    <PersistQueryClientProvider client={cache.client} persistOptions={cache.persistOptions}>
      {children}
    </PersistQueryClientProvider>
  );
}

export function QueryProviderWrapper({ children }: { children: React.ReactNode }) {
  const { session, loading } = useAuth();
  const accountId = session?.user.id ?? 'guest';

  useEffect(() => {
    if (Platform.OS === 'web') return;

    onlineManager.setEventListener((setOnline) =>
      NetInfo.addEventListener((state) => {
        setOnline(state.isConnected === true && state.isInternetReachable !== false);
      }),
    );
    focusManager.setFocused(AppState.currentState === 'active');
    const subscription = AppState.addEventListener('change', (state) => {
      focusManager.setFocused(state === 'active');
    });

    return () => {
      subscription.remove();
      onlineManager.setEventListener(() => undefined);
      focusManager.setFocused(undefined);
    };
  }, []);

  // Resolve auth before restoring. Remounting gives each account a fresh client,
  // including when a user signs out and continues browsing as a guest.
  if (loading) return null;

  return (
    <AccountQueryProvider key={accountId} accountId={accountId}>
      {children}
    </AccountQueryProvider>
  );
}
