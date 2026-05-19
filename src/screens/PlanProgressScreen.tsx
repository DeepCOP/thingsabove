import BottomSheet from '@gorhom/bottom-sheet';
import { useIsFocused } from '@react-navigation/native';
import { useCallback, useEffect, useRef } from 'react';
import { RefreshControl, ScrollView, Text, View } from 'react-native';

import DayCommentsSection from '@/src/components/DayComment';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { DayItemsList } from '@/src/components/planProgress/DayItemsList';
import { DaysCarousel } from '@/src/components/planProgress/DaysCarousel';
import { GroupAvatarsRow } from '@/src/components/planProgress/GroupAvatarRow';
import { PlanHeader } from '@/src/components/planProgress/PlanHeader';
import { PlanMetaRow } from '@/src/components/planProgress/PlanMetaRow';
import { StartReadingCTA } from '@/src/components/planProgress/StartReadingCTA';
import { DayItemsProgress, DevotionalDays, PlanGroupMember, PlanProgress } from '@/src/types/types';

type Props = {
  insetsBottom: number;
  coverImage?: string;
  completions?: number;
  visibility?: string | null;
  days: DevotionalDays[];
  selectedDay: number;
  currentDayId?: string;
  totalDays: number;
  planProgress: PlanProgress;
  missedCount?: number;
  members?: PlanGroupMember[];
  memberProgresses?: PlanProgress[];
  items?: DayItemsProgress[];
  selectedDayData: DevotionalDays | undefined;
  itemsLoading: boolean;
  refreshing: boolean;
  toggleLoading: boolean;
  onSelectDay: (day: number) => void;
  onRefresh: () => void;
  onMissedDays: () => void;
  onParticipants: () => void;
  onPressItem: (item: DayItemsProgress) => void;
  onToggleItem: (item: DayItemsProgress) => void;
  devotionalItem?: DayItemsProgress;
  openCommentsKey?: string;
  onOpenCommentsConsumed?: () => void;
};

export default function PlanProgressScreen({
  insetsBottom,
  coverImage,
  completions,
  visibility,
  days,
  selectedDay,
  selectedDayData,
  currentDayId,
  planProgress,
  totalDays,
  missedCount,
  members,
  memberProgresses,
  items,
  itemsLoading,
  refreshing,
  toggleLoading,
  onSelectDay,
  onRefresh,
  onMissedDays,
  onParticipants,
  onPressItem,
  onToggleItem,
  devotionalItem,
  openCommentsKey,
  onOpenCommentsConsumed,
}: Props) {
  const commentsSheetRef = useRef<BottomSheet>(null);
  const openedCommentsKeyRef = useRef<string | undefined>(undefined);
  const isFocused = useIsFocused();
  const isGroupPlan = Boolean(planProgress.group_id);
  console.log(planProgress.group_id);
  const openComments = useCallback(() => {
    if (!isGroupPlan) return false;

    const commentsSheet = commentsSheetRef.current;
    if (!commentsSheet) return false;

    commentsSheet.expand();
    return true;
  }, [isGroupPlan]);
  const commentItem = items?.find((item) => item.item_type === 'comment');

  const handleCommentsDone = () => {
    if (!commentItem || toggleLoading) return;

    if (!commentItem.completed) {
      onToggleItem(commentItem);
    }

    commentsSheetRef.current?.close();
  };

  useEffect(() => {
    if (
      !isGroupPlan ||
      !isFocused ||
      !openCommentsKey ||
      openedCommentsKeyRef.current === openCommentsKey
    ) {
      return;
    }

    let cancelled = false;
    let animationFrame: number | null = null;
    let attempts = 0;
    const maxAttempts = 10;

    const tryOpenComments = () => {
      if (cancelled) return;

      if (openComments()) {
        openedCommentsKeyRef.current = openCommentsKey;
        onOpenCommentsConsumed?.();
        return;
      }

      if (attempts < maxAttempts) {
        attempts += 1;
        animationFrame = requestAnimationFrame(tryOpenComments);
      }
    };

    animationFrame = requestAnimationFrame(tryOpenComments);

    return () => {
      cancelled = true;
      if (animationFrame !== null) {
        cancelAnimationFrame(animationFrame);
      }
    };
  }, [isFocused, isGroupPlan, onOpenCommentsConsumed, openComments, openCommentsKey]);
  console.log(members, isGroupPlan);

  return (
    <>
      <ScrollView
        className="flex-1 bg-white dark:bg-black"
        style={{ marginBottom: insetsBottom + 70 }}
        contentContainerStyle={{ paddingTop: 16 }}
        alwaysBounceVertical
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor="#2563eb" />
        }>
        <PlanHeader
          coverImage={coverImage}
          selectedDay={selectedDay}
          completions={completions}
          visibility={visibility}
        />

        <DaysCarousel
          days={days}
          selectedDay={selectedDay}
          currentDayId={currentDayId}
          completedDays={planProgress.completed_days || []}
          startDate={planProgress.start_date || ''}
          onSelectDay={onSelectDay}
        />

        <PlanMetaRow
          day={selectedDay}
          totalDays={totalDays}
          missedCount={missedCount}
          onMissedDays={onMissedDays}
        />

        {!!members?.length && (
          <GroupAvatarsRow
            members={members}
            progresses={memberProgresses}
            completedDay={selectedDay}
            onPress={onParticipants}
          />
        )}

        {itemsLoading ? (
          <LoadingSpinner />
        ) : items ? (
          <DayItemsList
            items={items}
            onPressItem={(item) => {
              if (item.item_type === 'comment') {
                if (isGroupPlan) {
                  openComments();
                }
                return;
              }

              onPressItem(item);
            }}
            onToggle={(item) => onToggleItem(item)}
            toggleLoading={toggleLoading}
          />
        ) : (
          <View className="items-center justify-center py-10">
            <Text>No items found</Text>
          </View>
        )}
      </ScrollView>

      <StartReadingCTA
        bottomInset={insetsBottom}
        visible={!!items?.length}
        onPress={() => devotionalItem && onPressItem(devotionalItem)}
      />

      {isGroupPlan && (
        <DayCommentsSection
          ref={commentsSheetRef}
          planId={planProgress.plan_id || ''}
          dayId={selectedDayData?.id || ''}
          group_id={planProgress.group_id || ''}
          isDoneLoading={toggleLoading}
          onDone={handleCommentsDone}
        />
      )}
    </>
  );
}
