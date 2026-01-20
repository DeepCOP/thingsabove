import { Text, TouchableOpacity, View } from 'react-native';
import UserAvatar from '../UserAvatar';

type Props = {
  members: any[];
  onPress: () => void;
};

export function GroupAvatarsRow({ members, onPress }: Props) {
  const max = 6;
  const size = 32;
  const overlap = 10;

  return (
    <View className="mt-4 flex-row items-center px-4">
      {members.slice(0, max).map((m, i) => (
        <TouchableOpacity
          key={m.id}
          onPress={onPress}
          style={{ marginLeft: i === 0 ? 0 : -overlap, zIndex: 100 - i }}>
          <UserAvatar
            uri={m.profiles.avatar_url}
            initial={m.profiles.first_name?.[0] ?? 'U'}
            size={size}
          />
        </TouchableOpacity>
      ))}

      {members.length > max && (
        <View className="ml-2 px-2 py-1 rounded-full bg-gray-200 dark:bg-gray-800">
          <Text className="text-xs dark:text-white">+{members.length - max}</Text>
        </View>
      )}
    </View>
  );
}
