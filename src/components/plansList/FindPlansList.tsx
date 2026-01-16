import { GridCard, ListCard } from '@/src/components/DevoCard';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { usePlans } from '@/src/hooks/useDevotionalPlans';
import { useAppStore } from '@/src/state/useAppStore';
import { router } from 'expo-router';
import { useMemo, useState } from 'react';
import { FlatList } from 'react-native';

export default function FindPlansList() {
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
