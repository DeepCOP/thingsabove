import { useAuth } from '@/src/state/AuthContext';
import Constants from 'expo-constants';
import * as Device from 'expo-device';
import * as Notifications from 'expo-notifications';
import { useEffect, useState } from 'react';
import { Alert, Platform } from 'react-native';
import { pushNotificationSetup } from '../api/mutations';

Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldPlaySound: true,
    shouldSetBadge: true,
    shouldShowBanner: true,
    shouldShowList: true,
  }),
});

export async function registerForPushNotificationsAsync(): Promise<string | null> {
  // 1️⃣ Physical device check
  if (!Device.isDevice) {
    Alert.alert('Unsupported device', 'Push notifications require a physical device.');
    return null;
  }

  // 2️⃣ Android channel
  if (Platform.OS === 'android') {
    await Notifications.setNotificationChannelAsync('default', {
      name: 'default',
      importance: Notifications.AndroidImportance.MAX,
      vibrationPattern: [0, 250, 250, 250],
      lightColor: '#FF231F7C',
    });
  }

  // 3️⃣ Permission check + request
  const { status: existingStatus } = await Notifications.getPermissionsAsync();

  let finalStatus = existingStatus;

  if (existingStatus !== 'granted') {
    const res = await Notifications.requestPermissionsAsync();
    finalStatus = res.status;
  }

  if (finalStatus !== 'granted') {
    Alert.alert('Notifications disabled', 'Please enable notifications in system settings.');
    return null;
  }

  // 4️⃣ Get Expo project ID
  const projectId = Constants?.expoConfig?.extra?.eas?.projectId ?? Constants?.easConfig?.projectId;

  if (!projectId) {
    console.warn('Expo project ID not found');
    return null;
  }

  // 5️⃣ Get push token
  const token = (await Notifications.getExpoPushTokenAsync({ projectId })).data;

  if (!token) return null;

  // 6️⃣ Register token only if newly granted or missing on backend
  const userTimeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;

  await pushNotificationSetup(userTimeZone, token);

  return token;
}

export function usePushNotifications() {
  const { session } = useAuth();

  const [expoPushToken, setExpoPushToken] = useState<string>();
  const [notification, setNotification] = useState<Notifications.Notification>();

  useEffect(() => {
    if (!session?.user?.id) return;

    registerForPushNotificationsAsync().then(async (token) => {
      if (!token) return;

      setExpoPushToken(token);
    });

    const notificationListener = Notifications.addNotificationReceivedListener(setNotification);

    const responseListener = Notifications.addNotificationResponseReceivedListener(() => {});

    return () => {
      notificationListener.remove();
      responseListener.remove();
    };
  }, [session?.user?.id]);

  return {
    expoPushToken,
    notification,
  };
}
