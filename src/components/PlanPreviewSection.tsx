import { Ionicons } from '@expo/vector-icons';
import { ComponentProps, useState } from 'react';
import {
  ActivityIndicator,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
  useColorScheme,
} from 'react-native';

import { DayItemTemplate, DevotionalDays } from '../types/types';
import { getHtmlExcerpt } from '../utils';

type IconName = ComponentProps<typeof Ionicons>['name'];

type Props = {
  days: DevotionalDays[];
  selectedDay: number;
  selectedDayData?: DevotionalDays;
  items: DayItemTemplate[];
  itemsLoading: boolean;
  onSelectDay: (dayNumber: number) => void;
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

export default function PlanPreviewSection({
  days,
  selectedDay,
  selectedDayData,
  items,
  itemsLoading,
  onSelectDay,
}: Props) {
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
