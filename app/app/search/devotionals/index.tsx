import { useSearchPlans } from '@/src/hooks/useDevotionalPlans';
import SearchDevosScreen from '@/src/screens/SearchDevosScreen';
import NetInfo from '@react-native-community/netinfo';
import { useRouter } from 'expo-router';
import React, { useEffect, useState } from 'react';

export default function SearchDevos() {
  const [search, setSearch] = useState('');
  const [debounced, setDebounced] = useState('');
  const [isOffline, setOffline] = useState(false);

  const router = useRouter();

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
    <SearchDevosScreen
      search={search}
      onChangeSearch={setSearch}
      isOffline={isOffline}
      isLoading={searchQuery.isLoading}
      data={flatData}
      onPressItem={(id) => router.push(`/app/devotional_detail/${id}`)}
      onLoadMore={() => {
        if (searchQuery.hasNextPage) {
          searchQuery.fetchNextPage();
        }
      }}
      isFetchingNextPage={searchQuery.isFetchingNextPage}
    />
  );
}
