import { useTranslation } from 'react-i18next';
import { ChurchStats } from '@/src/types/types';
import { Text, View } from 'react-native';

type Props = {
  stats: ChurchStats;
};

export default function ChurchRecentActivityCard({ stats }: Props) {
  const { t } = useTranslation('community');
  return (
    <View className="rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
      <Text className="text-lg font-semibold text-gray-900 dark:text-white">
        {t('recentActivity')}
      </Text>
      <View className="mt-3 gap-3">
        <View className="rounded-2xl bg-gray-50 p-4 dark:bg-neutral-900">
          <Text className="text-sm text-gray-700 dark:text-gray-300">
            {t('recentActiveMembers', { count: stats.activeMembersThisWeek })}
          </Text>
        </View>
        <View className="rounded-2xl bg-gray-50 p-4 dark:bg-neutral-900">
          <Text className="text-sm text-gray-700 dark:text-gray-300">
            {t('recentJoinedMembers', { count: stats.joinedThisMonth })}
          </Text>
        </View>
      </View>
    </View>
  );
}
