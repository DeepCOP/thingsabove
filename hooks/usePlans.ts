// hooks/usePlans.ts
import { fetchPlanById, fetchPlans, searchPlans, searchRelatedPlans } from '@/api/api';
import { useInfiniteQuery, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { v4 as uuidv4 } from 'uuid';

export const useRelatedPlans = (tags: string, currentPlanId: string) => {
  return useQuery({
    queryKey: ['related-plans', currentPlanId],
    enabled: !!tags && !!currentPlanId,

    queryFn: async () => searchRelatedPlans(currentPlanId, tags),
  });
};

export const useSearchPlans = (query: string) => {
  return useInfiniteQuery({
    enabled: query.trim().length > 0,
    queryKey: ['search_plans', query],

    queryFn: async ({
      pageParam,
    }: {
      pageParam: { created_at: string | null; id: string | null };
    }) => searchPlans({ pageParam, query }),

    initialPageParam: { created_at: null, id: null },
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });
};

export const useFetchPlan = (id: string) => {
  return useQuery({
    queryKey: ['plan', id],

    queryFn: async () => fetchPlanById(id),
  });
};
export const usePlans = () => {
  const plansQuery = useInfiniteQuery({
    queryKey: ['plans'],

    queryFn: async ({
      pageParam,
    }: {
      pageParam: { created_at: string | null; id: string | null };
    }) => fetchPlans({ pageParam }),
    initialPageParam: { created_at: null, id: null }, // PREVENTS auto-loop
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });

  return {
    plansQuery,
  };
};
