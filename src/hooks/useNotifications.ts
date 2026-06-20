import { markAllNotificationsRead, markNotificationRead } from '@/src/api/mutations';
import { getUserNotifications, getUserNotificationsCount } from '@/src/api/queries';
import { AppNotification } from '@/src/types/notifications';
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

  const markAllRead = useMutation({
    mutationFn: async (targetUserId: string) => await markAllNotificationsRead(targetUserId),
    onMutate: async (targetUserId) => {
      const notificationsQueryKey = ['notifications', targetUserId];
      const notificationsCountQueryKey = ['notifications_count', targetUserId];

      await queryClient.cancelQueries({ queryKey: notificationsQueryKey });
      await queryClient.cancelQueries({ queryKey: notificationsCountQueryKey });

      const previousNotifications =
        queryClient.getQueryData<AppNotification[]>(notificationsQueryKey);
      const previousCount = queryClient.getQueryData<number>(notificationsCountQueryKey);

      queryClient.setQueryData<AppNotification[]>(notificationsQueryKey, (current) =>
        current?.map((notification) => ({ ...notification, is_read: true })),
      );
      queryClient.setQueryData(notificationsCountQueryKey, 0);

      return { previousCount, previousNotifications, targetUserId };
    },
    onError: (_error, _targetUserId, context) => {
      if (!context) return;

      queryClient.setQueryData(
        ['notifications', context.targetUserId],
        context.previousNotifications,
      );
      queryClient.setQueryData(
        ['notifications_count', context.targetUserId],
        context.previousCount,
      );
    },
    onSettled: (_data, _error, targetUserId) => {
      queryClient.invalidateQueries({ queryKey: ['notifications_count', targetUserId] });
      queryClient.invalidateQueries({ queryKey: ['notifications', targetUserId] });
    },
  });

  return { notificationsQuery, markRead, markAllRead, notificationsCountQuery };
}
