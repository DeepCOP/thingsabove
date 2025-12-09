import { GridCard, ListCard } from '@/components/DevoCard';
import Dropdown from '@/components/DropDown';
import { usePlans } from '@/hooks/usePlans';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useMemo, useState } from 'react';
import {
  ActivityIndicator,
  FlatList,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';

export default function PlansScreen() {
  const { plansQuery } = usePlans();
  const colorScheme = useColorScheme();

  const [sort, setSort] = useState('Recent');
  const [isGrid, setIsGrid] = useState(false);
  // flatten pages and deduplicate by `id` to avoid duplicate items
  const flatData = useMemo(() => {
    const items = plansQuery.data?.pages.flatMap((page) => page.items) || [];
    return items;
  }, [plansQuery.data]);
  const sortedPlans = useMemo(() => {
    if (!flatData) return [];
    if (sort === 'Recent') {
      return [...flatData].sort(
        (a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime(),
      );
    }

    if (sort === 'Trending') {
      return [...flatData].sort(
        (a, b) => b.likes_count + b.comments_count * 2 - (a.likes_count + a.comments_count * 2),
      );
    }

    return flatData;
  }, [sort, flatData]);

  return (
    <View className="flex-1 bg-gray-100 dark:bg-black px-4 pt-12">
      {/* Top Bar */}
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
        </View>
      </View>

      {/* Sort Dropdown */}
      <View className="flex-row items-center mb-3">
        <Text className="text-gray-700 dark:text-gray-200 mr-2">Sort by:</Text>

        <Dropdown value={sort} onChange={(v) => setSort(v)} options={['Recent', 'Trending']} />
      </View>

      {plansQuery.isLoading && <ActivityIndicator style={{ marginTop: 30 }} size="large" />}

      {/* Plan list */}
      <FlatList
        showsVerticalScrollIndicator={false}
        data={sortedPlans}
        keyExtractor={(item) => item.id}
        key={isGrid ? 'grid' : 'list'}
        numColumns={isGrid ? 2 : 1}
        columnWrapperStyle={isGrid ? { gap: 12 } : undefined}
        contentContainerStyle={{ paddingBottom: 40 }}
        renderItem={({ item }) => (isGrid ? <GridCard item={item} /> : <ListCard item={item} />)}
        onEndReached={() => {
          if (plansQuery.hasNextPage) {
            plansQuery.fetchNextPage();
          }
        }}
        onEndReachedThreshold={2}
        ListFooterComponent={
          plansQuery.isFetchingNextPage ? (
            <ActivityIndicator size="small" style={{ marginTop: 10 }} />
          ) : null
        }
      />
    </View>
  );
}
