import { useTranslation } from 'react-i18next';
import { Text, TouchableOpacity, View } from 'react-native';

type Props = {
  day: number;
  totalDays: number;
  missedCount?: number;
  onMissedDays: () => void;
};

export function PlanMetaRow({ day, totalDays, missedCount, onMissedDays }: Props) {
  const { t } = useTranslation('plans');
  return (
    <View className="flex-row justify-between items-center mb-2 px-4">
      <Text className="text-xl font-bold dark:text-white">
        {t('dayOfTotal', { day, total: totalDays })}
      </Text>

      {missedCount ? (
        <TouchableOpacity
          className="px-3 py-1 border rounded-full border-green-500"
          onPress={onMissedDays}>
          <Text className="text-green-600 text-xs">{t('missedDays', { count: missedCount })}</Text>
        </TouchableOpacity>
      ) : (
        <View className="px-3 py-1 border rounded-full border-green-500">
          <Text className="text-green-600 text-xs">{t('onTrack')}</Text>
        </View>
      )}
    </View>
  );
}
