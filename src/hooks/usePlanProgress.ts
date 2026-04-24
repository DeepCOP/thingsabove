import {
  fetchGroupPlanProgressList,
  fetchMyPlanProgressPlans,
  fetchPlanDays,
  fetchPlanProgress,
} from '@/src/api/queries';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { startPlanProgress, stopPlanProgress } from '../api/mutations';

export function usePlanProgress(progress_id: string, user_id: string | undefined) {
  const planProgressQuery = useQuery({
    queryKey: ['plan_progress', progress_id, user_id],
    enabled: !!progress_id && !!user_id,
    queryFn: async () => fetchPlanProgress({ progress_id, user_id: user_id! }),
  });

  return {
    planProgressQuery,
  };
}

export function useStartPlanProgress() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationKey: ['start_plan'],
    mutationFn: startPlanProgress,
    onSuccess: (_progress, variables) => {
      queryClient.setQueryData(['has_user_plan_progress', variables.user_id], true);
      queryClient.invalidateQueries({
        queryKey: ['my_plan_progress_plans', variables.user_id],
      });
    },
  });
}

export function useStopPlanProgress() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: stopPlanProgress,
    onSuccess: (_result, variables) => {
      queryClient.removeQueries({
        queryKey: ['plan_progress', variables.progress_id, variables.user_id],
        exact: true,
      });
      queryClient.removeQueries({
        queryKey: ['day_items_progress', variables.user_id, variables.progress_id],
      });
      queryClient.setQueryData(['my_plan_progress_plans', variables.user_id], (old: unknown) => {
        if (!Array.isArray(old)) return old;

        return old.filter((item) => {
          const progress = item as { progress_id?: string | null };
          return progress.progress_id !== variables.progress_id;
        });
      });
      queryClient.invalidateQueries({
        queryKey: ['my_plan_progress_plans', variables.user_id],
      });
      queryClient.invalidateQueries({
        queryKey: ['has_user_plan_progress', variables.user_id],
      });
    },
  });
}

export const useMyPlanProgressPlans = (user_id: string | undefined) => {
  const myPlanProgressPlansQuery = useQuery({
    queryKey: ['my_plan_progress_plans', user_id],
    enabled: !!user_id,
    queryFn: async () => fetchMyPlanProgressPlans(),
  });
  return myPlanProgressPlansQuery;
};

export const useGroupPlanProgressList = (userIds: string[], groupId: string) => {
  const usersPlanProgress = useQuery({
    queryKey: ['users_plans_progresses', userIds, groupId],
    enabled: !!userIds && userIds.length > 0 && !!groupId,
    queryFn: async () => fetchGroupPlanProgressList({ userIds, groupId }),
  });
  return usersPlanProgress;
};
export const useDevotionalDays = (plan_id: string, userId: string) => {
  const daysQuery = useQuery({
    queryKey: ['devotional_days', plan_id, userId],
    enabled: !!plan_id && !!userId,
    queryFn: async () => fetchPlanDays({ plan_id }),
  });
  return daysQuery;
};
