import { RelatedPlansSection } from '@/src/components/RelatedPlans';
import { Ionicons } from '@expo/vector-icons';
import { Animated, Image, Text, TouchableOpacity, useColorScheme, View } from 'react-native';

type Props = {
  plan: any;
  progressAnim: Animated.Value;
  animationComplete: boolean;
  onBack: () => void;
  onShare: () => void;
};

export default function PlanCompleteScreen({
  plan,
  progressAnim,
  animationComplete,
  onBack,
  onShare,
}: Props) {
  const colorScheme = useColorScheme();
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
          {plan?.cover_image ? (
            <Image source={{ uri: plan.cover_image }} className="w-full h-56" resizeMode="cover" />
          ) : (
            <View className="w-full h-56 bg-gray-300 dark:bg-neutral-800" />
          )}
        </View>
      </View>

      {/* PROGRESS / RATING */}
      {animationComplete ? (
        <View className="mx-4 mt-6 bg-gray-300 dark:bg-neutral-900 rounded-2xl py-6 items-center">
          <Text className="text-lg font-semibold mb-3 text-gray-800 dark:text-white">
            You rated this Plan
          </Text>

          <View className="flex-row gap-2">
            {[1, 2, 3, 4, 5].map((i) => (
              <Ionicons
                key={i}
                name="star"
                size={26}
                color={colorScheme === 'dark' ? '#fff' : '#000'}
              />
            ))}
          </View>
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

      {/* RELATED */}
      <RelatedPlansSection plan={plan} />
    </View>
  );
}
