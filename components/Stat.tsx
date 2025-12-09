/* -------------------- SMALL ICON COUNTER --------------------- */

import { Ionicons } from '@expo/vector-icons';
import { Text, useColorScheme, View } from 'react-native';

export default function Stat({
  icon,
  count,
}: {
  icon: keyof typeof Ionicons.glyphMap;
  count: number;
}) {
  const colorScheme = useColorScheme();

  return (
    <View className="flex-row items-center gap-1">
      <Ionicons name={icon} size={14} color={colorScheme === 'dark' ? '#fff' : '#222'} />
      <Text className="text-gray-600 dark:text-gray-200 text-sm">{count}</Text>
    </View>
  );
}
