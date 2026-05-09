import { useAuth } from '@/src/state/AuthContext';
import * as Device from 'expo-device';
import * as Notifications from 'expo-notifications';
import { router, type Href } from 'expo-router';
import { useEffect, useState } from 'react';
import { Alert, Platform } from 'react-native';
import { pushNotificationSetup } from '../api/mutations';
import { getCurrentDeviceExpoPushToken, getExpoProjectId } from '../lib/pushToken';
import { getRouteFromNotificationResponse } from '../utils';

Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldPlaySound: true,
    shouldSetBadge: true,
    shouldShowBanner: true,
    shouldShowList: true,
  }),
});

function openRouteFromResponse(response: Notifications.NotificationResponse | null) {
  if (!response || response.actionIdentifier !== Notifications.DEFAULT_ACTION_IDENTIFIER) return;

  router.push(getRouteFromNotificationResponse(response) as Href);
  Notifications.clearLastNotificationResponse();
}

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
  const projectId = getExpoProjectId();

  if (!projectId) {
    console.warn('Expo project ID not found');
    return null;
  }

  // 5️⃣ Get push token
  const token = await getCurrentDeviceExpoPushToken();

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
    if (!session?.user?.id) {
      setExpoPushToken(undefined);
      return;
    }

    const notificationListener = Notifications.addNotificationReceivedListener(setNotification);
    const responseListener =
      Notifications.addNotificationResponseReceivedListener(openRouteFromResponse);

    openRouteFromResponse(Notifications.getLastNotificationResponse());

    registerForPushNotificationsAsync().then(async (token) => {
      if (!token) return;

      setExpoPushToken(token);
    });

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
