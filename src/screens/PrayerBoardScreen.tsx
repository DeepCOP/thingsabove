import PrayerEmptyState from '@/src/components/prayer/PrayerEmptyState';
import PrayerFilterChips from '@/src/components/prayer/PrayerFilterChips';
import PrayerRequestCard from '@/src/components/prayer/PrayerRequestCard';
import PrayerScopeSwitch from '@/src/components/prayer/PrayerScopeSwitch';
import {
  usePrayerBoard,
  useSetPrayerRequestAnswered,
  useTogglePrayerRequestSupport,
} from '@/src/hooks/usePrayer';
import { useProfile } from '@/src/hooks/useProfile';
import { PrayerFilter, PrayerScope } from '@/src/types/types';
import { useAuth } from '@/src/state/AuthContext';
import { useRouter } from 'expo-router';
import { useMemo, useState } from 'react';
import { RefreshControl, ScrollView, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

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

export default function PrayerBoardScreen() {
  const { session } = useAuth();
  const router = useRouter();
  const insets = useSafeAreaInsets();
  const [scope, setScope] = useState<PrayerScope>('public');
  const [filter, setFilter] = useState<PrayerFilter>('all');

  const profileQuery = useProfile(session?.user?.id);
  const boardQuery = usePrayerBoard(scope, filter);
  const togglePrayerMutation = useTogglePrayerRequestSupport();
  const markAnsweredMutation = useSetPrayerRequestAnswered();

  const hasChurch = Boolean(profileQuery.data?.church?.id);
  const isChurchLocked = scope === 'church' && !hasChurch;

  const emptyCopy = useMemo(() => {
    if (scope === 'church') {
      return {
        title: 'No church prayer requests yet',
        description:
          filter === 'mine'
            ? 'You have not posted to your church board yet. Share a prayer need with your church community.'
            : 'Your church board is quiet right now. Start the first request and invite others to pray with you.',
      };
    }

    if (filter === 'mine') {
      return {
        title: 'No prayer requests from you yet',
        description:
          'When you share a prayer request, it will appear here so you can track prayers and encouragements.',
      };
    }

    if (filter === 'urgent') {
      return {
        title: 'No urgent requests right now',
        description: 'There are no urgent prayer requests in this view at the moment.',
      };
    }

    if (filter === 'answered') {
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
  }, [filter, scope]);

  return (
    <ScrollView
      className="flex-1 bg-white dark:bg-black"
      contentContainerStyle={{
        paddingHorizontal: 16,
        paddingTop: 16,
        paddingBottom: insets.bottom + 24,
      }}
      refreshControl={
        <RefreshControl
          refreshing={boardQuery.isRefetching}
          onRefresh={() => boardQuery.refetch()}
          tintColor="#2563eb"
        />
      }>
      <PrayerScopeSwitch hasChurch={hasChurch} scope={scope} onChange={setScope} />

      {isChurchLocked ? (
        <View className="mt-4">
          <PrayerEmptyState
            icon="people-outline"
            title="Join your church prayer board"
            description="Add your church in Profile to unlock church-only prayer requests and support your local community."
            ctaLabel="Open Profile"
            onCta={() => router.navigate('/(tabs)/ProfileTab')}
          />
        </View>
      ) : (
        <>
          <View className="mt-4">
            <PrayerFilterChips filter={filter} onChange={setFilter} />
          </View>

          <View className="mt-6 gap-4">
            {boardQuery.isLoading ? (
              <PrayerBoardSkeleton />
            ) : boardQuery.isError ? (
              <PrayerEmptyState
                icon="alert-circle-outline"
                title="Unable to load the prayer board"
                description="Pull to refresh or try again in a moment."
                ctaLabel="Try Again"
                onCta={() => boardQuery.refetch()}
              />
            ) : boardQuery.data && boardQuery.data.length > 0 ? (
              boardQuery.data.map((item) => (
                <PrayerRequestCard
                  key={item.id}
                  item={item}
                  onPress={() =>
                    router.push({
                      pathname: '/prayer/[requestId]',
                      params: { requestId: item.id },
                    })
                  }
                  onTogglePrayer={() => togglePrayerMutation.mutate(item.id)}
                  onEncourage={() =>
                    router.push({
                      pathname: '/prayer/[requestId]',
                      params: { requestId: item.id },
                    })
                  }
                  onMarkAnswered={
                    item.viewer_is_owner && !item.is_answered
                      ? () =>
                          markAnsweredMutation.mutate({
                            requestId: item.id,
                            isAnswered: true,
                          })
                      : undefined
                  }
                  praying={
                    togglePrayerMutation.isPending && togglePrayerMutation.variables === item.id
                  }
                  answering={
                    markAnsweredMutation.isPending &&
                    markAnsweredMutation.variables?.requestId === item.id
                  }
                />
              ))
            ) : (
              <PrayerEmptyState
                title={emptyCopy.title}
                description={emptyCopy.description}
                ctaLabel="New Prayer Request"
                onCta={() => router.push('/prayer/new')}
              />
            )}
          </View>
        </>
      )}

      <TouchableOpacity
        className="mt-6 rounded-full bg-black px-6 py-4 dark:bg-white"
        onPress={() => router.push('/prayer/new')}>
        <Text className="text-center font-semibold text-white dark:text-black">
          New Prayer Request
        </Text>
      </TouchableOpacity>
    </ScrollView>
  );
}
