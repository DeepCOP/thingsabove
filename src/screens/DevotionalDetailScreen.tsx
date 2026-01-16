import LoadingSpinner from '@/src/components/LoadingSpinner';
import { RelatedPlansSection } from '@/src/components/RelatedPlans';
import BottomSheet from '@gorhom/bottom-sheet';
import { useRef } from 'react';
import { Image, ScrollView, Text, TouchableOpacity, View } from 'react-native';
import StartPlanBottomSheet from '../components/StartPlanBottomSheet';

type Props = {
  plan: any;
  isLoading: boolean;
  hasUserPlans: boolean;
  onStartPress: (mode: 'solo' | 'group') => void;
  onMyPlansPress: () => void;
};

export default function DevotionalDetailScreen({
  plan,
  isLoading,
  hasUserPlans,
  onStartPress,
  onMyPlansPress,
}: Props) {
  const bottomSheetRef = useRef<BottomSheet>(null);

  if (isLoading) {
    return <LoadingSpinner style={{ marginTop: 30 }} />;
  }

  if (!plan) {
    return (
      <View className="flex-1 items-center justify-center p-4">
        <Text className="text-center text-gray-700 dark:text-gray-300">
          This devotional could not be found.
        </Text>
      </View>
    );
  }

  return (
    <>
      <ScrollView
        className="flex-1 bg-white dark:bg-black"
        nestedScrollEnabled={true}
        contentContainerStyle={{ paddingBottom: 80 }}>
        {/* Cover Image */}
        <View className="px-4">
          {plan?.cover_image ? (
            <Image
              source={{ uri: plan.cover_image }}
              className="w-full h-60 rounded-2xl"
              resizeMode="cover"
            />
          ) : (
            <View className="w-full h-60 rounded-2xl bg-gray-300 dark:bg-neutral-800" />
          )}

          {(plan?.completions ?? 0) > 0 && (
            <View className="absolute bottom-0 left-4 right-4 bg-black/50 py-2 rounded-b-2xl">
              <Text className="text-center text-white font-semibold">
                Over {plan?.completions} completions
              </Text>
            </View>
          )}
        </View>

        <View className="px-4 mt-5">
          <Text className="text-2xl font-bold text-gray-900 dark:text-gray-100 leading-snug">
            {plan?.title}
          </Text>

          <View className="flex-row items-center gap-2 mt-2">
            <Text className="text-gray-600 dark:text-gray-300">{plan?.total_days} Days</Text>
          </View>
        </View>

        <TouchableOpacity
          className="mt-6 mx-4 bg-black dark:bg-white py-4 rounded-full"
          onPress={() => {
            bottomSheetRef.current?.expand();
          }}>
          <Text className="text-center text-white dark:text-black font-semibold text-lg">
            Start Plan
          </Text>
        </TouchableOpacity>
        {hasUserPlans && (
          <TouchableOpacity
            className="mt-6 mx-4 bg-black dark:bg-white py-4 rounded-full"
            onPress={onMyPlansPress}>
            <Text className="text-center text-white dark:text-black font-semibold text-lg">
              My Plans
            </Text>
          </TouchableOpacity>
        )}

        <View className="px-4 mt-6">
          <Text className="text-[16px] leading-7 text-gray-800 dark:text-gray-200">
            {plan?.description}
          </Text>
        </View>

        <RelatedPlansSection plan={plan} />
      </ScrollView>

      <StartPlanBottomSheet ref={bottomSheetRef} plan={plan} onStartPress={onStartPress} />
    </>
  );
}
