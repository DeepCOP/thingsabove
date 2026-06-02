import Ionicons from '@expo/vector-icons/Ionicons';
import BottomSheet from '@gorhom/bottom-sheet';
import { ComponentProps, useMemo, useRef } from 'react';
import {
  ActivityIndicator,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
  useColorScheme,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import PlanCoverImage from '@/src/components/PlanCoverImage';
import PlanVisibilityBadge from '@/src/components/PlanVisibilityBadge';
import StartPlanBottomSheet from '@/src/components/StartPlanBottomSheet';
import { DayItemTemplate, DevotionalDays } from '@/src/types/types';

type IconName = ComponentProps<typeof Ionicons>['name'];

type Props = {
  plan: any;
  days: DevotionalDays[];
  selectedDay: number;
  selectedDayData?: DevotionalDays;
  items: DayItemTemplate[];
  itemsLoading: boolean;
  isStartingSoloPlan: boolean;
  hasActiveSoloPlanProgress: boolean;
  hasActivePlanProgress: boolean;
  canStartPlan: boolean;
  isPrivatePlan: boolean;
  onSelectDay: (dayNumber: number) => void;
  onStartPress: (mode: 'solo' | 'group') => void;
  onContinuePress: () => void;
};

const decodeHtmlEntities = (value: string) =>
  value
    .replace(/&nbsp;/g, ' ')
    .replace(/&amp;/g, '&')
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'");

const getPreviewText = (html?: string | null) => {
  if (!html) return '';

  return decodeHtmlEntities(
    html
      .replace(/<br\s*\/?>/gi, ' ')
      .replace(/<\/p>/gi, ' ')
      .replace(/<[^>]+>/g, ' ')
      .replace(/\s+/g, ' ')
      .trim(),
  );
};

const truncatePreviewText = (value: string, maxLength = 220) => {
  if (value.length <= maxLength) return value;

  const truncated = value.slice(0, maxLength).trimEnd();
  const lastSpace = truncated.lastIndexOf(' ');

  return `${truncated.slice(0, lastSpace > 120 ? lastSpace : truncated.length)}...`;
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

export default function PlanPreviewScreen({
  plan,
  days,
  selectedDay,
  selectedDayData,
  items,
  itemsLoading,
  isStartingSoloPlan,
  hasActiveSoloPlanProgress,
  hasActivePlanProgress,
  canStartPlan,
  isPrivatePlan,
  onSelectDay,
  onStartPress,
  onContinuePress,
}: Props) {
  const bottomSheetRef = useRef<BottomSheet>(null);
  const insets = useSafeAreaInsets();
  const colorScheme = useColorScheme();
  const devotionalItem = items.find((item) => item.item_type === 'devotional');
  const scriptureCount = items.filter((item) => item.item_type === 'scripture').length;
  const previewText = useMemo(
    () => truncatePreviewText(getPreviewText(devotionalItem?.devotional_content)),
    [devotionalItem?.devotional_content],
  );
  const startButtonLabel =
    isPrivatePlan && !canStartPlan && hasActivePlanProgress ? 'Continue Plan' : 'Start Plan';
  const isStartButtonDisabled =
    isStartingSoloPlan || (isPrivatePlan && !canStartPlan && !hasActivePlanProgress);

  return (
    <>
      <View className="flex-1 bg-white dark:bg-black">
        <ScrollView
          className="flex-1"
          showsVerticalScrollIndicator={false}
          contentContainerStyle={{ paddingBottom: insets.bottom + 120 }}>
          <PlanCoverImage uri={plan?.cover_image} className="h-60 w-full rounded-2xl" />

          <View className="px-4 pt-5">
            <Text className="text-2xl font-bold leading-snug text-gray-900 dark:text-gray-100">
              {plan?.title}
            </Text>

            <View className="mt-2 flex-row items-center gap-2">
              <Text className="text-gray-600 dark:text-gray-300">
                {plan?.total_days ?? days.length} Days
              </Text>
              <PlanVisibilityBadge visibility={isPrivatePlan ? 'private' : null} />
            </View>

            {!!plan?.description && (
              <Text className="mt-4 text-[15px] leading-6 text-gray-700 dark:text-gray-300">
                {plan.description}
              </Text>
            )}
          </View>

          <View className="mt-7">
            <View className="px-4">
              <Text className="text-xl font-bold text-gray-900 dark:text-white">Plan Preview</Text>
            </View>

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

            <View className="mt-5 px-4">
              <View className="border-y border-gray-200 py-5 dark:border-neutral-800">
                <View className="flex-row items-start justify-between gap-4">
                  <View className="flex-1">
                    <Text className="text-lg font-bold text-gray-900 dark:text-white">
                      Day {selectedDay} of {plan?.total_days ?? days.length}
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

                {!!previewText && (
                  <Text className="mt-4 text-[15px] leading-6 text-gray-700 dark:text-gray-300">
                    {previewText}
                  </Text>
                )}
              </View>
            </View>

            <View className="mt-5 px-4">
              <Text className="text-base font-bold text-gray-900 dark:text-white">Readings</Text>

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
            </View>
          </View>
        </ScrollView>

        <View
          className="absolute bottom-0 left-0 right-0 border-t border-gray-200 bg-white px-4 pt-3 dark:border-neutral-800 dark:bg-black"
          style={{ paddingBottom: insets.bottom + 12 }}>
          <TouchableOpacity
            className={`rounded-full py-4 ${
              isStartButtonDisabled ? 'bg-gray-400 dark:bg-neutral-700' : 'bg-black dark:bg-white'
            }`}
            disabled={isStartButtonDisabled}
            onPress={() => {
              if (isStartingSoloPlan) return;

              if (isPrivatePlan && !canStartPlan && hasActivePlanProgress) {
                onContinuePress();
                return;
              }

              bottomSheetRef.current?.expand();
            }}>
            {isStartingSoloPlan ? (
              <ActivityIndicator
                size="small"
                color={colorScheme === 'dark' ? '#111827' : '#ffffff'}
              />
            ) : (
              <Text className="text-center text-lg font-semibold text-white dark:text-black">
                {startButtonLabel}
              </Text>
            )}
          </TouchableOpacity>
        </View>
      </View>

      <StartPlanBottomSheet
        ref={bottomSheetRef}
        plan={plan}
        hasActiveSoloPlanProgress={hasActiveSoloPlanProgress}
        isStartingSoloPlan={isStartingSoloPlan}
        onContinuePress={onContinuePress}
        onStartPress={onStartPress}
      />
    </>
  );
}
