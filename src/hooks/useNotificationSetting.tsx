import { useAuth } from '@/src/state/AuthContext';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import {
  toggleDailyEncouragement,
  toggleGroupDayCompletedPushNotifications,
} from '../api/mutations';
import { getNotificationsPreferences } from '../api/queries';
import { NotificationPreferences } from '../types/types';

export function useNotificationSettings() {
  const { session } = useAuth();
  const userId = session?.user.id;

  const queryClient = useQueryClient();

  // 1️⃣ Fetch preferences
  const { data, isLoading: loading } = useQuery({
    queryKey: ['notification_preferences', userId],
    enabled: !!userId,
    queryFn: async () => getNotificationsPreferences(userId!),
  });

  const aiNotificationsEnabled = data?.daily ?? true;
  const groupDayCompletedPushNotificationsEnabled = data?.group_day_completed ?? true;

  // 2️⃣ Update preference
  const { mutate: toggleAiNotifications, isPending } = useMutation({
    mutationFn: async (value: boolean) => toggleDailyEncouragement(value, userId),

    // 3️⃣ Optimistic update
    onMutate: async (value) => {
      await queryClient.cancelQueries({
        queryKey: ['notification_preferences', userId],
      });

      const previous = queryClient.getQueryData<NotificationPreferences>([
        'notification_preferences',
        userId,
      ]);

      queryClient.setQueryData(
        ['notification_preferences', userId],
        (old: NotificationPreferences | undefined) => {
          return {
            ...old,
            user_id: userId,
            daily: value,
          };
        },
      );
      return { previous };
    },

    onError: (_err, _value, context) => {
      if (context?.previous) {
        queryClient.setQueryData(['notification_preferences', userId], context.previous);
      }
    },

    onSettled: () => {
      queryClient.invalidateQueries({
        queryKey: ['notification_preferences', userId],
      });
    },
  });

  const { mutate: toggleGroupDayCompletedPushNotificationsSetting, isPending: isGroupUpdating } =
    useMutation({
      mutationFn: async (value: boolean) => toggleGroupDayCompletedPushNotifications(value, userId),

      onMutate: async (value) => {
        await queryClient.cancelQueries({
          queryKey: ['notification_preferences', userId],
        });

        const previous = queryClient.getQueryData<NotificationPreferences>([
          'notification_preferences',
          userId,
        ]);

        queryClient.setQueryData(
          ['notification_preferences', userId],
          (old: NotificationPreferences | undefined) => {
            return {
              ...old,
              user_id: userId,
              group_day_completed: value,
            };
          },
        );
        return { previous };
      },

      onError: (_err, _value, context) => {
        if (context?.previous) {
          queryClient.setQueryData(['notification_preferences', userId], context.previous);
        }
      },

      onSettled: () => {
        queryClient.invalidateQueries({
          queryKey: ['notification_preferences', userId],
        });
      },
    });

  return {
    loading,
    aiNotificationsEnabled,
    groupDayCompletedPushNotificationsEnabled,
    toggleAiNotifications,
    toggleGroupDayCompletedPushNotifications: toggleGroupDayCompletedPushNotificationsSetting,
    isUpdating: isPending || isGroupUpdating,
  };
}
