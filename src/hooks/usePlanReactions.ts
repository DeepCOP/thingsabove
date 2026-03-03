import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { reportPlan, togglePlanReaction } from '../api/queries';

type ReactionState = 'helpful' | null;
type PlanReactionCache = {
  helpful_count: number;
  user_reaction: ReactionState;
};

function normalizeReaction(value: unknown): ReactionState {
  return value === 'helpful' ? 'helpful' : null;
}

function readPlanReaction(item: unknown, planId: string): PlanReactionCache | null {
  if (!item || typeof item !== 'object') return null;

  const plan = item as {
    id?: string | null;
    helpful_count?: number | null;
    user_reaction?: string | null;
  };

  // If an id is present, ensure we are reading the same plan.
  if (plan.id && plan.id !== planId) return null;

  return {
    helpful_count: Math.max(0, plan.helpful_count ?? 0),
    user_reaction: normalizeReaction(plan.user_reaction),
  };
}

function findReactionInInfiniteData(data: unknown, planId: string): PlanReactionCache | null {
  if (!data || typeof data !== 'object') return null;
  const typed = data as { pages?: unknown[] };
  if (!Array.isArray(typed.pages)) return null;

  for (const page of typed.pages) {
    if (!page || typeof page !== 'object') continue;
    const items = (page as { items?: unknown[] }).items;
    if (!Array.isArray(items)) continue;

    for (const item of items) {
      const reaction = readPlanReaction(item, planId);
      if (reaction) return reaction;
    }
  }

  return null;
}

function resolveBaselineReaction({
  previousReaction,
  previousPlan,
  previousPlans,
  previousUserPlans,
  previousSearchPlans,
  planId,
}: {
  previousReaction: PlanReactionCache | undefined;
  previousPlan: unknown;
  previousPlans: [readonly unknown[], unknown][];
  previousUserPlans: [readonly unknown[], unknown][];
  previousSearchPlans: [readonly unknown[], unknown][];
  planId: string;
}): PlanReactionCache {
  if (previousReaction) return previousReaction;

  const fromPlan = readPlanReaction(previousPlan, planId);
  if (fromPlan) return fromPlan;

  for (const [, data] of previousPlans) {
    const fromPlans = findReactionInInfiniteData(data, planId);
    if (fromPlans) return fromPlans;
  }

  for (const [, data] of previousSearchPlans) {
    const fromSearch = findReactionInInfiniteData(data, planId);
    if (fromSearch) return fromSearch;
  }

  for (const [, data] of previousUserPlans) {
    if (!Array.isArray(data)) continue;
    for (const item of data) {
      const fromUserPlans = readPlanReaction(item, planId);
      if (fromUserPlans) return fromUserPlans;
    }
  }

  return { helpful_count: 0, user_reaction: null };
}

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
  const planKey = ['plan', planId] as const;

  return useMutation({
    mutationFn: async () => togglePlanReaction(planId, userId),

    onMutate: async () => {
      await Promise.all([
        qc.cancelQueries({ queryKey: reactionKey }),
        qc.cancelQueries({ queryKey: planKey }),
        qc.cancelQueries({ queryKey: ['plans'] }),
        qc.cancelQueries({ queryKey: ['user-plans'] }),
        qc.cancelQueries({ queryKey: ['search_plans'] }),
      ]);

      const previousReaction = qc.getQueryData<PlanReactionCache>(reactionKey);
      const previousPlan = qc.getQueryData(planKey);
      const previousPlans = qc.getQueriesData({ queryKey: ['plans'] });
      const previousUserPlans = qc.getQueriesData({ queryKey: ['user-plans'] });
      const previousSearchPlans = qc.getQueriesData({ queryKey: ['search_plans'] });

      const baseline = resolveBaselineReaction({
        previousReaction,
        previousPlan,
        previousPlans,
        previousUserPlans,
        previousSearchPlans,
        planId,
      });
      const wasHelpful = baseline.user_reaction === 'helpful';
      const delta = wasHelpful ? -1 : 1;
      const nextReaction: ReactionState = wasHelpful ? null : 'helpful';
      const nextCount = Math.max(0, baseline.helpful_count + delta);

      qc.setQueryData<PlanReactionCache>(reactionKey, {
        helpful_count: nextCount,
        user_reaction: nextReaction,
      });
      qc.setQueryData(planKey, (old) => updatePlanItemReaction(old, planId, delta, nextReaction));

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
        previousPlan,
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
      if (context.previousPlan === undefined) {
        qc.removeQueries({ queryKey: planKey, exact: true });
      } else {
        qc.setQueryData(planKey, context.previousPlan);
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
      qc.invalidateQueries({ queryKey: planKey });
      qc.invalidateQueries({ queryKey: ['plans'] });
      qc.invalidateQueries({ queryKey: ['user-plans'] });
      qc.invalidateQueries({ queryKey: ['search_plans'] });
    },
  });
}

export function useReportPlan(planId: string) {
  return useMutation({
    mutationFn: async (reason: string) => reportPlan(reason, planId),
  });
}
