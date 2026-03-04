/* eslint-disable react-hooks/exhaustive-deps */
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { useDayItemsProgress } from '@/src/hooks/useDayItemsProgress';
import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { useDevotionalDays, usePlanProgress } from '@/src/hooks/usePlanProgress';
import { useAuth } from '@/src/state/AuthContext';
import { BibleBook, useAppStore } from '@/src/state/useAppStore';
import { parseVerseRef, sortByItemKey } from '@/src/utils';
import { useQueryClient } from '@tanstack/react-query';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect, useMemo, useRef, useState } from 'react';

import LoadingSpinner from '@/src/components/LoadingSpinner';
import { usePlanGroupMembers } from '@/src/hooks/usePlanGroup';
import PlanProgressScreen from '@/src/screens/PlanProgressScreen';
import { DayItemsProgress } from '@/src/types/types';
import { Platform, Text, useColorScheme, View } from 'react-native';

dayjs.extend(utc);
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
  const { setSelectedBook, setItemId } = useAppStore();

  const currentDayData = days?.find(
    (d) =>
      dayjs(planProgress?.start_date)
        .startOf('day')
        .add(d.day_number - 1, 'day')
        .format('MMM DD') === dayjs().startOf('day').format('MMM DD'),
  );

  const selectedDay = days?.find((d) => d.day_number === selectedDayNumber);

  const setFromVerseRef = (ref: string, setSelectedBook: (b: BibleBook) => void) => {
    const parsed = parseVerseRef(ref);
    if (!parsed) return;

    setSelectedBook({
      name: parsed.book,
      chapter: parsed.chapter,
      verseEnd: parsed.verseEnd,
      verseStart: parsed.verseStart,
    });
  };
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
  const [pendingToggleItemId, setPendingToggleItemId] = useState<string | null>(null);
  const devotional = dayItemsProgress?.items.find((item) => item.item_type === 'devotional');
  const planTitle = plan?.title ?? 'Plan Progress';
  const planTotalDays = plan?.total_days ?? days?.length ?? 0;

  useEffect(() => {
    if (!planProgress || !plan) return;
    const completedOnce = !!planProgress.completed_once;
    const planId = plan.id;
    if (!planId) return;

    if (prevCompletedOnce.current === null) {
      prevCompletedOnce.current = completedOnce;
      return;
    }

    const justCompletedFirstTime = prevCompletedOnce.current === false && completedOnce === true;

    if (justCompleted) {
      const planKey = ['plan', plan.id] as const;
      void Promise.all([
        qc.invalidateQueries({ queryKey: planKey }),
        qc.invalidateQueries({ queryKey: ['plans'] }),
        qc.invalidateQueries({ queryKey: ['user-plans'] }),
        qc.invalidateQueries({ queryKey: ['search_plans'] }),
      ]);

      router.replace({
        pathname: `/plan_progress/[progressId]/plan-complete`,
        params: { progressId: planProgress.id, planId },
      });
    }

    prevCompletedOnce.current = completedOnce;
  }, [planProgress?.completed_once, planProgress?.id, plan?.id]);

  useEffect(() => {
    setSelectedDay(currentDayData?.day_number || 1);
  }, [currentDayData]);

  const missedDays = useMemo(() => {
    if (!planProgress || !plan) return null;
    return days?.filter((d) => {
      if (currentDayData) {
        return (
          !planProgress?.completed_days?.includes(d.day_number) &&
          d.day_number < currentDayData?.day_number
        );
      }

      return (
        !planProgress?.completed_days?.includes(d.day_number) &&
        dayjs(planProgress.start_date)
          .add(d.day_number - 1, 'day')
          .diff(dayjs().utc().startOf('day'), 'day') < 0
      );
    });
  }, [planProgress, currentDayData, plan]);

  function handleItemPress(item: DayItemsProgress) {
    setItemId(item.id);

    if (item.item_type === 'scripture') {
      setFromVerseRef(item.item_key || '', setSelectedBook);
    }

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
        toggleLoadingItemId={pendingToggleItemId}
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
          setPendingToggleItemId(item.id);
          toggleMutation.mutate(
            {
              item_type: item.item_type as 'scripture' | 'devotional',
              item_key: item.item_key as string,
              completed: !item.completed,
            },
            {
              onSettled: () => setPendingToggleItemId(null),
            },
          );
        }}
        devotionalItem={devotional}
      />
    </>
  );
}
