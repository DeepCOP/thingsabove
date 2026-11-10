import { useTranslation } from 'react-i18next';
import DaysPicker from '@/src/components/DaysPicker';
import dayjs, { formatLongDate, type Dayjs } from '@/src/lib/dayjs';
import { Ionicons } from '@expo/vector-icons';
import {
  ActivityIndicator,
  Image,
  ScrollView,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type Props = {
  coverImage?: string | null;
  dates: Dayjs[];
  selectedDate: Dayjs;
  onSelectDate: (date: Dayjs) => void;
  onEarlierDates: () => void;
  onLaterDates: () => void;
  isSoloPlan: boolean;
  isSubmitting: boolean;
  onNext: () => void;
};

export default function PickStartDateScreen({
  coverImage,
  dates,
  selectedDate,
  onSelectDate,
  onEarlierDates,
  onLaterDates,
  isSoloPlan,
  isSubmitting,
  onNext,
}: Props) {
  const { t, i18n } = useTranslation('plans');
  const insets = useSafeAreaInsets();
  const colorScheme = useColorScheme();
  const today = dayjs().startOf('day');
  const iconColor = colorScheme === 'dark' ? '#fff' : '#000';

  return (
    <View className="flex-1 dark:bg-black items-center" style={{ paddingBottom: insets.bottom }}>
      <ScrollView
        className="w-full"
        contentContainerStyle={{ alignItems: 'center', paddingBottom: 120 }}>
        {coverImage ? (
          <Image
            source={{ uri: coverImage }}
            className="w-full max-w-72 h-56 rounded-2xl"
            resizeMode="cover"
          />
        ) : (
          <View className="w-full max-w-72 h-56 rounded-2xl bg-gray-300 dark:bg-neutral-800" />
        )}

        {/* CONTENT */}
        <View
          className="px-4 mt-6 items-center w-full"
          pointerEvents={isSubmitting ? 'none' : 'auto'}>
          <Text className="dark:text-white text-xl font-bold mb-6 text-center">
            {t('pickStartDate')}
          </Text>

          <View className="w-full flex-row items-center justify-between mb-3">
            <TouchableOpacity
              onPress={onEarlierDates}
              disabled={isSubmitting}
              accessibilityRole="button"
              accessibilityLabel={t('earlierDates')}
              className="flex-1 flex-row items-center gap-1 py-3">
              <Ionicons name="chevron-back" size={20} color={iconColor} />
              <Text className="flex-shrink text-sm dark:text-white">{t('earlierDates')}</Text>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={onLaterDates}
              disabled={isSubmitting}
              accessibilityRole="button"
              accessibilityLabel={t('laterDates')}
              className="flex-1 flex-row items-center justify-end gap-1 py-3">
              <Text className="flex-shrink text-sm dark:text-white">{t('laterDates')}</Text>
              <Ionicons name="chevron-forward" size={20} color={iconColor} />
            </TouchableOpacity>
          </View>

          <ScrollView
            key={dates[0]?.format('YYYY-MM-DD')}
            horizontal
            showsHorizontalScrollIndicator={false}
            className="mb-5">
            <View className="flex-row gap-3">
              {dates.map((date) => {
                const isSelected = date.isSame(selectedDate, 'day');

                return (
                  <DaysPicker
                    key={date.format('YYYY-MM-DD')}
                    isActive={isSelected}
                    startDate={date.format('YYYY-MM-DD')}
                    day_number={1}
                    isCurrentDay={date.isSame(today, 'day')}
                    completed={false}
                    setSelectedDate={onSelectDate}
                  />
                );
              })}
            </View>
          </ScrollView>

          <Text
            className="text-gray-700 dark:text-gray-200 text-sm text-center"
            accessibilityLiveRegion="polite">
            {t('selectedStartDate', { date: formatLongDate(selectedDate, i18n.resolvedLanguage) })}
          </Text>
          {!isSoloPlan && (
            <Text className="text-gray-700 dark:text-gray-200 text-sm mt-6 text-center">
              {t('futureStartHint')}
            </Text>
          )}
        </View>
      </ScrollView>

      {/* NEXT BUTTON */}
      <View
        className="absolute bottom-8 left-0 right-0 items-end px-6"
        style={{ paddingBottom: insets.bottom + 5 }}>
        <TouchableOpacity
          onPress={onNext}
          disabled={isSubmitting}
          accessibilityRole="button"
          accessibilityState={{ disabled: isSubmitting, busy: isSubmitting }}
          accessibilityLabel={t(isSoloPlan ? 'startPlan' : 'next')}
          className="w-14 h-14 rounded-full bg-black dark:bg-white items-center justify-center">
          {isSubmitting ? (
            <ActivityIndicator color={colorScheme === 'dark' ? '#000' : '#fff'} />
          ) : (
            <Ionicons
              name="arrow-forward"
              size={24}
              color={colorScheme === 'dark' ? '#000' : '#fff'}
            />
          )}
        </TouchableOpacity>
      </View>
    </View>
  );
}
