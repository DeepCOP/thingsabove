import LoadingSpinner from '@/src/components/LoadingSpinner';
import { FlatList, Image, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { GetPendingFriendRequests } from '../types/types';

type Props = {
  data: GetPendingFriendRequests | undefined;
  isLoading: boolean;
  onAccept: (friendId: string) => void;
  onDecline: (friendId: string) => void;
  isAccepting: boolean;
  isDeclining: boolean;
};

export default function AcceptFriendRequestsScreen({
  data,
  isLoading,
  onAccept,
  onDecline,
  isAccepting,
  isDeclining,
}: Props) {
  const insets = useSafeAreaInsets();

  if (isLoading) {
    return (
      <View className="flex-1 items-center justify-center">
        <LoadingSpinner />
      </View>
    );
  }

  return (
    <View className="flex-1 bg-white dark:bg-black px-4" style={{ paddingBottom: insets.bottom }}>
      <Text className="text-xl font-bold dark:text-white mb-4">Friend Requests</Text>

      <FlatList
        data={data}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <View className="flex-row items-center p-3 mb-3 rounded-xl bg-gray-100 dark:bg-neutral-900">
            {item.avatar_url ? (
              <Image source={{ uri: item.avatar_url }} className="w-12 h-12 rounded-full mr-3" />
            ) : (
              <View className="w-12 h-12 rounded-full bg-gray-400 mr-3 items-center justify-center">
                <Text className="text-white font-bold">{item.first_name[0]}</Text>
              </View>
            )}

            <View className="flex-1">
              <Text className="font-semibold dark:text-white">
                {item.first_name} {item.last_name}
              </Text>
              <Text className="text-xs text-gray-500">Sent you a friend request</Text>
            </View>

            <View className="flex-row gap-2">
              <TouchableOpacity
                onPress={() => onDecline(item.requester_id)}
                disabled={isDeclining}
                className="px-3 py-2 rounded-full bg-gray-300 dark:bg-neutral-700">
                {isDeclining ? (
                  <LoadingSpinner size="small" />
                ) : (
                  <Text className="text-black dark:text-white text-sm">Decline</Text>
                )}
              </TouchableOpacity>

              <TouchableOpacity
                onPress={() => onAccept(item.requester_id)}
                disabled={isAccepting}
                className="px-4 py-2 rounded-full bg-black dark:bg-white">
                {isAccepting ? (
                  <LoadingSpinner size="small" />
                ) : (
                  <Text className="text-white dark:text-black text-sm font-semibold">Accept</Text>
                )}
              </TouchableOpacity>
            </View>
          </View>
        )}
        ListEmptyComponent={
          <Text className="text-gray-500 text-center mt-10">No pending friend requests</Text>
        }
      />
    </View>
  );
}
