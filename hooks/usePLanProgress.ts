// hooks/usePlanProgress.ts
import { supabase } from '@/api/supabase';
import { PlanDayView, PlanProgressInsert } from '@/types/types';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

export function usePlanProgress(plan_id: string, user_id: string) {
  const queryClient = useQueryClient();

  const planProgressQuery = useQuery({
    queryKey: ['plan_progress', plan_id, user_id],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('plan_progress')
        .select('id, current_day, completed_days,created_at')
        .eq('plan_id', plan_id)
        .eq('user_id', user_id)
        .single();

      if (error && error.code !== 'PGRST116') throw error;
      return data;
    },
  });

  const daysQuery = useQuery({
    queryKey: ['devotional_days', plan_id],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('devotional_days')
        .select('*')
        .eq('plan_id', plan_id)
        .order('day_number');

      if (error) throw error;
      return data;
    },
  });

  const insertToPlanProgress = useMutation({
    mutationKey: ['start_plan'],

    mutationFn: async (payload: PlanProgressInsert) => {
      console.log('Inserting to plan progress:', payload);
      const { data, error } = await supabase
        .from('plan_progress')
        .insert(payload)
        .select('*')
        .single();

      if (error) throw error;
      return data;
    },

    onSuccess: (data) => {
      // Invalidate any queries that depend on the user's plan progress
      queryClient.invalidateQueries({ queryKey: ['plan_progress'] });
    },
  });

  return { planProgressQuery, daysQuery, insertToPlanProgress };
}

export const usePlanDay = (day_id: string | null) => {
  return useQuery<PlanDayView>({
    queryKey: ['plan_day', day_id],
    enabled: !!day_id,

    queryFn: async () => {
      console.log(day_id);
      const { data, error } = await supabase
        .from('plan_day_view')
        .select('*')
        .eq('day_id', day_id ?? '')
        .single();

      if (error) throw error;
      return data;
    },
  });
};
