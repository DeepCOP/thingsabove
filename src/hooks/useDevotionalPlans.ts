import {
  fetchMyDevotionalPlans,
  fetchPlanTags,
  fetchPlanById,
  fetchPlans,
  fetchUserPlans,
  type PlanCursor,
  searchPlans,
  searchRelatedPlans,
} from '@/src/api/queries';
import { useInfiniteQuery, useQuery, useQueryClient } from '@tanstack/react-query';
import { useMemo } from 'react';
import { useAuth } from '../state/AuthContext';
import { planDetailKey } from '../lib/queryKeys';
import { cacheStaleTime } from '../lib/queryCachePolicy';
import { fetchPlanWithAvailability } from '../lib/unavailablePlan';
import { useRefreshQueryOnFocus } from './useRefreshQueryOnFocus';
export const useRelatedPlans = (tags: string[], currentPlanId: string) => {
  const { session } = useAuth();
  return useQuery({
    queryKey: [
      'related_plans',
      currentPlanId,
      [...new Set(tags)].sort(),
      session?.user.id ?? 'guest',
    ],
    enabled: !!tags.length && !!currentPlanId,

    queryFn: async () => searchRelatedPlans(currentPlanId, tags),
  });
};

export const useSearchPlans = (query: string) => {
  const { session } = useAuth();
  return useInfiniteQuery({
    enabled: query.trim().length > 0,
    queryKey: ['search_plans', query, session?.user.id ?? 'guest'],
    staleTime: cacheStaleTime(1000 * 60 * 60 * 24),

    queryFn: async ({ pageParam }) => searchPlans({ pageParam, query }),

    initialPageParam: null as PlanCursor | null,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });
};

export const useFetchDevotionalPlanById = (id: string) => {
  const { session } = useAuth();
  const client = useQueryClient();
  const userId = session?.user.id;
  const queryKey = useMemo(() => planDetailKey(id, userId), [id, userId]);
  const query = useQuery({
    queryKey,
    enabled: !!id,
    refetchOnMount: 'always',
    queryFn: () => fetchPlanWithAvailability(client, id, () => fetchPlanById(id)),
  });
  useRefreshQueryOnFocus(queryKey);
  return query;
};

export const usePlanTags = () => {
  return useQuery({
    queryKey: ['plan_tags'],
    staleTime: cacheStaleTime(1000 * 60 * 60 * 24),
    queryFn: fetchPlanTags,
  });
};

export const usePlans = (selectedTags: string[] = []) => {
  const { session } = useAuth();
  const normalizedSelectedTags = useMemo(
    () =>
      Array.from(new Set(selectedTags.map((tag) => tag.trim().toLowerCase()).filter(Boolean))).sort(
        (a, b) => a.localeCompare(b),
      ),
    [selectedTags],
  );

  const plansQuery = useInfiniteQuery({
    queryKey: ['discover_plans', normalizedSelectedTags, session?.user.id ?? 'guest'],
    staleTime: cacheStaleTime(1000 * 60 * 60 * 24),
    queryFn: async ({ pageParam }) => fetchPlans({ pageParam, tags: normalizedSelectedTags }),
    initialPageParam: null as PlanCursor | null,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });

  return {
    plansQuery,
  };
};

export const useFetchPlansByIds = (planIds: string[]) => {
  const { session } = useAuth();
  return useQuery({
    queryKey: ['plans_by_ids', planIds, session?.user.id ?? 'guest'],
    enabled: planIds.length > 0,
    queryFn: async () => await fetchUserPlans(planIds),
  });
};

export const useMyDevotionalPlans = (userId?: string) => {
  return useQuery({
    queryKey: ['my_devotional_plans', userId],
    enabled: !!userId,
    queryFn: async () => fetchMyDevotionalPlans(),
  });
};
