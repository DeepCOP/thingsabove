import { useNotifications } from '@/src/hooks/useNotifications';
import NotificationsScreen from '@/src/screens/NotificationsScreen';
import { useAuth } from '@/src/state/AuthContext';
import { AppNotification, isNotificationType, NOTIFICATION_TYPES } from '@/src/types/notifications';
import { Json } from '@/src/types/supabase.gen.types';
import { useRouter } from 'expo-router';
import { useState } from 'react';
import { Alert } from 'react-native';

type PlanInviteNotificationData = {
  group_id: string;
  invited_by?: string;
  plan_id: string;
};

type PrayerEncouragementNotificationData = {
  encouraged_by: string;
  request_id: string;
};

type GroupDayCompletedNotificationData = {
  progress_id: string;
  plan_id?: string;
  group_id?: string;
  day_id?: string;
  day_number?: number;
  completed_by?: string;
};

function isJsonObject(value: Json): value is Record<string, Json> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

function getRequiredStringValue(data: Record<string, Json>, key: string) {
  const value = data[key];
  return typeof value === 'string' && value.length > 0 ? value : null;
}

function getOptionalNumberValue(data: Record<string, Json>, key: string) {
  const value = data[key];
  return typeof value === 'number' ? value : null;
}

function parsePlanInviteNotificationData(data: Json): PlanInviteNotificationData | null {
  if (!isJsonObject(data)) {
    return null;
  }

  const planId = getRequiredStringValue(data, 'plan_id');
  const groupId = getRequiredStringValue(data, 'group_id');
  const invitedBy = getRequiredStringValue(data, 'invited_by');

  if (!planId || !groupId) {
    return null;
  }

  return {
    plan_id: planId,
    group_id: groupId,
    ...(invitedBy ? { invited_by: invitedBy } : {}),
  };
}

function parsePrayerEncouragementNotificationData(
  data: Json,
): PrayerEncouragementNotificationData | null {
  if (!isJsonObject(data)) {
    return null;
  }

  const requestId = getRequiredStringValue(data, 'request_id');
  const encouragedBy = getRequiredStringValue(data, 'encouraged_by');

  if (!requestId || !encouragedBy) {
    return null;
  }

  return {
    request_id: requestId,
    encouraged_by: encouragedBy,
  };
}

function parseGroupDayCompletedNotificationData(
  data: Json,
): GroupDayCompletedNotificationData | null {
  if (!isJsonObject(data)) {
    return null;
  }

  const progressId = getRequiredStringValue(data, 'progress_id');
  const planId = getRequiredStringValue(data, 'plan_id');
  const groupId = getRequiredStringValue(data, 'group_id');
  const dayId = getRequiredStringValue(data, 'day_id');
  const dayNumber = getOptionalNumberValue(data, 'day_number');
  const completedBy = getRequiredStringValue(data, 'completed_by');

  if (!progressId) {
    return null;
  }

  return {
    progress_id: progressId,
    ...(planId ? { plan_id: planId } : {}),
    ...(groupId ? { group_id: groupId } : {}),
    ...(dayId ? { day_id: dayId } : {}),
    ...(dayNumber !== null ? { day_number: dayNumber } : {}),
    ...(completedBy ? { completed_by: completedBy } : {}),
  };
}

export default function NotificationsTab() {
  const router = useRouter();
  const { session } = useAuth();
  const { notificationsQuery, markRead } = useNotifications(session?.user?.id);
  const [selectedMessageNotification, setSelectedMessageNotification] =
    useState<AppNotification | null>(null);
  const isLoading = notificationsQuery.isFetching && !notificationsQuery.data;

  function markNotificationAsRead(item: AppNotification) {
    if (!item.is_read) {
      markRead.mutate(item.id);
    }
  }

  function showUnsupportedNotificationAlert() {
    Alert.alert(
      'Notification not supported',
      'This notification type is not supported in this app version yet.',
    );
  }

  function handleNotificationPress(item: AppNotification) {
    if (!isNotificationType(item.type)) {
      showUnsupportedNotificationAlert();
      return;
    }

    switch (item.type) {
      case NOTIFICATION_TYPES.PLAN_INVITE: {
        const data = parsePlanInviteNotificationData(item.data);

        if (!data) {
          Alert.alert(
            'Notification unavailable',
            'This invitation is missing details and cannot be opened right now.',
          );
          return;
        }

        router.push({
          pathname: '/devotional_detail/[planId]/invitation',
          params: {
            groupId: data.group_id,
            planId: data.plan_id,
            ...(data.invited_by ? { invitedBy: data.invited_by } : {}),
          },
        });
        markNotificationAsRead(item);
        return;
      }
      case NOTIFICATION_TYPES.GROUP_DAY_COMPLETED: {
        const data = parseGroupDayCompletedNotificationData(item.data);

        if (!data) {
          Alert.alert(
            'Notification unavailable',
            'This group plan update is missing details and cannot be opened right now.',
          );
          return;
        }

        router.push({
          pathname: '/plan_progress/[progressId]',
          params: {
            progressId: data.progress_id,
            ...(data.group_id ? { groupId: data.group_id } : {}),
            ...(data.plan_id ? { planId: data.plan_id } : {}),
            ...(data.day_id ? { dayId: data.day_id } : {}),
            ...(data.day_number ? { dayNumber: String(data.day_number) } : {}),
          },
        });
        markNotificationAsRead(item);
        return;
      }
      case NOTIFICATION_TYPES.FRIEND_REQUEST:
        router.push('/accept_friend');
        markNotificationAsRead(item);
        return;
      case NOTIFICATION_TYPES.PRAYER_ENCOURAGEMENT: {
        const data = parsePrayerEncouragementNotificationData(item.data);

        if (!data) {
          Alert.alert(
            'Notification unavailable',
            'This prayer encouragement is missing details and cannot be opened right now.',
          );
          return;
        }

        router.push({
          pathname: '/prayer/[requestId]',
          params: {
            requestId: data.request_id,
          },
        });
        markNotificationAsRead(item);
        return;
      }
      case NOTIFICATION_TYPES.AI_NOTIFICATION:
        setSelectedMessageNotification(item);
        markNotificationAsRead(item);
        return;
      default:
        showUnsupportedNotificationAlert();
        return;
    }
  }

  return (
    <NotificationsScreen
      notifications={notificationsQuery.data}
      isLoading={isLoading}
      hasError={notificationsQuery.isError && !notificationsQuery.data}
      onPress={handleNotificationPress}
      onRetry={() => notificationsQuery.refetch()}
      messageNotification={selectedMessageNotification}
      onCloseMessage={() => setSelectedMessageNotification(null)}
    />
  );
}
