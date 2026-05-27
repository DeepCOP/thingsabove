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
import { useInfiniteQuery, useQuery } from '@tanstack/react-query';
import { useMemo } from 'react';
export const useRelatedPlans = (tags: string[], currentPlanId: string) => {
  return useQuery({
    queryKey: ['related_plans', currentPlanId],
    enabled: !!tags.length && !!currentPlanId,

    queryFn: async () => searchRelatedPlans(currentPlanId, tags),
  });
};

export const useSearchPlans = (query: string) => {
  return useInfiniteQuery({
    enabled: query.trim().length > 0,
    queryKey: ['search_plans', query],
    staleTime: 1000 * 60 * 60 * 24,

    queryFn: async ({ pageParam }) => searchPlans({ pageParam, query }),

    initialPageParam: null as PlanCursor | null,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });
};

export const useFetchDevotionalPlanById = (id: string) => {
  return useQuery({
    queryKey: ['plan', id],
    enabled: !!id,
    queryFn: async () => fetchPlanById(id),
  });
};

export const usePlanTags = () => {
  return useQuery({
    queryKey: ['plan_tags'],
    staleTime: 1000 * 60 * 60 * 24,
    queryFn: fetchPlanTags,
  });
};

export const usePlans = (selectedTags: string[] = []) => {
  const normalizedSelectedTags = useMemo(
    () =>
      Array.from(new Set(selectedTags.map((tag) => tag.trim()).filter(Boolean))).sort((a, b) =>
        a.localeCompare(b),
      ),
    [selectedTags],
  );

  const plansQuery = useInfiniteQuery({
    queryKey: ['discover_plans', normalizedSelectedTags],
    staleTime: 1000 * 60 * 60 * 24,
    queryFn: async ({ pageParam }) => fetchPlans({ pageParam, tags: normalizedSelectedTags }),
    initialPageParam: null as PlanCursor | null,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });

  return {
    plansQuery,
  };
};

export const useFetchPlansByIds = (planIds: string[]) => {
  return useQuery({
    queryKey: ['plans_by_ids', planIds],
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
