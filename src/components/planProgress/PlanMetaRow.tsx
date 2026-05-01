import { Text, TouchableOpacity, View } from 'react-native';

type Props = {
  day: number;
  totalDays: number;
  missedCount?: number;
  onMissedDays: () => void;
};

export function PlanMetaRow({ day, totalDays, missedCount, onMissedDays }: Props) {
  return (
    <View className="flex-row justify-between items-center mb-2 px-4">
      <Text className="text-xl font-bold dark:text-white">
        Day {day} of {totalDays}
      </Text>

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
  );
}
