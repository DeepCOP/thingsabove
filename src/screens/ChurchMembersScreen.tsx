import LoadingSpinner from '@/src/components/LoadingSpinner';
import UserAvatar from '@/src/components/UserAvatar';
import { useChurch } from '@/src/hooks/useChurch';
import { useChurchMembers } from '@/src/hooks/useChurchMembers';
import { useChurchStats } from '@/src/hooks/useChurchStats';
import { useProfile } from '@/src/hooks/useProfile';
import { useAuth } from '@/src/state/AuthContext';
import { useDebounce } from '@/src/utils';
import { Ionicons } from '@expo/vector-icons';
import { Href, useRouter } from 'expo-router';
import { useState } from 'react';
import { FlatList, Share, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type Props = {
  churchId: string;
};

const formatJoinedLabel = (value: string | null) => {
  if (!value) return null;

  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return null;

  return `Joined church ${date.toLocaleDateString(undefined, {
    month: 'short',
    year: 'numeric',
  })}`;
};

export default function ChurchMembersScreen({ churchId }: Props) {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const { session } = useAuth();
  const [query, setQuery] = useState('');
  const [isRefreshing, setIsRefreshing] = useState(false);
  const debouncedQuery = useDebounce(query.trim(), 300);

  const viewerProfileQuery = useProfile(session?.user?.id);
  const churchQuery = useChurch(churchId);
  const { membersQuery, members } = useChurchMembers(churchId, debouncedQuery);
  const statsQuery = useChurchStats(churchId);

  const isLoading =
    viewerProfileQuery.isLoading ||
    churchQuery.isLoading ||
    statsQuery.isLoading ||
    (membersQuery.isLoading && !membersQuery.data);

  const error =
    viewerProfileQuery.error || churchQuery.error || membersQuery.error || statsQuery.error;

  const viewerChurchId = viewerProfileQuery.data?.church?.id ?? null;
  const church = churchQuery.data;
  const stats = statsQuery.data;
  const hasSearch = Boolean(debouncedQuery);

  const handleShareChurch = async () => {
    if (!church) return;
    await Share.share({
      message: `Join ${church.name} on ThingsAbove.`,
    });
  };

  const handleRefresh = async () => {
    setIsRefreshing(true);

    try {
      await membersQuery.refetch();
    } finally {
      setIsRefreshing(false);
    }
  };

  if (isLoading) {
    return <LoadingSpinner style={{ marginTop: 30 }} />;
  }

  if (error) {
    return (
      <View className="flex-1 items-center justify-center bg-white px-6 dark:bg-black">
        <Text className="text-lg font-semibold text-gray-900 dark:text-white">
          Unable to load members
        </Text>
        <Text className="mt-2 text-center text-sm text-gray-600 dark:text-gray-400">
          Please try again. We could not load the church member list right now.
        </Text>
        <TouchableOpacity
          className="mt-5 rounded-full bg-black px-5 py-3 dark:bg-white"
          onPress={() => {
            churchQuery.refetch();
            membersQuery.refetch();
            statsQuery.refetch();
          }}>
          <Text className="font-semibold text-white dark:text-black">Try again</Text>
        </TouchableOpacity>
      </View>
    );
  }

  if (!viewerChurchId || viewerChurchId !== churchId) {
    return (
      <View className="flex-1 items-center justify-center bg-white px-6 dark:bg-black">
        <Text className="text-lg font-semibold text-gray-900 dark:text-white">
          Members are only available for your church
        </Text>
        <Text className="mt-2 text-center text-sm text-gray-600 dark:text-gray-400">
          Go back to your profile and open the church linked to your account.
        </Text>
        <TouchableOpacity
          className="mt-5 rounded-full bg-black px-5 py-3 dark:bg-white"
          onPress={() => router.back()}>
          <Text className="font-semibold text-white dark:text-black">Go back</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <View className="flex-1 bg-white dark:bg-black" style={{ paddingBottom: insets.bottom }}>
      <FlatList
        data={members}
        keyExtractor={(item) => item.id}
        contentContainerStyle={{ paddingBottom: 24 }}
        showsVerticalScrollIndicator={false}
        onEndReachedThreshold={0.5}
        onEndReached={() => {
          if (membersQuery.hasNextPage && !membersQuery.isFetchingNextPage) {
            membersQuery.fetchNextPage();
          }
        }}
        ListHeaderComponent={
          <View className="px-4 pt-4">
            <View className="rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
              <View className="flex-row items-start justify-between gap-3">
                <View className="flex-1">
                  <Text className="text-lg font-semibold text-gray-900 dark:text-white">
                    {church?.name ?? 'Church members'}
                  </Text>
                  <Text className="mt-1 text-sm text-gray-500 dark:text-gray-400">
                    Full member list for this church community.
                  </Text>
                </View>
                <View className="rounded-full bg-blue-50 px-3 py-1 dark:bg-blue-950/40">
                  <Text className="text-xs font-semibold text-blue-700 dark:text-blue-300">
                    {stats?.memberCount ?? 0} total
                  </Text>
                </View>
              </View>

              <View className="mt-4 flex-row gap-2">
                <View className="rounded-full bg-gray-100 px-3 py-2 dark:bg-neutral-900">
                  <Text className="text-sm text-gray-700 dark:text-gray-300">
                    {stats?.activeMembersThisWeek ?? 0} active this week
                  </Text>
                </View>
                <View className="rounded-full bg-gray-100 px-3 py-2 dark:bg-neutral-900">
                  <Text className="text-sm text-gray-700 dark:text-gray-300">
                    {stats?.joinedThisMonth ?? 0} joined this month
                  </Text>
                </View>
              </View>
            </View>

            <View className="mt-4 flex-row items-center rounded-2xl border border-gray-200 bg-white px-4 py-3 dark:border-neutral-800 dark:bg-neutral-950">
              <Ionicons name="search-outline" size={18} color="#9ca3af" />
              <TextInput
                value={query}
                onChangeText={setQuery}
                placeholder="Search members"
                placeholderTextColor="#9ca3af"
                className="ml-2 flex-1 text-base text-gray-900 dark:text-white"
              />
            </View>

            {hasSearch && membersQuery.isFetching && !membersQuery.isFetchingNextPage ? (
              <View className="mt-2 px-1">
                <LoadingSpinner size={'small'} />
              </View>
            ) : null}
          </View>
        }
        ListEmptyComponent={
          <View className="mx-4 mt-6 items-center rounded-2xl border border-gray-200 bg-gray-50 px-4 py-8 dark:border-neutral-800 dark:bg-neutral-900">
            <Ionicons name="people-outline" size={28} color="#9ca3af" />
            <Text className="mt-3 text-base font-semibold text-gray-900 dark:text-white">
              No members found
            </Text>
            <Text className="mt-1 text-center text-sm text-gray-600 dark:text-gray-400">
              {hasSearch
                ? 'Try a different name or clear the search.'
                : 'Invite members to grow this church community.'}
            </Text>
          </View>
        }
        renderItem={({ item }) => (
          <View className="mx-4 mt-4 rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
            <View className="flex-row items-center gap-3">
              <UserAvatar
                uri={item.avatar_url}
                initial={item.first_name?.[0] ?? 'U'}
                size={52}
                border={false}
              />

              <View className="flex-1">
                <Text className="text-base font-semibold text-gray-900 dark:text-white">
                  {[item.first_name, item.last_name].filter(Boolean).join(' ') || 'Church Member'}
                </Text>

                {(() => {
                  const joinedLabel = formatJoinedLabel(item.church_joined_at);
                  if (!joinedLabel) return null;

                  return (
                    <Text className="mt-1 text-sm text-gray-500 dark:text-gray-400">
                      {joinedLabel}
                    </Text>
                  );
                })()}
              </View>
            </View>
          </View>
        )}
        ListFooterComponent={
          <View className="px-4 pt-6">
            {membersQuery.isFetchingNextPage ? (
              <View className="pb-4">
                <LoadingSpinner />
              </View>
            ) : null}

            <TouchableOpacity
              className="rounded-full bg-black py-4 dark:bg-white"
              onPress={handleShareChurch}>
              <Text className="text-center text-base font-semibold text-white dark:text-black">
                Invite Members
              </Text>
            </TouchableOpacity>

            <TouchableOpacity
              className="mt-3 rounded-full border border-gray-300 py-4 dark:border-neutral-700"
              onPress={handleShareChurch}>
              <Text className="text-center text-base font-semibold text-gray-900 dark:text-white">
                Share Church Link
              </Text>
            </TouchableOpacity>
          </View>
        }
        refreshing={isRefreshing}
        onRefresh={handleRefresh}
      />
    </View>
  );
}
