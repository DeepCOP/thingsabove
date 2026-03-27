import { ChurchStats } from '@/src/types/types';
import { Text, View } from 'react-native';

type Props = {
  stats: ChurchStats;
};

export default function ChurchRecentActivityCard({ stats }: Props) {
  return (
    <View className="rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
      <Text className="text-lg font-semibold text-gray-900 dark:text-white">Recent Activity</Text>
      <View className="mt-3 gap-3">
        <View className="rounded-2xl bg-gray-50 p-4 dark:bg-neutral-900">
          <Text className="text-sm text-gray-700 dark:text-gray-300">
            {stats.activeMembersThisWeek} members were active in the last 7 days
          </Text>
        </View>
        <View className="rounded-2xl bg-gray-50 p-4 dark:bg-neutral-900">
          <Text className="text-sm text-gray-700 dark:text-gray-300">
            {stats.joinedThisMonth} members joined this month
          </Text>
        </View>
      </View>
    </View>
  );
}
