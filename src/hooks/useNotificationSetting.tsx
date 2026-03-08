import { useAuth } from '@/src/state/AuthContext';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { toggleDailyEncouragement } from '../api/mutations';
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

  const dailyEncouragement = data?.daily ?? false;

  // 2️⃣ Update preference
  const { mutate: toggleDailyEncouragementMutation, isPending } = useMutation({
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

  return {
    loading,
    dailyEncouragement,
    toggleDailyEncouragementMutation,
    isUpdating: isPending,
  };
}
