import LoadingSpinner from '@/src/components/LoadingSpinner';
import PlanCoverImage from '@/src/components/PlanCoverImage';
import PlanVisibilityBadge from '@/src/components/PlanVisibilityBadge';
import { RelatedPlansSection } from '@/src/components/RelatedPlans';
import { Ionicons } from '@expo/vector-icons';
import BottomSheet from '@gorhom/bottom-sheet';
import { ComponentProps, useRef, useState } from 'react';
import {
  ActivityIndicator,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
  useColorScheme,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import ReportPlanSheet from '../components/ReportPlanModal';
import StartPlanBottomSheet from '../components/StartPlanBottomSheet';
import { useAuth } from '../state/AuthContext';
import { DayItemTemplate, DevotionalDays } from '../types/types';

type IconName = ComponentProps<typeof Ionicons>['name'];

type Props = {
  onReportPress: () => void;
  handleToggleReaction: () => void;
  currentReaction:
    | {
        helpful_count: number;
        user_reaction: 'helpful' | null;
      }
    | undefined;
  reportSheetRef: React.RefObject<BottomSheet | null>;
  plan: any;
  isLoading: boolean;
  previewDays: DevotionalDays[];
  selectedPreviewDay: number;
  selectedPreviewDayData?: DevotionalDays;
  previewItems: DayItemTemplate[];
  previewItemsLoading: boolean;
  hasActiveSoloPlanProgress: boolean;
  hasActivePlanProgress: boolean;
  canStartPlan: boolean;
  isPrivatePlan: boolean;
  isStartingSoloPlan: boolean;
  onSelectPreviewDay: (dayNumber: number) => void;
  onStartPress: (mode: 'solo' | 'group') => void;
  onContinuePress: () => void;
  isSaved: boolean;
  onToggleSave: () => void;
};

function getItemIcon(item: DayItemTemplate): IconName {
  if (item.item_type === 'devotional') return 'document-text-outline';
  if (item.item_type === 'comment') return 'chatbubble-ellipses-outline';

  return 'book-outline';
}

function getItemLabel(item: DayItemTemplate) {
  if (item.item_type === 'devotional') return item.title?.trim() || 'Devotional';
  if (item.item_type === 'comment') return 'Reflection';

  return item.item_key || 'Scripture';
}

function getItemSubtitle(item: DayItemTemplate) {
  if (item.item_type === 'devotional') return 'Devotional reading';
  if (item.item_type === 'comment') return 'Notes and reflection';

  return 'Scripture';
}

const decodeHtmlEntities = (value: string) =>
  value
    .replace(/&nbsp;/g, ' ')
    .replace(/&amp;/g, '&')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'");

const getHtmlExcerpt = (html?: string | null, maxLength = 220) => {
  if (!html) return '';

  const text = decodeHtmlEntities(
    html
      .replace(/<br\s*\/?>/gi, ' ')
      .replace(/<\/p>/gi, ' ')
      .replace(/<[^>]+>/g, ' ')
      .replace(/\s+/g, ' ')
      .trim(),
  );

  if (text.length <= maxLength) return text;

  const truncated = text.slice(0, maxLength).trimEnd();
  const lastSpace = truncated.lastIndexOf(' ');

  return `${truncated.slice(0, lastSpace > 120 ? lastSpace : truncated.length)}...`;
};

function PlanPreviewSection({
  days,
  selectedDay,
  selectedDayData,
  items,
  itemsLoading,
  onSelectDay,
}: {
  days: DevotionalDays[];
  selectedDay: number;
  selectedDayData?: DevotionalDays;
  items: DayItemTemplate[];
  itemsLoading: boolean;
  onSelectDay: (dayNumber: number) => void;
}) {
  const colorScheme = useColorScheme();
  const [readingsExpanded, setReadingsExpanded] = useState(false);
  const devotionalItem = items.find((item) => item.item_type === 'devotional');
  const scriptureCount = items.filter((item) => item.item_type === 'scripture').length;
  const devotionalExcerpt = getHtmlExcerpt(devotionalItem?.devotional_content);

  return (
    <View className="mt-7">
      <View className="px-4">
        <Text className="text-xl font-bold text-gray-900 dark:text-white">Plan Preview</Text>
      </View>

      {!!days.length && (
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          className="mt-4"
          contentContainerStyle={{ paddingHorizontal: 16 }}>
          <View className="flex-row gap-3">
            {days.map((day) => {
              const isActive = day.day_number === selectedDay;

              return (
                <TouchableOpacity
                  key={day.id}
                  onPress={() => onSelectDay(day.day_number)}
                  className={`h-16 min-w-20 items-center justify-center rounded-xl border px-3 ${
                    isActive
                      ? 'border-black bg-black/10 dark:border-white dark:bg-white/10'
                      : 'border-gray-300 dark:border-gray-700'
                  }`}>
                  <Text className="text-xs text-gray-500 dark:text-gray-400">Day</Text>
                  <Text className="text-lg font-bold text-gray-900 dark:text-white">
                    {day.day_number}
                  </Text>
                </TouchableOpacity>
              );
            })}
          </View>
        </ScrollView>
      )}

      <View className="mt-5 px-4">
        <View className="border-y border-gray-200 py-5 dark:border-neutral-800">
          <View className="flex-row items-start justify-between gap-4">
            <View className="flex-1">
              <Text className="text-lg font-bold text-gray-900 dark:text-white">
                Day {selectedDay} of {days.length || selectedDay}
              </Text>
              {!!selectedDayData?.title && (
                <Text className="mt-1 text-base font-semibold text-gray-700 dark:text-gray-200">
                  {selectedDayData.title}
                </Text>
              )}
            </View>

            <View className="rounded-full border border-green-500 px-3 py-1">
              <Text className="text-xs font-semibold text-green-600">
                {scriptureCount} {scriptureCount === 1 ? 'Scripture' : 'Scriptures'}
              </Text>
            </View>
          </View>

          {!!devotionalExcerpt && (
            <Text className="mt-4 text-[15px] leading-6 text-gray-700 dark:text-gray-300">
              {devotionalExcerpt}
            </Text>
          )}
        </View>
      </View>

      <View className="mt-5 px-4">
        <TouchableOpacity
          className="flex-row items-center justify-between rounded-xl border border-gray-200 px-4 py-4 dark:border-neutral-800"
          onPress={() => setReadingsExpanded((expanded) => !expanded)}>
          <View>
            <Text className="text-base font-bold text-gray-900 dark:text-white">Readings</Text>
            <Text className="mt-0.5 text-sm text-gray-500 dark:text-gray-400">
              {itemsLoading
                ? 'Loading readings'
                : `${items.length} ${items.length === 1 ? 'item' : 'items'}`}
            </Text>
          </View>

          <Ionicons
            name={readingsExpanded ? 'chevron-up' : 'chevron-down'}
            size={22}
            color={colorScheme === 'dark' ? '#fff' : '#111827'}
          />
        </TouchableOpacity>

        {readingsExpanded && (
          <>
            {itemsLoading ? (
              <ActivityIndicator
                className="mt-6"
                color={colorScheme === 'dark' ? '#fff' : '#111'}
              />
            ) : items.length ? (
              <View className="mt-3 overflow-hidden rounded-xl border border-gray-200 dark:border-neutral-800">
                {items.map((item, index) => {
                  const isLast = index === items.length - 1;

                  return (
                    <View
                      key={`${item.item_type}-${item.item_key}-${index}`}
                      className={`flex-row items-center px-4 py-4 ${
                        isLast ? '' : 'border-b border-gray-200 dark:border-neutral-800'
                      }`}>
                      <View className="mr-3 h-10 w-10 items-center justify-center rounded-full bg-gray-100 dark:bg-neutral-800">
                        <Ionicons
                          name={getItemIcon(item)}
                          size={20}
                          color={colorScheme === 'dark' ? '#fff' : '#111827'}
                        />
                      </View>

                      <View className="flex-1">
                        <Text className="text-base font-semibold text-gray-900 dark:text-white">
                          {getItemLabel(item)}
                        </Text>
                        <Text className="mt-0.5 text-sm text-gray-500 dark:text-gray-400">
                          {getItemSubtitle(item)}
                        </Text>
                      </View>
                    </View>
                  );
                })}
              </View>
            ) : (
              <View className="mt-4 rounded-xl border border-gray-200 px-4 py-6 dark:border-neutral-800">
                <Text className="text-center text-gray-500 dark:text-gray-400">
                  No reading items found for this day.
                </Text>
              </View>
            )}
          </>
        )}
      </View>
    </View>
  );
}

export default function DevotionalDetailScreen({
  onReportPress,
  handleToggleReaction,
  currentReaction,
  reportSheetRef,
  plan,
  isLoading,
  previewDays,
  selectedPreviewDay,
  selectedPreviewDayData,
  previewItems,
  previewItemsLoading,
  hasActiveSoloPlanProgress,
  hasActivePlanProgress,
  canStartPlan,
  isPrivatePlan,
  isStartingSoloPlan,
  onSelectPreviewDay,
  onStartPress,
  onContinuePress,
  isSaved,
  onToggleSave,
}: Props) {
  const bottomSheetRef = useRef<BottomSheet>(null);
  const insets = useSafeAreaInsets();
  const colorScheme = useColorScheme();

  const { isGuest } = useAuth();
  const resolvedTopInset = insets.top;
  const startButtonLabel =
    isPrivatePlan && !canStartPlan && hasActivePlanProgress ? 'Continue Plan' : 'Start Plan';
  const isStartButtonDisabled =
    isStartingSoloPlan || (isPrivatePlan && !canStartPlan && !hasActivePlanProgress);
  const scrollBottomPadding = insets.bottom + 112;

  const handleStartButtonPress = () => {
    if (isStartingSoloPlan) return;

    if (isPrivatePlan && !canStartPlan && hasActivePlanProgress) {
      onContinuePress();
      return;
    }

    bottomSheetRef.current?.expand();
  };

  if (isLoading) {
    return <LoadingSpinner style={{ marginTop: 30 }} />;
  }

  if (!plan) {
    return (
      <View className="flex-1 items-center justify-center p-4">
        <Text className="text-center text-gray-700 dark:text-gray-300">
          This devotional could not be found.
        </Text>
      </View>
    );
  }

  return (
    <>
      <ScrollView
        className="flex-1 bg-white dark:bg-black"
        nestedScrollEnabled={true}
        showsVerticalScrollIndicator={false}
        contentContainerStyle={{
          paddingTop: resolvedTopInset + 70,
          paddingBottom: scrollBottomPadding,
        }}>
        <View>
          <PlanCoverImage uri={plan?.cover_image} className="w-full h-60 rounded-2xl" />

          {(plan?.completions ?? 0) > 0 && (
            <View className="absolute bottom-0 left-0 right-0 bg-black/50 py-2 rounded-b-2xl">
              <Text className="text-center text-white font-semibold">
                {plan?.completions} completions
              </Text>
            </View>
          )}
        </View>

        <View className="px-4 mt-5">
          <Text className="text-2xl font-bold text-gray-900 dark:text-gray-100 leading-snug">
            {plan?.title}
          </Text>

          <View className="flex-row items-center gap-2 mt-2">
            <Text className="text-gray-600 dark:text-gray-300">{plan?.total_days} Days</Text>
            <PlanVisibilityBadge visibility={isPrivatePlan ? 'private' : null} />
          </View>

          {isPrivatePlan && (
            <Text className="mt-3 text-sm leading-6 text-gray-600 dark:text-gray-300">
              {canStartPlan
                ? 'Only people you invite can join this plan.'
                : 'You can keep reading through the invite-only plan invitation you already joined.'}
            </Text>
          )}
        </View>

        <View className="px-4 mt-4 flex-row items-center gap-6">
          <TouchableOpacity
            className="flex-row items-center gap-1 justify-center"
            disabled={isGuest}
            onPress={handleToggleReaction}>
            <Ionicons
              name={currentReaction?.user_reaction === 'helpful' ? 'heart' : 'heart-outline'}
              size={22}
              color={currentReaction?.user_reaction === 'helpful' ? '#EAB308' : '#9ca3af'}
            />
            <Text
              className={` ${
                currentReaction?.user_reaction === 'helpful' ? 'text-yellow-500' : 'text-gray-500'
              }`}>
              {currentReaction?.helpful_count ?? 0}
            </Text>
          </TouchableOpacity>

          <TouchableOpacity
            className="flex-row items-center gap-1 justify-center"
            onPress={onToggleSave}>
            <Ionicons
              name={isSaved ? 'bookmark' : 'bookmark-outline'}
              size={20}
              color={isSaved ? (colorScheme === 'dark' ? '#F9FAFB' : '#111827') : '#9CA3AF'}
            />
            <Text
              className={
                isSaved ? 'text-gray-900 dark:text-gray-100' : 'text-gray-500 dark:text-gray-400'
              }>
              {isSaved ? 'Saved' : 'Save'}
            </Text>
          </TouchableOpacity>

          <TouchableOpacity
            className="flex-row items-start gap-1 justify-center"
            onPress={onReportPress}>
            <Ionicons name="flag-outline" size={18} color="red" />
            <Text className="text-red-600">Report</Text>
          </TouchableOpacity>
        </View>

        <View className="px-4 mt-6">
          <Text className="text-[16px] leading-7 text-gray-800 dark:text-gray-200">
            {plan?.description}
          </Text>
        </View>

        <PlanPreviewSection
          days={previewDays}
          selectedDay={selectedPreviewDay}
          selectedDayData={selectedPreviewDayData}
          items={previewItems}
          itemsLoading={previewItemsLoading}
          onSelectDay={onSelectPreviewDay}
        />

        <RelatedPlansSection plan={plan} />
      </ScrollView>

      <View
        className="absolute bottom-0 left-0 right-0 border-t border-gray-200 bg-white px-4 pt-3 dark:border-neutral-800 dark:bg-black"
        style={{ paddingBottom: insets.bottom + 12 }}>
        <TouchableOpacity
          className={`rounded-full py-4 ${
            isStartButtonDisabled ? 'bg-gray-400 dark:bg-neutral-700' : 'bg-black dark:bg-white'
          }`}
          onPress={handleStartButtonPress}
          disabled={isStartButtonDisabled}>
          {isStartingSoloPlan ? (
            <ActivityIndicator
              size="small"
              color={colorScheme === 'dark' ? '#111827' : '#ffffff'}
            />
          ) : (
            <Text className="text-center text-white dark:text-black font-semibold text-lg">
              {startButtonLabel}
            </Text>
          )}
        </TouchableOpacity>
      </View>

      <StartPlanBottomSheet
        ref={bottomSheetRef}
        plan={plan}
        hasActiveSoloPlanProgress={hasActiveSoloPlanProgress}
        isStartingSoloPlan={isStartingSoloPlan}
        onContinuePress={onContinuePress}
        onStartPress={onStartPress}
      />
      <ReportPlanSheet ref={reportSheetRef} planId={plan.id} />
    </>
  );
}
