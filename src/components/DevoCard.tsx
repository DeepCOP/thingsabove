/* -------------------- LIST VIEW CARD --------------------- */

import PlanCoverImage from '@/src/components/PlanCoverImage';
import Stat from '@/src/components/Stat';
import { DevotionalPlanView } from '@/src/types/types';
import { Ionicons } from '@expo/vector-icons';
import { Pressable, Text, TouchableOpacity, View, useColorScheme } from 'react-native';
import { ProgressBar } from './ProgressBar';

export function ListCard({
  item,
  onPress,
  isSaved,
  onToggleSave,
}: {
  item: DevotionalPlanView & {
    completed_days?: number | null;
    helpful_count?: number | null;
    rating_avg?: number | null;
    rating_count?: number | null;
    user_reaction?: 'helpful' | null;
  };
  onPress: () => void;
  isSaved?: boolean;
  onToggleSave?: () => void;
}) {
  const percentageCompletion = ((item.completed_days ?? 0) / (item?.total_days ?? 1)) * 100;
  const helpfulCount = item.helpful_count ?? 0;
  const isHelpfulMarkedByMe = item.user_reaction === 'helpful';
  const colorScheme = useColorScheme();
  const ratingAverageRaw = Number(item.rating_avg);
  const ratingAverage = Number.isFinite(ratingAverageRaw) ? ratingAverageRaw : 0;
  const ratingCountRaw = Number(item.rating_count);
  const ratingCount = Number.isFinite(ratingCountRaw) ? ratingCountRaw : 0;
  const hasRating = ratingCount > 0;
  const ratingDisplay = hasRating ? ratingAverage.toFixed(1) : '0';
  return (
    <TouchableOpacity
      className="bg-white dark:bg-neutral-900 rounded-xl p-3 mb-3 shadow-sm "
      onPress={() => {
        onPress();
      }}>
      <View className=" flex-row gap-3">
        <PlanCoverImage uri={item.cover_image} className="w-20 h-20 rounded-lg" />

        <View className="flex-1">
          <View className="flex-row items-start justify-between gap-2">
            <Text className="flex-1 font-semibold text-[16px] text-gray-900 dark:text-white">
              {item.title}
            </Text>
            {onToggleSave && (
              <Pressable
                onPress={(event) => {
                  event.stopPropagation?.();
                  onToggleSave();
                }}
                hitSlop={8}
                className="pt-0.5">
                <Ionicons
                  name={isSaved ? 'bookmark' : 'bookmark-outline'}
                  size={18}
                  color={isSaved ? (colorScheme === 'dark' ? '#F9FAFB' : '#111827') : '#9CA3AF'}
                />
              </Pressable>
            )}
          </View>

          <Text className="text-gray-600 dark:text-gray-200 text-sm mt-1">
            {item.total_days} Days
          </Text>

          {/* Icons Row */}
          <View className="flex-row items-center gap-4 mt-2">
            <Stat
              icon="heart"
              label="Helpful"
              iconColor={isHelpfulMarkedByMe ? '#EAB308' : '#9CA3AF'}
              count={helpfulCount}
            />
            <Stat
              icon={hasRating ? 'star' : 'star-outline'}
              count={ratingDisplay}
              iconColor={hasRating ? '#EAB308' : '#9CA3AF'}
            />
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
  isSaved,
  onToggleSave,
}: {
  item: DevotionalPlanView & {
    completed_days?: number | null;
    helpful_count?: number | null;
    rating_avg?: number | null;
    rating_count?: number | null;
    user_reaction?: 'helpful' | null;
  };
  onPress: () => void;
  isSaved?: boolean;
  onToggleSave?: () => void;
}) {
  const percentageCompletion = ((item.completed_days ?? 0) / (item?.total_days ?? 1)) * 100;
  const helpfulCount = item.helpful_count ?? 0;
  const isHelpfulMarkedByMe = item.user_reaction === 'helpful';
  const colorScheme = useColorScheme();
  const ratingAverageRaw = Number(item.rating_avg);
  const ratingAverage = Number.isFinite(ratingAverageRaw) ? ratingAverageRaw : 0;
  const ratingCountRaw = Number(item.rating_count);
  const ratingCount = Number.isFinite(ratingCountRaw) ? ratingCountRaw : 0;
  const hasRating = ratingCount > 0;
  const ratingDisplay = hasRating ? ratingAverage.toFixed(1) : '0';

  return (
    <TouchableOpacity
      className="bg-white dark:bg-neutral-900 rounded-xl p-3 mb-3 w-[48%] shadow-sm"
      onPress={onPress}>
      <View className="rounded-lg mb-2 overflow-hidden bg-white dark:bg-white elevation-2xl">
        <PlanCoverImage uri={item.cover_image} className="w-full h-32" />
      </View>
      <View className="flex-row items-start justify-between gap-2">
        <Text
          numberOfLines={2}
          className="flex-1 font-semibold text-gray-900 dark:text-white text-[14px]">
          {item.title}
        </Text>
        {onToggleSave && (
          <Pressable
            onPress={(event) => {
              event.stopPropagation?.();
              onToggleSave();
            }}
            hitSlop={8}
            className="pt-0.5">
            <Ionicons
              name={isSaved ? 'bookmark' : 'bookmark-outline'}
              size={18}
              color={isSaved ? (colorScheme === 'dark' ? '#F9FAFB' : '#111827') : '#9CA3AF'}
            />
          </Pressable>
        )}
      </View>

      <Text className="text-gray-600 dark:text-gray-200 text-sm mt-1">{item.total_days} Days</Text>
      {/* Icons Row */}
      <View className="flex-row items-center gap-4 mt-2">
        <Stat
          icon="heart"
          label="Helpful"
          iconColor={isHelpfulMarkedByMe ? '#EAB308' : '#9CA3AF'}
          count={helpfulCount}
        />
        <Stat
          icon={hasRating ? 'star' : 'star-outline'}
          count={ratingDisplay}
          iconColor={hasRating ? '#EAB308' : '#9CA3AF'}
        />
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
