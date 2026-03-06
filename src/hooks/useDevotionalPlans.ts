import {
  fetchPlanById,
  fetchPlans,
  fetchUserPlans,
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

    queryFn: async ({
      pageParam,
    }: {
      pageParam: { created_at: string | null; id: string | null };
    }) => searchPlans({ pageParam, query }),

    initialPageParam: { created_at: null, id: null },
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
    queryFn: async ({
      pageParam,
    }: {
      pageParam: { created_at: string | null; id: string | null };
    }) => fetchPlans({ pageParam }),
    initialPageParam: { created_at: null, id: null },
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });

  return {
    plansQuery,
  };
};

export const useFetchUserPlans = (planId: string[], userId: string) => {
  return useQuery({
    queryKey: ['user_plans', planId, userId],
    enabled: !!planId && planId.length > 0 && !!userId,

    queryFn: async () => await fetchUserPlans(planId),
  });
};
