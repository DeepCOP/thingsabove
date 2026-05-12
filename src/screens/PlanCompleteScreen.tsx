import PlanCoverImage from '@/src/components/PlanCoverImage';
import { RelatedPlansSection } from '@/src/components/RelatedPlans';
import { Ionicons } from '@expo/vector-icons';
import { Animated, Text, TouchableOpacity, useColorScheme, View } from 'react-native';

type Props = {
  plan: any;
  progressAnim: Animated.Value;
  animationComplete: boolean;
  currentRating: number;
  ratingLoading: boolean;
  ratingSaving: boolean;
  onBack: () => void;
  onFindMorePlans: () => void;
  onShare: () => void;
  onRate: (rating: number) => void;
};

export default function PlanCompleteScreen({
  plan,
  progressAnim,
  animationComplete,
  currentRating,
  ratingLoading,
  ratingSaving,
  onBack,
  onFindMorePlans,
  onShare,
  onRate,
}: Props) {
  const colorScheme = useColorScheme();
  const hasRating = currentRating > 0;
  return (
    <View className="flex-1 bg-white dark:bg-black">
      {/* HEADER */}
      <View className="flex-row items-center justify-between px-4 pt-20 pb-3">
        <TouchableOpacity onPress={onBack}>
          <Ionicons name="arrow-back" size={24} color={colorScheme === 'dark' ? '#fff' : '#000'} />
        </TouchableOpacity>

        <Text className="text-lg font-semibold text-gray-800 dark:text-white">Plan Complete</Text>

        <TouchableOpacity onPress={onShare}>
          <Ionicons
            name="share-social-outline"
            size={22}
            color={colorScheme === 'dark' ? '#fff' : '#000'}
          />
        </TouchableOpacity>
      </View>

      {/* COVER */}
      <View className="px-4 mt-3">
        <View className="overflow-hidden rounded-2xl">
          <PlanCoverImage uri={plan?.cover_image} className="w-full h-56" />
        </View>
      </View>

      {/* PROGRESS / RATING */}
      {animationComplete ? (
        <View className="mx-4 mt-6 bg-gray-300 dark:bg-neutral-900 rounded-2xl py-6 items-center">
          <Text className="text-lg font-semibold mb-3 text-gray-800 dark:text-white">
            {hasRating ? 'You rated this Plan' : 'Rate this Plan'}
          </Text>

          <View className="flex-row gap-2">
            {[1, 2, 3, 4, 5].map((i) => (
              <TouchableOpacity
                key={i}
                onPress={() => onRate(i)}
                disabled={ratingLoading || ratingSaving}>
                <Ionicons
                  name={i <= currentRating ? 'star' : 'star-outline'}
                  size={26}
                  color={i <= currentRating ? '#EAB308' : colorScheme === 'dark' ? '#fff' : '#000'}
                />
              </TouchableOpacity>
            ))}
          </View>

          {ratingSaving && (
            <Text className="text-xs text-gray-500 dark:text-gray-400 mt-3">Saving rating...</Text>
          )}
        </View>
      ) : (
        <View className="mx-4 mt-6 h-[3px] bg-black/10 overflow-hidden">
          <Animated.View
            style={{
              height: '100%',
              backgroundColor: colorScheme === 'dark' ? '#fff' : '#000',
              transform: [{ scaleX: progressAnim }],
              transformOrigin: 'left',
            }}
          />
        </View>
      )}

      <View className="px-4 mt-5">
        <TouchableOpacity
          onPress={onFindMorePlans}
          className="bg-black dark:bg-white py-4 rounded-full">
          <Text className="text-white dark:text-black text-center font-semibold">
            Find More Plans
          </Text>
        </TouchableOpacity>
      </View>

      {/* RELATED */}
      <RelatedPlansSection plan={plan} />
    </View>
  );
}
