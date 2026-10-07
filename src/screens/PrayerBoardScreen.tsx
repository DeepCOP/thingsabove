import { useTranslation } from 'react-i18next';
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
  newRequestLabel,
  loadMoreLabel,
}: PrayerBoardScreenProps = {}) {
  const { t } = useTranslation('community');
  const { session } = useAuth();
  const router = useRouter();
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
        title: t('noChurchPrayerRequests'),
        description:
          activeFilter === 'mine' ? t('noChurchPrayersMine') : t('noChurchPrayersDescription'),
      };
    }

    if (activeFilter === 'mine') {
      return {
        title: t('noMyPrayerRequests'),
        description: t('noMyPrayersDescription'),
      };
    }

    if (activeFilter === 'urgent') {
      return {
        title: t('noUrgentRequests'),
        description: t('noUrgentDescription'),
      };
    }

    if (activeFilter === 'answered') {
      return {
        title: t('noAnsweredRequests'),
        description: t('noAnsweredDescription'),
      };
    }

    return {
      title: t('noPrayerRequests'),
      description: t('noPrayersDescription'),
    };
  }, [activeFilter, scope, t]);

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
    <View className="flex-1 bg-white dark:bg-black">
      <ScrollView
        className="flex-1"
        contentContainerStyle={{
          paddingHorizontal: 16,
          paddingTop: 16,
          paddingBottom: 24,
        }}
        refreshControl={
          <RefreshControl refreshing={isRefreshing} onRefresh={handleRefresh} tintColor="#2563eb" />
        }>
        <PrayerScopeSwitch hasChurch={hasChurch} scope={scope} onChange={setScope} />

        {isChurchLocked ? (
          <View className="mt-4">
            <PrayerEmptyState
              icon="people-outline"
              title={t('joinChurchPrayerBoard')}
              description={t('joinChurchPrayerDescription')}
              ctaLabel={t('openProfile')}
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
                  title={t('prayerBoardError')}
                  description={t('prayerBoardRetry')}
                  ctaLabel={t('tryAgainCaps')}
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
                    markAnsweredLabel={t('praise')}
                  />
                ))
              ) : (
                <PrayerEmptyState
                  title={resolvedEmptyCopy.title}
                  description={resolvedEmptyCopy.description}
                  ctaLabel={newRequestLabel ?? t('newPrayerRequest')}
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
                        {loadMoreLabel ?? t('loadMoreRequests')}
                      </Text>
                    </TouchableOpacity>
                  )}
                </View>
              ) : null}
            </View>
          </>
        )}
      </ScrollView>

      <View
        className="border-t border-gray-200 bg-white px-4 pt-3 dark:border-neutral-800 dark:bg-black"
        style={{ paddingBottom: 12 }}>
        <TouchableOpacity
          className="rounded-full bg-black px-6 py-4 dark:bg-white"
          onPress={() => router.push('/app/prayer/new')}>
          <Text className="text-center font-semibold text-white dark:text-black">
            {newRequestLabel ?? t('newPrayerRequest')}
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}
