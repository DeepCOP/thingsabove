import { useAuth } from '@/src/state/AuthContext';
import Constants from 'expo-constants';
import * as Device from 'expo-device';
import * as Notifications from 'expo-notifications';
import { useEffect, useState } from 'react';
import { Platform } from 'react-native';
import { pushNotificationSetup } from '../api/mutations';

Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldPlaySound: true,
    shouldSetBadge: true,
    shouldShowBanner: true,
    shouldShowList: true,
  }),
});

function handleRegistrationError(message: string) {
  console.warn(message);
  throw new Error(message);
}

export async function registerForPushNotificationsAsync(): Promise<string | undefined> {
  if (Platform.OS === 'android') {
    await Notifications.setNotificationChannelAsync('default', {
      name: 'default',
      importance: Notifications.AndroidImportance.MAX,
      vibrationPattern: [0, 250, 250, 250],
      lightColor: '#FF231F7C',
    });
  }

  if (!Device.isDevice) {
    return;
  }

  const { status: existingStatus } = await Notifications.getPermissionsAsync();
  let finalStatus = existingStatus;

  if (existingStatus !== 'granted') {
    const { status } = await Notifications.requestPermissionsAsync();
    finalStatus = status;
  }

  if (finalStatus !== 'granted') {
    handleRegistrationError('Permission not granted for push notifications');
    return;
  }

  const projectId = Constants?.expoConfig?.extra?.eas?.projectId ?? Constants?.easConfig?.projectId;

  if (!projectId) {
    handleRegistrationError('Expo project ID not found');
    return;
  }

  const token = (await Notifications.getExpoPushTokenAsync({ projectId })).data;

  if (token) {
    const userTimeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    await pushNotificationSetup(userTimeZone, token);
  }

  return token;
}

export function usePushNotifications() {
  const { session } = useAuth();

  const [expoPushToken, setExpoPushToken] = useState<string>();
  const [notification, setNotification] = useState<Notifications.Notification>();

  useEffect(() => {
    if (!session?.user?.id) return;

    registerForPushNotificationsAsync()
      .then(async (token) => {
        if (!token) return;

        setExpoPushToken(token);
      })
      .catch(console.error);

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
