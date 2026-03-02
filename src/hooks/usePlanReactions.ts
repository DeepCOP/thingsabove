import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { getPlanReactionSummary, reportPlan, togglePlanReaction } from '../api/queries';

export function useTogglePlanReaction(planId: string, userId: string) {
  const qc = useQueryClient();

  return useMutation({
    mutationFn: async () => togglePlanReaction(planId, userId),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['plan-reactions', planId, userId] });
      qc.invalidateQueries({ queryKey: ['plans'] });
      qc.invalidateQueries({ queryKey: ['user-plans'] });
      qc.invalidateQueries({ queryKey: ['search_plans'] });
    },
  });
}

export function usePlanReactions(planId: string, userId: string) {
  return useQuery({
    queryKey: ['plan-reactions', planId, userId],
    queryFn: async () => getPlanReactionSummary(planId),
  });
}

export function useReportPlan(planId: string) {
  return useMutation({
    mutationFn: async (reason: string) => reportPlan(reason, planId),
  });
}
