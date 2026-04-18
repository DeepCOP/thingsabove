import LoadingSpinner from '@/src/components/LoadingSpinner';
import UserAvatar from '@/src/components/UserAvatar';
import { Text, TouchableOpacity, View } from 'react-native';

type Mode = 'requester' | 'receiver' | 'friends';

type Props = {
  id: string;
  first_name: string;
  last_name: string;
  avatar_url?: string | null;

  mode: Mode;

  statusText?: string; // "Pending", "Not friends", etc.

  onAdd?: (id: string) => void;
  onAccept?: (id: string) => void;
  onDecline?: (id: string) => void;
  onPressProfile?: (id: string) => void;

  isAdding?: boolean;
  isAccepting?: boolean;
  isDeclining?: boolean;
};

export default function FriendRequestCard({
  id,
  first_name,
  last_name,
  avatar_url,
  mode,
  statusText,
  onAdd,
  onAccept,
  onDecline,
  onPressProfile,
  isAdding,
  isAccepting,
  isDeclining,
}: Props) {
  return (
    <View className="flex-row items-center p-3 mb-3 rounded-xl bg-gray-100 dark:bg-neutral-900">
      <TouchableOpacity
        className="flex-1 flex-row items-center"
        disabled={!onPressProfile}
        onPress={() => onPressProfile?.(id)}>
        <UserAvatar uri={avatar_url} first_name={first_name} last_name={last_name} size={34} />

        <View className="flex-1 ml-3">
          <Text className="font-semibold dark:text-white">
            {first_name} {last_name}
          </Text>
          <Text className="text-xs text-gray-500">
            {mode === 'receiver' ? 'Sent you a friend request' : statusText}
          </Text>
        </View>
      </TouchableOpacity>

      {/* REQUESTER */}
      {mode === 'requester' && onAdd && (
        <TouchableOpacity
          onPress={() => onAdd(id)}
          className="bg-black dark:bg-white px-4 py-2 rounded-full"
          disabled={isAdding}>
          {isAdding ? (
            <LoadingSpinner size="small" />
          ) : (
            <Text className="text-white dark:text-black font-semibold">Add</Text>
          )}
        </TouchableOpacity>
      )}

      {/* RECEIVER */}
      {mode === 'receiver' && (
        <View className="flex-row gap-2">
          <TouchableOpacity
            onPress={() => onDecline?.(id)}
            disabled={isDeclining}
            className="px-3 py-2 rounded-full bg-gray-300 dark:bg-neutral-700">
            {isDeclining ? (
              <LoadingSpinner size="small" />
            ) : (
              <Text className="text-black dark:text-white text-sm">Decline</Text>
            )}
          </TouchableOpacity>

          <TouchableOpacity
            onPress={() => onAccept?.(id)}
            disabled={isAccepting}
            className="px-4 py-2 rounded-full bg-black dark:bg-white">
            {isAccepting ? (
              <LoadingSpinner size="small" />
            ) : (
              <Text className="text-white dark:text-black text-sm font-semibold">Accept</Text>
            )}
          </TouchableOpacity>
        </View>
      )}
    </View>
  );
}
