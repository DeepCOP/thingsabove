import { createPlanGroup } from '@/src/api/mutations';
import { useMutation, useQueryClient } from '@tanstack/react-query';

type CreatePlanGroupInput = {
  plan_id: string;
  start_date: string;
  user_id: string;
  invited_user_ids: string[];
};

export function useCreatePlanGroup() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ plan_id, start_date, user_id, invited_user_ids }: CreatePlanGroupInput) =>
      await createPlanGroup({ plan_id, start_date, user_id, invited_user_ids }),

    onSuccess: (groupId, user_id) => {
      queryClient.invalidateQueries({ queryKey: ['plan_groups'] });
      queryClient.invalidateQueries({ queryKey: ['plan_progress'] });
      queryClient.invalidateQueries({ queryKey: ['plan-group', groupId] });
      queryClient.invalidateQueries({ queryKey: ['user_plans_progressess', user_id] });
      return groupId;
    },
    onError: (error) => {
      console.error('Error creating plan group:', error);
    },
  });
}
