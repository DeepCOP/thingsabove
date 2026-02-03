import { useAuth } from '@/src/state/AuthContext';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import Constants from 'expo-constants';
import * as Device from 'expo-device';
import * as Notifications from 'expo-notifications';
import { Alert, Platform } from 'react-native';
import { pushNotificationSetup, toggleDailyEncouragement } from '../api/mutations';
import { getNOtificationsPreferences } from '../api/queries';

type NotificationPrefs = {
  daily_encouragement: boolean | null;
};

export async function ensurePushReady(): Promise<string | null> {
  const { status: existingStatus } = await Notifications.getPermissionsAsync();

  // 1️⃣ Permission
  if (Platform.OS === 'android') {
    await Notifications.setNotificationChannelAsync('default', {
      name: 'default',
      importance: Notifications.AndroidImportance.MAX,
      vibrationPattern: [0, 250, 250, 250],
      lightColor: '#FF231F7C',
    });
  }
  if (!Device.isDevice) {
    Alert.alert('Unsupported device', 'Push notifications require a physical device.');
    return null;
  }

  let finalStatus = existingStatus;
  if (existingStatus !== 'granted') {
    const res = await Notifications.requestPermissionsAsync();
    finalStatus = res.status;
  }

  if (finalStatus !== 'granted') {
    Alert.alert('Notifications disabled', 'Please enable notifications in system settings.');
    return null;
  }

  // 3️⃣ Get Expo push token
  const projectId = Constants?.expoConfig?.extra?.eas?.projectId ?? Constants?.easConfig?.projectId;

  if (!projectId) {
    console.warn('Expo project ID not found');
    return null;
  }

  const token = (await Notifications.getExpoPushTokenAsync({ projectId })).data;

  if (token && existingStatus !== 'granted') {
    const userTimeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    await pushNotificationSetup(userTimeZone, token);
  }
  return token;
}

export function useNotificationSettings() {
  const { session } = useAuth();
  const userId = session?.user.id;

  const queryClient = useQueryClient();

  // 1️⃣ Fetch preferences
  const { data, isLoading: loading } = useQuery({
    queryKey: ['notification-preferences', userId],
    enabled: !!userId,
    queryFn: async () => getNOtificationsPreferences(userId!),
  });

  const dailyEncouragement = data?.daily ?? false;

  // 2️⃣ Update preference
  const { mutate: toggleDailyEncouragementMutation, isPending } = useMutation({
    mutationFn: async (value: boolean) => toggleDailyEncouragement(value, userId),

    // 3️⃣ Optimistic update
    onMutate: async (value) => {
      await queryClient.cancelQueries({
        queryKey: ['notification-preferences', userId],
      });

      const previous = queryClient.getQueryData<NotificationPrefs | null>([
        'notification-preferences',
        userId,
      ]);

      queryClient.setQueryData(['notification-preferences', userId], {
        daily_encouragement: value,
      });

      return { previous };
    },

    onError: (_err, _value, context) => {
      if (context?.previous) {
        queryClient.setQueryData(['notification-preferences', userId], context.previous);
      }
    },

    onSettled: () => {
      queryClient.invalidateQueries({
        queryKey: ['notification-preferences', userId],
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
