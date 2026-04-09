import { ChurchStats } from '@/src/types/types';
import { Text, View } from 'react-native';

type Props = {
  stats: ChurchStats;
};

export default function ChurchStatGrid({ stats }: Props) {
  const cards = [
    { label: 'Members', value: String(stats.memberCount) },
    { label: 'Active Plans', value: String(stats.activePlansCount) },
    { label: 'Completed', value: String(stats.completedPlansCount) },
    { label: 'Top Plan', value: stats.topPlan?.title ?? 'N/A' },
  ];

  return (
    <View className="flex-row flex-wrap gap-3">
      {cards.map((card) => (
        <View key={card.label} className="w-[48%] rounded-2xl bg-gray-50 p-4 dark:bg-neutral-900">
          <Text className="text-xs uppercase text-gray-500 dark:text-gray-400">{card.label}</Text>
          <Text className="mt-2 text-2xl font-bold text-gray-900 dark:text-white">
            {card.value}
          </Text>
        </View>
      ))}
    </View>
  );
}
