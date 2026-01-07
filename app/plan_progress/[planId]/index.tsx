/* eslint-disable react-hooks/exhaustive-deps */
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import DayCommentsSection from '@/components/DayComment';
import { useAuth } from '@/context/AuthContext';
import { useDayItemsProgress } from '@/hooks/useDayItemsProgress';
import { useFetchDevotionalPlanById } from '@/hooks/useDevotionalPlans';
import { useDevotionalDays, usePlanProgress } from '@/hooks/usePlanProgress';
import { BibleBook, useAppStore } from '@/store/useAppStore';
import { parseVerseRef, sortByItemKey } from '@/utils/utils';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect, useMemo, useRef, useState } from 'react';

import LoadingSpinner from '@/components/LoadingSpinner';
import { DayItemsList } from '@/components/planProgress/DayItemsList';
import { DaysCarousel } from '@/components/planProgress/DaysCarousel';
import { GroupAvatarsRow } from '@/components/planProgress/GroupAvatarRow';
import { PlanHeader } from '@/components/planProgress/PlanHeader';
import { PlanMetaRow } from '@/components/planProgress/PlanMetaRow';
import { StartReadingCTA } from '@/components/planProgress/StartReadingCTA';
import { usePlanGroupMembers } from '@/hooks/usePlanGroup';
import { DayItemsProgress } from '@/types/types';
import { BottomSheetModal } from '@gorhom/bottom-sheet';
import { ScrollView, Text, View } from 'react-native';

dayjs.extend(utc);
export default function PlanProgressScreen() {
  const commentsSheetRef = useRef<BottomSheetModal>(null);
  const insets = useSafeAreaInsets();
  const { planId, groupId } = useLocalSearchParams(); // plan ID
  const router = useRouter();
  const { setMissedDays } = useAppStore();
  const { session, loading: sessionLoading } = useAuth();
  const { planProgressQuery } = usePlanProgress(
    planId as string,
    session?.user?.id as string,
    groupId as string,
  );
  const daysQuery = useDevotionalDays(planId as string, session?.user?.id as string);
  const planGroupMembersQuery = usePlanGroupMembers(groupId as string);
  const planProgress = planProgressQuery.data;
  const days = daysQuery.data;
  const planQuery = useFetchDevotionalPlanById(planId as string);
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
  const { dayItemsProgressQuery, toggleMutation, loadItems, loadingItems } = useDayItemsProgress({
    user_id: session?.user?.id!,
    plan_id: planId as string,
    day_id: selectedDay?.id || '',
    group_id: groupId as string,
  });

  const dayItemsProgress = useMemo(() => {
    if (!dayItemsProgressQuery?.data) return null;
    const data = dayItemsProgressQuery?.data;

    return {
      items: [...data].sort((a, b) => sortByItemKey(a.item_key, b.item_key)),
    };
  }, [dayItemsProgressQuery?.data]);

  const prevCompletedCount = useRef<number | null>(null);
  const devotional = dayItemsProgress?.items.find((item) => item.item_type === 'devotional');

  useEffect(() => {
    if (!planProgress || !plan) return;

    const completedCount = planProgress.completed_days?.length ?? 0;

    if (prevCompletedCount.current === null) {
      prevCompletedCount.current = completedCount;
      return;
    }

    const justCompleted =
      prevCompletedCount.current < plan.total_days && completedCount === plan.total_days;

    if (justCompleted) {
      router.replace(`/plan_progress/${plan.id}/plan-complete`);
    }

    prevCompletedCount.current = completedCount;
  }, [planProgress?.completed_days?.length, plan?.total_days]);

  useEffect(() => {
    setSelectedDay(currentDayData?.day_number || 1);
  }, [currentDayData]);

  useEffect(() => {
    if (dayItemsProgress?.items || loadingItems) {
      return;
    }
    loadItems.mutate();
  }, [dayItemsProgress]);

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
    console.log(item.item_key, item.item_type);

    if (item.item_type === 'scripture') {
      setFromVerseRef(item.item_key || '', setSelectedBook);
    }

    router.push({
      pathname: `/devotional_detail/[id]/[dayId]/[itemId]`,
      params: {
        groupId: groupId,
        id: plan?.id || '',
        dayId: selectedDay?.id || '',
        itemId: item.id || '',
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
          title: plan?.title || 'Plan Progress',
        }}
      />
      <ScrollView
        className="flex-1 bg-white dark:bg-black"
        style={{ marginBottom: insets.bottom + 70 }}>
        <PlanHeader
          title={plan.title}
          coverImage={plan.cover_image || undefined}
          selectedDay={selectedDayNumber}
        />

        <DaysCarousel
          days={days}
          selectedDay={selectedDayNumber}
          currentDayId={currentDayData?.id}
          completedDays={planProgress.completed_days ?? []}
          startDate={planProgress.start_date ?? ''}
          onSelectDay={setSelectedDay}
        />

        <PlanMetaRow
          day={selectedDayNumber}
          totalDays={days.length}
          missedCount={missedDays?.length}
          onComments={() => commentsSheetRef.current?.expand()}
          onMissedDays={() => {
            setMissedDays(missedDays ?? []);
            router.push(`/plan_progress/${planId}/missedDays`);
          }}
        />

        {!planGroupMembersQuery.isLoading && planGroupMembersQuery.data && (
          <GroupAvatarsRow
            members={planGroupMembersQuery.data}
            onPress={() =>
              router.push({
                pathname: `/devotional_detail/[id]/participants`,
                params: {
                  groupId: groupId,
                  totalDays: plan.total_days,
                  id: planId as string,
                },
              })
            }
          />
        )}

        {dayItemsProgress ? (
          <DayItemsList
            items={dayItemsProgress.items}
            onPressItem={handleItemPress}
            onToggle={(item) =>
              toggleMutation.mutate({
                item_type: item.item_type,
                item_key: item.item_key,
                completed: !item.completed,
              })
            }
            toggleLoading={toggleMutation.isPending}
          />
        ) : (
          <LoadingSpinner />
        )}
      </ScrollView>

      <StartReadingCTA
        bottomInset={insets.bottom}
        visible={!!dayItemsProgress?.items?.length}
        onPress={() => {
          if (!devotional) return;
          handleItemPress(devotional || ({} as any));
        }}
      />

      <DayCommentsSection
        ref={commentsSheetRef}
        planId={planId as string}
        dayId={selectedDay?.id || ''}
        group_id={groupId as string}
      />
    </>
  );
}
