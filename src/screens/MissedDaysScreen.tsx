import dayjs from '@/src/lib/dayjs';
import { Ionicons } from '@expo/vector-icons';
import { FlatList, Text, TouchableOpacity, useColorScheme, View } from 'react-native';

type MissedDay = {
  id: string;
  day_number: number;
};

type Props = {
  missedDays: MissedDay[];
  completedDays: number[];
  createdAt: string;
  onToggleDay: (dayId: string) => void;
};

export default function MissedDaysScreen({
  missedDays,
  completedDays,
  createdAt,
  onToggleDay,
}: Props) {
  const colorScheme = useColorScheme();
  if (!missedDays.length) {
    return (
      <View className="flex-1 justify-center items-center">
        <Text className="text-gray-500 dark:text-gray-400">No missed days! 🎉</Text>
      </View>
    );
  }

  return (
    <FlatList
      data={missedDays}
      keyExtractor={(item) => item.id}
      renderItem={({ item }) => {
        const isCompleted = completedDays.includes(item.day_number);

        return (
          <View className="p-4 flex-row items-center border-b border-gray-200 dark:border-gray-700">
            <TouchableOpacity
              onPress={() => onToggleDay(item.id)}
              className={`rounded-full p-1 border mr-3 ${
                isCompleted ? 'bg-black dark:bg-white' : 'border-gray-500'
              }`}>
              <Ionicons
                name="checkmark"
                size={12}
                color={colorScheme === 'dark' ? 'black' : 'white'}
              />
            </TouchableOpacity>

            <Text className="text-gray-900 font-semibold dark:text-gray-100">
              {dayjs(createdAt)
                .startOf('day')
                .add(item.day_number - 1, 'day')
                .format('MMMM DD, YYYY')}
            </Text>
          </View>
        );
      }}
    />
  );
}
