// hooks/usePlans.ts
import { fetchPlans, searchPlans } from '@/api/api';
import { useInfiniteQuery } from '@tanstack/react-query';

export const useSearchPlans = (query: string) => {
  return useInfiniteQuery({
    enabled: query.trim().length > 0,
    queryKey: ['search_plans', query],

    queryFn: async ({ pageParam }) => await searchPlans({ query, pageParam }),

    initialPageParam: { created_at: null, id: null },
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });
};

export const usePlans = () => {
  const plansQuery = useInfiniteQuery({
    queryKey: ['plans'],

    queryFn: async ({ pageParam }) => await fetchPlans({ pageParam }),
    initialPageParam: { created_at: null, id: null }, // PREVENTS auto-loop
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });

  return {
    plansQuery,
  };
};
