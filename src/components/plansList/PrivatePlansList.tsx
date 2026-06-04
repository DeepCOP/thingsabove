import { GridCard, ListCard } from '@/src/components/DevoCard';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useMyDevotionalPlans } from '@/src/hooks/useDevotionalPlans';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import { GetMyDevotionalPlans } from '@/src/types/types';
import { planMatchesSelectedTags } from '@/src/utils/planTags';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useMemo, useState } from 'react';
import { FlatList, Text, TouchableOpacity, useColorScheme, View } from 'react-native';

type PrivatePlanCardItem = {
  author_id: string | null;
  completions: number | null;
  cover_image: string | null;
  created_at: string | null;
  description: string | null;
  helpful_count: number | null;
  id: string | null;
  rating_avg: number | null;
  rating_count: number | null;
  status: string | null;
  tags: string[] | null;
  title: string | null;
  total_days: number | null;
  updated_at: string | null;
  user_reaction: string | null;
  visibility: string | null;
};

const toPrivatePlanCardItem = (plan: GetMyDevotionalPlans[number]): PrivatePlanCardItem => ({
  author_id: null,
  completions: 0,
  cover_image: plan.cover_image ?? null,
  created_at: plan.created_at ?? null,
  description: plan.description ?? null,
  helpful_count: plan.helpful_count ?? 0,
  id: plan.id ?? null,
  rating_avg: 0,
  rating_count: 0,
  status: plan.status ?? null,
  tags: plan.tags ?? [],
  title: plan.title ?? null,
  total_days: plan.total_days ?? 0,
  updated_at: plan.created_at ?? null,
  user_reaction: null,
  visibility: plan.visibility ?? 'private',
});

export default function PrivatePlansList({ selectedTags = [] }: { selectedTags?: string[] }) {
  const colorScheme = useColorScheme();
  const { sort, isGrid } = useAppStore();
  const { session } = useAuth();
  const hasSelectedTags = !!session?.user?.id && selectedTags.length > 0;
  const myDevotionalPlansQuery = useMyDevotionalPlans(session?.user?.id);
  const [refreshing, setRefreshing] = useState(false);

  const privatePlans = useMemo(() => {
    const authoredPlans = myDevotionalPlansQuery.data ?? [];

    return authoredPlans
      .filter((plan) => plan.visibility === 'private' && plan.status === 'published')
      .map(toPrivatePlanCardItem)
      .filter((plan) => planMatchesSelectedTags(plan, selectedTags));
  }, [myDevotionalPlansQuery.data, selectedTags]);

  const sortedPlans = useMemo(() => {
    if (sort === 'Trending') {
      return [...privatePlans].sort(
        (planOne, planTwo) => (planTwo.helpful_count ?? 0) - (planOne.helpful_count ?? 0),
      );
    }

    return [...privatePlans].sort((planOne, planTwo) => {
      const timeOne = planOne.created_at ? new Date(planOne.created_at).getTime() : 0;
      const timeTwo = planTwo.created_at ? new Date(planTwo.created_at).getTime() : 0;
      return timeTwo - timeOne;
    });
  }, [privatePlans, sort]);

  const onRefresh = async () => {
    setRefreshing(true);
    await myDevotionalPlansQuery.refetch();
    setRefreshing(false);
  };

  const EmptyPrivatePlans = () => (
    <View className="flex-1 items-center justify-center px-4">
      <View className="w-full max-w-72 items-center rounded-2xl border border-gray-200 bg-white px-6 py-8 dark:border-neutral-800 dark:bg-neutral-900">
        <View className="mb-4 h-14 w-14 items-center justify-center rounded-full bg-gray-100 dark:bg-neutral-800">
          <Ionicons
            name="lock-closed-outline"
            size={24}
            color={colorScheme === 'dark' ? '#E5E7EB' : '#6B7280'}
          />
        </View>
        <Text className="mb-2 text-center text-lg font-semibold text-gray-900 dark:text-white">
          {hasSelectedTags
            ? 'No invite-only plans match these tags'
            : session?.user?.id
              ? 'No invite-only plans yet'
              : 'Sign in to view invite-only plans'}
        </Text>
        <Text className="text-center text-gray-600 dark:text-gray-400">
          {hasSelectedTags
            ? 'Try another tag or clear the filter.'
            : session?.user?.id
              ? 'Invite-only plans you publish will show up here so you can open and share them.'
              : 'Your authored invite-only plans will appear here after you sign in.'}
        </Text>
        {!session?.user?.id && (
          <TouchableOpacity
            onPress={() => router.push('/app/(auth)/signin')}
            className="mt-6 w-full rounded-xl bg-black py-3 dark:bg-white">
            <Text className="text-center font-semibold text-white dark:text-black">Sign In</Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );

  if (!session?.user?.id) {
    return <EmptyPrivatePlans />;
  }

  if (myDevotionalPlansQuery.isLoading) {
    return <LoadingSpinner />;
  }

  return (
    <FlatList
      className="flex-1"
      showsVerticalScrollIndicator={false}
      data={sortedPlans}
      keyExtractor={(item, index) => item.id ?? `private-plan-${index}`}
      refreshing={refreshing}
      onRefresh={onRefresh}
      key={isGrid ? 'grid' : 'list'}
      numColumns={isGrid ? 2 : 1}
      columnWrapperStyle={isGrid ? { gap: 12 } : undefined}
      contentContainerStyle={{
        flexGrow: 1,
        justifyContent: sortedPlans.length === 0 ? 'center' : undefined,
        paddingBottom: 40,
      }}
      renderItem={({ item }) =>
        isGrid ? (
          <GridCard
            item={item}
            onPress={() => item.id && router.push(`/app/devotional_detail/${item.id}`)}
          />
        ) : (
          <ListCard
            item={item}
            onPress={() => item.id && router.push(`/app/devotional_detail/${item.id}`)}
          />
        )
      }
      ListEmptyComponent={<EmptyPrivatePlans />}
    />
  );
}
