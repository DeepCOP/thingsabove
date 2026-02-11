import LoadingSpinner from '@/src/components/LoadingSpinner';
import { FlatList, Text, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import FriendRequestCard from '../components/FriendRequestCard';
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
          <FriendRequestCard
            id={item.requester_id}
            first_name={item.first_name}
            last_name={item.last_name}
            avatar_url={item.avatar_url}
            mode="receiver"
            onAccept={onAccept}
            onDecline={onDecline}
            isAccepting={isAccepting}
            isDeclining={isDeclining}
          />
        )}
        ListEmptyComponent={
          <Text className="text-gray-500 text-center mt-10">No pending friend requests</Text>
        }
      />
    </View>
  );
}
