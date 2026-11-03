import { acceptFriendRequest, addFriend, declineFriendRequest } from '@/src/api/mutations';
import {
  fetchFriendship,
  fetchPendingFriendRequests,
  fetchUserFriends,
  getUserByEmail,
  searchUsersByName,
} from '@/src/api/queries';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { COMMUNITY_STALE_TIME } from '../lib/queryCache';
import { invalidateFriendQueries } from '../lib/queryInvalidation';
import { useAuth } from '../state/AuthContext';

export function useFriends(userId: string | undefined) {
  return useQuery({
    queryKey: ['friends', userId],
    staleTime: COMMUNITY_STALE_TIME,
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
    staleTime: COMMUNITY_STALE_TIME,
    enabled: !!userId && !!friendId && userId !== friendId,
    queryFn: async () => await fetchFriendship({ userId: userId!, friendId: friendId! }),
  });
}

export function useAddFriend() {
  const qc = useQueryClient();

  return useMutation({
    mutationFn: async ({ friendId }: { friendId: string; userId: string }) =>
      await addFriend({ receiver_id: friendId }),
    onSuccess: (_data, variables) => invalidateFriendQueries(qc, variables.userId),
  });
}

export function useSearchUsersByName({
  query,
  userId,
}: {
  query: string;
  userId: string | undefined;
}) {
  return useQuery({
    queryKey: ['search_users_by_name', query, userId],
    enabled: query.length >= 2 && !!userId,
    staleTime: 0,
    queryFn: async () => await searchUsersByName(query),
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
  const { session } = useAuth();

  return useMutation({
    mutationFn: async ({ friendId }: { friendId: string }) => await acceptFriendRequest(friendId),

    onSuccess: () => invalidateFriendQueries(qc, session?.user.id),
  });
}

export function useDeclineFriendRequest() {
  const qc = useQueryClient();
  const { session } = useAuth();

  return useMutation({
    mutationFn: async ({ friendId }: { friendId: string }) => await declineFriendRequest(friendId),

    onSuccess: () => invalidateFriendQueries(qc, session?.user.id),
  });
}

export function usePendingFriendRequests(userId: string | undefined) {
  return useQuery({
    queryKey: ['friend_requests', userId],
    staleTime: COMMUNITY_STALE_TIME,
    enabled: !!userId,
    queryFn: async () => await fetchPendingFriendRequests(),
  });
}
