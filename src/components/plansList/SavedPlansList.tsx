import { GridCard, ListCard } from '@/src/components/DevoCard';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useSavedPlans, useToggleSavedPlan } from '@/src/hooks/useSavedPlans';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import { planMatchesSelectedTags } from '@/src/utils/planTags';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useMemo, useState } from 'react';
import { FlatList, Text, useColorScheme, View } from 'react-native';

export default function SavedPlansList({ selectedTags = [] }: { selectedTags?: string[] }) {
  const colorScheme = useColorScheme();
  const { sort, isGrid } = useAppStore();
  const { session } = useAuth();
  const hasSelectedTags = !!session?.user?.id && selectedTags.length > 0;
  const savedPlansQuery = useSavedPlans(session?.user?.id);
  const { toggleSavedPlan } = useToggleSavedPlan(session?.user?.id);
  const [refreshing, setRefreshing] = useState(false);

  const flatData = useMemo(() => {
    if (!savedPlansQuery.data) return [];

    return savedPlansQuery.data;
  }, [savedPlansQuery.data]);

  const savedPlanIds = useMemo(
    () =>
      flatData
        .map((savedPlan) => savedPlan.id)
        .filter((planId): planId is string => typeof planId === 'string' && planId.length > 0),
    [flatData],
  );

  const visibleData = useMemo(
    () => flatData.filter((plan) => planMatchesSelectedTags(plan, selectedTags)),
    [flatData, selectedTags],
  );

  const sortedPlans = useMemo(() => {
    if (sort === 'Recent') {
      return [...visibleData].sort((a, b) => {
        const timeA = a.saved_at ? new Date(a.saved_at).getTime() : undefined;
        const timeB = b.saved_at ? new Date(b.saved_at).getTime() : undefined;

        if (timeA !== undefined && timeB !== undefined) {
          return timeB - timeA;
        }

        if (timeA !== undefined) return -1;
        if (timeB !== undefined) return 1;

        return 0;
      });
    }

    if (sort === 'Trending') {
      return [...visibleData].sort(
        (planOne, planTwo) => (planTwo.helpful_count || 0) - (planOne.helpful_count || 0),
      );
    }

    return visibleData;
  }, [sort, visibleData]);

  const onRefresh = async () => {
    setRefreshing(true);
    await savedPlansQuery.refetch();
    setRefreshing(false);
  };

  const EmptySavedPlans = () => (
    <View className="flex-1 items-center justify-center px-4">
      <View className="w-full max-w-72 bg-white dark:bg-neutral-900 border border-gray-200 dark:border-neutral-800 rounded-2xl px-6 py-8 items-center">
        <View className="w-14 h-14 rounded-full bg-gray-100 dark:bg-neutral-800 items-center justify-center mb-4">
          <Ionicons
            name="bookmark-outline"
            size={24}
            color={colorScheme === 'dark' ? '#E5E7EB' : '#6B7280'}
          />
        </View>
        <Text className="text-lg font-semibold text-gray-900 dark:text-white mb-2 text-center">
          {hasSelectedTags
            ? 'No saved plans match these tags'
            : session?.user?.id
              ? 'No saved plans yet'
              : 'Sign in to save plans'}
        </Text>
        <Text className="text-center text-gray-600 dark:text-gray-400">
          {hasSelectedTags
            ? 'Try another tag or clear the filter.'
            : session?.user?.id
              ? 'Save a plan to read later.'
              : 'Create an account to keep your saved plans in sync.'}
        </Text>
      </View>
    </View>
  );

  if (!session?.user?.id) {
    return <EmptySavedPlans />;
  }

  if (savedPlansQuery.isLoading) {
    return <LoadingSpinner />;
  }

  if (savedPlanIds.length === 0) {
    return <EmptySavedPlans />;
  }

  return (
    <FlatList
      className="flex-1"
      showsVerticalScrollIndicator={false}
      data={sortedPlans}
      keyExtractor={(item) => item.id!}
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
      renderItem={({ item }) => {
        const planId = item.id as string | null;
        const isSaved = !!planId && savedPlanIds.includes(planId);

        return isGrid ? (
          <GridCard
            item={item}
            isSaved={isSaved}
            onToggleSave={() => planId && toggleSavedPlan(planId, isSaved, item)}
            onPress={() => router.push(`/devotional_detail/${item.id}`)}
          />
        ) : (
          <ListCard
            item={item}
            isSaved={isSaved}
            onToggleSave={() => planId && toggleSavedPlan(planId, isSaved, item)}
            onPress={() => router.push(`/devotional_detail/${item.id}`)}
          />
        );
      }}
      ListEmptyComponent={<EmptySavedPlans />}
    />
  );
}
