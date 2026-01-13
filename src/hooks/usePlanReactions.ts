import { supabase } from '@/api/supabaseClient';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

export function useTogglePlanReaction(planId: string, userId: string) {
  const qc = useQueryClient();

  return useMutation({
    mutationFn: async (reaction: 'like' | 'dislike') => {
      if (!planId || !userId) {
        return null;
      }

      const { data, error } = await supabase.rpc('toggle_reaction', {
        p_plan_id: planId,
        p_user_id: userId,
        p_reaction_type: reaction,
      });

      if (error) throw error;
      return data;
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['plan-reactions', planId, userId] });
      qc.invalidateQueries({ queryKey: ['plans'] });
    },
  });
}

export function usePlanReactions(planId: string, userId: string) {
  return useQuery({
    queryKey: ['plan-reactions', planId, userId],
    queryFn: async () => {
      const { data, error } = await supabase
        .rpc('get_plan_reaction_summary', { p_plan_id: planId })
        .single();

      if (error) throw error;
      return data;
    },
  });
}

export function useReportPlan(planId: string) {
  return useMutation({
    mutationFn: async (reason: string) => {
      const { error } = await supabase.rpc('report_plan', {
        p_plan_id: planId,
        p_reason: reason,
      });
      if (error) throw error;
    },
  });
}
