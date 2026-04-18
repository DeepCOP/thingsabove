import UserAvatar from '@/src/components/UserAvatar';
import { ChurchMemberPreview } from '@/src/types/types';
import { Text, TouchableOpacity, View } from 'react-native';

type Props = {
  members: ChurchMemberPreview[];
  onSeeAll?: () => void;
  onMemberPress?: (userId: string) => void;
};

export default function ChurchMembersPreview({ members, onSeeAll, onMemberPress }: Props) {
  return (
    <View className="rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
      <View className="flex-row items-center justify-between">
        <Text className="text-lg font-semibold text-gray-900 dark:text-white">Members</Text>
        {onSeeAll ? (
          <TouchableOpacity onPress={onSeeAll}>
            <Text className="text-sm font-medium text-blue-600 dark:text-blue-400">See all</Text>
          </TouchableOpacity>
        ) : null}
      </View>

      {members.length === 0 ? (
        <Text className="mt-3 text-sm text-gray-500 dark:text-gray-400">
          No members found for this church yet.
        </Text>
      ) : (
        <View className="mt-4 flex-row flex-wrap gap-4">
          {members.map((member) => (
            <TouchableOpacity
              key={member.id}
              className="items-center"
              disabled={!onMemberPress}
              onPress={() => onMemberPress?.(member.id)}>
              <UserAvatar
                uri={member.avatar_url}
                first_name={member.first_name}
                last_name={member.last_name}
                size={56}
                border={false}
              />
              <Text className="mt-2 text-xs text-gray-600 dark:text-gray-400">
                {member.first_name ?? 'Member'}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      )}
    </View>
  );
}
