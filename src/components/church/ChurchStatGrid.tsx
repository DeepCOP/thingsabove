import { useTranslation } from 'react-i18next';
import { ChurchStats } from '@/src/types/types';
import { Text, View } from 'react-native';

type Props = {
  stats: ChurchStats;
};

export default function ChurchStatGrid({ stats }: Props) {
  const { t } = useTranslation('community');
  const cards = [
    { label: t('members'), value: String(stats.memberCount) },
    { label: t('activePlans'), value: String(stats.activePlansCount) },
    { label: t('completed'), value: String(stats.completedPlansCount) },
    { label: t('topPlan'), value: stats.topPlan?.title ?? t('notAvailable') },
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
