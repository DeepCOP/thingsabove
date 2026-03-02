import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { getPlanReactionSummary, reportPlan, togglePlanReaction } from '../api/queries';

type ReactionState = 'helpful' | null;
type PlanReactionCache = {
  helpful_count: number;
  user_reaction: ReactionState;
};

function updatePlanItemReaction(item: unknown, planId: string, delta: number, next: ReactionState) {
  if (!item || typeof item !== 'object') return item;

  const plan = item as {
    id?: string | null;
    helpful_count?: number | null;
    user_reaction?: string | null;
  };

  if (plan.id !== planId) return item;

  return {
    ...plan,
    helpful_count: Math.max(0, (plan.helpful_count ?? 0) + delta),
    user_reaction: next,
  };
}

function updateInfinitePlanPages(
  data: unknown,
  planId: string,
  delta: number,
  next: ReactionState,
) {
  if (!data || typeof data !== 'object') return data;

  const typed = data as { pages?: unknown[]; pageParams?: unknown[] };
  if (!Array.isArray(typed.pages)) return data;

  return {
    ...typed,
    pages: typed.pages.map((page) => {
      if (!page || typeof page !== 'object') return page;
      const typedPage = page as { items?: unknown[] };
      if (!Array.isArray(typedPage.items)) return page;

      return {
        ...typedPage,
        items: typedPage.items.map((item) => updatePlanItemReaction(item, planId, delta, next)),
      };
    }),
  };
}

export function useTogglePlanReaction(planId: string, userId: string) {
  const qc = useQueryClient();
  const reactionKey = ['plan-reactions', planId, userId] as const;

  return useMutation({
    mutationFn: async () => togglePlanReaction(planId, userId),

    onMutate: async () => {
      await Promise.all([
        qc.cancelQueries({ queryKey: reactionKey }),
        qc.cancelQueries({ queryKey: ['plans'] }),
        qc.cancelQueries({ queryKey: ['user-plans'] }),
        qc.cancelQueries({ queryKey: ['search_plans'] }),
      ]);

      const previousReaction = qc.getQueryData<PlanReactionCache>(reactionKey);
      const previousPlans = qc.getQueriesData({ queryKey: ['plans'] });
      const previousUserPlans = qc.getQueriesData({ queryKey: ['user-plans'] });
      const previousSearchPlans = qc.getQueriesData({ queryKey: ['search_plans'] });

      const wasHelpful = previousReaction?.user_reaction === 'helpful';
      const delta = wasHelpful ? -1 : 1;
      const nextReaction: ReactionState = wasHelpful ? null : 'helpful';

      qc.setQueryData<PlanReactionCache>(reactionKey, (old) => ({
        helpful_count: Math.max(0, (old?.helpful_count ?? 0) + delta),
        user_reaction: nextReaction,
      }));

      qc.setQueriesData({ queryKey: ['plans'] }, (old) =>
        updateInfinitePlanPages(old, planId, delta, nextReaction),
      );
      qc.setQueriesData({ queryKey: ['search_plans'] }, (old) =>
        updateInfinitePlanPages(old, planId, delta, nextReaction),
      );
      qc.setQueriesData({ queryKey: ['user-plans'] }, (old) => {
        if (!Array.isArray(old)) return old;
        return old.map((item) => updatePlanItemReaction(item, planId, delta, nextReaction));
      });

      return {
        previousReaction,
        previousPlans,
        previousUserPlans,
        previousSearchPlans,
      };
    },

    onError: (_error, _variables, context) => {
      if (!context) return;

      if (context.previousReaction === undefined) {
        qc.removeQueries({ queryKey: reactionKey, exact: true });
      } else {
        qc.setQueryData(reactionKey, context.previousReaction);
      }

      context.previousPlans.forEach(([key, data]) => {
        qc.setQueryData(key, data);
      });
      context.previousUserPlans.forEach(([key, data]) => {
        qc.setQueryData(key, data);
      });
      context.previousSearchPlans.forEach(([key, data]) => {
        qc.setQueryData(key, data);
      });
    },

    onSettled: () => {
      qc.invalidateQueries({ queryKey: reactionKey });
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
