import { ListCard } from '@/src/components/DevoCard';
import { Ionicons } from '@expo/vector-icons';
import { ActivityIndicator, FlatList, Text, TextInput, useColorScheme, View } from 'react-native';

type Props = {
  search: string;
  onChangeSearch: (v: string) => void;
  isOffline: boolean;
  isLoading: boolean;
  data: any[];
  onPressItem: (id: string) => void;
  onLoadMore: () => void;
  isFetchingNextPage: boolean;
};

export default function SearchDevosScreen({
  search,
  onChangeSearch,
  isOffline,
  isLoading,
  data,
  onPressItem,
  onLoadMore,
  isFetchingNextPage,
}: Props) {
  const colorScheme = useColorScheme();
  return (
    <View className="flex-1 px-4 pt-3">
      {/* Search Input */}
      <View className="flex-row items-center bg-white dark:bg-neutral-900 px-4 py-2 rounded-full mb-4 shadow">
        <Ionicons name="search" size={20} color={colorScheme === 'dark' ? '#fff' : '#222'} />
        <TextInput
          placeholder="Search devotionals..."
          value={search}
          onChangeText={onChangeSearch}
          className="ml-2 flex-1 text-gray-900 dark:text-gray-100"
          placeholderTextColor="#aaa"
        />
      </View>

      {isLoading && <ActivityIndicator style={{ marginTop: 30 }} size="large" />}

      {/* Offline */}
      {isOffline && (
        <View className="items-center py-20">
          <Ionicons name="cloud-offline-outline" size={40} color="#999" />
          <Text className="text-gray-500 mt-2">You&apos;re offline</Text>
        </View>
      )}

      {/* Empty query */}
      {!isOffline && search.length === 0 && (
        <View className="items-center py-20">
          <Ionicons name="book-outline" size={40} color="#aaa" />
          <Text className="text-gray-500 mt-2">Search devotionals...</Text>
        </View>
      )}

      {/* No results */}
      {!isOffline && search.length > 0 && data.length === 0 && !isLoading && (
        <View className="items-center py-20">
          <Ionicons name="alert-circle-outline" size={40} color="#aaa" />
          <Text className="text-gray-500 mt-2">No results found</Text>
        </View>
      )}

      {/* Results */}
      <FlatList
        data={data}
        keyExtractor={(item) => item.id!}
        showsVerticalScrollIndicator={false}
        contentContainerStyle={{ paddingBottom: 40 }}
        renderItem={({ item }) => <ListCard item={item} onPress={() => onPressItem(item.id)} />}
        onEndReached={onLoadMore}
        onEndReachedThreshold={2}
        ListFooterComponent={
          isFetchingNextPage ? <ActivityIndicator size="small" style={{ marginTop: 10 }} /> : null
        }
      />
    </View>
  );
}
