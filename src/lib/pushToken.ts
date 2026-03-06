import Constants from 'expo-constants';
import * as Notifications from 'expo-notifications';

export function getExpoProjectId(): string | null {
  return Constants?.expoConfig?.extra?.eas?.projectId ?? Constants?.easConfig?.projectId ?? null;
}

export async function getCurrentDeviceExpoPushToken(): Promise<string | null> {
  const projectId = getExpoProjectId();
  if (!projectId) return null;

  try {
    const token = (await Notifications.getExpoPushTokenAsync({ projectId })).data;
    return token ?? null;
  } catch {
    return null;
  }
}
