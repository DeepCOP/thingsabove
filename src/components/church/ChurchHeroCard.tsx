import { Church } from '@/src/types/types';
import { Text, TouchableOpacity, View } from 'react-native';

type Props = {
  church: Church;
  memberCount?: number;
  onOpenWebsite?: () => void;
};

export default function ChurchHeroCard({ church, memberCount, onOpenWebsite }: Props) {
  return (
    <View className="rounded-3xl border border-gray-200 bg-white p-5 dark:border-neutral-800 dark:bg-neutral-950">
      <View className="flex-row items-start justify-between gap-3">
        <View className="flex-1">
          <Text className="text-2xl font-bold text-gray-900 dark:text-white">{church.name}</Text>
          {church.address ? (
            <Text className="mt-2 text-sm text-gray-600 dark:text-gray-400">{church.address}</Text>
          ) : null}
          {church.website_url ? (
            <TouchableOpacity className="mt-2" onPress={onOpenWebsite}>
              <Text className="text-sm text-blue-600 dark:text-blue-400">{church.website_url}</Text>
            </TouchableOpacity>
          ) : null}
        </View>

        {typeof memberCount === 'number' ? (
          <View className="rounded-full bg-blue-50 px-3 py-1 dark:bg-blue-950/40">
            <Text className="text-xs font-semibold text-blue-700 dark:text-blue-300">
              {memberCount} members
            </Text>
          </View>
        ) : null}
      </View>
    </View>
  );
}
