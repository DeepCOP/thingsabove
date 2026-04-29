import LoadingSpinner from '@/src/components/LoadingSpinner';
import { Ionicons } from '@expo/vector-icons';
import { Text, TextInput, TouchableOpacity, View } from 'react-native';
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
  onShareInviteLink: () => void;
};

export default function AddFriendScreen({
  email,
  onEmailChange,
  isEmailValid,
  user,
  isSearching,
  isAdding,
  onAddFriend,
  onShareInviteLink,
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

      <View className="mt-6 rounded-2xl border border-gray-200 bg-gray-50 p-4 dark:border-neutral-800 dark:bg-neutral-950">
        <Text className="text-base font-semibold text-gray-900 dark:text-white">
          Invite someone new
        </Text>
        <Text className="mt-1 text-sm leading-6 text-gray-600 dark:text-gray-400">
          Share a link so a friend can join ThingsAbove and connect with you.
        </Text>

        <TouchableOpacity
          onPress={onShareInviteLink}
          className="mt-4 flex-row items-center justify-center rounded-full border border-blue-600 bg-blue-50/70 px-4 py-3 dark:border-blue-400 dark:bg-blue-950/30">
          <Ionicons name="share-social-outline" size={18} color="#2563eb" />
          <Text className="ml-2 font-semibold text-blue-600 dark:text-blue-400">
            Share Invite Link
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}
