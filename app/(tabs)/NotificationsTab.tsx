import LoadingSpinner from '@/components/LoadingSpinner';
import { useAuth } from '@/context/AuthContext';
import { useNotifications } from '@/hooks/useNotifications';
import { Json } from '@/lib/types/supabase.gen.types';
import { Ionicons } from '@expo/vector-icons';
import dayjs from 'dayjs';
import { useRouter } from 'expo-router';
import { FlatList, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type planInviteNotificationData = {
  plan_id: string;
  group_id: string;
  invited_by: string;
};

type friendRequestNotificationData = {
  requester_id: string;
};

export default function NotificationsScreen() {
  const router = useRouter();
  const { session } = useAuth();
  const { notificationsQuery, markRead } = useNotifications(session?.user?.id);
  const insets = useSafeAreaInsets();

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

    const data = item.data as planInviteNotificationData & friendRequestNotificationData;

    switch (item.type) {
      case 'plan_invite':
        router.push({
          pathname: '/devotional_detail/[id]/invitation',
          params: {
            groupId: data.group_id,
            invitedBy: data.invited_by,
            id: data.plan_id,
          },
        });
        break;
      case 'friend_request':
        router.push('/accept_friend');
        break;
      default:
        break;
    }
  }
  if ((notificationsQuery.data ?? []).length === 0) {
    return (
      <View className="flex-1 items-center justify-center">
        <Ionicons name="notifications" size={50} color="gray" />
        <Text className="text-gray-700 dark:text-gray-200">No notifications</Text>
      </View>
    );
  }
  return (
    <>
      <View className="flex-1 bg-white dark:bg-black px-4" style={{ paddingBottom: insets.bottom }}>
        <FlatList
          data={notificationsQuery.data}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => (
            <TouchableOpacity
              onPress={() => {
                markRead.mutate(item.id);
                handleNotificationPress(item);
              }}
              className={`p-4 rounded-xl mb-3 ${
                item.is_read ? 'bg-neutral-900' : 'bg-neutral-800 border border-white/10'
              }`}>
              <View className="flex-1 flex-row justify-between">
                <Text className="text-white font-semibold">{item.title}</Text>
                <Text className="text-xs text-gray-200 mt-2">
                  {dayjs(item.created_at).format('DD/MM/YYYY')}
                </Text>
              </View>
              {item.body && <Text className="text-gray-400 mt-1">{item.body}</Text>}
            </TouchableOpacity>
          )}
        />
      </View>
    </>
  );
}
