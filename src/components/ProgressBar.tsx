import { View } from 'react-native';

export function ProgressBar({ percentage }: { percentage: number }) {
  return (
    <View className="h-2 w-full bg-gray-300 dark:bg-neutral-800 rounded-full mt-2">
      <View className="h-2 bg-green-500 rounded-full" style={{ width: `${percentage}%` }} />
    </View>
  );
}
