import type { QueryClient } from '@tanstack/react-query';

const planListKeys = new Set([
  'discover_plans',
  'search_plans',
  'related_plans',
  'plans_by_ids',
  'my_saved_plans',
  'my_plan_progress_plans',
  'users_plans_progresses',
]);

function belongsToPlan(value: unknown, planId: string): boolean {
  if (!value || typeof value !== 'object') return false;
  const item = value as { id?: string; plan_id?: string };
  return item.plan_id === planId || item.id === planId;
}

function withoutPlan(data: unknown, planId: string): unknown {
  if (Array.isArray(data)) return data.filter((item) => !belongsToPlan(item, planId));
  if (!data || typeof data !== 'object') return data;
  const infinite = data as { pages?: ({ items?: unknown } | null)[] };
  if (!Array.isArray(infinite.pages)) return data;
  return {
    ...infinite,
    pages: infinite.pages.map((page) =>
      Array.isArray(page?.items)
        ? {
            ...page,
            items: page.items.filter((item) => !belongsToPlan(item, planId)),
          }
        : page,
    ),
  };
}

export async function clearUnavailablePlan(client: QueryClient, planId: string) {
  const progressIds = new Set<string>();
  const queries = client.getQueryCache().getAll();
  for (const query of queries) {
    if (query.queryKey[0] === 'plan_progress' && belongsToPlan(query.state.data, planId)) {
      progressIds.add(String(query.queryKey[1]));
    }
    if (query.queryKey[0] === 'my_plan_progress_plans' && Array.isArray(query.state.data)) {
      for (const row of query.state.data) {
        if (belongsToPlan(row, planId) && row.progress_id) progressIds.add(row.progress_id);
      }
    }
  }

  const contentQueries = queries.filter(({ queryKey, state }) => {
    const [type, id, progressId] = queryKey;
    if (['devotional_days', 'day_item_templates', 'day_comments'].includes(String(type))) {
      return id === planId;
    }
    if (type === 'plan_progress') return progressIds.has(String(id));
    if (type === 'day_items_progress') {
      return (
        progressIds.has(String(progressId)) ||
        (Array.isArray(state.data) && state.data.some((item) => belongsToPlan(item, planId)))
      );
    }
    return false;
  });
  const contentHashes = new Set(contentQueries.map((query) => query.queryHash));

  // Stop older responses from restoring the content we are about to clear.
  // The detail query itself is deliberately excluded: it is fetching null.
  await client.cancelQueries({
    predicate: (query) =>
      planListKeys.has(String(query.queryKey[0])) || contentHashes.has(query.queryHash),
  });

  client.setQueriesData({ queryKey: ['plan', planId] }, null);
  client.setQueriesData(
    { predicate: ({ queryKey }) => planListKeys.has(String(queryKey[0])) },
    (data) => withoutPlan(data, planId),
  );
  for (const query of contentQueries) {
    // Keep active observers attached and give them an explicit empty state.
    client.setQueryData(query.queryKey, query.queryKey[0] === 'plan_progress' ? null : []);
  }

  // A missing published plan can also be a draft or newly private. Let the
  // server decide what remains in the author's management list.
  void client.invalidateQueries({ queryKey: ['my_devotional_plans'] });
  // Resume list requests canceled above, preserving their pagination cursors.
  void client.invalidateQueries({
    predicate: ({ queryKey }) => planListKeys.has(String(queryKey[0])),
  });
}

export async function fetchPlanWithAvailability<T>(
  client: QueryClient,
  planId: string,
  fetchPlan: () => Promise<T | null>,
): Promise<T | null> {
  const plan = await fetchPlan();
  if (plan === null) await clearUnavailablePlan(client, planId);
  return plan;
}
