import { markNotificationRead } from '@/src/api/mutations';
import { getUserNotifications, getUserNotificationsCount } from '@/src/api/queries';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

export function useNotifications(userId: string | undefined) {
  const queryClient = useQueryClient();

  const notificationsQuery = useQuery({
    queryKey: ['notifications', userId],
    enabled: !!userId,
    staleTime: 0,
    refetchOnReconnect: 'always',
    refetchOnWindowFocus: 'always',
    queryFn: async () => await getUserNotifications(),
  });

  const notificationsCountQuery = useQuery({
    queryKey: ['notifications_count', userId],
    staleTime: 0,
    enabled: !!userId,
    refetchOnReconnect: 'always',
    refetchOnWindowFocus: 'always',
    queryFn: async () => await getUserNotificationsCount(),
  });

  const markRead = useMutation({
    mutationFn: async (id: string) => await markNotificationRead(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['notifications_count'] });
      queryClient.invalidateQueries({ queryKey: ['notifications'] });
    },
  });

  return { notificationsQuery, markRead, notificationsCountQuery };
}
