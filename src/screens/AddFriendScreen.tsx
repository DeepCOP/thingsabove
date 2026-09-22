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
  const colorScheme = useColorScheme();
  const isAccepted = user.friendship_status === 'accepted';
  const isPending = user.friendship_status === 'pending';
  const isIncomingRequest = isPending && user.receiver_id === currentUserId;
  const canAdd = !user.friendship_status;

  const statusLabel = isAccepted ? 'Friends' : isIncomingRequest ? 'Respond' : 'Pending';
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
        subtitle={user.church_name?.trim() || 'Church not listed'}
        subtitleClassName="mt-1 text-xs text-gray-500 dark:text-gray-400"
        uri={user.avatar_url}
        userId={user.id}
      />

      {canAdd ? (
        <TouchableOpacity
          accessibilityLabel={`Add ${user.first_name} ${user.last_name} as a friend`}
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
            <Text className="font-semibold text-white dark:text-black">Add</Text>
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
        Unable to search right now
      </Text>
      <Text className="mt-1 text-center text-sm text-gray-500 dark:text-gray-400">
        Check your connection and try again.
      </Text>
    </View>
  ) : isSearching ? (
    <View className="items-center py-10">
      <LoadingSpinner size="small" />
      <Text className="mt-3 text-sm text-gray-500 dark:text-gray-400">Searching...</Text>
    </View>
  ) : isSearchReady ? (
    <View className="items-center px-6 py-10">
      <Ionicons color="#9ca3af" name="person-outline" size={30} />
      <Text className="mt-3 text-center font-semibold text-gray-900 dark:text-white">
        No people found
      </Text>
      <Text className="mt-1 text-center text-sm text-gray-500 dark:text-gray-400">
        Try another name or enter the full email address.
      </Text>
    </View>
  ) : trimmedQuery.length === 1 ? (
    <Text className="px-1 py-4 text-sm text-gray-500 dark:text-gray-400">
      Enter at least 2 characters to search.
    </Text>
  ) : null;

  return (
    <View className="flex-1 bg-white px-4 pt-6 dark:bg-black">
      <Text className="text-xl font-bold text-gray-900 dark:text-white">Add Friend</Text>
      <Text className="mt-1 text-sm leading-5 text-gray-600 dark:text-gray-400">
        Search by first name, last name, or email, send a friend request.
      </Text>

      <View className="mt-4 flex-row items-center rounded-xl bg-gray-100 px-4 dark:bg-neutral-900">
        <Ionicons
          color={colorScheme === 'dark' ? '#9ca3af' : '#6b7280'}
          name="search-outline"
          size={20}
        />
        <TextInput
          autoCapitalize="words"
          autoCorrect={false}
          className="ml-2 flex-1 py-3.5 text-base text-gray-900 dark:text-white"
          onChangeText={onQueryChange}
          placeholder="Search by name or email"
          placeholderTextColor={colorScheme === 'dark' ? '#737373' : '#9ca3af'}
          returnKeyType="search"
          value={query}
        />
        {isSearching ? (
          <ActivityIndicator
            className="ml-2"
            color={colorScheme === 'dark' ? '#d1d5db' : '#4b5563'}
            size="small"
          />
        ) : null}
        {query.length > 0 ? (
          <TouchableOpacity
            accessibilityLabel="Clear search"
            className="ml-2 p-1"
            onPress={() => onQueryChange('')}>
            <Ionicons
              color={colorScheme === 'dark' ? '#9ca3af' : '#6b7280'}
              name="close-circle"
              size={20}
            />
          </TouchableOpacity>
        ) : null}
      </View>

      {isSearchReady && !searchError && results.length > 0 ? (
        <Text className="mb-3 mt-5 text-sm text-gray-500 dark:text-gray-400">
          {results.length} {results.length === 1 ? 'person' : 'people'} found
        </Text>
      ) : null}

      <FlatList
        contentContainerStyle={{ paddingBottom: insets.bottom + 24 }}
        data={results}
        keyboardShouldPersistTaps="handled"
        keyExtractor={(item) => item.id}
        ListEmptyComponent={emptyState}
        ListFooterComponent={
          <View className="mt-6 rounded-2xl border border-gray-200 bg-gray-50 p-4 dark:border-neutral-800 dark:bg-neutral-950">
            <Text className="text-base font-semibold text-gray-900 dark:text-white">
              Invite someone new
            </Text>
            <Text className="mt-1 text-sm leading-6 text-gray-600 dark:text-gray-400">
              Share a link so a friend can join ThingsAbove and connect with you.
            </Text>

            <TouchableOpacity
              className="mt-4 flex-row items-center justify-center rounded-full border border-blue-600 bg-blue-50/70 px-4 py-3 dark:border-blue-400 dark:bg-blue-950/30"
              onPress={onShareInviteLink}>
              <Ionicons name="share-social-outline" size={18} color="#2563eb" />
              <Text className="ml-2 font-semibold text-blue-600 dark:text-blue-400">
                Share Invite Link
              </Text>
            </TouchableOpacity>
          </View>
        }
        renderItem={({ item }) => (
          <SearchResultRow
            currentUserId={currentUserId}
            isAddDisabled={isAdding}
            isAdding={isAdding && addingFriendId === item.id}
            onAddFriend={onAddFriend}
            onOpenProfile={onOpenProfile}
            user={item}
          />
        )}
        showsVerticalScrollIndicator={false}
      />
    </View>
  );
}
