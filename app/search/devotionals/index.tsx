import { ListCard } from '@/components/DevoCard';
import { useSearchPlans } from '@/hooks/usePlans';
import { Ionicons } from '@expo/vector-icons';
import NetInfo from '@react-native-community/netinfo';
import React, { useEffect, useState } from 'react';
import { ActivityIndicator, FlatList, Text, TextInput, useColorScheme, View } from 'react-native';

export default function SearchDevos() {
  const [search, setSearch] = useState('');
  const [debounced, setDebounced] = useState('');
  const [isOffline, setOffline] = useState(false);

  const colorScheme = useColorScheme();

  // Debounce 400ms
  useEffect(() => {
    const timeout = setTimeout(() => setDebounced(search), 400);
    return () => clearTimeout(timeout);
  }, [search]);

  // Detect offline
  useEffect(() => {
    const unsubscribe = NetInfo.addEventListener((state) => {
      setOffline(!state.isConnected);
    });

    return () => unsubscribe();
  }, []);

  const searchQuery = useSearchPlans(debounced);

  const flatData = searchQuery.data?.pages.flatMap((page) => page.items) || [];

  return (
    <View className="flex-1 px-4 pt-3">
      {/* Search Input */}
      <View className="flex-row items-center bg-white dark:bg-neutral-900 px-4 py-2 rounded-full mb-4 shadow">
        <Ionicons name="search" size={20} color={colorScheme === 'dark' ? '#fff' : '#222'} />
        <TextInput
          placeholder="Search devotionals..."
          value={search}
          onChangeText={setSearch}
          className="ml-2 flex-1 text-gray-900 dark:text-gray-100"
          placeholderTextColor="#aaa"
        />
      </View>
      {searchQuery.isLoading && <ActivityIndicator style={{ marginTop: 30 }} size="large" />}

      {/* Offline UI */}
      {isOffline && (
        <View className="items-center py-20">
          <Ionicons name="cloud-offline-outline" size={40} color="#999" />
          <Text className="text-gray-500 mt-2">You&apos;re offline</Text>
        </View>
      )}

      {/* No Query */}
      {debounced.length === 0 && !isOffline && (
        <View className="items-center py-20">
          <Ionicons name="book-outline" size={40} color="#aaa" />
          <Text className="text-gray-500 mt-2">Search devotionals...</Text>
        </View>
      )}

      {/* No Results */}
      {!isOffline && debounced.length > 0 && flatData.length === 0 && !searchQuery.isLoading && (
        <View className="items-center py-20">
          <Ionicons name="alert-circle-outline" size={40} color="#aaa" />
          <Text className="text-gray-500 mt-2">No results found</Text>
        </View>
      )}

      {/* Results */}
      <FlatList
        data={flatData}
        keyExtractor={(item) => item.id!}
        showsVerticalScrollIndicator={false}
        contentContainerStyle={{ paddingBottom: 40 }}
        renderItem={({ item }) => <ListCard item={item} />}
        onEndReached={() => {
          if (searchQuery.hasNextPage) {
            searchQuery.fetchNextPage();
          }
        }}
        onEndReachedThreshold={2}
        ListFooterComponent={
          searchQuery.isFetchingNextPage ? (
            <ActivityIndicator size="small" style={{ marginTop: 10 }} />
          ) : null
        }
      />
    </View>
  );
}
