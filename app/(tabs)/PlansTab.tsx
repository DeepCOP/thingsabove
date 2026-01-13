import { GridCard, ListCard } from '@/components/DevoCard';
import Dropdown from '@/components/DropDown';
import LoadingSpinner from '@/components/LoadingSpinner';
import { MyPlansToggle } from '@/components/MyPlansToggle';
import { useAuth } from '@/context/AuthContext';
import { useFetchUserPlans, usePlans } from '@/hooks/useDevotionalPlans';
import { useUserPlanProgress } from '@/hooks/usePlanProgress';
import { useAppStore } from '@/store/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useMemo, useState } from 'react';
import { FlatList, Text, TouchableOpacity, useColorScheme, View } from 'react-native';

export default function PlansScreen() {
  const { session } = useAuth();
  const colorScheme = useColorScheme();
  const [activeTab, setActiveTab] = useState<'my-plans' | 'find-plans'>('my-plans');

  const { sort, setSort, isGrid, setIsGrid } = useAppStore();

  return (
    <View className="flex-1 bg-gray-100 dark:bg-black px-4 pt-12">
      <View className="flex-row justify-between items-center mb-4">
        <TouchableOpacity onPress={() => setIsGrid(!isGrid)}>
          <Ionicons
            name={isGrid ? 'list-outline' : 'grid-outline'}
            size={24}
            color={colorScheme === 'dark' ? '#fff' : '#222'}
          />
        </TouchableOpacity>

        <View className="flex-row items-center gap-4">
          <Ionicons
            name="search"
            size={22}
            color={colorScheme === 'dark' ? '#fff' : '#222'}
            onPress={() => router.push('/search/devotionals')}
          />
          <Ionicons
            name="settings-outline"
            size={22}
            color={colorScheme === 'dark' ? '#fff' : '#222'}
          />
          {!session && (
            <TouchableOpacity onPress={() => router.push('/login/signin')}>
              <Ionicons
                name="person-add"
                size={22}
                color={colorScheme === 'dark' ? '#fff' : '#222'}
              />
            </TouchableOpacity>
          )}
        </View>
      </View>
      <MyPlansToggle activeTab={activeTab} onChange={setActiveTab} />

      <View className="flex-row items-center mb-3">
        <Text className="text-gray-700 dark:text-gray-200 mr-2">Sort by:</Text>

        <Dropdown
          value={sort}
          onChange={(v) => setSort(v as 'Recent' | 'Trending')}
          options={['Recent', 'Trending']}
        />
      </View>

      {activeTab === 'my-plans' && <MyPlansList />}
      {activeTab === 'find-plans' && <FindPlansList />}
    </View>
  );
}

function FindPlansList() {
  const { plansQuery } = usePlans();

  const { sort, isGrid } = useAppStore();
  const flatData = useMemo(() => {
    const items = plansQuery.data?.pages.flatMap((page) => page.items) || [];
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
        (a, b) => new Date(b.created_at!).getTime() - new Date(a.created_at!).getTime(),
      );
    }

    if (sort === 'Trending') {
      return [...flatData].sort((a, b) => (b.likes_count || 0) - (a.likes_count || 0));
    }

    return flatData;
  }, [sort, flatData]);

  if (plansQuery.isLoading) {
    return <LoadingSpinner />;
  }
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
      renderItem={({ item }) =>
        isGrid ? (
          <GridCard item={item} onPress={() => router.push(`/devotional_detail/${item.id}`)} />
        ) : (
          <ListCard item={item} onPress={() => router.push(`/devotional_detail/${item.id}`)} />
        )
      }
      onEndReached={() => {
        if (plansQuery.hasNextPage) {
          plansQuery.fetchNextPage();
        }
      }}
      onEndReachedThreshold={2}
      ListFooterComponent={
        plansQuery.isFetchingNextPage ? (
          <LoadingSpinner style={{ marginTop: 30 }} size={'small'} />
        ) : null
      }
    />
  );
}

function MyPlansList() {
  const { session } = useAuth();
  const userPlanProgressQuery = useUserPlanProgress(session?.user.id);
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
        keyExtractor={(item) => item.progress_id!}
        refreshing={refreshing}
        onRefresh={onRefresh}
        key={isGrid ? 'grid' : 'list'}
        numColumns={isGrid ? 2 : 1}
        columnWrapperStyle={isGrid ? { gap: 12 } : undefined}
        contentContainerStyle={{ paddingBottom: 40 }}
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
                  pathname: '/plan_progress/[planId]',
                  params: {
                    groupId: item.group_id,
                    planId: item.id!,
                  },
                })
              }
            />
          ) : (
            <ListCard
              item={item}
              onPress={() =>
                router.push({
                  pathname: '/plan_progress/[planId]',
                  params: {
                    groupId: item.group_id,
                    planId: item.id!,
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
