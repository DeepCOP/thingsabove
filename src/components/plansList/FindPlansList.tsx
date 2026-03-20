import { GridCard, ListCard } from '@/src/components/DevoCard';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { usePlans } from '@/src/hooks/useDevotionalPlans';
import { useSavedPlans, useToggleSavedPlan } from '@/src/hooks/useSavedPlans';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useMemo, useState } from 'react';
import { FlatList, Text, useColorScheme, View } from 'react-native';

export default function FindPlansList() {
  const { plansQuery } = usePlans();
  const colorScheme = useColorScheme();
  const { session } = useAuth();
  const { sort, isGrid } = useAppStore();
  const savedPlansQuery = useSavedPlans(session?.user?.id);
  const savedPlanIds = useMemo(
    () =>
      (savedPlansQuery.data ?? [])
        .map((savedPlan) => savedPlan.id)
        .filter((planId): planId is string => typeof planId === 'string' && planId.length > 0),
    [savedPlansQuery.data],
  );
  const { toggleSavedPlan } = useToggleSavedPlan(session?.user?.id);
  const flatData = useMemo(() => {
    const items =
      plansQuery.data?.pages.flatMap((page) =>
        page.items.map((item) => ({
          ...item,
          helpful_count: (item as { helpful_count?: number | null }).helpful_count ?? 0,
          user_reaction:
            (item as { user_reaction?: string | null }).user_reaction === 'helpful'
              ? ('helpful' as const)
              : null,
        })),
      ) || [];
    return items;
  }, [plansQuery.data]);

  const [refreshing, setRefreshing] = useState(false);

  const onRefresh = async () => {
    setRefreshing(true);

    await plansQuery.refetch();

    setRefreshing(false);
  };

  const sortedPlans = useMemo(() => {
    if (!flatData) return [];

    if (sort === 'Recent') {
      return [...flatData].sort(
        (planOne, planTwo) =>
          new Date(planTwo.created_at!).getTime() - new Date(planOne.created_at!).getTime(),
      );
    }

    if (sort === 'Trending') {
      return [...flatData].sort(
        (planOne, planTwo) => (planTwo.helpful_count || 0) - (planOne.helpful_count || 0),
      );
    }

    return flatData;
  }, [sort, flatData]);

  if (plansQuery.isLoading) {
    return <LoadingSpinner />;
  }
  const EmptyPlans = () => {
    return (
      <View className="flex-1 items-center justify-center px-4">
        <View className="w-full max-w-72 bg-white dark:bg-neutral-900 border border-gray-200 dark:border-neutral-800 rounded-2xl px-6 py-8 items-center">
          <View className="w-14 h-14 rounded-full bg-gray-100 dark:bg-neutral-800 items-center justify-center mb-4">
            <Ionicons
              name="book-sharp"
              size={24}
              color={colorScheme === 'dark' ? '#E5E7EB' : '#6B7280'}
            />
          </View>
          <Text className="text-lg font-semibold text-gray-900 dark:text-white mb-2 text-center">
            No plans found
          </Text>
          <Text className="text-center text-gray-600 dark:text-gray-400">
            Try searching for a topic or check back later.
          </Text>
        </View>
      </View>
    );
  };
  return (
    <FlatList
      showsVerticalScrollIndicator={false}
      data={sortedPlans}
      keyExtractor={(item) => item.id!}
      refreshing={refreshing}
      onRefresh={onRefresh}
      key={isGrid ? 'grid' : 'list'}
      numColumns={isGrid ? 2 : 1}
      columnWrapperStyle={isGrid ? { gap: 12 } : undefined}
      contentContainerStyle={{ paddingBottom: 40 }}
      renderItem={({ item }) => {
        const planId = item.id as string | null;
        const isSaved = !!planId && savedPlanIds.includes(planId);

        return isGrid ? (
          <GridCard
            item={item}
            isSaved={isSaved}
            onToggleSave={() => {
              if (!planId) return;
              if (!session?.user?.id) {
                router.push('/(auth)/signin');
                return;
              }
              toggleSavedPlan(planId, isSaved, item);
            }}
            onPress={() => router.push(`/devotional_detail/${item.id}`)}
          />
        ) : (
          <ListCard
            item={item}
            isSaved={isSaved}
            onToggleSave={() => {
              if (!planId) return;
              if (!session?.user?.id) {
                router.push('/(auth)/signin');
                return;
              }
              toggleSavedPlan(planId, isSaved, item);
            }}
            onPress={() => router.push(`/devotional_detail/${item.id}`)}
          />
        );
      }}
      onEndReached={() => {
        if (plansQuery.hasNextPage) {
          plansQuery.fetchNextPage();
        }
      }}
      onEndReachedThreshold={2}
      ListEmptyComponent={<EmptyPlans />}
      ListFooterComponent={
        plansQuery.isFetchingNextPage ? (
          <LoadingSpinner style={{ marginTop: 30 }} size={'small'} />
        ) : null
      }
    />
  );
}
