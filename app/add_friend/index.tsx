import LoadingSpinner from '@/components/LoadingSpinner';
import { useAuth } from '@/context/AuthContext';
import { useAddFriend, useGetUserByEmail } from '@/hooks/useFriends';
import { isValidEmail, useDebounce } from '@/utils/utils';
import { useState } from 'react';
import { Image, Text, TextInput, TouchableOpacity, View } from 'react-native';

export default function AddFriendScreen() {
  const { session } = useAuth();
  const userId = session?.user?.id!;

  const [email, setEmail] = useState('');
  const debouncedEmail = useDebounce(email.trim(), 500);

  const isEmailValid = isValidEmail(debouncedEmail.trim());

  const userQuery = useGetUserByEmail({
    query: isEmailValid ? debouncedEmail : '',
    userId,
  });

  const addFriend = useAddFriend();

  return (
    <View className="flex-1 bg-white dark:bg-black px-4 pt-6">
      <Text className="text-xl font-bold dark:text-white mb-3">Add Friend</Text>

      {/* Email Input */}
      <TextInput
        value={email}
        onChangeText={setEmail}
        placeholder="Enter email address"
        keyboardType="email-address"
        autoCapitalize="none"
        className="px-4 py-3 rounded-xl bg-gray-100 dark:bg-neutral-900 dark:text-white"
      />

      {/* Validation feedback */}
      {email.length > 3 && !isEmailValid && (
        <Text className="text-red-500 text-xs mt-2">Enter a valid email address</Text>
      )}

      {/* Loading */}
      {userQuery.isLoading && <LoadingSpinner size={'small'} />}

      {/* Result */}
      {userQuery.data && (
        <View className="mt-4 flex-row items-center p-3 rounded-xl bg-gray-100 dark:bg-neutral-900">
          {userQuery.data.avatar_url ? (
            <Image
              source={{ uri: userQuery.data.avatar_url }}
              className="w-10 h-10 rounded-full mr-3"
            />
          ) : (
            <View className="w-10 h-10 rounded-full bg-gray-400 mr-3 items-center justify-center">
              <Text className="text-white font-bold">{userQuery.data.first_name[0]}</Text>
            </View>
          )}

          <View className="flex-1">
            <Text className="font-semibold dark:text-white">
              {userQuery.data.first_name} {userQuery.data.last_name}
            </Text>
            <Text className="text-xs text-gray-500">
              {userQuery.data.friendship_status ?? 'Not friends'}
            </Text>
          </View>

          {userQuery.data.friendship_status === null && (
            <TouchableOpacity
              onPress={() =>
                addFriend.mutate({
                  friendId: userQuery.data.id,
                  userId,
                })
              }
              className="bg-black dark:bg-white px-4 py-2 rounded-full">
              {addFriend.isPending ? (
                <LoadingSpinner size={'small'} />
              ) : (
                <Text className="text-white dark:text-black font-semibold">Add</Text>
              )}
            </TouchableOpacity>
          )}
        </View>
      )}

      {/* No result */}
      {isEmailValid && !userQuery.isLoading && !userQuery.data && (
        <Text className="mt-4 text-gray-500 text-sm">No user found</Text>
      )}
    </View>
  );
}
