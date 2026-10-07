import { useTranslation } from 'react-i18next';
import { PrayerFilter } from '@/src/types/types';
import { Text, TouchableOpacity, View } from 'react-native';

type Props = {
  filter: PrayerFilter;
  onChange: (filter: PrayerFilter) => void;
};

export default function PrayerFilterChips({ filter, onChange }: Props) {
  const { t } = useTranslation('community');
  const FILTERS: { label: string; value: PrayerFilter }[] = [
    { label: t('all'), value: 'all' },
    { label: t('mine'), value: 'mine' },
    { label: t('urgent'), value: 'urgent' },
    { label: t('answered'), value: 'answered' },
  ];

  return (
    <View className="flex-row flex-wrap gap-2">
      {FILTERS.map((item) => {
        const active = filter === item.value;

        return (
          <TouchableOpacity
            key={item.value}
            className={`rounded-full px-4 py-2 ${
              active ? 'bg-black dark:bg-white' : 'bg-gray-100 dark:bg-neutral-900'
            }`}
            onPress={() => onChange(item.value)}>
            <Text
              className={`text-sm font-medium ${
                active ? 'text-white dark:text-black' : 'text-gray-700 dark:text-gray-300'
              }`}>
              {item.label}
            </Text>
          </TouchableOpacity>
        );
      })}
    </View>
  );
}
