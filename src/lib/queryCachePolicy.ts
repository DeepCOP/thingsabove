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

export function shouldPersistQuery(query: {
  state: { data: unknown; dataUpdatedAt: number };
}): boolean {
  return query.state.dataUpdatedAt > 0 && hasCacheableData(query.state.data);
}

export const cacheStaleTime = (duration: number) => (query: { state: ResultState }) =>
  query.state.status === 'success' && !hasCacheableData(query.state.data) ? 0 : duration;
