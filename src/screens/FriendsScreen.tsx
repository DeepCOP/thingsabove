import LoadingSpinner from '@/src/components/LoadingSpinner';
import UserAvatar from '@/src/components/UserAvatar';
import { Ionicons } from '@expo/vector-icons';
import { FlatList, Text, TouchableOpacity, View, useColorScheme } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type Friend = {
  id: string;
  first_name?: string | null;
  last_name?: string | null;
  avatar_url?: string | null;
};

type Props = {
  friends: Friend[];
  isLoading: boolean;
  pendingCount: number;
  onAddFriend: () => void;
  onFriendRequests: () => void;
};

export default function FriendsScreen({
  friends,
  isLoading,
  pendingCount,
  onAddFriend,
  onFriendRequests,
}: Props) {
  const insets = useSafeAreaInsets();
  const colorScheme = useColorScheme();
  const primaryActionColor = colorScheme === 'dark' ? '#000000' : '#ffffff';
  const accentColor = colorScheme === 'dark' ? '#60a5fa' : '#2563eb';

  if (isLoading) {
    return (
      <View className="flex-1 items-center justify-center bg-white dark:bg-black">
        <LoadingSpinner />
      </View>
    );
  }

  return (
    <View className="flex-1 bg-white px-4 dark:bg-black" style={{ paddingBottom: insets.bottom }}>
      <View className="mt-6 rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
        <Text className="text-lg font-semibold text-gray-900 dark:text-white">Your Friends</Text>
        <Text className="mt-2 text-sm leading-6 text-gray-600 dark:text-gray-400">
          See who you are connected with on ThingsAbove and add more friends from here.
        </Text>

        <View className="mt-4 flex-row gap-3">
          <TouchableOpacity
            className="flex-1 flex-row items-center justify-center rounded-full bg-black px-4 py-3 dark:bg-white"
            onPress={onAddFriend}>
            <Ionicons name="person-add-outline" size={18} color={primaryActionColor} />
            <Text className="ml-2 font-semibold text-white dark:text-black">Add Friend</Text>
          </TouchableOpacity>

          <TouchableOpacity
            className="flex-row items-center justify-center rounded-full border border-gray-300 px-4 py-3 dark:border-neutral-700"
            onPress={onFriendRequests}>
            <Ionicons name="mail-open-outline" size={18} color={accentColor} />
            <Text className="ml-2 font-semibold text-blue-600 dark:text-blue-400">
              Requests{pendingCount > 0 ? ` (${pendingCount})` : ''}
            </Text>
          </TouchableOpacity>
        </View>
      </View>

      {friends.length > 0 ? (
        <>
          <Text className="mt-6 mb-3 text-sm text-gray-500 dark:text-gray-400">
            {friends.length} Friend{friends.length === 1 ? '' : 's'}
          </Text>

          <FlatList
            data={friends}
            keyExtractor={(item) => item.id}
            renderItem={({ item }) => {
              const fullName = [item.first_name, item.last_name].filter(Boolean).join(' ').trim();

              return (
                <View className="mb-3 flex-row items-center rounded-xl bg-gray-100 p-3 dark:bg-neutral-900">
                  <UserAvatar
                    initial={item.first_name?.[0] ?? 'U'}
                    uri={item.avatar_url}
                    size={42}
                  />

                  <View className="ml-3 flex-1">
                    <Text className="font-semibold text-gray-900 dark:text-white">
                      {fullName || 'Unknown user'}
                    </Text>
                    <Text className="mt-1 text-xs text-gray-500 dark:text-gray-400">Friend</Text>
                  </View>
                </View>
              );
            }}
            showsVerticalScrollIndicator={false}
          />
        </>
      ) : (
        <View className="flex-1 items-center justify-center px-6">
          <Ionicons name="people-outline" size={32} color="#9ca3af" />
          <Text className="mt-4 text-lg font-semibold text-gray-900 dark:text-white">
            No friends yet
          </Text>
          <Text className="mt-2 text-center text-sm leading-6 text-gray-600 dark:text-gray-400">
            Start building your circle on ThingsAbove by adding your first friend.
          </Text>

          <TouchableOpacity
            className="mt-6 rounded-full bg-black px-6 py-4 dark:bg-white"
            onPress={onAddFriend}>
            <Text className="font-semibold text-white dark:text-black">Add Friend</Text>
          </TouchableOpacity>
        </View>
      )}
    </View>
  );
}
