// hooks/useDayItemsProgress.ts
import { supabase } from '@/api/supabase';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useEffect } from 'react';

interface Params {
  user_id: string;
  plan_id: string;
  day_id: string;
  scripture_refs: string[];
}

const getNumericPrefix = (key?: string | null) => {
  if (!key) return 0;
  const match = key.match(/^(\d+)/);
  return match ? Number(match[0]) : 0;
};

const sortByItemKey = (a?: string | null, b?: string | null) => {
  const na = getNumericPrefix(a);
  const nb = getNumericPrefix(b);

  if (na === nb) {
    return (a ?? '').localeCompare(b ?? '');
  }
  return na - nb;
};

export function useDayItemsProgress({ user_id, plan_id, day_id, scripture_refs }: Params) {
  const queryClient = useQueryClient();

  // Load completed items
  const dayItemsProgressQuery = useQuery({
    queryKey: ['day_items_progress', user_id, plan_id, day_id],
    enabled: !!day_id && !!plan_id && !!user_id,
    queryFn: async () => {
      const { data, error } = await supabase
        .from('day_items_progress')
        .select('*')
        .eq('user_id', user_id)
        .eq('plan_id', plan_id)
        .eq('day_id', day_id);

      if (error) throw error;
      // Return mapped progress
      return {
        items: [...data].sort((a, b) => {
          const getNumericPrefix = (key?: string | null) => {
            if (!key) return 0;
            const match = key.match(/^(\d+)/); // Match numerical prefix at the beginning
            return match ? Number(match[0]) : 0;
          };

          const numericA = getNumericPrefix(a.item_key);
          const numericB = getNumericPrefix(b.item_key);

          // If the numeric prefixes are the same, fall back to lexicographical comparison
          if (numericA === numericB) {
            return (a.item_key ?? '').localeCompare(b.item_key ?? '');
          }

          return numericA - numericB;
        }),
        devotional: {
          completed: data.find((i) => i.item_type === 'devotional' && i.item_key === 'main')
            ?.completed,
          id: data.find((i) => i.item_type === 'devotional' && i.item_key === 'main')?.id,
        },
        scriptures: [...scripture_refs]
          .sort((a, b) => sortByItemKey(a, b))
          .map((ref) => ({
            ref,
            completed: data.find((i) => i.item_type === 'scripture' && i.item_key === ref)
              ?.completed,
            id: data.find((i) => i.item_type === 'scripture' && i.item_key === ref)?.id,
          })),
      };
    },
  });

  // Toggle completion (using RPC)
  const toggleMutation = useMutation({
    mutationFn: async ({
      item_type,
      item_key,
      completed,
    }: {
      item_type: 'devotional' | 'scripture';
      item_key: string;
      completed: boolean;
    }) => {
      const { error } = await supabase.rpc('toggle_item_completion', {
        p_user_id: user_id,
        p_plan_id: plan_id,
        p_day_id: day_id,
        p_item_type: item_type,
        p_item_key: item_key,
        p_completed: completed,
      });

      if (error) throw error;
    },

    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ['day_items_progress', user_id, plan_id, day_id],
      });

      queryClient.invalidateQueries({
        queryKey: ['plan_progress', plan_id, user_id],
      });
      queryClient.invalidateQueries({
        queryKey: ['plan', plan_id],
      });
    },
    onError: (error) => {
      console.error('Error toggling item completion:', error);
    },
  });

  const toggleDayCompletion = useMutation({
    mutationFn: async ({completed,user_id,plan_id,day_id}: {completed: boolean,user_id: string,plan_id: string,day_id: string}) => {
      const { error } = await supabase.rpc('toggle_day_completion', {
        p_user_id: user_id,
        p_plan_id: plan_id,
        p_day_id: day_id,
        p_completed: completed,
      });
      ``

      if (error) throw error;
    },   
     onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ['day_items_progress', user_id, plan_id, day_id],
      });

      queryClient.invalidateQueries({
        queryKey: ['plan_progress', plan_id, user_id],
      });
      queryClient.invalidateQueries({
        queryKey: ['plan', plan_id],
      });
    },
  });

  const loadItems = useMutation({
    mutationFn: async () => {
      const { error } = await supabase.rpc('ensure_day_items_exist', {
        p_user_id: user_id,
        p_plan_id: plan_id,
        p_day_id: day_id,
      });

      if (error) throw error;
    },

    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ['day_items_progress', user_id, plan_id, day_id],
      });

      queryClient.invalidateQueries({
        queryKey: ['plan_progress', plan_id, user_id],
      });
    },
    onError: (error) => {
      console.error('Error toggling item completion:', error);
    },
  });
  const toggleItem = (type: 'devotional' | 'scripture', key: string, completed: boolean) => {
    toggleMutation.mutate({ item_type: type, item_key: key, completed });
  };

  useEffect(() => {
    if (!day_id || !plan_id || !user_id) return;

    const loadItem = async () => {
      const { error } = await supabase.rpc('ensure_day_items_exist', {
        p_user_id: user_id,
        p_plan_id: plan_id,
        p_day_id: day_id,
      });

      if (error) throw error;
    };

    loadItem();
  }, [day_id]);

  return {
    dayItemsProgressQuery: dayItemsProgressQuery.data,
    isLoading: dayItemsProgressQuery.isLoading,
    toggleMutation,
    toggleDayCompletion,
    toggleItem,
    loadItems,
  };
}
