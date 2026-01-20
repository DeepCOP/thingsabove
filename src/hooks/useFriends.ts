import { acceptFriendRequest, addFriend, declineFriendRequest } from '@/src/api/mutations';
import { fetchPendingFriendRequests, fetchUserFriends, getUserByEmail } from '@/src/api/queries';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

export function useFriends(userId: string | undefined) {
  return useQuery({
    queryKey: ['friends', userId],
    staleTime: 1000 * 60 * 60 * 24,
    enabled: !!userId,
    queryFn: async () => await fetchUserFriends({ userId: userId! }),
  });
}

export function useAddFriend() {
  const qc = useQueryClient();

  return useMutation({
    mutationFn: async ({ friendId }: { friendId: string; userId: string }) =>
      await addFriend({ receiver_id: friendId }),
    onSuccess: (userId) => {
      qc.invalidateQueries({ queryKey: ['friends', userId] });
      qc.invalidateQueries({ queryKey: ['get-user-by-email'] });
    },
  });
}

export function useGetUserByEmail({ query, userId }: { query: string; userId: string }) {
  return useQuery({
    queryKey: ['get-user-by-email', query],
    enabled: !!query,
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
    },
  });
}

export function useDeclineFriendRequest() {
  const qc = useQueryClient();

  return useMutation({
    mutationFn: async ({ friendId }: { friendId: string }) => await declineFriendRequest(friendId),

    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['friend-requests'] });
      qc.invalidateQueries({ queryKey: ['friends'] });
    },
  });
}

export function usePendingFriendRequests() {
  return useQuery({
    queryKey: ['friend-requests'],
    queryFn: async () => await fetchPendingFriendRequests(),
  });
}
