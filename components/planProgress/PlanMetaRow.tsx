import { Ionicons } from '@expo/vector-icons';
import { Text, TouchableOpacity, View } from 'react-native';

type Props = {
  day: number;
  totalDays: number;
  missedCount?: number;
  onComments: () => void;
  onMissedDays: () => void;
};

export function PlanMetaRow({ day, totalDays, missedCount, onComments, onMissedDays }: Props) {
  return (
    <View className="flex-row justify-between items-center mb-2 px-4">
      <Text className="text-xl font-bold dark:text-white">
        Day {day} of {totalDays}
      </Text>

      <View className="flex-row items-center">
        <TouchableOpacity onPress={onComments} className="px-4 py-2">
          <Ionicons name="chatbubble-ellipses" size={24} />
        </TouchableOpacity>

        {missedCount ? (
          <TouchableOpacity
            className="px-3 py-1 border rounded-full border-green-500"
            onPress={onMissedDays}>
            <Text className="text-green-600 text-xs">{missedCount} Missed Days</Text>
          </TouchableOpacity>
        ) : (
          <View className="px-3 py-1 border rounded-full border-green-500">
            <Text className="text-green-600 text-xs">ON TRACK!</Text>
          </View>
        )}
      </View>
    </View>
  );
}
