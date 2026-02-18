import LoadingSpinner from '@/src/components/LoadingSpinner';
import { Text, TextInput, View } from 'react-native';
import FriendRequestCard from '../components/FriendRequestCard';
import { useAuth } from '../state/AuthContext';

type UserResult = {
  id: string;
  first_name: string;
  last_name: string;
  avatar_url?: string | null;
  friendship_status: string | null;
  receiver_id: string | null;
  requester_id: string | null;
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
  const { session, loading: sessionLoading } = useAuth();
  const currentUserId = session?.user?.id;

  if (sessionLoading) {
    return (
      <View className="flex-1 items-center justify-center">
        <LoadingSpinner />
      </View>
    );
  }
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
        <FriendRequestCard
          id={user.id}
          first_name={user.first_name}
          last_name={user.last_name}
          avatar_url={user.avatar_url}
          mode={
            !user.friendship_status
              ? 'requester'
              : user.friendship_status === 'pending' && user.receiver_id === currentUserId
                ? 'receiver'
                : 'friends'
          }
          statusText={
            user.friendship_status === 'accepted'
              ? 'Friends'
              : user.friendship_status === 'pending'
                ? 'Pending'
                : 'Not friends'
          }
          onAdd={onAddFriend}
          isAdding={isAdding}
        />
      )}

      {/* No result */}
      {isEmailValid && !isSearching && !user && (
        <Text className="mt-4 text-gray-500 text-sm">No user found</Text>
      )}
    </View>
  );
}
