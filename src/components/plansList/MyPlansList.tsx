import { GridCard, ListCard } from '@/src/components/DevoCard';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useFetchUserPlans } from '@/src/hooks/useDevotionalPlans';
import { useUserPlanProgressList } from '@/src/hooks/usePlanProgress';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useMemo, useState } from 'react';
import { FlatList, Text, TouchableOpacity, useColorScheme, View } from 'react-native';

export default function MyPlansList({
  listHeaderComponent,
  listFooterComponent,
  containterStyle,
}: {
  listHeaderComponent?: React.JSX.Element;
  listFooterComponent?: React.JSX.Element;
  containterStyle?: object;
}) {
  const { session, loading: sessionLoading } = useAuth();
  const userPlanProgressQuery = useUserPlanProgressList(session?.user?.id);
  const colorScheme = useColorScheme();
  const userPlanProgress = useMemo(
    () => userPlanProgressQuery.data ?? [],
    [userPlanProgressQuery.data],
  );
  const plansQuery = useFetchUserPlans(
    userPlanProgress?.map((progress) => progress?.plan_id ?? '') || [],
    session?.user.id!,
  );

  const flataData = useMemo(() => {
    return userPlanProgress
      .map((progress) => {
        const plan = plansQuery.data?.find((plan) => plan.id === progress.plan_id);

        return plan
          ? {
              ...plan,
              progress_id: progress.id,
              group_id: progress.group_id,
              completed_days: progress.completed_days?.length || 0,
            }
          : null;
      })
      .filter((plan) => plan !== null);
  }, [userPlanProgress, plansQuery.data]);

  const { sort, isGrid } = useAppStore();

  const [refreshing, setRefreshing] = useState(false);

  const onRefresh = async () => {
    setRefreshing(true);

    await userPlanProgressQuery.refetch();

    setRefreshing(false);
  };
  const EmptyPlans = () => (
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
          You don&apos;t have any plans yet
        </Text>
        <Text className="text-center text-gray-600 dark:text-gray-400">
          Find a plan to start your first streak.
        </Text>
      </View>
    </View>
  );

  const sortedPlans = useMemo(() => {
    if (!flataData) return [];
    if (sort === 'Recent') {
      return [...flataData].sort(
        (a, b) => new Date(b.created_at!).getTime() - new Date(a.created_at!).getTime(),
      );
    }

    if (sort === 'Trending') {
      return [...flataData].sort((a, b) => (b.likes_count || 0) - (a.likes_count || 0));
    }

    return flataData;
  }, [sort, flataData]);
  if (!session && !sessionLoading) {
    return (
      <View className="flex-1 items-center justify-center px-4">
        <View className="w-full max-w-72 bg-white dark:bg-neutral-900 border border-gray-200 dark:border-neutral-800 rounded-2xl px-6 py-8 items-center">
          <View className="w-14 h-14 rounded-full bg-gray-100 dark:bg-neutral-800 items-center justify-center mb-4">
            <Ionicons
              name="lock-closed"
              size={24}
              color={colorScheme === 'dark' ? '#E5E7EB' : '#6B7280'}
            />
          </View>
          <Text className="text-lg font-semibold text-gray-900 dark:text-white mb-2 text-center">
            Sign in to view your plans
          </Text>
          <Text className="text-center text-gray-600 dark:text-gray-400 mb-6">
            Save progress, track streaks, and pick up right where you left off.
          </Text>
          <TouchableOpacity
            onPress={() => router.push('/(auth)/signin')}
            className="w-full bg-black dark:bg-white py-3 rounded-xl mb-3">
            <Text className="text-center text-white dark:text-black font-semibold">Sign In</Text>
          </TouchableOpacity>
          <TouchableOpacity
            onPress={() => router.push('/(auth)/signup')}
            className="w-full border border-black dark:border-white py-3 rounded-xl">
            <Text className="text-center font-semibold dark:text-white">Create Account</Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  }
  if (plansQuery.isLoading || userPlanProgressQuery.isLoading || sessionLoading) {
    return <LoadingSpinner />;
  }

  return (
    <>
      <FlatList
        showsVerticalScrollIndicator={false}
        data={sortedPlans}
        ListHeaderComponent={listHeaderComponent}
        ListFooterComponent={listFooterComponent}
        keyExtractor={(item) => item.progress_id!}
        refreshing={refreshing}
        onRefresh={onRefresh}
        ListEmptyComponent={<EmptyPlans />}
        key={isGrid ? 'grid' : 'list'}
        numColumns={isGrid ? 2 : 1}
        columnWrapperStyle={isGrid ? { gap: 12 } : undefined}
        contentContainerStyle={{ paddingBottom: 40, ...containterStyle }}
        renderItem={({ item }) => {
          return isGrid ? (
            <GridCard
              item={item}
              onPress={() =>
                router.push({
                  pathname: '/plan_progress/[progressId]',
                  params: {
                    groupId: item.group_id,
                    planId: item.id!,
                    progressId: item.progress_id!,
                  },
                })
              }
            />
          ) : (
            <ListCard
              item={item}
              onPress={() =>
                router.push({
                  pathname: '/plan_progress/[progressId]',
                  params: {
                    groupId: item.group_id,
                    planId: item.id!,
                    progressId: item.progress_id!,
                  },
                })
              }
            />
          );
        }}
      />
    </>
  );
}
