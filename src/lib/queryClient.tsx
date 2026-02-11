// lib/queryClient.ts
import AsyncStorage from '@react-native-async-storage/async-storage';
import { QueryClient } from '@tanstack/react-query';
import {
  PersistQueryClientProvider,
  persistQueryClient,
} from '@tanstack/react-query-persist-client';

import { createAsyncStoragePersister } from '@tanstack/query-async-storage-persister';
import React from 'react';

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 60 * 24,
      retry: 3,

      refetchOnReconnect: 'always',
    },
    mutations: {
      retry: 3,
      retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000),
    },
  },
});

// create persistor
const asyncStoragePersistor = createAsyncStoragePersister({
  storage: AsyncStorage,
});

// helper react component to wrap app
export function QueryProviderWrapper({ children }: { children: React.ReactNode }) {
  const shouldDehydrateQuery = (query: { state: { status: string; data: unknown } }) => {
    if (query.state.status !== 'success') return false;
    const data = query.state.data;
    if (data == null) return false;
    if (Array.isArray(data) && data.length === 0) return false;
    return true;
  };

  // persist on mount
  React.useEffect(() => {
    persistQueryClient({
      queryClient,
      persister: asyncStoragePersistor,
      maxAge: 1000 * 60 * 60 * 24, // 24 hours
      buster: 'v1', // change to force refetch / reset
      dehydrateOptions: { shouldDehydrateQuery },
    });
  }, []);

  return (
    <PersistQueryClientProvider
      client={queryClient}
      persistOptions={{
        persister: asyncStoragePersistor,
        dehydrateOptions: { shouldDehydrateQuery },
      }}>
      {children}
    </PersistQueryClientProvider>
  );
}
