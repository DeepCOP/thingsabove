import {
  fetchGroupPlanProgressList,
  fetchPlanDays,
  fetchPlanProgress,
  fetchUserPlanProgressList,
} from '@/src/api/queries';
import { PlanProgress } from '@/src/types/types';
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
    onSuccess: (progressId, variables) => {
      const now = new Date().toISOString();
      queryClient.invalidateQueries({
        queryKey: ['plan_progress', progressId, variables.user_id],
      });
      queryClient.setQueryData(['user_plans_progresses', variables.user_id], (old: unknown) => {
        const newProgress: PlanProgress = {
          id: progressId,
          user_id: variables.user_id,
          plan_id: variables.plan_id,
          group_id: variables.group_id ?? null,
          current_day: 1,
          completed_days: [],
          completed_once: false,
          start_date: variables.start_date ?? now,
          created_at: now,
          updated_at: now,
        };

        if (!Array.isArray(old)) return [newProgress];

        const existingIndex = old.findIndex((progress) => progress?.id === progressId);
        if (existingIndex >= 0) {
          const next = [...old];
          next[existingIndex] = {
            ...(next[existingIndex] as PlanProgress),
            updated_at: now,
          };
          return next;
        }

        return [newProgress, ...old];
      });
    },
  });
}

export function useStopPlanProgress() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationKey: ['stop_plan_progress'],
    mutationFn: stopPlanProgress,
    onSuccess: (_, variables) => {
      queryClient.setQueryData(['user_plans_progresses', variables.user_id], (old: unknown) => {
        if (!Array.isArray(old)) return old;
        return old.filter((progress) => progress?.id !== variables.progress_id);
      });
      queryClient.removeQueries({
        queryKey: ['plan_progress', variables.progress_id, variables.user_id],
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
