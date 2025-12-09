// hooks/usePlans.ts
import { supabase } from '@/lib/supabase';
import { useInfiniteQuery, useQueryClient } from '@tanstack/react-query';

export const useSearchPlans = (query: string) => {
  return useInfiniteQuery({
    enabled: query.trim().length > 0,
    queryKey: ['search_plans', query],

    queryFn: async ({
      pageParam,
    }: {
      pageParam: { created_at: string | null; id: string | null };
    }) => {
      const PAGE_SIZE = 10;

      const { data, error } = await supabase.rpc('search_plans', {
        search_query: query,
        limit_count: PAGE_SIZE,
        cursor_created_at: pageParam?.created_at ?? null,
        cursor_id: pageParam?.id ?? null,
      });

      if (error) throw error;
      console.log(data.length);
      const last = data?.[data.length - 1] ?? null;

      return {
        items: data,
        nextCursor: last ? { created_at: last.created_at, id: last.id } : null,
      };
    },

    initialPageParam: { created_at: null, id: null },
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });
};

export const usePlans = () => {
  const queryClient = useQueryClient();

  const plansQuery = useInfiniteQuery({
    queryKey: ['plans'],

    queryFn: async ({
      pageParam,
    }: {
      pageParam: { created_at: string | null; id: string | null };
    }) => {
      const PAGE_SIZE = 10;
      const { created_at, id } = pageParam ?? {};

      let query = supabase
        .from('devotional_plans_with_meta')
        .select('*')
        .order('created_at', { ascending: false })
        .order('id', { ascending: false }) // secondary key for stable ordering
        .limit(PAGE_SIZE);

      if (created_at && id) {
        query = query.or(
          `created_at.lt.${created_at},and(created_at.eq.${created_at},id.lt.${id})`,
        );
      }

      const { data, error } = await query;
      if (error) throw error;

      // last item becomes the new cursor
      console.log(data.length);
      const last = data[data.length - 1];

      return {
        items: data,
        nextCursor: last ? { created_at: last.created_at, id: last.id } : null,
      };
    },
    initialPageParam: { created_at: null, id: null }, // PREVENTS auto-loop
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });

  return {
    plansQuery,
  };
};
