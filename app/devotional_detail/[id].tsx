import { RelatedPlansSection } from '@/components/RelatedPlans';
import { useFetchPlan } from '@/hooks/usePlans';
import { Ionicons } from '@expo/vector-icons';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import {
  ActivityIndicator,
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

  const planQuery = useFetchPlan(id as string);
  const plan = planQuery.data;

  if (planQuery.isLoading) {
    return <ActivityIndicator style={{ marginTop: 30 }} size="large" />;
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
          <Image
            source={{ uri: plan?.cover_image || undefined }}
            className="w-full h-60 rounded-2xl"
            resizeMode="cover"
          />

          {/* Completion ribbon */}
          {(plan?.completions ?? 0) > 0 && (
            <View className="absolute bottom-0 left-4 right-4 bg-black/50 py-2 rounded-b-2xl">
              <Text className="text-center text-white font-semibold">
                Over {plan?.completions} completions
              </Text>
            </View>
          )}
        </View>

        {/* Title + Days */}
        <View className="px-4 mt-5">
          <Text className="text-2xl font-bold text-gray-900 dark:text-gray-100 leading-snug">
            {plan?.title}
          </Text>

          <View className="flex-row items-center gap-2 mt-2">
            <Text className="text-gray-600 dark:text-gray-300">{plan?.total_days} Days</Text>
          </View>
        </View>

        {/* Start Plan Button */}
        <TouchableOpacity
          className="mt-6 mx-4 bg-black dark:bg-white py-4 rounded-full"
          onPress={() => router.push(`/devotional_detail/${plan?.id}/start`)}>
          <Text className="text-center text-white dark:text-black font-semibold text-lg">
            Start Plan
          </Text>
        </TouchableOpacity>

        {/* Description */}
        <View className="px-4 mt-6">
          <Text className="text-[16px] leading-7 text-gray-800 dark:text-gray-200">
            {plan?.description}
          </Text>
        </View>

        <RelatedPlansSection plan={plan} />
      </ScrollView>
    </>
  );
}
