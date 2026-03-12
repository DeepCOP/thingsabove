// hooks/useDayItemsProgress.ts
import { toggleDayCompletion, toggleItemCompletion } from '@/src/api/mutations';
import { fetchDayItems } from '@/src/api/queries';
import { DayItemsProgress, PlanProgress } from '@/src/types/types';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

interface Params {
  user_id: string;
  plan_id: string;
  progress_id: string;
  day_id: string;
  group_id?: string | null;
}

export function useDayItemsProgress({ user_id, plan_id, progress_id, day_id, group_id }: Params) {
  const queryClient = useQueryClient();
  const normalizedGroupId =
    group_id && group_id !== 'null' && group_id !== 'undefined' ? group_id : undefined;
  const getDayItemsKey = (targetDayId: string) =>
    ['day_items_progress', user_id, progress_id, targetDayId, normalizedGroupId] as const;
  const planProgressKey = ['plan_progress', progress_id, user_id] as const;
  const userPlansKey = ['user_plans_progresses', user_id] as const;

  const updateDayItemsForItem = (
    items: DayItemsProgress[] | undefined,
    item_id: string,
    completed: boolean,
  ) => {
    if (!items) return items;
    return items.map((item) => (item.id === item_id ? { ...item, completed } : item));
  };

  const updateDayItemsForDay = (items: DayItemsProgress[] | undefined, completed: boolean) => {
    if (!items) return items;
    return items.map((item) => ({ ...item, completed }));
  };

  const resolveDayNumber = (items: DayItemsProgress[] | undefined) => {
    if (!items) return null;
    const match = items.find((item) => typeof item.day_number === 'number');
    return match?.day_number ?? null;
  };

  const isDayComplete = (items: DayItemsProgress[] | undefined) => {
    if (!items || items.length === 0) return false;
    return items.every((item) => item.completed === true);
  };

  const updatePlanProgressCompletedDays = (
    progress: PlanProgress | undefined,
    dayNumber: number,
    completed: boolean,
  ) => {
    if (!progress) return progress;
    const prevDays = progress.completed_days ?? [];
    const hasDay = prevDays.includes(dayNumber);
    const nextDays = completed
      ? hasDay
        ? prevDays
        : [...prevDays, dayNumber]
      : prevDays.filter((day) => day !== dayNumber);
    return { ...progress, completed_days: nextDays };
  };

  const updateUserPlansProgresses = (
    list: PlanProgress[] | undefined,
    dayNumber: number,
    completed: boolean,
  ) => {
    if (!Array.isArray(list)) return list;
    return list.map((progress) =>
      progress.id === progress_id
        ? (updatePlanProgressCompletedDays(progress, dayNumber, completed) as PlanProgress)
        : progress,
    );
  };

  // Load completed items
  const dayItemsProgressQuery = useQuery({
    queryKey: getDayItemsKey(day_id),
    enabled: !!day_id && !!progress_id && !!user_id,
    queryFn: async () => {
      const data = await fetchDayItems({
        user_id,
        plan_id,
        progress_id,
        day_id,
        groupId: normalizedGroupId,
      });
      return data;
    },
  });

  // Toggle completion (using RPC)
  const toggleMutation = useMutation({
    mutationFn: async ({
      item_id,
      item_type,
      item_key,
      completed,
    }: {
      item_id: string;
      item_type: 'devotional' | 'scripture';
      item_key: string;
      completed: boolean;
    }) => {
      return toggleItemCompletion({
        item_key,
        item_type,
        completed,
        user_id,
        plan_id,
        progress_id,
        day_id,
        groupId: normalizedGroupId,
      });
    },

    onMutate: async (variables) => {
      const dayItemsKey = getDayItemsKey(day_id);

      await Promise.all([
        queryClient.cancelQueries({ queryKey: dayItemsKey }),
        queryClient.cancelQueries({ queryKey: planProgressKey }),
        queryClient.cancelQueries({ queryKey: userPlansKey }),
      ]);

      const previousDayItems = queryClient.getQueryData<DayItemsProgress[]>(dayItemsKey);
      const previousPlanProgress = queryClient.getQueryData<PlanProgress>(planProgressKey);
      const previousUserPlans = queryClient.getQueryData<PlanProgress[]>(userPlansKey);

      const nextDayItems = updateDayItemsForItem(
        previousDayItems,
        variables.item_id,
        variables.completed,
      );
      queryClient.setQueryData(dayItemsKey, nextDayItems);

      const dayNumber = resolveDayNumber(nextDayItems);
      if (dayNumber !== null) {
        const completed = isDayComplete(nextDayItems);
        queryClient.setQueryData(
          planProgressKey,
          updatePlanProgressCompletedDays(previousPlanProgress, dayNumber, completed),
        );
        queryClient.setQueryData(
          userPlansKey,
          updateUserPlansProgresses(previousUserPlans, dayNumber, completed),
        );
      }

      return {
        dayItemsKey,
        previousDayItems,
        previousPlanProgress,
        previousUserPlans,
      };
    },
    onError: (error, _variables, context) => {
      console.error('Error toggling item completion:', error);
      if (!context) return;

      if (context.previousDayItems === undefined) {
        queryClient.removeQueries({ queryKey: context.dayItemsKey, exact: true });
      } else {
        queryClient.setQueryData(context.dayItemsKey, context.previousDayItems);
      }

      if (context.previousPlanProgress === undefined) {
        queryClient.removeQueries({ queryKey: planProgressKey, exact: true });
      } else {
        queryClient.setQueryData(planProgressKey, context.previousPlanProgress);
      }

      if (context.previousUserPlans === undefined) {
        queryClient.removeQueries({ queryKey: userPlansKey, exact: true });
      } else {
        queryClient.setQueryData(userPlansKey, context.previousUserPlans);
      }
    },
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: getDayItemsKey(day_id) });
      queryClient.invalidateQueries({ queryKey: planProgressKey });
    },
  });

  const toggleDayCompletionMutation = useMutation({
    mutationFn: async ({ completed, day_id }: { completed: boolean; day_id: string }) =>
      toggleDayCompletion({
        completed,
        user_id,
        plan_id,
        progress_id,
        day_id,
        groupId: normalizedGroupId,
      }),

    onMutate: async (variables) => {
      const targetDayId = variables.day_id || day_id;
      const dayItemsKey = getDayItemsKey(targetDayId);

      await Promise.all([
        queryClient.cancelQueries({ queryKey: dayItemsKey }),
        queryClient.cancelQueries({ queryKey: planProgressKey }),
        queryClient.cancelQueries({ queryKey: userPlansKey }),
      ]);

      const previousDayItems = queryClient.getQueryData<DayItemsProgress[]>(dayItemsKey);
      const previousPlanProgress = queryClient.getQueryData<PlanProgress>(planProgressKey);
      const previousUserPlans = queryClient.getQueryData<PlanProgress[]>(userPlansKey);

      const nextDayItems = updateDayItemsForDay(previousDayItems, variables.completed);
      queryClient.setQueryData(dayItemsKey, nextDayItems);

      const dayNumber = resolveDayNumber(nextDayItems);
      if (dayNumber !== null) {
        queryClient.setQueryData(
          planProgressKey,
          updatePlanProgressCompletedDays(previousPlanProgress, dayNumber, variables.completed),
        );
        queryClient.setQueryData(
          userPlansKey,
          updateUserPlansProgresses(previousUserPlans, dayNumber, variables.completed),
        );
      }

      return {
        dayItemsKey,
        previousDayItems,
        previousPlanProgress,
        previousUserPlans,
      };
    },
    onError: (error, _variables, context) => {
      console.error('Error toggling item completion:', error);
      if (!context) return;

      if (context.previousDayItems === undefined) {
        queryClient.removeQueries({ queryKey: context.dayItemsKey, exact: true });
      } else {
        queryClient.setQueryData(context.dayItemsKey, context.previousDayItems);
      }

      if (context.previousPlanProgress === undefined) {
        queryClient.removeQueries({ queryKey: planProgressKey, exact: true });
      } else {
        queryClient.setQueryData(planProgressKey, context.previousPlanProgress);
      }

      if (context.previousUserPlans === undefined) {
        queryClient.removeQueries({ queryKey: userPlansKey, exact: true });
      } else {
        queryClient.setQueryData(userPlansKey, context.previousUserPlans);
      }
    },
    onSettled: (_data, _error, variables) => {
      const targetDayId = variables?.day_id || day_id;
      queryClient.invalidateQueries({ queryKey: getDayItemsKey(targetDayId) });
      queryClient.invalidateQueries({ queryKey: planProgressKey });
    },
  });

  const toggleItem = (
    item_id: string,
    type: 'devotional' | 'scripture',
    key: string,
    completed: boolean,
  ) => {
    toggleMutation.mutate({ item_id, item_type: type, item_key: key, completed });
  };

  return {
    dayItemsProgressQuery,
    toggleMutation,
    toggleDayCompletion: toggleDayCompletionMutation,
    toggleItem,
  };
}
