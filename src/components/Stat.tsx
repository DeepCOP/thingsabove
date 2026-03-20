/* -------------------- SMALL ICON COUNTER --------------------- */

import { Ionicons } from '@expo/vector-icons';
import { Text, useColorScheme, View } from 'react-native';

export default function Stat({
  icon,
  count,
  iconColor,
}: {
  icon: keyof typeof Ionicons.glyphMap;
  count: number | string;
  label?: string;
  iconColor?: string;
}) {
  const colorScheme = useColorScheme();
  const resolvedIconColor = iconColor ?? (colorScheme === 'dark' ? '#fff' : '#222');

  return (
    <View className="flex-row items-center gap-1">
      <Ionicons name={icon} size={14} color={resolvedIconColor} />
      <Text className="text-gray-600 dark:text-gray-200 text-sm">{count}</Text>
    </View>
  );
}
