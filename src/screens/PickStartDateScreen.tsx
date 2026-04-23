import DaysPicker from '@/src/components/DaysPicker';
import dayjs, { type Dayjs } from '@/src/lib/dayjs';
import { Ionicons } from '@expo/vector-icons';
import { Image, ScrollView, Text, TouchableOpacity, useColorScheme, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type Props = {
  coverImage?: string | null;
  dates: Dayjs[];
  selectedDate: Dayjs;
  onSelectDate: (date: Dayjs) => void;
  onNext: () => void;
};

export default function PickStartDateScreen({
  coverImage,
  dates,
  selectedDate,
  onSelectDate,
  onNext,
}: Props) {
  const insets = useSafeAreaInsets();
  const colorScheme = useColorScheme();
  const startDate = dayjs().startOf('day');

  return (
    <View className="flex-1 dark:bg-black items-center" style={{ paddingBottom: insets.bottom }}>
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
      <View className="px-4 mt-6 items-center w-full">
        <Text className="dark:text-white text-xl font-bold mb-6 text-center">
          When do you want to start this plan?
        </Text>

        <ScrollView horizontal showsHorizontalScrollIndicator={false} className="mb-5">
          <View className="flex-row gap-3">
            {dates.map((date, index) => {
              const isSelected = date.isSame(selectedDate, 'day');

              return (
                <DaysPicker
                  key={date.toISOString()}
                  isActive={isSelected}
                  startDate={startDate.toISOString()}
                  day_number={index + 1}
                  isCurrentDay={date.isSame(startDate, 'day')}
                  completed={false}
                  setSelectedDate={onSelectDate}
                />
              );
            })}
          </View>
        </ScrollView>

        <Text className="text-gray-700 dark:text-gray-200 text-sm mt-6 text-center">
          Starting on a future date gives participants time to accept your invitation.
        </Text>
      </View>

      {/* NEXT BUTTON */}
      <View
        className="absolute bottom-8 left-0 right-0 items-end px-6"
        style={{ paddingBottom: insets.bottom + 5 }}>
        <TouchableOpacity
          onPress={onNext}
          className="w-14 h-14 rounded-full bg-black dark:bg-white items-center justify-center">
          <Ionicons
            name="arrow-forward"
            size={24}
            color={colorScheme === 'dark' ? '#000' : '#fff'}
          />
        </TouchableOpacity>
      </View>
    </View>
  );
}
