import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { upsertPlanRating } from '../api/mutations';
import { fetchMyPlanRating, reportPlan, togglePlanReaction } from '../api/queries';

type ReactionState = 'helpful' | null;
type PlanReactionCache = {
  helpful_count: number;
  user_reaction: ReactionState;
};
type PlanRatingCache = {
  rating_avg: number;
  rating_count: number;
};

const MAX_PLAN_RATING = 5;

function normalizeReaction(value: unknown): ReactionState {
  return value === 'helpful' ? 'helpful' : null;
}

function normalizeNumericRating(value: unknown): number | null {
  const rating = Number(value);
  return Number.isFinite(rating) && rating > 0 ? rating : null;
}

function clampPlanRating(rating: number) {
  return Math.max(1, Math.min(MAX_PLAN_RATING, Math.round(rating)));
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

function readPlanRating(item: unknown, planId: string): PlanRatingCache | null {
  if (!item || typeof item !== 'object') return null;

  const plan = item as {
    id?: string | null;
    rating_avg?: number | null;
    rating_count?: number | null;
  };

  if (plan.id && plan.id !== planId) return null;

  const ratingAverageRaw = Number(plan.rating_avg);
  const ratingCountRaw = Number(plan.rating_count);

  return {
    rating_avg: Number.isFinite(ratingAverageRaw) ? ratingAverageRaw : 0,
    rating_count: Number.isFinite(ratingCountRaw) ? Math.max(0, ratingCountRaw) : 0,
  };
}

function findRatingInInfiniteData(data: unknown, planId: string): PlanRatingCache | null {
  if (!data || typeof data !== 'object') return null;
  const typed = data as { pages?: unknown[] };
  if (!Array.isArray(typed.pages)) return null;

  for (const page of typed.pages) {
    if (!page || typeof page !== 'object') continue;
    const items = (page as { items?: unknown[] }).items;
    if (!Array.isArray(items)) continue;

    for (const item of items) {
      const rating = readPlanRating(item, planId);
      if (rating) return rating;
    }
  }

  return null;
}

function resolveBaselineRating({
  previousPlan,
  previousPlans,
  previousUserPlans,
  previousSearchPlans,
  planId,
}: {
  previousPlan: unknown;
  previousPlans: [readonly unknown[], unknown][];
  previousUserPlans: [readonly unknown[], unknown][];
  previousSearchPlans: [readonly unknown[], unknown][];
  planId: string;
}): PlanRatingCache {
  const fromPlan = readPlanRating(previousPlan, planId);
  if (fromPlan) return fromPlan;

  for (const [, data] of previousPlans) {
    const fromPlans = findRatingInInfiniteData(data, planId);
    if (fromPlans) return fromPlans;
  }

  for (const [, data] of previousSearchPlans) {
    const fromSearch = findRatingInInfiniteData(data, planId);
    if (fromSearch) return fromSearch;
  }

  for (const [, data] of previousUserPlans) {
    if (!Array.isArray(data)) continue;
    for (const item of data) {
      const fromUserPlans = readPlanRating(item, planId);
      if (fromUserPlans) return fromUserPlans;
    }
  }

  return { rating_avg: 0, rating_count: 0 };
}

function getNextPlanRating({
  currentAverage,
  currentCount,
  previousUserRating,
  nextRating,
}: {
  currentAverage: number;
  currentCount: number;
  previousUserRating: number | null | undefined;
  nextRating: number;
}): PlanRatingCache {
  const safeCount = Math.max(0, currentCount);
  const safeAverage = Number.isFinite(currentAverage) ? currentAverage : 0;
  const normalizedPreviousRating = normalizeNumericRating(previousUserRating);
  const normalizedNextRating = clampPlanRating(nextRating);

  if (normalizedPreviousRating !== null) {
    const nextCount = safeCount > 0 ? safeCount : 1;
    const currentTotal = safeCount > 0 ? safeAverage * safeCount : normalizedPreviousRating;
    const nextAverage = Number(
      ((currentTotal - normalizedPreviousRating + normalizedNextRating) / nextCount).toFixed(2),
    );

    return {
      rating_avg: nextAverage,
      rating_count: nextCount,
    };
  }

  const nextCount = safeCount + 1;
  const nextAverage = Number(
    ((safeAverage * safeCount + normalizedNextRating) / nextCount).toFixed(2),
  );

  return {
    rating_avg: nextAverage,
    rating_count: nextCount,
  };
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

function updatePlanItemRating(item: unknown, planId: string, next: PlanRatingCache) {
  if (!item || typeof item !== 'object') return item;

  const plan = item as {
    id?: string | null;
    rating_avg?: number | null;
    rating_count?: number | null;
  };

  if (plan.id !== planId) return item;

  return {
    ...plan,
    rating_avg: next.rating_avg,
    rating_count: next.rating_count,
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

function updateInfinitePlanPagesRating(data: unknown, planId: string, next: PlanRatingCache) {
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
        items: typedPage.items.map((item) => updatePlanItemRating(item, planId, next)),
      };
    }),
  };
}

export function useTogglePlanReaction(planId: string, userId: string) {
  const qc = useQueryClient();
  const reactionKey = ['plan_reactions', planId, userId] as const;
  const planKey = ['plan', planId] as const;

  return useMutation({
    mutationFn: async () => togglePlanReaction(planId, userId),

    onMutate: async () => {
      await Promise.all([
        qc.cancelQueries({ queryKey: reactionKey }),
        qc.cancelQueries({ queryKey: planKey }),
        qc.cancelQueries({ queryKey: ['discover_plans'] }),
        qc.cancelQueries({ queryKey: ['user_plans'] }),
        qc.cancelQueries({ queryKey: ['search_plans'] }),
      ]);

      const previousReaction = qc.getQueryData<PlanReactionCache>(reactionKey);
      const previousPlan = qc.getQueryData(planKey);
      const previousPlans = qc.getQueriesData({ queryKey: ['discover_plans'] });
      const previousUserPlans = qc.getQueriesData({ queryKey: ['user_plans'] });
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

      qc.setQueriesData({ queryKey: ['discover_plans'] }, (old) =>
        updateInfinitePlanPages(old, planId, delta, nextReaction),
      );
      qc.setQueriesData({ queryKey: ['search_plans'] }, (old) =>
        updateInfinitePlanPages(old, planId, delta, nextReaction),
      );
      qc.setQueriesData({ queryKey: ['user_plans'] }, (old) => {
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
    },
  });
}

export function usePlanRating(planId: string | undefined, userId: string | undefined) {
  const qc = useQueryClient();
  const resolvedPlanId = planId?.trim() || '';
  const resolvedUserId = userId?.trim() || '';
  const ratingKey = [
    'plan-rating',
    resolvedPlanId || 'unknown',
    resolvedUserId || 'guest',
  ] as const;
  const planKey = ['plan', resolvedPlanId] as const;

  const planRatingQuery = useQuery({
    queryKey: ratingKey,
    enabled: !!resolvedPlanId && !!resolvedUserId,
    queryFn: () => fetchMyPlanRating(resolvedPlanId),
  });

  const ratePlanMutation = useMutation({
    mutationFn: async (rating: number) => {
      if (!resolvedPlanId || !resolvedUserId) return;
      await upsertPlanRating({ planId: resolvedPlanId, rating: clampPlanRating(rating) });
    },

    onMutate: async (rating: number) => {
      if (!resolvedPlanId || !resolvedUserId) return;

      const nextRating = clampPlanRating(rating);

      await Promise.all([
        qc.cancelQueries({ queryKey: ratingKey }),
        qc.cancelQueries({ queryKey: planKey }),
        qc.cancelQueries({ queryKey: ['discover_plans'] }),
        qc.cancelQueries({ queryKey: ['user_plans'] }),
        qc.cancelQueries({ queryKey: ['search_plans'] }),
      ]);

      const previousRating = qc.getQueryData<number | null>(ratingKey);
      const previousPlan = qc.getQueryData(planKey);
      const previousPlans = qc.getQueriesData({ queryKey: ['discover_plans'] });
      const previousUserPlans = qc.getQueriesData({ queryKey: ['user_plans'] });
      const previousSearchPlans = qc.getQueriesData({ queryKey: ['search_plans'] });

      const baseline = resolveBaselineRating({
        previousPlan,
        previousPlans,
        previousUserPlans,
        previousSearchPlans,
        planId: resolvedPlanId,
      });
      const nextPlanRating = getNextPlanRating({
        currentAverage: baseline.rating_avg,
        currentCount: baseline.rating_count,
        previousUserRating: previousRating,
        nextRating,
      });

      qc.setQueryData<number | null>(ratingKey, nextRating);
      qc.setQueryData(planKey, (old) => updatePlanItemRating(old, resolvedPlanId, nextPlanRating));

      qc.setQueriesData({ queryKey: ['discover_plans'] }, (old) =>
        updateInfinitePlanPagesRating(old, resolvedPlanId, nextPlanRating),
      );
      qc.setQueriesData({ queryKey: ['search_plans'] }, (old) =>
        updateInfinitePlanPagesRating(old, resolvedPlanId, nextPlanRating),
      );
      qc.setQueriesData({ queryKey: ['user_plans'] }, (old) => {
        if (!Array.isArray(old)) return old;
        return old.map((item) => updatePlanItemRating(item, resolvedPlanId, nextPlanRating));
      });

      return {
        previousRating,
        previousPlan,
        previousPlans,
        previousUserPlans,
        previousSearchPlans,
      };
    },

    onError: (_error, _rating, context) => {
      if (!context) return;

      if (context.previousRating === undefined) {
        qc.removeQueries({ queryKey: ratingKey, exact: true });
      } else {
        qc.setQueryData(ratingKey, context.previousRating);
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
      qc.invalidateQueries({ queryKey: ratingKey });
      qc.invalidateQueries({ queryKey: planKey });
    },
  });

  return {
    planRatingQuery,
    ratePlanMutation,
    currentRating: typeof planRatingQuery.data === 'number' ? planRatingQuery.data : 0,
    ratingLoading: planRatingQuery.isLoading,
    ratingSaving: ratePlanMutation.isPending,
    ratePlan: (rating: number) => {
      if (!resolvedPlanId || !resolvedUserId) return;
      ratePlanMutation.mutate(clampPlanRating(rating));
    },
  };
}

export function useReportPlan(planId: string) {
  return useMutation({
    mutationFn: async (reason: string) => reportPlan(reason, planId),
  });
}
