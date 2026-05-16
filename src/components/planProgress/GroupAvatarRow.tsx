import type { PlanGroupMember, PlanProgress } from '@/src/types/types';
import { Text, TouchableOpacity, View } from 'react-native';

import { useMemo } from 'react';
import UserAvatar from '../UserAvatar';

type Props = {
  members: PlanGroupMember[];
  progresses?: PlanProgress[];
  completedDay: number;
  onPress: () => void;
};

export function GroupAvatarsRow({ members, progresses, completedDay, onPress }: Props) {
  const max = 6;
  const size = 32;
  const overlap = 10;
  const completedUsers = useMemo(() => {
    return new Set(
      progresses?.filter((p) => p.completed_days?.includes(completedDay)).map((p) => p.user_id),
    );
  }, [progresses, completedDay]);

  return (
    <View className="mt-4 flex-row items-center px-4">
      {members.slice(0, max).map((m, i) => {
        return (
          <TouchableOpacity
            key={m.id}
            onPress={onPress}
            style={{ marginLeft: i === 0 ? 0 : -overlap, zIndex: 100 - i }}>
            <View
              style={{
                padding: 2,
                borderRadius: (size + 8) / 2,
                borderWidth: 2,
                borderColor: completedUsers.has(m.user_id) ? '#86efac' : 'transparent',
              }}>
              <UserAvatar
                uri={m.profiles?.avatar_url}
                first_name={m.profiles?.first_name}
                last_name={m.profiles?.last_name}
                size={size}
              />
            </View>
          </TouchableOpacity>
        );
      })}

      {members.length > max && (
        <View className="ml-2 px-2 py-1 rounded-full bg-gray-200 dark:bg-gray-800">
          <Text className="text-xs dark:text-white">+{members.length - max}</Text>
        </View>
      )}
    </View>
  );
}
