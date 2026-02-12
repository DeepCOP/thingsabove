// hooks/useDayItemsProgress.ts
import { toggleDayCompletion, toggleItemCompletion } from '@/src/api/mutations';
import { fetchDayItems } from '@/src/api/queries';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

interface Params {
  user_id: string;
  plan_id: string;
  progress_id: string;
  day_id: string;
  group_id?: string;
}

export function useDayItemsProgress({ user_id, plan_id, progress_id, day_id, group_id }: Params) {
  const queryClient = useQueryClient();

  // Load completed items
  const dayItemsProgressQuery = useQuery({
    queryKey: ['day_items_progress', user_id, progress_id, day_id, group_id],
    enabled: !!day_id && !!progress_id && !!user_id,
    queryFn: async () => {
      const data = await fetchDayItems({
        user_id,
        plan_id,
        progress_id,
        day_id,
        groupId: group_id,
      });
      return data;
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
      return toggleItemCompletion({
        item_key,
        item_type,
        completed,
        user_id,
        plan_id,
        progress_id,
        day_id,
        groupId: group_id,
      });
    },

    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ['day_items_progress', user_id, progress_id, day_id, group_id],
      });

      queryClient.invalidateQueries({
        queryKey: ['plan_progress', progress_id, user_id],
      });
      queryClient.invalidateQueries({
        queryKey: ['user_plans_progressess', user_id],
      });
    },
    onError: (error) => {
      console.error('Error toggling item completion:', error);
    },
  });

  const toggleDayCompletionMutation = useMutation({
    mutationFn: async ({ completed, day_id }: { completed: boolean; day_id: string }) =>
      toggleDayCompletion({ completed, user_id, plan_id, progress_id, day_id, groupId: group_id }),

    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ['day_items_progress', user_id, progress_id, day_id, group_id],
      });

      queryClient.invalidateQueries({
        queryKey: ['plan_progress', progress_id, user_id],
      });
      queryClient.invalidateQueries({
        queryKey: ['user_plans_progressess', user_id],
      });
    },
    onError: (error) => {
      console.error('Error toggling item completion:', error);
    },
  });

  const toggleItem = (type: 'devotional' | 'scripture', key: string, completed: boolean) => {
    toggleMutation.mutate({ item_type: type, item_key: key, completed });
  };

  return {
    dayItemsProgressQuery,
    toggleMutation,
    toggleDayCompletion: toggleDayCompletionMutation,
    toggleItem,
  };
}
