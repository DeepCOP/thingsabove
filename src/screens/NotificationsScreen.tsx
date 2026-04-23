import LoadingSpinner from '@/src/components/LoadingSpinner';
import dayjs from '@/src/lib/dayjs';
import { Json } from '@/src/types/supabase.gen.types';
import { Ionicons } from '@expo/vector-icons';
import { FlatList, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { GetMyNotifications } from '../types/types';

type NotificationItem = {
  id: string;
  title: string;
  body: string;
  created_at: string;
  is_read: boolean;
  type: string;
  data: Json;
};

type Props = {
  notifications: GetMyNotifications;
  isLoading: boolean;
  onPress: (item: NotificationItem) => void;
};

export default function NotificationsScreen({ notifications, isLoading, onPress }: Props) {
  const insets = useSafeAreaInsets();

  if (isLoading) {
    return <LoadingSpinner />;
  }

  if (!notifications || notifications.length === 0) {
    return (
      <View className="flex-1 items-center justify-center">
        <Ionicons name="notifications" size={50} color="gray" />
        <Text className="text-gray-700 dark:text-gray-200">No notifications</Text>
      </View>
    );
  }

  return (
    <View className="flex-1 bg-white dark:bg-black px-4" style={{ paddingBottom: insets.bottom }}>
      <FlatList
        data={notifications}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <TouchableOpacity
            onPress={() => onPress(item)}
            className={`p-4 rounded-xl mb-3 ${
              item.is_read ? 'bg-neutral-900' : 'bg-neutral-800 border border-white/10'
            }`}>
            <View className="flex-row justify-between">
              <Text className="text-white font-semibold">{item.title}</Text>
              <Text className="text-xs text-gray-200">
                {dayjs(item.created_at).format('DD/MM/YYYY')}
              </Text>
            </View>

            {item.body && <Text className="text-gray-400 mt-1">{item.body}</Text>}
          </TouchableOpacity>
        )}
      />
    </View>
  );
}
