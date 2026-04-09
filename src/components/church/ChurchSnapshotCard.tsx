import { ChurchStats } from '@/src/types/types';
import { Text, View } from 'react-native';

type Props = {
  stats: ChurchStats;
};

export default function ChurchSnapshotCard({ stats }: Props) {
  return (
    <View className="rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
      <Text className="text-lg font-semibold text-gray-900 dark:text-white">Church Snapshot</Text>
      <Text className="mt-2 text-sm leading-6 text-gray-600 dark:text-gray-400">
        {stats.activeMembersThisWeek} members were active this week across {stats.activePlansCount}{' '}
        plans. {stats.joinedThisMonth} members joined this month.
      </Text>
    </View>
  );
}
