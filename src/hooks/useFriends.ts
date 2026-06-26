import { acceptFriendRequest, addFriend, declineFriendRequest } from '@/src/api/mutations';
import {
  fetchFriendship,
  fetchPendingFriendRequests,
  fetchUserFriends,
  getUserByEmail,
} from '@/src/api/queries';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

export function useFriends(userId: string | undefined) {
  return useQuery({
    queryKey: ['friends', userId],
    staleTime: 1000 * 60 * 60 * 24,
    enabled: !!userId,
    queryFn: async () => await fetchUserFriends({ userId: userId! }),
  });
}

export function useFriendship({
  userId,
  friendId,
}: {
  userId: string | undefined;
  friendId: string | undefined;
}) {
  return useQuery({
    queryKey: ['friendship', userId, friendId],
    enabled: !!userId && !!friendId && userId !== friendId,
    queryFn: async () => await fetchFriendship({ userId: userId!, friendId: friendId! }),
  });
}

export function useAddFriend() {
  const qc = useQueryClient();

  return useMutation({
    mutationFn: async ({ friendId }: { friendId: string; userId: string }) =>
      await addFriend({ receiver_id: friendId }),
    onSuccess: (_data, variables) => {
      qc.invalidateQueries({ queryKey: ['friends', variables.userId] });
      qc.invalidateQueries({ queryKey: ['friendship', variables.userId, variables.friendId] });
      qc.invalidateQueries({ queryKey: ['get_user_by_email'] });
    },
  });
}

export function useGetUserByEmail({ query, userId }: { query: string; userId: string }) {
  return useQuery({
    queryKey: ['get_user_by_email', query, userId],
    enabled: !!query && !!userId,
    staleTime: 0,
    queryFn: async () => await getUserByEmail(query),
  });
}

export function useAcceptFriendRequest() {
  const qc = useQueryClient();

  return useMutation({
    mutationFn: async ({ friendId }: { friendId: string }) => await acceptFriendRequest(friendId),

    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['friends'] });
      qc.invalidateQueries({ queryKey: ['friend_requests'] });
      qc.invalidateQueries({ queryKey: ['friendship'] });
    },
  });
}

export function useDeclineFriendRequest() {
  const qc = useQueryClient();

  return useMutation({
    mutationFn: async ({ friendId }: { friendId: string }) => await declineFriendRequest(friendId),

    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['friend_requests'] });
      qc.invalidateQueries({ queryKey: ['friends'] });
      qc.invalidateQueries({ queryKey: ['friendship'] });
    },
  });
}

export function usePendingFriendRequests(userId: string | undefined) {
  return useQuery({
    queryKey: ['friend_requests', userId],
    enabled: !!userId,
    queryFn: async () => await fetchPendingFriendRequests(),
  });
}
