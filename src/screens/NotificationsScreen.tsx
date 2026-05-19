import LoadingSpinner from '@/src/components/LoadingSpinner';
import dayjs from '@/src/lib/dayjs';
import { AppNotification } from '@/src/types/notifications';
import { Ionicons } from '@expo/vector-icons';
import { FlatList, Modal, Pressable, ScrollView, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type Props = {
  notifications?: AppNotification[];
  hasError?: boolean;
  isLoading: boolean;
  messageNotification?: AppNotification | null;
  onCloseMessage?: () => void;
  onPress: (item: AppNotification) => void;
  onRetry?: () => void;
};

export default function NotificationsScreen({
  notifications,
  hasError,
  isLoading,
  messageNotification,
  onCloseMessage,
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

      <Modal
        animationType="fade"
        transparent
        visible={!!messageNotification}
        onRequestClose={onCloseMessage}>
        <Pressable className="flex-1 justify-center bg-black/60 px-5" onPress={onCloseMessage}>
          <Pressable className="max-h-[80%] rounded-2xl bg-white p-5 dark:bg-neutral-900">
            <View className="mb-4 flex-row items-start justify-between gap-3">
              <View className="flex-1">
                <Text className="text-lg font-semibold text-gray-950 dark:text-white">
                  {messageNotification?.title || 'Notification'}
                </Text>
                {messageNotification?.created_at ? (
                  <Text className="mt-1 text-xs text-gray-500 dark:text-gray-400">
                    {dayjs(messageNotification.created_at).format('DD/MM/YYYY')}
                  </Text>
                ) : null}
              </View>

              <TouchableOpacity
                accessibilityRole="button"
                accessibilityLabel="Close"
                className="rounded-full bg-gray-100 p-2 dark:bg-neutral-800"
                onPress={onCloseMessage}>
                <Ionicons name="close" size={18} color="#9ca3af" />
              </TouchableOpacity>
            </View>

            <ScrollView>
              <Text className="text-base leading-6 text-gray-700 dark:text-gray-200">
                {messageNotification?.body || 'No message available.'}
              </Text>
            </ScrollView>
          </Pressable>
        </Pressable>
      </Modal>
    </View>
  );
}
