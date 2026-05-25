import {
  fetchMyDevotionalPlans,
  fetchPlanById,
  fetchPlans,
  fetchUserPlans,
  type PlanCursor,
  searchPlans,
  searchRelatedPlans,
} from '@/src/api/queries';
import { useInfiniteQuery, useQuery } from '@tanstack/react-query';
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
export const usePlans = () => {
  const plansQuery = useInfiniteQuery({
    queryKey: ['discover_plans'],
    staleTime: 1000 * 60 * 60 * 24,
    queryFn: async ({ pageParam }) => fetchPlans({ pageParam }),
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
