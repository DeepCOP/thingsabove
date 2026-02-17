import {
  fetchGroupPlanProgressList,
  fetchPlanDays,
  fetchPlanProgress,
  fetchUserPlanProgressList,
} from '@/src/api/queries';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { startPlanProgress } from '../api/mutations';

export function usePlanProgress(progress_id: string, user_id: string | undefined) {
  const queryClient = useQueryClient();

  const planProgressQuery = useQuery({
    queryKey: ['plan_progress', progress_id, user_id],
    enabled: !!progress_id && !!user_id,
    queryFn: async () => fetchPlanProgress({ progress_id, user_id: user_id! }),
  });

  const startPlanProgressMutation = useMutation({
    mutationKey: ['start_plan'],

    mutationFn: startPlanProgress,

    onSuccess: (progress_id, user_id) => {
      // Invalidate any queries that depend on the user's plan progress
      queryClient.invalidateQueries({
        queryKey: ['plan_progress', progress_id, user_id],
      });
      queryClient.invalidateQueries({
        queryKey: ['user_plans_progressess'],
      });
    },
  });

  return {
    planProgressQuery,
    startPlanProgressMutation,
  };
}

export const useUserPlanProgressList = (user_id: string | undefined) => {
  const userPlanProgressQuery = useQuery({
    queryKey: ['user_plans_progressess', user_id],
    enabled: !!user_id,
    queryFn: async () => fetchUserPlanProgressList({ user_id: user_id! }),
  });
  return userPlanProgressQuery;
};

export const useGroupPlanProgressList = (userIds: string[], groupId: string) => {
  const usersPlanProgress = useQuery({
    queryKey: ['users_plans_progressess', userIds, groupId],
    enabled: !!userIds && userIds.length > 0 && !!groupId,
    queryFn: async () => fetchGroupPlanProgressList({ userIds, groupId }),
  });
  return usersPlanProgress;
};
export const useDevotionalDays = (plan_id: string, userdId: string) => {
  const daysQuery = useQuery({
    queryKey: ['devotional_days', plan_id, userdId],
    enabled: !!plan_id && !!userdId,
    queryFn: async () => fetchPlanDays({ plan_id }),
  });
  return daysQuery;
};
