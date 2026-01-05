import {
  acceptFriendRequest,
  addFriend,
  declineFriendRequest,
  fetchPendingFriendRequests,
  fetchUserFriends,
  FriendRequestRealTime,
  FriendRequestRealTimeReceiver,
  getUserByEmail,
} from '@/api/queries';
import { supabase } from '@/api/supabaseClient';
import { RealtimeChannel } from '@supabase/supabase-js';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useEffect } from 'react';

export function useFriends(userId: string) {
  return useQuery({
    queryKey: ['friends', userId],
    staleTime: 1000 * 60 * 60 * 24,
    enabled: !!userId,
    queryFn: async () => await fetchUserFriends({ userId }),
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

export function useRealtimeFriends(userId: string, onNew: () => void) {
  useEffect(() => {
    if (!userId) return;

    let requesterChannel: RealtimeChannel;

    const getRequesterChannel = async () => {
      requesterChannel = await FriendRequestRealTime({ userId, onNew });
    };

    let receiverChannel: RealtimeChannel;

    const getReceiverChannel = async () => {
      receiverChannel = await FriendRequestRealTimeReceiver({ userId, onNew });
    };

    getRequesterChannel();
    getReceiverChannel();

    return () => {
      if (receiverChannel) {
        supabase.removeChannel(requesterChannel);
      }
      if (requesterChannel) {
        supabase.removeChannel(receiverChannel);
      }
    };
  }, [userId, onNew]);
}
