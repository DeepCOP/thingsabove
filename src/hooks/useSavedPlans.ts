import { fetchSavedPlanIds, removeSavedPlanForUser, savePlanForUser } from '@/src/api/queries';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

export function useSavedPlanIds(userId?: string) {
  return useQuery({
    queryKey: ['saved_plan_ids', userId],
    enabled: !!userId,
    queryFn: async () => fetchSavedPlanIds(userId as string),
  });
}

type TogglePayload = {
  planId: string;
  isSaved: boolean;
};

type ToggleContext = {
  previous: string[];
};

export function useToggleSavedPlan(userId?: string) {
  const qc = useQueryClient();
  const queryKey = ['saved_plan_ids', userId] as const;

  const mutation = useMutation({
    mutationFn: async ({ planId, isSaved }: TogglePayload) => {
      if (!userId) return;
      if (isSaved) {
        await removeSavedPlanForUser(userId, planId);
        return;
      }
      await savePlanForUser(userId, planId);
    },
    onMutate: async ({ planId, isSaved }) => {
      if (!userId) return;
      await qc.cancelQueries({ queryKey });

      const previous = qc.getQueryData<string[]>(queryKey) ?? [];
      const next = isSaved
        ? previous.filter((id) => id !== planId)
        : Array.from(new Set([...previous, planId]));

      qc.setQueryData(queryKey, next);
      return { previous } as ToggleContext;
    },
    onError: (_error, _variables, context) => {
      if (!context) return;
      qc.setQueryData(queryKey, context.previous);
    },
  });

  const toggleSavedPlan = (planId: string, isSaved: boolean) => {
    if (!userId || !planId) return;
    mutation.mutate({ planId, isSaved });
  };

  return {
    toggleSavedPlan,
    isPending: mutation.isPending,
  };
}
