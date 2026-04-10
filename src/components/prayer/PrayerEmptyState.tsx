import { Ionicons } from '@expo/vector-icons';
import { Text, TouchableOpacity, View } from 'react-native';

type Props = {
  icon?: keyof typeof Ionicons.glyphMap;
  title: string;
  description: string;
  ctaLabel?: string;
  onCta?: () => void;
};

export default function PrayerEmptyState({
  icon = 'heart-outline',
  title,
  description,
  ctaLabel,
  onCta,
}: Props) {
  return (
    <View className="items-center rounded-3xl border border-gray-200 bg-white px-5 py-8 dark:border-neutral-800 dark:bg-neutral-950">
      <View className="h-14 w-14 items-center justify-center rounded-2xl bg-blue-50 dark:bg-blue-950/40">
        <Ionicons name={icon} size={26} color="#2563eb" />
      </View>

      <Text className="mt-4 text-center text-lg font-semibold text-gray-900 dark:text-white">
        {title}
      </Text>

      <Text className="mt-2 text-center text-sm leading-6 text-gray-600 dark:text-gray-400">
        {description}
      </Text>

      {ctaLabel && onCta ? (
        <TouchableOpacity
          className="mt-5 rounded-full bg-black px-5 py-3 dark:bg-white"
          onPress={onCta}>
          <Text className="font-semibold text-white dark:text-black">{ctaLabel}</Text>
        </TouchableOpacity>
      ) : null}
    </View>
  );
}
