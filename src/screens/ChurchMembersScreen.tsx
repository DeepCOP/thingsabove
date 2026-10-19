import { useTranslation } from 'react-i18next';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import ProfileIdentityRow from '@/src/components/ProfileIdentityRow';
import { getOrCreateChurchInviteCode } from '@/src/api/churchQueries';
import { useChurch } from '@/src/hooks/useChurch';
import { useChurchAnalytics } from '@/src/hooks/useChurchAnalytics';
import { useAcceptChurchInvite } from '@/src/hooks/useChurchInvitation';
import { useChurchMembers } from '@/src/hooks/useChurchMembers';
import { useProfile } from '@/src/hooks/useProfile';
import { buildChurchInvitationMessage, buildChurchShareMessage } from '@/src/lib/churchShare';
import { useAuth } from '@/src/state/AuthContext';
import { Ionicons } from '@expo/vector-icons';
import { useState } from 'react';
import { Alert, FlatList, Share, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useDebounce } from '../utils';

type Props = {
  churchId: string;
};

const formatJoinedDate = (value: string | null, locale: string) => {
  if (!value) return null;

  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return null;

  return date.toLocaleDateString(locale, {
    month: 'short',
    year: 'numeric',
  });
};

const getInviterName = (firstName?: string | null, lastName?: string | null) => {
  const value = [firstName, lastName].filter(Boolean).join(' ').trim();
  return value || undefined;
};

export default function ChurchMembersScreen({ churchId }: Props) {
  const { t, i18n } = useTranslation('community');
  const insets = useSafeAreaInsets();
  const { session } = useAuth();
  const [query, setQuery] = useState('');
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [isSharingInvite, setIsSharingInvite] = useState(false);
  const debouncedQuery = useDebounce(query.trim(), 300);

  const churchQuery = useChurch(churchId);
  const { membersQuery, members } = useChurchMembers(churchId, debouncedQuery);
  const analyticsQuery = useChurchAnalytics(churchId);
  const viewerProfileQuery = useProfile(session?.user?.id);
  const acceptChurchMutation = useAcceptChurchInvite(churchId, session?.user?.id);

  const isLoading =
    churchQuery.isLoading ||
    analyticsQuery.isLoading ||
    (membersQuery.isLoading && !membersQuery.data);

  const error = churchQuery.error || membersQuery.error || analyticsQuery.error;

  const church = churchQuery.data;
  const stats = analyticsQuery.data?.stats;
  const hasSearch = Boolean(debouncedQuery);
  const viewerChurchId = viewerProfileQuery.data?.church?.id ?? null;
  const isChurchMember = viewerChurchId === churchId;
  const canShowMembershipAction =
    Boolean(viewerProfileQuery.data && churchId) && !viewerProfileQuery.error;

  const handleShareChurch = async () => {
    if (!church) return;
    await Share.share({ message: buildChurchShareMessage(church) });
  };

  const handleInviteMembers = async () => {
    if (!isChurchMember || !church) return;

    try {
      setIsSharingInvite(true);
      const inviteCode = await getOrCreateChurchInviteCode({ churchId });

      await Share.share({
        message: buildChurchInvitationMessage({
          church,
          invitedBy: session?.user?.id,
          inviteCode,
          inviterName: getInviterName(
            viewerProfileQuery.data?.first_name,
            viewerProfileQuery.data?.last_name,
          ),
        }),
      });
    } catch (error) {
      console.error('Error sharing church invitation:', error);
      Alert.alert(t('shareInviteError'), t('pleaseTryAgain'));
    } finally {
      setIsSharingInvite(false);
    }
  };

  const joinChurch = () => {
    acceptChurchMutation.mutate(undefined, {
      onSuccess: () => {
        viewerProfileQuery.refetch();
        analyticsQuery.refetch();
        membersQuery.refetch();
      },
      onError: () => {
        Alert.alert(t('joinChurchError'), t('pleaseTryAgain'));
      },
    });
  };

  const handleJoinChurch = () => {
    if (!church || acceptChurchMutation.isPending) return;

    const currentChurchName = viewerProfileQuery.data?.church?.name;

    if (currentChurchName && viewerChurchId !== churchId) {
      Alert.alert(
        t('joinChurchConfirm'),
        t('churchSwitchDescription', { church: church.name, currentChurch: currentChurchName }),
        [
          { text: t('cancel'), style: 'cancel' },
          { text: t('joinChurch'), onPress: joinChurch },
        ],
      );
      return;
    }

    joinChurch();
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
          {t('membersError')}
        </Text>
        <Text className="mt-2 text-center text-sm text-gray-600 dark:text-gray-400">
          {t('membersListUnavailable')}
        </Text>
        <TouchableOpacity
          className="mt-5 rounded-full bg-black px-5 py-3 dark:bg-white"
          onPress={() => {
            churchQuery.refetch();
            membersQuery.refetch();
            analyticsQuery.refetch();
          }}>
          <Text className="font-semibold text-white dark:text-black">{t('tryAgain')}</Text>
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
                    {church?.name ?? t('churchMembers')}
                  </Text>
                  <Text className="mt-1 text-sm text-gray-500 dark:text-gray-400">
                    {t('membersListDescription')}
                  </Text>
                </View>
                <View className="rounded-full bg-blue-50 px-3 py-1 dark:bg-blue-950/40">
                  <Text className="text-xs font-semibold text-blue-700 dark:text-blue-300">
                    {t('memberTotal', { count: stats?.memberCount ?? 0 })}
                  </Text>
                </View>
              </View>

              <View className="mt-4 flex-row gap-2">
                <View className="rounded-full bg-gray-100 px-3 py-2 dark:bg-neutral-900">
                  <Text className="text-sm text-gray-700 dark:text-gray-300">
                    {t('activeThisWeek', { count: stats?.activeMembersThisWeek ?? 0 })}
                  </Text>
                </View>
                <View className="rounded-full bg-gray-100 px-3 py-2 dark:bg-neutral-900">
                  <Text className="text-sm text-gray-700 dark:text-gray-300">
                    {t('joinedThisMonth', { count: stats?.joinedThisMonth ?? 0 })}
                  </Text>
                </View>
              </View>
            </View>

            <View className="mt-4 flex-row items-center rounded-2xl border border-gray-200 bg-white px-4 py-3 dark:border-neutral-800 dark:bg-neutral-950">
              <Ionicons name="search-outline" size={18} color="#9ca3af" />
              <TextInput
                value={query}
                onChangeText={setQuery}
                placeholder={t('searchMembers')}
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
              {t('noMembers')}
            </Text>
            <Text className="mt-1 text-center text-sm text-gray-600 dark:text-gray-400">
              {hasSearch
                ? t('memberSearchHint')
                : isChurchMember
                  ? t('memberInviteHint')
                  : t('memberJoinHint')}
            </Text>
          </View>
        }
        renderItem={({ item }) => {
          const joinedDate = formatJoinedDate(item.church_joined_at, i18n.resolvedLanguage ?? 'en');
          const joinedLabel = joinedDate ? t('joinedChurchDate', { date: joinedDate }) : null;

          return (
            <View className="mx-4 mt-4 rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
              <ProfileIdentityRow
                border={false}
                first_name={item.first_name}
                last_name={item.last_name}
                name={
                  [item.first_name, item.last_name].filter(Boolean).join(' ') || t('churchMember')
                }
                size={52}
                subtitle={joinedLabel}
                subtitleClassName="text-sm text-gray-500 dark:text-gray-400"
                titleClassName="text-base font-semibold text-gray-900 dark:text-white"
                uri={item.avatar_url}
                userId={item.id}
              />
            </View>
          );
        }}
        ListFooterComponent={
          <View className="px-4 pt-6">
            {membersQuery.isFetchingNextPage ? (
              <View className="pb-4">
                <LoadingSpinner />
              </View>
            ) : null}

            {canShowMembershipAction ? (
              isChurchMember ? (
                <TouchableOpacity
                  className="rounded-full bg-black py-4 dark:bg-white"
                  disabled={isSharingInvite}
                  onPress={handleInviteMembers}>
                  <Text className="text-center text-base font-semibold text-white dark:text-black">
                    {isSharingInvite ? t('preparingInvite') : t('shareInviteLink')}
                  </Text>
                </TouchableOpacity>
              ) : (
                <TouchableOpacity
                  className="rounded-full bg-black py-4 dark:bg-white"
                  disabled={acceptChurchMutation.isPending}
                  onPress={handleJoinChurch}>
                  <Text className="text-center text-base font-semibold text-white dark:text-black">
                    {acceptChurchMutation.isPending ? t('joining') : t('joinChurch')}
                  </Text>
                </TouchableOpacity>
              )
            ) : null}

            <TouchableOpacity
              className="mt-3 rounded-full border border-gray-300 py-4 dark:border-neutral-700"
              onPress={handleShareChurch}>
              <Text className="text-center text-base font-semibold text-gray-900 dark:text-white">
                {t('shareChurchLink')}
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
