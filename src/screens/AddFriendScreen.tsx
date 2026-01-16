import LoadingSpinner from '@/src/components/LoadingSpinner';
import { Image, Text, TextInput, TouchableOpacity, View } from 'react-native';

type UserResult = {
  id: string;
  first_name: string;
  last_name: string;
  avatar_url?: string | null;
  friendship_status: string | null;
};

type Props = {
  email: string;
  onEmailChange: (value: string) => void;
  isEmailValid: boolean;
  user?: UserResult | null;
  isSearching: boolean;
  isAdding: boolean;
  onAddFriend: (friendId: string) => void;
};

export default function AddFriendScreen({
  email,
  onEmailChange,
  isEmailValid,
  user,
  isSearching,
  isAdding,
  onAddFriend,
}: Props) {
  return (
    <View className="flex-1 bg-white dark:bg-black px-4 pt-6">
      <Text className="text-xl font-bold dark:text-white mb-3">Add Friend</Text>

      {/* Email input */}
      <TextInput
        value={email}
        onChangeText={onEmailChange}
        placeholder="Enter email address"
        keyboardType="email-address"
        autoCapitalize="none"
        className="px-4 py-3 rounded-xl bg-gray-100 dark:bg-neutral-900 dark:text-white"
      />

      {/* Validation */}
      {email.length > 3 && !isEmailValid && (
        <Text className="text-red-500 text-xs mt-2">Enter a valid email address</Text>
      )}

      {/* Loading */}
      {isSearching && <LoadingSpinner size="small" />}

      {/* User result */}
      {user && (
        <View className="mt-4 flex-row items-center p-3 rounded-xl bg-gray-100 dark:bg-neutral-900">
          {user.avatar_url ? (
            <Image source={{ uri: user.avatar_url }} className="w-10 h-10 rounded-full mr-3" />
          ) : (
            <View className="w-10 h-10 rounded-full bg-gray-400 mr-3 items-center justify-center">
              <Text className="text-white font-bold">{user.first_name[0]}</Text>
            </View>
          )}

          <View className="flex-1">
            <Text className="font-semibold dark:text-white">
              {user.first_name} {user.last_name}
            </Text>
            <Text className="text-xs text-gray-500">{user.friendship_status ?? 'Not friends'}</Text>
          </View>

          {user.friendship_status === null && (
            <TouchableOpacity
              onPress={() => onAddFriend(user.id)}
              className="bg-black dark:bg-white px-4 py-2 rounded-full">
              {isAdding ? (
                <LoadingSpinner size="small" />
              ) : (
                <Text className="text-white dark:text-black font-semibold">Add</Text>
              )}
            </TouchableOpacity>
          )}
        </View>
      )}

      {/* No result */}
      {isEmailValid && !isSearching && !user && (
        <Text className="mt-4 text-gray-500 text-sm">No user found</Text>
      )}
    </View>
  );
}
