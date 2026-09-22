import { useAddFriend, useSearchUsersByName } from '@/src/hooks/useFriends';
import { buildFriendInviteMessage } from '@/src/lib/planShare';
import AddFriendScreen from '@/src/screens/AddFriendScreen';
import { useAuth } from '@/src/state/AuthContext';
import { useDebounce } from '@/src/utils';
import { useRouter } from 'expo-router';
import { useState } from 'react';
import { Alert, Share } from 'react-native';

export default function AddFriend() {
  const { session } = useAuth();
  const router = useRouter();
  const userId = session?.user?.id;

  const [searchQuery, setSearchQuery] = useState('');
  const normalizedQuery = searchQuery.trim().replace(/\s+/g, ' ');
  const debouncedQuery = useDebounce(normalizedQuery, 400);
  const isSearchReady = debouncedQuery.length >= 2 && debouncedQuery === normalizedQuery;

  const usersQuery = useSearchUsersByName({
    query: debouncedQuery,
    userId,
  });

  const addFriend = useAddFriend();
  const isSearching =
    normalizedQuery.length >= 2 &&
    (!isSearchReady || usersQuery.isLoading || usersQuery.isFetching);

  return (
    <AddFriendScreen
      query={searchQuery}
      onQueryChange={setSearchQuery}
      results={isSearchReady && !usersQuery.error ? (usersQuery.data ?? []) : []}
      isSearchReady={isSearchReady}
      isSearching={isSearching}
      searchError={isSearchReady ? usersQuery.error?.message : undefined}
      isAdding={addFriend.isPending}
      addingFriendId={addFriend.isPending ? addFriend.variables?.friendId : undefined}
      onAddFriend={(friendId) => {
        if (!userId) return;

        addFriend.mutate(
          { friendId, userId },
          {
            onError: (error) => {
              Alert.alert('Unable to send friend request', error.message);
            },
          },
        );
      }}
      onOpenProfile={(profileUserId) => router.push(`/app/profile/${profileUserId}`)}
      onShareInviteLink={() => Share.share({ message: buildFriendInviteMessage() })}
    />
  );
}
