import { GetMyNotifications } from './types';

export const NOTIFICATION_TYPES = {
  PLAN_INVITE: 'plan_invite',
  FRIEND_REQUEST: 'friend_request',
  PRAYER_ENCOURAGEMENT: 'prayer_encouragement',
} as const;

export type NotificationType = (typeof NOTIFICATION_TYPES)[keyof typeof NOTIFICATION_TYPES];
export type AppNotification = GetMyNotifications[number];

export const AVAILABLE_NOTIFICATION_TYPES = Object.values(NOTIFICATION_TYPES) as NotificationType[];

export function isNotificationType(value: string): value is NotificationType {
  return AVAILABLE_NOTIFICATION_TYPES.includes(value as NotificationType);
}
