import {
  getUserNotifications,
  getUserNotificationsCount,
  markNotificationRead,
  notificationsRealTime,
} from '@/api/queries';
import { supabase } from '@/api/supabaseClient';
import { RealtimeChannel } from '@supabase/supabase-js';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useEffect } from 'react';

export function useNotifications() {
  const queryClient = useQueryClient();

  const notificationsQuery = useQuery({
    queryKey: ['notifications'],
    staleTime: 0,
    refetchOnReconnect: 'always',
    refetchOnWindowFocus: 'always',
    queryFn: async () => await getUserNotifications(),
  });

  const notificationsCountQuery = useQuery({
    queryKey: ['notifications-count'],
    staleTime: 0,
    refetchOnReconnect: 'always',
    refetchOnWindowFocus: 'always',
    queryFn: async () => await getUserNotificationsCount(),
  });

  const markRead = useMutation({
    mutationFn: async (id: string) => await markNotificationRead(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['notifications-count'] });
      queryClient.invalidateQueries({ queryKey: ['notifications'] });
    },
  });

  return { notificationsQuery, markRead, notificationsCountQuery };
}

export function useRealtimeNotifications(userId: string | null, onNew: () => void) {
  useEffect(() => {
    if (!userId) return;

    let channel: RealtimeChannel;
    const getChannel = async () => {
      channel = await notificationsRealTime(userId, onNew);
    };

    getChannel();

    return () => {
      if (channel) {
        supabase.removeChannel(channel);
      }
    };
  }, [userId]);
}
