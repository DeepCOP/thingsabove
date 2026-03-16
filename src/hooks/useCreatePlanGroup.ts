import { createPlanGroup } from '@/src/api/mutations';
import { PlanProgress } from '@/src/types/types';
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

    onSuccess: (progress, variables) => {
      const now = new Date().toISOString();
      const progressId = progress.id;
      queryClient.invalidateQueries({
        queryKey: ['plan_progress', progressId, variables.user_id],
      });
      queryClient.invalidateQueries({ queryKey: ['plan_group'] });

      const newProgress: PlanProgress = {
        ...progress,
        start_date: progress.start_date ?? variables.start_date,
        created_at: progress.created_at ?? now,
        updated_at: progress.updated_at ?? now,
      };

      queryClient.setQueryData(['plan_progress', progressId, variables.user_id], newProgress);

      queryClient.setQueryData(['user_plans_progresses', variables.user_id], (old: unknown) => {
        if (!Array.isArray(old)) return [newProgress];

        const existingIndex = old.findIndex((progress) => progress?.id === progressId);
        if (existingIndex >= 0) {
          const next = [...old];
          next[existingIndex] = {
            ...(next[existingIndex] as PlanProgress),
            ...newProgress,
            updated_at: now,
          };
          return next;
        }

        return [newProgress, ...old];
      });
    },
    onError: (error) => {
      console.error('Error creating plan group:', error);
    },
  });
}
