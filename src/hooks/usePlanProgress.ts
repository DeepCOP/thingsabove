import {
  fetchMyPlanProgressPlans,
  fetchGroupPlanProgressList,
  fetchPlanDays,
  fetchPlanProgress,
  fetchUserPlanProgressList,
} from '@/src/api/queries';
import { PlanProgress } from '@/src/types/types';
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
    onSuccess: (progress, variables) => {
      const now = new Date().toISOString();
      const progressId = progress.id;
      queryClient.invalidateQueries({
        queryKey: ['plan_progress', progressId, variables.user_id],
      });

      const newProgress: PlanProgress = {
        ...progress,
        created_at: progress.created_at ?? now,
        updated_at: progress.updated_at ?? now,
        start_date: progress.start_date ?? now,
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
      queryClient.invalidateQueries({
        queryKey: ['my_plan_progress_plans', variables.user_id],
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
