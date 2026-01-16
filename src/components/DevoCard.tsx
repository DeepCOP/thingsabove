/* -------------------- LIST VIEW CARD --------------------- */

import Stat from '@/src/components/Stat';
import { DevotionalPlanView } from '@/src/types/types';
import { Image, Text, TouchableOpacity, View } from 'react-native';
import { ProgressBar } from './ProgressBar';

export function ListCard({
  item,
  onPress,
}: {
  item: DevotionalPlanView & {
    completed_days?: number | null;
  };
  onPress: () => void;
}) {
  const percentageCompletion = ((item.completed_days ?? 0) / (item?.total_days ?? 1)) * 100;
  return (
    <TouchableOpacity
      className="bg-white dark:bg-neutral-900 rounded-xl p-3 mb-3 shadow-sm "
      onPress={() => {
        onPress();
      }}>
      <View className=" flex-row gap-3">
        <Image
          source={{ uri: item.cover_image || '../assets/placeholder_cover.png' }}
          className="w-20 h-20 rounded-lg"
          resizeMode="cover"
        />

        <View className="flex-1">
          <Text className="font-semibold text-[16px] text-gray-900 dark:text-white">
            {item.title}
          </Text>

          <Text className="text-gray-600 dark:text-gray-200 text-sm mt-1">
            {item.total_days} Days
          </Text>

          {/* Icons Row */}
          <View className="flex-row items-center gap-4 mt-2">
            <Stat icon="heart-outline" count={item.likes_count ?? 0} />
            <Stat icon="thumbs-down-outline" count={item.dislikes_count ?? 0} />
            <Stat icon="people-outline" count={item.completions ?? 0} />
          </View>
        </View>
      </View>
      {(item.completed_days ?? 0) > 0 && (
        <View className="flex-1 flex-row items-end justify-end">
          <Text className="font-semibold text-green-600 text-end">
            {percentageCompletion.toFixed(2)}%
          </Text>
        </View>
      )}
      {(item?.completed_days ?? 0) > 0 && <ProgressBar percentage={percentageCompletion} />}
    </TouchableOpacity>
  );
}

/* -------------------- GRID VIEW CARD --------------------- */

export function GridCard({
  item,
  onPress,
}: {
  item: DevotionalPlanView & {
    completed_days?: number | null;
  };
  onPress: () => void;
}) {
  const percentageCompletion = ((item.completed_days ?? 0) / (item?.total_days ?? 1)) * 100;

  return (
    <TouchableOpacity
      className="bg-white dark:bg-neutral-900 rounded-xl p-3 mb-3 w-[48%] shadow-sm"
      onPress={onPress}>
      <View className="rounded-lg mb-2 overflow-hidden bg-white dark:bg-white elevation-2xl">
        <Image
          source={{ uri: item.cover_image || '../assets/placeholder_cover.png' }}
          className="w-full h-32"
          resizeMode="cover"
        />
      </View>
      <Text numberOfLines={2} className="font-semibold text-gray-900 dark:text-white text-[14px]">
        {item.title}
      </Text>

      <Text className="text-gray-600 dark:text-gray-200 text-sm mt-1">{item.total_days} Days</Text>
      {/* Icons Row */}
      <View className="flex-row items-center gap-4 mt-2">
        <Stat icon="heart-outline" count={item.likes_count ?? 0} />
        <Stat icon="thumbs-down-outline" count={item.dislikes_count ?? 0} />
        <Stat icon="people-outline" count={item.completions ?? 0} />
      </View>
      {(item.completed_days ?? 0) > 0 && (
        <View className="flex-1 flex-row items-end justify-end">
          <Text className="font-semibold text-green-600 text-end">
            {percentageCompletion.toFixed(2)}%
          </Text>
        </View>
      )}
      {(item?.completed_days ?? 0) > 0 && <ProgressBar percentage={percentageCompletion} />}
    </TouchableOpacity>
  );
}
