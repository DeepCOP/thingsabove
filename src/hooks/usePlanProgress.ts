import {
  fetchGroupPlanProgressList,
  fetchPlanDays,
  fetchPlanProgress,
  fetchUserPlanProgressList,
} from '@/src/api/queries';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { startPlanProgress } from '../api/mutations';

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
    onSuccess: (progressId, variables) => {
      queryClient.invalidateQueries({
        queryKey: ['plan_progress', progressId, variables.user_id],
      });
      queryClient.invalidateQueries({
        queryKey: ['user_plans_progresses', variables.user_id],
      });
    },
  });
}

export const useUserPlanProgressList = (user_id: string | undefined) => {
  const userPlanProgressQuery = useQuery({
    queryKey: ['user_plans_progresses', user_id],
    enabled: !!user_id,
    queryFn: async () => fetchUserPlanProgressList({ user_id: user_id! }),
  });
  return userPlanProgressQuery;
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
