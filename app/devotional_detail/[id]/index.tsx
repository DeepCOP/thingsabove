import LoadingSpinner from '@/components/LoadingSpinner';
import { RelatedPlansSection } from '@/components/RelatedPlans';
import { useAuth } from '@/context/AuthContext';
import { useFetchDevotionalPlanById } from '@/hooks/useDevotionalPlans';
import { usePlanProgress, useUserPlanProgress } from '@/hooks/usePlanProgress';
import { Ionicons } from '@expo/vector-icons';
import BottomSheet, { BottomSheetBackdrop, BottomSheetView } from '@gorhom/bottom-sheet';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { useRef } from 'react';
import {
  Image,
  ScrollView,
  Share,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';

export default function DevotionalDetailScreen() {
  const { id } = useLocalSearchParams(); // plan ID passed from card
  const router = useRouter();
  const colorScheme = useColorScheme();
  const { isGuest, session } = useAuth();
  const { insertToPlanProgress, planProgressQuery } = usePlanProgress(
    id as string,
    session?.user?.id,
  );
  const userPlanProgressQuery = useUserPlanProgress(session?.user.id);
  const userPlanProgress = userPlanProgressQuery.data || [];

  const bottomSheetRef = useRef<BottomSheet>(null);

  const planQuery = useFetchDevotionalPlanById(id as string);
  const plan = planQuery.data;

  if (planQuery.isLoading || planProgressQuery.isLoading) {
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
      <Stack.Screen
        options={{
          headerRight: () => {
            return (
              <TouchableOpacity
                onPress={async () => {
                  const content = `Join me in reading ${plan?.title}\n\n ${process.env.EXPO_BASE_URL}/devotional_detail/${plan?.id}`;
                  await Share.share({ message: content });
                }}>
                <Ionicons
                  name="share-social-outline"
                  size={24}
                  color={colorScheme === 'dark' ? '#fff' : '#111'}
                />
              </TouchableOpacity>
            );
          },
        }}
      />
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
          }}
          disabled={insertToPlanProgress.isPending}>
          <Text className="text-center text-white dark:text-black font-semibold text-lg">
            Start Plan
          </Text>
        </TouchableOpacity>
        {userPlanProgress.length > 0 && (
          <TouchableOpacity
            className="mt-6 mx-4 bg-black dark:bg-white py-4 rounded-full"
            onPress={() => {
              router.push('/PlansTab');
            }}>
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
      <BottomSheet
        index={-1}
        snapPoints={['50%']}
        ref={bottomSheetRef}
        enablePanDownToClose={true}
        backgroundStyle={{ backgroundColor: colorScheme === 'dark' ? '#171717' : '#fff' }}
        backdropComponent={(props) => (
          <BottomSheetBackdrop
            {...props}
            opacity={0.7} // Adjust backdrop opacity
            pressBehavior="close" // Close sheet on backdrop tap
            disappearsOnIndex={-1} // Hide backdrop when sheet is fully closed (index -1)
            appearsOnIndex={0} // Show backdrop when sheet opens to the first snap point (index 0)
          />
        )}>
        <BottomSheetView className="flex-1 px-4 pt-4 items-center justify-center">
          {plan?.cover_image ? (
            <Image
              source={{ uri: plan.cover_image }}
              className="w-full max-w-28 h-28 rounded-2xl mb-3"
              resizeMode="cover"
            />
          ) : (
            <View className="w-full max-w-28 h-28 rounded-2xl bg-gray-300 dark:bg-neutral-800 mt-3" />
          )}
          <Text className="text-3xl text-center font-bold dark:text-white mb-4">
            How Do you Want Read This Plan
          </Text>

          <View className="gap-3 w-full px-4 items-center justify-center">
            <TouchableOpacity
              onPress={() => {
                if (isGuest) {
                  router.push({
                    pathname: '/login/signin',
                    params: { redirectTo: `/plan_progress/${plan?.id}/index` },
                  });
                  return;
                }
                if (planProgressQuery.data) {
                  router.push(`/plan_progress/${plan?.id}`);
                  return;
                }
                insertToPlanProgress.mutate(
                  {
                    current_day: 1,
                    plan_id: id as string,
                    user_id: session?.user?.id as string,
                  },
                  {
                    onSuccess: () => {
                      router.push(`/plan_progress/${plan?.id}`);
                    },
                  },
                );
              }}
              className="px-4 py-4 rounded-full  bg-gray-300 dark:bg-neutral-600 w-full flex-row items-center justify-center">
              <Text className="text-gray-900 text-lg font-bold dark:text-white">By YourSelf</Text>
            </TouchableOpacity>
            <TouchableOpacity
              className="px-4 py-4 rounded-full  bg-gray-300 dark:bg-neutral-600 w-full flex-row items-center justify-center"
              onPress={() => {
                if (isGuest) {
                  router.push({
                    pathname: '/login/signin',
                    params: { redirectTo: `/plan_progress/${plan?.id}/index` },
                  });
                  return;
                }
                router.push(`/devotional_detail/${plan?.id}/start-date`);
              }}>
              <Text className="text-gray-900 text-lg font-bold dark:text-white">With Friends</Text>
            </TouchableOpacity>
          </View>
        </BottomSheetView>
      </BottomSheet>
    </>
  );
}
