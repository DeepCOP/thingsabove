import LoadingSpinner from '@/src/components/LoadingSpinner';
import dayjs from '@/src/lib/dayjs';
import { AppNotification } from '@/src/types/notifications';
import { Ionicons } from '@expo/vector-icons';
import { FlatList, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type Props = {
  notifications?: AppNotification[];
  hasError?: boolean;
  isLoading: boolean;
  onPress: (item: AppNotification) => void;
  onRetry?: () => void;
};

export default function NotificationsScreen({
  notifications,
  hasError,
  isLoading,
  onPress,
  onRetry,
}: Props) {
  const insets = useSafeAreaInsets();

  if (isLoading) {
    return <LoadingSpinner />;
  }

  if (hasError) {
    return (
      <View className="flex-1 items-center justify-center bg-white px-6 dark:bg-black">
        <Ionicons name="alert-circle-outline" size={50} color="#ef4444" />
        <Text className="mt-4 text-lg font-semibold text-gray-900 dark:text-white">
          Unable to load notifications
        </Text>
        <Text className="mt-2 text-center text-sm text-gray-600 dark:text-gray-400">
          We could not load your notifications right now.
        </Text>
        {onRetry ? (
          <TouchableOpacity
            className="mt-5 rounded-full bg-black px-5 py-3 dark:bg-white"
            onPress={onRetry}>
            <Text className="font-semibold text-white dark:text-black">Try again</Text>
          </TouchableOpacity>
        ) : null}
      </View>
    );
  }

  if (!notifications || notifications.length === 0) {
    return (
      <View className="flex-1 items-center justify-center bg-white px-6 dark:bg-black">
        <Ionicons name="notifications" size={50} color="gray" />
        <Text className="text-gray-700 dark:text-gray-200">No unread notifications</Text>
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
            <View className="flex-row items-start justify-between gap-3">
              <Text className="flex-1 pr-2 text-white font-semibold">{item.title}</Text>
              <Text className="shrink-0 pt-0.5 text-right text-xs text-gray-200">
                {dayjs(item.created_at).format('DD/MM/YYYY')}
              </Text>
            </View>

            {item.body ? <Text className="mt-1 text-gray-400">{item.body}</Text> : null}
          </TouchableOpacity>
        )}
      />
    </View>
  );
}
