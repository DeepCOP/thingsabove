import BottomSheet from '@gorhom/bottom-sheet';
import { useRef } from 'react';
import { RefreshControl, ScrollView, Text, View } from 'react-native';

import DayCommentsSection from '@/src/components/DayComment';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { DayItemsList } from '@/src/components/planProgress/DayItemsList';
import { DaysCarousel } from '@/src/components/planProgress/DaysCarousel';
import { GroupAvatarsRow } from '@/src/components/planProgress/GroupAvatarRow';
import { PlanHeader } from '@/src/components/planProgress/PlanHeader';
import { PlanMetaRow } from '@/src/components/planProgress/PlanMetaRow';
import { StartReadingCTA } from '@/src/components/planProgress/StartReadingCTA';
import { DayItemsProgress, DevotionalDays, PlanProgress } from '@/src/types/types';

type Props = {
  insetsBottom: number;
  coverImage?: string;
  completions?: number;
  visibility?: string | null;
  days: any[];
  selectedDay: number;
  currentDayId?: string;
  totalDays: number;
  planProgress: PlanProgress;
  missedCount?: number;
  members?: any[];
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
}: Props) {
  const commentsSheetRef = useRef<BottomSheet>(null);
  const openComments = () => commentsSheetRef.current?.expand();

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

        {!!members?.length && <GroupAvatarsRow members={members} onPress={onParticipants} />}

        {itemsLoading ? (
          <LoadingSpinner />
        ) : items ? (
          <DayItemsList
            items={items}
            onPressItem={(item) => {
              if (item.item_type === 'comment') {
                openComments();
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

      <DayCommentsSection
        ref={commentsSheetRef}
        planId={planProgress.plan_id || ''}
        dayId={selectedDayData?.id || ''}
        group_id={planProgress.group_id || ''}
      />
    </>
  );
}
