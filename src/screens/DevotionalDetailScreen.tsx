import LoadingSpinner from '@/src/components/LoadingSpinner';
import PlanCoverImage from '@/src/components/PlanCoverImage';
import { RelatedPlansSection } from '@/src/components/RelatedPlans';
import { Ionicons } from '@expo/vector-icons';
import BottomSheet from '@gorhom/bottom-sheet';
import { useRef } from 'react';
import { ScrollView, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import ReportPlanSheet from '../components/ReportPlanModal';
import StartPlanBottomSheet from '../components/StartPlanBottomSheet';
import { useAuth } from '../state/AuthContext';

type Props = {
  onReportPress: () => void;
  handleToggleReaction: () => void;
  currentReaction:
    | {
        helpful_count: number;
        user_reaction: 'helpful' | null;
      }
    | undefined;
  reportSheetRef: React.RefObject<BottomSheet | null>;
  plan: any;
  isLoading: boolean;
  hasUserPlans: boolean;
  onStartPress: (mode: 'solo' | 'group') => void;
  onMyPlansPress: () => void;
};

export default function DevotionalDetailScreen({
  onReportPress,
  handleToggleReaction,
  currentReaction,
  reportSheetRef,
  plan,
  isLoading,
  hasUserPlans,
  onStartPress,
  onMyPlansPress,
}: Props) {
  const bottomSheetRef = useRef<BottomSheet>(null);
  const insets = useSafeAreaInsets();

  const { isGuest } = useAuth();
  const resolvedTopInset = insets.top;
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
        showsVerticalScrollIndicator={false}
        contentContainerStyle={{ paddingTop: resolvedTopInset + 70, paddingBottom: insets.bottom }}>
        {/* Cover Image */}
        <View>
          <PlanCoverImage uri={plan?.cover_image} className="w-full h-60 rounded-2xl" />

          {(plan?.completions ?? 0) > 0 && (
            <View className="absolute bottom-0 left-0 right-0 bg-black/50 py-2 rounded-b-2xl">
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
        <View className="px-4 mt-4 flex-row items-center gap-6">
          <TouchableOpacity
            className="flex-row items-center gap-1 justify-center"
            disabled={isGuest}
            onPress={handleToggleReaction}>
            <Ionicons
              name={currentReaction?.user_reaction === 'helpful' ? 'heart' : 'heart-outline'}
              size={22}
              color={currentReaction?.user_reaction === 'helpful' ? '#EAB308' : '#9ca3af'}
            />
            <Text
              className={` ${
                currentReaction?.user_reaction === 'helpful' ? 'text-yellow-500' : 'text-gray-500'
              }`}>
              {currentReaction?.helpful_count ?? 0}
            </Text>
          </TouchableOpacity>
          <TouchableOpacity
            className=" flex-row items-start gap-1 justify-center"
            onPress={() => {
              onReportPress();
            }}>
            <Ionicons name="flag-outline" size={18} color="red" />
            <Text className="text-red-600">Report</Text>
          </TouchableOpacity>
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
      <ReportPlanSheet ref={reportSheetRef} planId={plan.id} />
    </>
  );
}
