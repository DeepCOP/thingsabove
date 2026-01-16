import { View } from 'react-native';

export const RelatedPlanSkeleton = () => {
  return (
    <View className="mr-4 w-48">
      <View className="h-28 w-full bg-gray-300 dark:bg-neutral-800 rounded-xl animate-pulse" />
      <View className="h-4 w-20 bg-gray-300 dark:bg-neutral-800 rounded mt-3 animate-pulse" />
      <View className="h-4 w-32 bg-gray-300 dark:bg-neutral-800 rounded mt-2 animate-pulse" />
    </View>
  );
};
