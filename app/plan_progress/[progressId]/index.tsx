/* eslint-disable react-hooks/exhaustive-deps */
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { useDayItemsProgress } from '@/src/hooks/useDayItemsProgress';
import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { useDevotionalDays, usePlanProgress } from '@/src/hooks/usePlanProgress';
import dayjs from '@/src/lib/dayjs';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import {
  incrementPlanCompletions,
  incrementPlanCompletionsInInfiniteData,
  sortByItemKey,
} from '@/src/utils';
import { useQueryClient } from '@tanstack/react-query';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect, useMemo, useRef, useState } from 'react';

import LoadingSpinner from '@/src/components/LoadingSpinner';
import { usePlanGroupMembers } from '@/src/hooks/usePlanGroup';
import PlanProgressScreen from '@/src/screens/PlanProgressScreen';
import { DayItemsProgress } from '@/src/types/types';
import { Platform, Text, useColorScheme, View } from 'react-native';

export default function PlanProgress() {
  const colorScheme = useColorScheme();

  const insets = useSafeAreaInsets();
  const { progressId } = useLocalSearchParams();
  const router = useRouter();
  const qc = useQueryClient();
  const { setMissedDays } = useAppStore();
  const { session, loading: sessionLoading } = useAuth();
  const { planProgressQuery } = usePlanProgress(progressId as string, session?.user?.id as string);
  const daysQuery = useDevotionalDays(
    planProgressQuery.data?.plan_id as string,
    session?.user?.id as string,
  );
  const planGroupMembersQuery = usePlanGroupMembers(planProgressQuery.data?.group_id as string);
  const planProgress = planProgressQuery.data;
  const days = daysQuery.data;
  const planQuery = useFetchDevotionalPlanById(planProgress?.plan_id as string);
  const plan = planQuery.data;
  const [selectedDayNumber, setSelectedDay] = useState<number>(1);
  const today = dayjs().startOf('day');
  const planStartDate = planProgress?.start_date
    ? dayjs(planProgress.start_date).startOf('day')
    : null;

  const currentDayData = planStartDate
    ? days?.find((d) => planStartDate.add(d.day_number - 1, 'day').isSame(today, 'day'))
    : undefined;

  const selectedDay = days?.find((d) => d.day_number === selectedDayNumber);

  const { dayItemsProgressQuery, toggleMutation } = useDayItemsProgress({
    user_id: session?.user?.id!,
    plan_id: planProgress?.plan_id as string,
    progress_id: progressId as string,
    day_id: selectedDay?.id || '',
    group_id: planProgress?.group_id as string,
  });

  const dayItemsProgress = useMemo(() => {
    if (!dayItemsProgressQuery?.data) return null;
    const data = dayItemsProgressQuery?.data;

    return {
      items: [...data].sort((a, b) => sortByItemKey(a.item_key, b.item_key)),
    };
  }, [dayItemsProgressQuery?.data]);

  const prevCompletedOnce = useRef<boolean | null>(null);
  const prevPlanComplete = useRef<boolean | null>(null);
  const devotional = dayItemsProgress?.items.find((item) => item.item_type === 'devotional');
  const planTitle = plan?.title ?? 'Plan Progress';
  const planTotalDays = plan?.total_days ?? days?.length ?? 0;

  useEffect(() => {
    if (!planProgress || !plan) return;
    const completedOnce = !!planProgress.completed_once;
    const completedDaysCount = planProgress.completed_days?.length ?? 0;
    const isPlanComplete = planTotalDays > 0 && completedDaysCount >= planTotalDays;
    const planId = plan.id;
    if (!planId) return;

    const hasPrevCompletedOnce = prevCompletedOnce.current !== null;
    const hasPrevPlanComplete = prevPlanComplete.current !== null;
    const justMarkedCompletedOnce =
      hasPrevCompletedOnce && prevCompletedOnce.current === false && completedOnce === true;
    const justCompleted =
      hasPrevPlanComplete && prevPlanComplete.current === false && isPlanComplete === true;

    if (justMarkedCompletedOnce) {
      const planId = plan.id;
      if (!planId) return;

      const planKey = ['plan', planId] as const;
      qc.setQueryData(planKey, (old: unknown) => incrementPlanCompletions(old, planId));
      qc.setQueriesData({ queryKey: ['discover_plans'] }, (old: unknown) =>
        incrementPlanCompletionsInInfiniteData(old, planId),
      );
      void qc.invalidateQueries({ queryKey: ['search_plans'] });
      void qc.invalidateQueries({ queryKey: planKey });
    }

    if (justCompleted) {
      router.replace({
        pathname: `/plan_progress/[progressId]/plan-complete`,
        params: { progressId: planProgress.id, planId },
      });
    }

    prevCompletedOnce.current = completedOnce;
    prevPlanComplete.current = isPlanComplete;
  }, [
    planProgress?.completed_days?.length,
    planProgress?.completed_once,
    planProgress?.id,
    plan?.id,
    planTotalDays,
  ]);

  useEffect(() => {
    setSelectedDay(currentDayData?.day_number || 1);
  }, [currentDayData]);

  const missedDays = useMemo(() => {
    if (!planProgress || !plan || !planStartDate) return null;
    return days?.filter((d) => {
      if (currentDayData) {
        return (
          !planProgress?.completed_days?.includes(d.day_number) &&
          d.day_number < currentDayData?.day_number
        );
      }

      return (
        !planProgress?.completed_days?.includes(d.day_number) &&
        planStartDate.add(d.day_number - 1, 'day').diff(today, 'day') < 0
      );
    });
  }, [planProgress, currentDayData, plan, planStartDate, today.valueOf(), days]);

  function handleItemPress(item: DayItemsProgress) {
    router.push({
      pathname: `/devotional_detail/[id]/[dayId]/[itemId]`,
      params: {
        progressId: progressId,
        id: plan?.id || '',
        dayId: selectedDay?.id || '',
        itemId: item.id || '',
        groupId: planProgress?.group_id as string,
      },
    });
  }

  if (planProgressQuery.isLoading || daysQuery.isLoading || planQuery.isLoading || sessionLoading) {
    return <LoadingSpinner />;
  }

  if (!planProgress || !days || !plan) {
    return (
      <View className="flex-1 justify-center items-center">
        <Text>Plan not found</Text>
      </View>
    );
  }

  return (
    <>
      <Stack.Screen
        options={{
          title: planTitle,
          headerTransparent: true,
          headerBlurEffect:
            Platform.OS === 'ios'
              ? colorScheme === 'dark'
                ? 'systemMaterialDark'
                : 'systemMaterialLight'
              : undefined,
          headerStyle: {
            backgroundColor:
              Platform.OS === 'ios'
                ? 'transparent'
                : colorScheme === 'dark'
                  ? 'rgba(0, 0, 0, 0.65)'
                  : 'rgba(255, 255, 255, 0.65)',
          },
        }}
      />

      <PlanProgressScreen
        insetsBottom={insets.bottom}
        insetsTop={insets.top}
        title={planTitle}
        coverImage={plan.cover_image || undefined}
        completions={plan.completions ?? 0}
        days={days}
        selectedDay={selectedDayNumber}
        selectedDayData={selectedDay}
        currentDayId={currentDayData?.id}
        totalDays={planTotalDays}
        missedCount={missedDays?.length || 0}
        members={planGroupMembersQuery.data}
        items={dayItemsProgress?.items}
        itemsLoading={dayItemsProgressQuery.isLoading}
        toggleLoading={toggleMutation.isPending}
        planProgress={planProgress}
        onSelectDay={setSelectedDay}
        onComments={() => {}}
        onMissedDays={() => {
          setMissedDays(missedDays || []);
          router.push(`/plan_progress/${progressId}/missedDays`);
        }}
        onParticipants={() =>
          router.push({
            pathname: `/devotional_detail/[id]/participants`,
            params: {
              id: plan.id ?? '',
              groupId: planProgress.group_id,
              totalDays: planTotalDays,
              progressId: planProgress.id,
            },
          })
        }
        onPressItem={handleItemPress}
        onToggleItem={(item) => {
          toggleMutation.mutate({
            item_id: item.id,
            item_type: item.item_type as 'scripture' | 'devotional',
            item_key: item.item_key as string,
            completed: !item.completed,
          });
        }}
        devotionalItem={devotional}
      />
    </>
  );
}
