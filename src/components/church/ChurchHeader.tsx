import { Ionicons } from '@expo/vector-icons';
import { Text, TouchableOpacity, View, useColorScheme } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type ChurchHeaderProps = {
  title: string;
  onBackPress: () => void;
};

export default function ChurchHeader({ title, onBackPress }: ChurchHeaderProps) {
  const colorScheme = useColorScheme();
  const insets = useSafeAreaInsets();
  const isDark = colorScheme === 'dark';
  const backIconColor = isDark ? '#f9fafb' : '#111827';

  return (
    <View
      className="border-b border-gray-200 bg-white px-4 pb-3 dark:border-neutral-900 dark:bg-black"
      style={{ paddingTop: insets.top + 8 }}>
      <View className="relative flex-row items-center justify-center">
        <TouchableOpacity
          accessibilityLabel="Go back"
          accessibilityRole="button"
          className="absolute left-0 z-10 h-10 w-10 items-center justify-center rounded-full bg-gray-100 dark:bg-neutral-900"
          onPress={onBackPress}>
          <Ionicons name="chevron-back" size={22} color={backIconColor} />
        </TouchableOpacity>

        <View className="min-h-10 max-w-[70%] justify-center">
          <Text
            className="text-center text-lg font-semibold text-gray-900 dark:text-white"
            numberOfLines={1}>
            {title}
          </Text>
        </View>
      </View>
    </View>
  );
}
