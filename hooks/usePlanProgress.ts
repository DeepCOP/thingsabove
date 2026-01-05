import {
  fetchPlanDays,
  fetchPlanDayView,
  fetchPlanProgress,
  fetchUserPlanProgress,
  insertToPlanProgress,
} from '@/api/queries';
import { PlanDayView, PlanProgressInsert } from '@/types/types';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

export function usePlanProgress(plan_id: string, user_id: string, group_id?: string) {
  const queryClient = useQueryClient();

  const planProgressQuery = useQuery({
    queryKey: ['plan_progress', plan_id, user_id, group_id],
    staleTime: 0,
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

export const useDevotionalDays = (plan_id: string) => {
  const daysQuery = useQuery({
    queryKey: ['devotional_days', plan_id],
    enabled: !!plan_id,
    queryFn: async () => fetchPlanDays({ plan_id }),
  });
  return daysQuery;
};

export const usePlanDay = (day_id: string | null) => {
  return useQuery<PlanDayView>({
    queryKey: ['plan_day', day_id],
    enabled: !!day_id,

    queryFn: async () => fetchPlanDayView(day_id!),
  });
};
