import { fetchMySavedPlans, removeSavedPlanForUser, savePlanForUser } from '@/src/api/queries';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { DevotionalPlanView, SavedPlanListItem } from '../types/types';

export function useSavedPlans(userId?: string) {
  return useQuery({
    queryKey: ['my_saved_plans', userId],
    enabled: !!userId,
    queryFn: async () => fetchMySavedPlans(),
  });
}

type TogglePayload = {
  planId: string;
  isSaved: boolean;
  item?: DevotionalPlanView | null;
};

type ToggleContext = {
  previousSavedPlans: SavedPlanListItem[];
};

const toSavedPlanListItem = (item: DevotionalPlanView): SavedPlanListItem => ({
  ...item,
  saved_at: new Date().toISOString(),
});

export function useToggleSavedPlan(userId?: string) {
  const qc = useQueryClient();
  const savedPlansQueryKey = ['my_saved_plans', userId] as const;

  const mutation = useMutation({
    mutationFn: async ({ planId, isSaved }: TogglePayload) => {
      if (!userId) return;
      if (isSaved) {
        await removeSavedPlanForUser(userId, planId);
        return;
      }
      await savePlanForUser(userId, planId);
    },
    onMutate: async ({ planId, isSaved, item }) => {
      if (!userId) return;
      await qc.cancelQueries({ queryKey: savedPlansQueryKey });

      const previousSavedPlans = qc.getQueryData<SavedPlanListItem[]>(savedPlansQueryKey) ?? [];

      const nextSavedPlans = isSaved
        ? previousSavedPlans.filter((savedPlan) => savedPlan.id !== planId)
        : item
          ? [
              toSavedPlanListItem(item),
              ...previousSavedPlans.filter((savedPlan) => savedPlan.id !== planId),
            ]
          : previousSavedPlans;

      qc.setQueryData(savedPlansQueryKey, nextSavedPlans);

      return { previousSavedPlans } as ToggleContext;
    },
    onError: (_error, _variables, context) => {
      if (!context) return;
      qc.setQueryData(savedPlansQueryKey, context.previousSavedPlans);
    },
    onSettled: async () => {
      await qc.invalidateQueries({ queryKey: savedPlansQueryKey });
    },
  });

  const toggleSavedPlan = (planId: string, isSaved: boolean, item?: DevotionalPlanView | null) => {
    if (!userId || !planId) return;
    mutation.mutate({ planId, isSaved, item });
  };

  return {
    toggleSavedPlan,
    isPending: mutation.isPending,
  };
}
