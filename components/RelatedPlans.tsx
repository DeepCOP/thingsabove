import { RelatedPlanSkeleton } from '@/components/PlanSkeleton';
import { useRelatedPlans } from '@/hooks/usePlans';
import { DevotionalPlan } from '@/types/types';
import { useRouter } from 'expo-router';
import { FlatList, Image, Text, TouchableOpacity, View } from 'react-native';

export function RelatedPlansSection({ plan }: { plan: DevotionalPlan | undefined | null }) {
  const tags = plan?.tags ? plan.tags : '';
  const { data, isLoading } = useRelatedPlans(tags, plan?.id || '');
  const router = useRouter();

  const noResults = !isLoading && (!data || data.length === 0);

  return (
    <View className="mt-10 px-4">
      <Text className="text-2xl font-bold mb-4 dark:text-white">Related Plans</Text>

      <View style={{ width: '100%' }}>
        {isLoading ? (
          <FlatList
            data={[1, 2, 3, 4]}
            horizontal
            keyExtractor={(i) => i.toString()}
            showsHorizontalScrollIndicator={false}
            renderItem={() => <RelatedPlanSkeleton />}
          />
        ) : noResults ? (
          <Text className="text-gray-600 dark:text-gray-400 text-base px-2">
            No related plans found.
          </Text>
        ) : (
          <FlatList
            horizontal
            data={data}
            keyExtractor={(item) => item.id}
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={{ paddingRight: 10 }}
            renderItem={({ item }) => (
              <TouchableOpacity
                className="mr-4 w-48"
                onPress={() => router.push(`/devotional_detail/${item?.id}`)}>
                <Image
                  source={{ uri: item.cover_image || undefined }}
                  className="h-28 w-full rounded-xl"
                  resizeMode="cover"
                />
                <Text className="mt-2 text-gray-700 dark:text-gray-300 font-semibold">
                  {item.total_days} Days
                </Text>
                <Text className="text-gray-900 dark:text-gray-100" numberOfLines={2}>
                  {item.title}
                </Text>
              </TouchableOpacity>
            )}
          />
        )}
      </View>
    </View>
  );
}
