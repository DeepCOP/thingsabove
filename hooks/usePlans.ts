// hooks/usePlans.ts
import { fetchPlanById, fetchPlans, searchPlans, searchRelatedPlans } from '@/api/api';
import { supabase } from '@/api/supabase';
import { mutationQueue } from '@/lib/mutationQueue';
import { useInfiniteQuery, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { v4 as uuidv4 } from 'uuid';
export const useRelatedPlans = (tags: string, currentPlanId: string) => {
  return useQuery({
    queryKey: ['related-plans', currentPlanId],
    enabled: !!tags.trim() && !!currentPlanId,

    queryFn: async () => searchRelatedPlans(currentPlanId, tags.trim()),
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

export const useFetchDevotionalPlan = (id: string) => {
  return useQuery({
    queryKey: ['plan', id],

    queryFn: async () => fetchPlanById(id),
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
    }) => fetchPlans({ pageParam }),
    initialPageParam: { created_at: null, id: null }, // PREVENTS auto-loop
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });

  // Start plan (create a plan_progress row for the user)
  const startPlanMutation = useMutation({
    mutationFn: async ({ plan_id, user_id }: { plan_id: string; user_id: string }) => {
      const { data, error } = await supabase.from('plan_progress').insert({
        user_id,
        plan_id,
        current_day: 1,
        completed_days: [],
      });
      if (error) throw error;
      return data;
    },
    // optimistic: update cache immediately
    onMutate: async ({ plan_id, user_id }) => {
      await queryClient.cancelQueries({ queryKey: ['my_plans', user_id] });
      const prev = queryClient.getQueryData(['my_plans', user_id]);
      // optionally update cache to show started state
      queryClient.setQueryData(['my_plans', user_id], (old: any) => {
        return old;
      });
      return { prev };
    },
    onError: async (err, variables, context) => {
      // if offline or failed, enqueue and optimistically show started state
      const qid = uuidv4();
      mutationQueue.enqueue({
        id: qid,
        key: 'start_plan',
        payload: variables,
      });
    },
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['my_plans'] });
    },
  });

  // Toggle reaction (like/dislike) — simple example
  const toggleReaction = useMutation({
    mutationFn: async ({
      plan_id,
      user_id,
      type,
    }: {
      plan_id: string;
      user_id: string;
      type: 'like' | 'dislike';
    }) => {
      // server-side logic should handle toggle: insert or delete existing reaction
      const { data, error } = await supabase.rpc('toggle_reaction', {
        p_plan_id: plan_id,
        p_user_id: user_id,
        p_reaction_type: type,
      });
      if (error) throw error;
      return data;
    },
    onMutate: async ({ plan_id, user_id, type }) => {
      await queryClient.cancelQueries({ queryKey: ['plans'] });
      const previous = queryClient.getQueryData(['plans']);
      // perform small optimistic change on plans cache (example only)
      queryClient.setQueryData(['plans'], (old: any) => {
        if (!old) return old;
        return old.map((p: any) => {
          if (p.id !== plan_id) return p;
          // naive toggle: increment likes
          return {
            ...p,
            likes: (p.likes || 0) + (type === 'like' ? 1 : 0),
          };
        });
      });
      return { previous };
    },
    onError: (err, variables) => {
      // enqueue mutation for retry
      const qid = uuidv4();
      mutationQueue.enqueue({
        id: qid,
        key: 'toggle_reaction',
        payload: variables,
      });
    },
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['plans'] });
    },
  });

  return {
    plansQuery,
    startPlanMutation,
    toggleReaction,
  };
};
