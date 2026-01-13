import { insertToPlanProgress } from '@/lib/api/mutations';
import {
  fetchPlanDays,
  fetchPlanDayView,
  fetchPlanProgress,
  fetchUserPlanProgress,
  fetchUsersPlanProgress,
} from '@/lib/api/queries';
import { PlanDayView, PlanProgressInsert } from '@/lib/types/types';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

export function usePlanProgress(plan_id: string, user_id: string, group_id?: string) {
  const queryClient = useQueryClient();

  const planProgressQuery = useQuery({
    queryKey: ['plan_progress', plan_id, user_id, group_id],
    enabled: !!plan_id && !!user_id,
    queryFn: async () => fetchPlanProgress({ plan_id, user_id, groupId: group_id }),
  });

  const insertToPlanProgressMutation = useMutation({
    mutationKey: ['start_plan'],

    mutationFn: async (payload: PlanProgressInsert) => insertToPlanProgress(payload),

    onSuccess: (data) => {
      // Invalidate any queries that depend on the user's plan progress
      queryClient.invalidateQueries({ queryKey: ['plan_progress'] });
    },
  });

  return {
    planProgressQuery,
    insertToPlanProgress: insertToPlanProgressMutation,
  };
}

export const useUserPlanProgress = (user_id: string) => {
  const userPlanProgressQuery = useQuery({
    queryKey: ['user_plans_progressess', user_id],
    enabled: !!user_id,
    queryFn: async () => fetchUserPlanProgress({ user_id }),
  });
  return userPlanProgressQuery;
};

export const useUsersPlanProgress = (userIds: string[], groupId: string) => {
  const usersPlanProgress = useQuery({
    queryKey: ['users_plans_progressess', userIds, groupId],
    enabled: !!userIds && userIds.length > 0 && !!groupId,
    queryFn: async () => fetchUsersPlanProgress({ userIds, groupId }),
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

export const usePlanDayView = (day_id: string | null, userId: string) => {
  return useQuery<PlanDayView>({
    queryKey: ['plan_day', day_id, userId],
    enabled: !!day_id && !!userId,

    queryFn: async () => fetchPlanDayView(day_id!),
  });
};
