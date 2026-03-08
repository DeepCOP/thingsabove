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

    onSuccess: (_progressId, variables) => {
      queryClient.invalidateQueries({ queryKey: ['plan_progress'] });
      queryClient.invalidateQueries({ queryKey: ['plan_group'] });
      queryClient.invalidateQueries({ queryKey: ['user_plans_progresses', variables.user_id] });
    },
    onError: (error) => {
      console.error('Error creating plan group:', error);
    },
  });
}
