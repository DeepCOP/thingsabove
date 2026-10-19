import { useTranslation } from 'react-i18next';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import ProfileIdentityRow from '@/src/components/ProfileIdentityRow';
import { useAuth } from '@/src/state/AuthContext';
import { UserSearchResult } from '@/src/types/types';
import { Ionicons } from '@expo/vector-icons';
import {
  ActivityIndicator,
  FlatList,
  Text,
  TextInput,
  TouchableOpacity,
  View,
  useColorScheme,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type Props = {
  query: string;
  onQueryChange: (value: string) => void;
  results: UserSearchResult[];
  isSearchReady: boolean;
  isSearching: boolean;
  searchError?: string;
  isAdding: boolean;
  addingFriendId?: string;
  onAddFriend: (friendId: string) => void;
  onOpenProfile: (userId: string) => void;
  onShareInviteLink: () => void;
};

type SearchResultRowProps = {
  user: UserSearchResult;
  isAdding: boolean;
  isAddDisabled: boolean;
  currentUserId?: string;
  onAddFriend: (friendId: string) => void;
  onOpenProfile: (userId: string) => void;
};

function SearchResultRow({
  user,
  isAdding,
  isAddDisabled,
  currentUserId,
  onAddFriend,
  onOpenProfile,
}: SearchResultRowProps) {
  const { t } = useTranslation('community');
  const colorScheme = useColorScheme();
  const isAccepted = user.friendship_status === 'accepted';
  const isPending = user.friendship_status === 'pending';
  const isIncomingRequest = isPending && user.receiver_id === currentUserId;
  const canAdd = !user.friendship_status;

  const statusLabel = isAccepted ? t('friends') : isIncomingRequest ? t('respond') : t('pending');
  const statusClassName = isAccepted
    ? 'border-green-200 bg-green-50 dark:border-green-900 dark:bg-green-950/30'
    : 'border-gray-200 bg-gray-50 dark:border-neutral-700 dark:bg-neutral-800';
  const statusTextClassName = isAccepted
    ? 'text-green-700 dark:text-green-400'
    : 'text-gray-600 dark:text-gray-300';

  return (
    <View className="mb-3 flex-row items-center rounded-2xl border border-gray-200 bg-white p-3 dark:border-neutral-800 dark:bg-neutral-950">
      <ProfileIdentityRow
        className="flex-1"
        first_name={user.first_name}
        last_name={user.last_name}
        size={44}
        subtitle={user.church_name?.trim() || t('churchNotListed')}
        subtitleClassName="mt-1 text-xs text-gray-500 dark:text-gray-400"
        uri={user.avatar_url}
        userId={user.id}
      />

      {canAdd ? (
        <TouchableOpacity
          accessibilityLabel={t('addFriendAccessibility', {
            name: `${user.first_name} ${user.last_name}`.trim(),
          })}
          className={`ml-3 min-w-16 items-center rounded-full bg-black px-4 py-2.5 dark:bg-white ${
            isAddDisabled && !isAdding ? 'opacity-50' : ''
          }`}
          disabled={isAddDisabled}
          onPress={() => onAddFriend(user.id)}>
          {isAdding ? (
            <ActivityIndicator
              color={colorScheme === 'dark' ? '#000000' : '#ffffff'}
              size="small"
            />
          ) : (
            <Text className="font-semibold text-white dark:text-black">{t('add')}</Text>
          )}
        </TouchableOpacity>
      ) : (
        <TouchableOpacity
          className={`ml-3 rounded-full border px-3 py-2 ${statusClassName}`}
          disabled={!isIncomingRequest}
          onPress={() => onOpenProfile(user.id)}>
          <Text className={`text-xs font-semibold ${statusTextClassName}`}>{statusLabel}</Text>
        </TouchableOpacity>
      )}
    </View>
  );
}

export default function AddFriendScreen({
  query,
  onQueryChange,
  results,
  isSearchReady,
  isSearching,
  searchError,
  isAdding,
  addingFriendId,
  onAddFriend,
  onOpenProfile,
  onShareInviteLink,
}: Props) {
  const { t } = useTranslation('community');
  const { session, loading: sessionLoading } = useAuth();
  const insets = useSafeAreaInsets();
  const colorScheme = useColorScheme();
  const currentUserId = session?.user?.id;
  const trimmedQuery = query.trim();

  if (sessionLoading) {
    return (
      <View className="flex-1 items-center justify-center bg-white dark:bg-black">
        <LoadingSpinner />
      </View>
    );
  }

  const emptyState = searchError ? (
    <View className="items-center px-6 py-10">
      <Ionicons color="#ef4444" name="alert-circle-outline" size={30} />
      <Text className="mt-3 text-center font-semibold text-gray-900 dark:text-white">
        {t('friendSearchError')}
      </Text>
      <Text className="mt-1 text-center text-sm text-gray-500 dark:text-gray-400">
        {t('friendSearchErrorHint')}
      </Text>
    </View>
  ) : isSearching ? (
    <View className="items-center py-10">
      <LoadingSpinner size="small" />
      <Text className="mt-3 text-sm text-gray-500 dark:text-gray-400">{t('searchingPeople')}</Text>
    </View>
  ) : isSearchReady ? (
    <View className="items-center px-6 py-10">
      <Ionicons color="#9ca3af" name="person-outline" size={30} />
      <Text className="mt-3 text-center font-semibold text-gray-900 dark:text-white">
        {t('noPeopleFound')}
      </Text>
      <Text className="mt-1 text-center text-sm text-gray-500 dark:text-gray-400">
        {t('noPeopleFoundHint')}
      </Text>
    </View>
  ) : trimmedQuery.length === 1 ? (
    <Text className="px-1 py-4 text-sm text-gray-500 dark:text-gray-400">
      {t('minFriendSearch', { count: 2 })}
    </Text>
  ) : null;

  return (
    <View className="flex-1 bg-white dark:bg-black px-4 pt-6">
      <FlatList
        data={results}
        keyExtractor={(item) => item.id}
        keyboardShouldPersistTaps="handled"
        contentContainerStyle={{ paddingBottom: insets.bottom + 32 }}
        ListHeaderComponent={
          <View className="mb-4">
            <Text className="mb-3 text-xl font-bold dark:text-white">{t('addFriend')}</Text>
            <TextInput
              value={query}
              onChangeText={onQueryChange}
              placeholder={t('searchPeoplePlaceholder')}
              placeholderTextColor={colorScheme === 'dark' ? '#9ca3af' : '#6b7280'}
              accessibilityLabel={t('searchPeoplePlaceholder')}
              autoCapitalize="none"
              autoCorrect={false}
              returnKeyType="search"
              className="rounded-xl bg-gray-100 px-4 py-3 text-gray-900 dark:bg-neutral-900 dark:text-white"
            />
          </View>
        }
        ListEmptyComponent={emptyState}
        renderItem={({ item }) => (
          <SearchResultRow
            user={item}
            isAdding={isAdding && addingFriendId === item.id}
            isAddDisabled={isAdding || !currentUserId}
            currentUserId={currentUserId}
            onAddFriend={onAddFriend}
            onOpenProfile={onOpenProfile}
          />
        )}
        ListFooterComponent={
          <View className="mt-6 rounded-2xl border border-gray-200 bg-gray-50 p-4 dark:border-neutral-800 dark:bg-neutral-950">
            <Text className="text-base font-semibold text-gray-900 dark:text-white">
              {t('inviteSomeone')}
            </Text>
            <Text className="mt-1 text-sm leading-6 text-gray-600 dark:text-gray-400">
              {t('friendInviteDescription')}
            </Text>
            <TouchableOpacity
              onPress={onShareInviteLink}
              className="mt-4 flex-row items-center justify-center rounded-full border border-blue-600 bg-blue-50/70 px-4 py-3 dark:border-blue-400 dark:bg-blue-950/30">
              <Ionicons name="share-social-outline" size={18} color="#2563eb" />
              <Text className="ml-2 font-semibold text-blue-600 dark:text-blue-400">
                {t('shareInviteLink')}
              </Text>
            </TouchableOpacity>
          </View>
        }
      />
    </View>
  );
}
