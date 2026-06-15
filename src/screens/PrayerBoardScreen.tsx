import PrayerEmptyState from '@/src/components/prayer/PrayerEmptyState';
import PrayerFilterChips from '@/src/components/prayer/PrayerFilterChips';
import PrayerRequestCard from '@/src/components/prayer/PrayerRequestCard';
import PrayerScopeSwitch from '@/src/components/prayer/PrayerScopeSwitch';
import { usePrayerBoard, useTogglePrayerRequestSupport } from '@/src/hooks/usePrayer';
import { useProfile } from '@/src/hooks/useProfile';
import { useAuth } from '@/src/state/AuthContext';
import { PrayerFilter, PrayerScope } from '@/src/types/types';
import { useRouter } from 'expo-router';
import { useEffect, useMemo, useRef, useState } from 'react';
import { RefreshControl, ScrollView, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import LoadingSpinner from '@/src/components/LoadingSpinner';

type PrayerBoardScreenProps = {
  fixedFilter?: PrayerFilter;
  initialFilter?: PrayerFilter;
  emptyStateCopy?: {
    title: string;
    description: string;
  };
  newRequestLabel?: string;
  loadMoreLabel?: string;
};

function PrayerBoardSkeleton() {
  return (
    <View className="gap-4">
      {[0, 1, 2].map((item) => (
        <View
          key={item}
          className="rounded-3xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
          <View className="h-4 w-32 rounded-full bg-gray-200 dark:bg-neutral-800" />
          <View className="mt-4 h-4 w-full rounded-full bg-gray-200 dark:bg-neutral-800" />
          <View className="mt-2 h-4 w-5/6 rounded-full bg-gray-200 dark:bg-neutral-800" />
          <View className="mt-6 flex-row gap-3">
            <View className="h-8 w-20 rounded-full bg-gray-200 dark:bg-neutral-800" />
            <View className="h-8 w-24 rounded-full bg-gray-200 dark:bg-neutral-800" />
          </View>
        </View>
      ))}
    </View>
  );
}

export default function PrayerBoardScreen({
  fixedFilter,
  initialFilter = 'all',
  emptyStateCopy,
  newRequestLabel = 'New Prayer Request',
  loadMoreLabel = 'Load More Requests',
}: PrayerBoardScreenProps = {}) {
  const { session } = useAuth();
  const router = useRouter();
  const insets = useSafeAreaInsets();
  const [filter, setFilter] = useState<PrayerFilter>(fixedFilter ?? initialFilter);
  const [isRefreshing, setIsRefreshing] = useState(false);
  const activeFilter = fixedFilter ?? filter;

  const profileQuery = useProfile(session?.user?.id);
  const togglePrayerMutation = useTogglePrayerRequestSupport();

  const hasChurch = Boolean(profileQuery.data?.church?.id);
  const [scope, setScope] = useState<PrayerScope>('public');
  const hasInitializedScopeRef = useRef(false);
  const boardQuery = usePrayerBoard(scope, activeFilter);

  const isChurchLocked = scope === 'church' && !hasChurch;

  useEffect(() => {
    if (hasInitializedScopeRef.current || profileQuery.isLoading) {
      return;
    }

    setScope(hasChurch ? 'church' : 'public');
    hasInitializedScopeRef.current = true;
  }, [hasChurch, profileQuery.isLoading]);

  const emptyCopy = useMemo(() => {
    if (scope === 'church') {
      return {
        title: 'No church prayer requests yet',
        description:
          activeFilter === 'mine'
            ? 'You have not posted to your church board yet. Share a prayer need with your church community.'
            : 'Your church board is quiet right now. Start the first request and invite others to pray with you.',
      };
    }

    if (activeFilter === 'mine') {
      return {
        title: 'No prayer requests from you yet',
        description:
          'When you share a prayer request, it will appear here so you can track prayers and encouragements.',
      };
    }

    if (activeFilter === 'urgent') {
      return {
        title: 'No urgent requests right now',
        description: 'There are no urgent prayer requests in this view at the moment.',
      };
    }

    if (activeFilter === 'answered') {
      return {
        title: 'No answered requests yet',
        description:
          'Answered prayer requests will show up here as people share what God has done.',
      };
    }

    return {
      title: 'No prayer requests yet',
      description: 'Start the conversation with a prayer request that others can carry with you.',
    };
  }, [activeFilter, scope]);

  const resolvedEmptyCopy = emptyStateCopy ?? emptyCopy;

  const boardItems = useMemo(
    () => boardQuery.data?.pages.flatMap((page) => page.items) ?? [],
    [boardQuery.data],
  );

  const handleRefresh = async () => {
    setIsRefreshing(true);
    try {
      await boardQuery.refetch();
    } finally {
      setIsRefreshing(false);
    }
  };

  return (
    <ScrollView
      className="flex-1 bg-white dark:bg-black"
      contentContainerStyle={{
        paddingHorizontal: 16,
        paddingTop: 16,
        paddingBottom: insets.bottom + 24,
      }}
      refreshControl={
        <RefreshControl refreshing={isRefreshing} onRefresh={handleRefresh} tintColor="#2563eb" />
      }>
      <PrayerScopeSwitch hasChurch={hasChurch} scope={scope} onChange={setScope} />

      {isChurchLocked ? (
        <View className="mt-4">
          <PrayerEmptyState
            icon="people-outline"
            title="Join your church prayer board"
            description="Add your church in Profile to unlock church-only prayer requests and support your local community."
            ctaLabel="Open Profile"
            onCta={() => router.navigate('/app/(tabs)/ProfileTab')}
          />
        </View>
      ) : (
        <>
          {!fixedFilter ? (
            <View className="mt-4">
              <PrayerFilterChips filter={activeFilter} onChange={setFilter} />
            </View>
          ) : null}

          <View className="mt-6 gap-4">
            {boardQuery.isLoading ? (
              <PrayerBoardSkeleton />
            ) : boardQuery.isError && boardItems.length === 0 ? (
              <PrayerEmptyState
                icon="alert-circle-outline"
                title="Unable to load the prayer board"
                description="Pull to refresh or try again in a moment."
                ctaLabel="Try Again"
                onCta={() => boardQuery.refetch()}
              />
            ) : boardItems.length > 0 ? (
              boardItems.map((item) => (
                <PrayerRequestCard
                  key={item.id}
                  item={item}
                  onPress={() =>
                    router.push({
                      pathname: '/app/prayer/[requestId]',
                      params: { requestId: item.id },
                    })
                  }
                  onTogglePraying={() => togglePrayerMutation.mutate(item.id)}
                  onEncourage={() =>
                    router.push({
                      pathname: '/app/prayer/[requestId]',
                      params: { requestId: item.id },
                    })
                  }
                  onMarkAnswered={
                    item.viewer_is_owner && !item.is_answered
                      ? () =>
                          router.push({
                            pathname: '/app/prayer/[requestId]',
                            params: { requestId: item.id },
                          })
                      : undefined
                  }
                  markAnsweredLabel="Praise"
                />
              ))
            ) : (
              <PrayerEmptyState
                title={resolvedEmptyCopy.title}
                description={resolvedEmptyCopy.description}
                ctaLabel={newRequestLabel}
                onCta={() => router.push('/app/prayer/new')}
              />
            )}

            {boardItems.length > 0 && boardQuery.hasNextPage ? (
              <View className="items-center pt-2">
                {boardQuery.isFetchingNextPage ? (
                  <LoadingSpinner size="small" />
                ) : (
                  <TouchableOpacity
                    className="rounded-full border border-gray-300 px-5 py-3 dark:border-neutral-700"
                    onPress={() => boardQuery.fetchNextPage()}>
                    <Text className="font-medium text-gray-900 dark:text-white">
                      {loadMoreLabel}
                    </Text>
                  </TouchableOpacity>
                )}
              </View>
            ) : null}
          </View>
        </>
      )}

      <TouchableOpacity
        className="mt-6 rounded-full bg-black px-6 py-4 dark:bg-white"
        onPress={() => router.push('/app/prayer/new')}>
        <Text className="text-center font-semibold text-white dark:text-black">
          {newRequestLabel}
        </Text>
      </TouchableOpacity>
    </ScrollView>
  );
}
