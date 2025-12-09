/* -------------------- LIST VIEW CARD --------------------- */

import Stat from '@/components/Stat';
import { Image, Text, TouchableOpacity, View } from 'react-native';

export function ListCard({ item }: { item: any }) {
  return (
    <TouchableOpacity className="bg-white dark:bg-neutral-900 rounded-xl p-3 mb-3 shadow-sm flex-row gap-3">
      <Image
        source={{ uri: item.cover_image }}
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
          <Stat icon="heart-outline" count={item.likes_count} />
          <Stat icon="thumbs-down-outline" count={item.dislikes_count} />
          <Stat icon="people-outline" count={item.completions} />
        </View>
      </View>
    </TouchableOpacity>
  );
}

/* -------------------- GRID VIEW CARD --------------------- */

export function GridCard({ item }: { item: any }) {
  return (
    <TouchableOpacity className="bg-white dark:bg-neutral-900 rounded-xl p-3 mb-3 w-[48%] shadow-sm">
      <View
        className="
      rounded-lg 
      mb-2 
      overflow-hidden 
      bg-white
      dark:bg-white 
      elevation-2xl
    ">
        <Image source={{ uri: item.cover_image }} className="w-full h-32" resizeMode="cover" />
      </View>
      <Text numberOfLines={2} className="font-semibold text-gray-900 dark:text-white text-[14px]">
        {item.title}
      </Text>

      <Text className="text-gray-600 dark:text-gray-200 text-sm mt-1">{item.total_days} Days</Text>
      {/* Icons Row */}
      <View className="flex-row items-center gap-4 mt-2">
        <Stat icon="heart-outline" count={item.likes_count} />
        <Stat icon="thumbs-down-outline" count={item.dislikes_count} />
        <Stat icon="people-outline" count={item.completions} />
      </View>
    </TouchableOpacity>
  );
}
