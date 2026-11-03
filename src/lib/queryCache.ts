import { createAsyncStoragePersister } from '@tanstack/query-async-storage-persister';
import { QueryClient } from '@tanstack/react-query';

export const QUERY_CACHE_MAX_AGE = 24 * 60 * 60 * 1000;
export const COMMUNITY_STALE_TIME = 30 * 1000;

type CacheStorage = {
  getItem: (key: string) => Promise<string | null>;
  setItem: (key: string, value: string) => Promise<unknown>;
  removeItem: (key: string) => Promise<unknown>;
};

// All accounts share one disk snapshot. Serialize access so an old account's
// in-flight write finishes before the next account restores or clears it.
export function createAccountQueryCacheFactory(storage: CacheStorage) {
  let storageQueue: Promise<unknown> = Promise.resolve();

  function enqueue<T>(operation: () => Promise<T>): Promise<T> {
    const result = storageQueue.then(operation);
    storageQueue = result.catch(() => undefined);
    return result;
  }

  return (accountId: string) => {
    let active = true;
    const client = new QueryClient({
      defaultOptions: {
        queries: {
          staleTime: 60 * 1000,
          gcTime: QUERY_CACHE_MAX_AGE,
          retry: 3,
          refetchOnReconnect: 'always',
        },
        mutations: { retry: 0 },
      },
    });
    const storagePersister = createAsyncStoragePersister({
      storage: {
        getItem: (key) => enqueue(async () => (active ? storage.getItem(key) : null)),
        setItem: (key, value) =>
          enqueue(async () => {
            if (active) await storage.setItem(key, value);
          }),
        removeItem: (key) =>
          enqueue(async () => {
            if (active) await storage.removeItem(key);
          }),
      },
    });

    return {
      client,
      persistOptions: {
        // Also discard snapshots from the previous, unscoped cache format.
        buster: `v2:${accountId}`,
        maxAge: QUERY_CACHE_MAX_AGE,
        // There are no mutation defaults to safely resume persisted mutations.
        dehydrateOptions: { shouldDehydrateMutation: () => false },
        persister: {
          ...storagePersister,
          restoreClient: async () => {
            const snapshot = await storagePersister.restoreClient();
            // An account can change while AsyncStorage is still reading.
            return active ? snapshot : undefined;
          },
        },
      },
      activate: () => {
        active = true;
      },
      deactivate: async () => {
        // Block throttled saves and late mutation callbacks before clearing.
        active = false;
        await client.cancelQueries();
        // Cancellation settles fetches before their GC timers are cleared.
        // A Strict Mode effect replay may have reactivated this same client.
        if (!active) client.clear();
      },
    };
  };
}
