import { GridCard, ListCard } from '@/src/components/DevoCard';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useFetchUserPlans } from '@/src/hooks/useDevotionalPlans';
import { useUserPlanProgressList } from '@/src/hooks/usePlanProgress';
import { useSavedPlanIds, useToggleSavedPlan } from '@/src/hooks/useSavedPlans';
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
  mode = 'all',
}: {
  listHeaderComponent?: React.JSX.Element;
  listFooterComponent?: React.JSX.Element;
  containterStyle?: object;
  mode?: 'all' | 'completed';
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
              completed_once: !!progress.completed_once,
              helpful_count: (plan as { helpful_count?: number | null }).helpful_count ?? 0,
              user_reaction:
                (plan as { user_reaction?: string | null }).user_reaction === 'helpful'
                  ? ('helpful' as const)
                  : null,
            }
          : null;
      })
      .filter((plan) => plan !== null);
  }, [userPlanProgress, plansQuery.data]);

  const visibleData = useMemo(() => {
    if (mode !== 'completed')
      return flataData.filter(
        (plan) =>
          (plan.completed_days ?? 0) < (typeof plan.total_days === 'number' ? plan.total_days : 0),
      );

    return flataData.filter(
      (plan) =>
        (plan.completed_days ?? 0) >= (typeof plan.total_days === 'number' ? plan.total_days : 0),
    );
  }, [flataData, mode]);

  const { sort, isGrid } = useAppStore();
  const savedPlanIdsQuery = useSavedPlanIds(session?.user?.id);
  const savedPlanIds = savedPlanIdsQuery.data ?? [];
  const { toggleSavedPlan } = useToggleSavedPlan(session?.user?.id);

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
        {mode === 'completed' ? (
          <>
            <Text className="text-lg font-semibold text-gray-900 dark:text-white mb-2 text-center">
              No completed plans yet
            </Text>
            <Text className="text-center text-gray-600 dark:text-gray-400">
              Finish a plan and it will appear here.
            </Text>
          </>
        ) : (
          <>
            <Text className="text-lg font-semibold text-gray-900 dark:text-white mb-2 text-center">
              You don&apos;t have any plans yet
            </Text>
            <Text className="text-center text-gray-600 dark:text-gray-400">
              Find a plan to start your first streak.
            </Text>
          </>
        )}
      </View>
    </View>
  );

  const sortedPlans = useMemo(() => {
    if (!visibleData) return [];

    if (sort === 'Recent') {
      return [...visibleData].sort(
        (a, b) => new Date(b.created_at!).getTime() - new Date(a.created_at!).getTime(),
      );
    }

    if (sort === 'Trending') {
      return [...visibleData].sort((a, b) => (b.helpful_count || 0) - (a.helpful_count || 0));
    }

    return visibleData;
  }, [sort, visibleData]);
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
          const planId = item.id as string | null;
          const isSaved = !!planId && savedPlanIds.includes(planId);

          return isGrid ? (
            <GridCard
              item={item}
              isSaved={isSaved}
              onToggleSave={() => planId && toggleSavedPlan(planId, isSaved)}
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
              isSaved={isSaved}
              onToggleSave={() => planId && toggleSavedPlan(planId, isSaved)}
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
