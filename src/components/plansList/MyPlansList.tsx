import { GridCard, ListCard } from '@/src/components/DevoCard';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useFetchUserPlans } from '@/src/hooks/useDevotionalPlans';
import { useUserPlanProgressList } from '@/src/hooks/usePlanProgress';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useMemo, useState } from 'react';
import { FlatList, Text, View } from 'react-native';

export default function MyPlansList({
  listHeaderComponent,
  listFooterComponent,
  containterStyle,
}: {
  listHeaderComponent?: React.ReactNode;
  listFooterComponent?: React.ReactNode;
  containterStyle?: object;
}) {
  const { session } = useAuth();
  const userPlanProgressQuery = useUserPlanProgressList(session?.user?.id);
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

  if (!session) {
    return (
      <View className="flex-1 items-center justify-center">
        <Text className="text-gray-700 dark:text-gray-200">You are not logged in.</Text>
      </View>
    );
  }
  if (plansQuery.isLoading || userPlanProgressQuery.isLoading) {
    return <LoadingSpinner />;
  }
  return (
    <>
      {(!plansQuery.data || plansQuery.data.length === 0 || !userPlanProgressQuery.data) && (
        <View className="items-center justify-center absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2  ">
          <Ionicons name="book-sharp" size={50} color="gray" />
          <Text className="text-gray-700 dark:text-gray-200">You don&apos;t have plan</Text>
        </View>
      )}
      <FlatList
        showsVerticalScrollIndicator={false}
        data={sortedPlans}
        ListHeaderComponent={() => listHeaderComponent}
        ListFooterComponent={() => listFooterComponent}
        keyExtractor={(item) => item.progress_id!}
        refreshing={refreshing}
        onRefresh={onRefresh}
        key={isGrid ? 'grid' : 'list'}
        numColumns={isGrid ? 2 : 1}
        columnWrapperStyle={isGrid ? { gap: 12 } : undefined}
        contentContainerStyle={{ paddingBottom: 40, ...containterStyle }}
        renderItem={({ item }) => {
          if (!plansQuery.data || plansQuery.data.length === 0 || !userPlanProgressQuery.data) {
            return (
              <View className="flex-1 items-center justify-center">
                <Text className="text-gray-700 dark:text-gray-200">You don&apos;t have plan</Text>
              </View>
            );
          }
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
