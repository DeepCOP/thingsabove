import { useTranslation } from 'react-i18next';
import { RelatedPlanSkeleton } from '@/src/components/PlanSkeleton';
import PlanCoverImage from '@/src/components/PlanCoverImage';
import { useRouter } from 'expo-router';
import { FlatList, Text, TouchableOpacity, View } from 'react-native';
import { useRelatedPlans } from '../hooks/useDevotionalPlans';
import { DevotionalPlan } from '../types/types';

export function RelatedPlansSection({ plan }: { plan: DevotionalPlan | undefined | null }) {
  const { t } = useTranslation('plans');
  const tags = plan?.tags ? plan.tags : [];
  const { data, isLoading } = useRelatedPlans(tags, plan?.id || '');
  const router = useRouter();

  const noResults = !isLoading && (!data || data.length === 0);

  return (
    <View className="mt-10 px-4">
      <Text className="text-2xl font-bold mb-4 dark:text-white">{t('relatedPlans')}</Text>

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
            {t('noRelatedPlans')}
          </Text>
        ) : (
          <FlatList
            horizontal
            data={data}
            keyExtractor={(item, index) => item.id ?? `related-plan-${index}`}
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={{ paddingRight: 10 }}
            renderItem={({ item }) => (
              <TouchableOpacity
                className="mr-4 w-48"
                onPress={() => router.push(`/app/devotional_detail/${item?.id}`)}>
                <PlanCoverImage uri={item.cover_image} className="h-28 w-full rounded-xl" />
                <Text className="mt-2 text-gray-700 dark:text-gray-300 font-semibold">
                  {t('days', { count: item.total_days ?? 0 })}
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
