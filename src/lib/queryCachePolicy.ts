import type { QueryClient } from '@tanstack/react-query';

type ResultState = { status: string; data: unknown };

export function hasCacheableData(data: unknown): boolean {
  if (data == null || data instanceof Error) return false;
  if (typeof data === 'string') return data.trim().length > 0;
  if (Array.isArray(data)) return data.length > 0;
  if (typeof data !== 'object') return true; // Zero counts and false are valid results.

  const result = data as Record<string, unknown>;
  if (Array.isArray(result.pages)) return result.pages.some(hasCacheableData);
  if (Array.isArray(result.items)) return result.items.length > 0;
  return Object.keys(result).length > 0;
}

export function shouldPersistQuery(query: { state: ResultState }): boolean {
  return query.state.status === 'success' && hasCacheableData(query.state.data);
}

export const cacheStaleTime = (duration: number) => (query: { state: ResultState }) =>
  shouldPersistQuery(query) ? duration : 0;

export function installQueryCachePolicy(client: QueryClient) {
  const cache = client.getQueryCache();
  const scheduled = new Set<string>();

  return cache.subscribe((event) => {
    if (event.type !== 'updated' && event.type !== 'observerRemoved') return;
    const query = event.query;
    if (query.getObserversCount() || query.state.fetchStatus !== 'idle') return;
    if (query.state.status === 'pending' || shouldPersistQuery(query)) return;
    if (scheduled.has(query.queryHash)) return;
    scheduled.add(query.queryHash);

    // Like gcTime: 0, wait until observers have had a chance to attach and the
    // fetch has finished scheduling its own GC. Never remove an active result.
    setTimeout(() => {
      scheduled.delete(query.queryHash);
      if (cache.get(query.queryHash) !== query || query.getObserversCount()) return;
      if (query.state.fetchStatus !== 'idle' || query.state.status === 'pending') return;
      if (shouldPersistQuery(query)) return;

      if (query.state.status === 'error' && hasCacheableData(query.state.data)) {
        // A failed refresh must not destroy the last successful offline data.
        // Drop the error state, retain its original age, and require revalidation.
        query.setState({
          status: 'success',
          error: null,
          fetchFailureCount: 0,
          fetchFailureReason: null,
          isInvalidated: true,
        });
      } else {
        cache.remove(query);
      }
    }, 0);
  });
}
