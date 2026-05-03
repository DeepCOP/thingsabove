import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useNotifications } from '@/src/hooks/useNotifications';
import NotificationsScreen from '@/src/screens/NotificationsScreen';
import { useAuth } from '@/src/state/AuthContext';
import { Json } from '@/src/types/supabase.gen.types';
import { useRouter } from 'expo-router';

type planInviteNotificationData = {
  plan_id: string;
  group_id: string;
  invited_by: string;
};

type friendRequestNotificationData = {
  requester_id: string;
};

type prayerEncouragementNotificationData = {
  request_id: string;
  encouraged_by: string;
};

export default function NotificationsTab() {
  const router = useRouter();
  const { session } = useAuth();
  const { notificationsQuery, markRead } = useNotifications(session?.user?.id);

  if (notificationsQuery.isLoading) {
    return <LoadingSpinner />;
  }

  function handleNotificationPress(item: {
    body: string;
    created_at: string;
    data: Json;
    id: string;
    is_read: boolean;
    title: string;
    type: string;
  }) {
    markRead.mutate(item.id);

    const data = item.data as planInviteNotificationData &
      friendRequestNotificationData &
      prayerEncouragementNotificationData;

    switch (item.type) {
      case 'plan_invite':
        router.push({
          pathname: '/devotional_detail/[planId]/invitation',
          params: {
            groupId: data.group_id,
            invitedBy: data.invited_by,
            planId: data.plan_id,
          },
        });
        break;
      case 'friend_request':
        router.push('/accept_friend');
        break;
      case 'prayer_encouragement':
        router.push({
          pathname: '/prayer/[requestId]',
          params: {
            requestId: data.request_id,
          },
        });
        break;
      default:
        break;
    }
  }
  return (
    <NotificationsScreen
      notifications={notificationsQuery.data || []}
      isLoading={notificationsQuery.isLoading}
      onPress={handleNotificationPress}
    />
  );
}
