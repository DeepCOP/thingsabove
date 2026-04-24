import dayjs, { type Dayjs } from '@/src/lib/dayjs';
import { Ionicons } from '@expo/vector-icons';
import { Text, TouchableOpacity, View } from 'react-native';

type Props = {
  setSelectedDate?: (date: Dayjs) => void;
  setSelectedDayNumber?: (dayNumber: number) => void;
  startDate: string;
  completed: boolean;
  isActive: boolean;
  day_number: number;
  isCurrentDay: boolean;
};

export default function DaysPicker({
  startDate,
  setSelectedDate,
  setSelectedDayNumber,
  isCurrentDay,
  completed,
  day_number,
  isActive,
}: Props) {
  return (
    <TouchableOpacity
      onPress={() => {
        if (setSelectedDayNumber) {
          setSelectedDayNumber(day_number);
        }

        if (setSelectedDate) {
          setSelectedDate(
            dayjs(startDate)
              .startOf('day')
              .add(day_number - 1, 'day'),
          );
        }
      }}
      className={`px-4 py-3 rounded-xl border ${
        isActive
          ? 'border-black dark:border-white bg-black/10 dark:bg-white/10'
          : 'border-gray-300 dark:border-gray-700'
      }`}>
      {completed && (
        <View className="absolute top-1 right-1 bg-green-900 rounded-full p-1 z-10">
          <Ionicons name="checkmark" size={12} color="white" />
        </View>
      )}

      <Text className="text-center font-semibold dark:text-white">
        {setSelectedDate
          ? dayjs(startDate)
              .startOf('day')
              .add(day_number - 1, 'day')
              .format('ddd')
          : day_number}
      </Text>
      <Text
        className={`text-xs ${isCurrentDay ? 'text-white dark:text-gray-800 bg-black dark:bg-white px-2 font-semibold rounded-full' : 'text-gray-500'} dark:text-gray-400 `}>
        {dayjs(startDate)
          .startOf('day')
          .add(day_number - 1, 'day')
          .format('MMM DD')}
      </Text>
    </TouchableOpacity>
  );
}
