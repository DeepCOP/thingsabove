import { Ionicons } from '@expo/vector-icons';
import { Text, TouchableOpacity, useColorScheme, View } from 'react-native';

type Props = {
  items: any[];
  devotional?: any;
  onPressItem: (item: any) => void;
  onToggle: (item: any) => void;
};

export function DayItemsList({ items, devotional, onPressItem, onToggle }: Props) {
  const colorScheme = useColorScheme();
  return (
    <View className="mt-4 space-y-6 px-4">
      {items.map((item) => (
        <TouchableOpacity
          key={item.id}
          className="flex-row items-center justify-between"
          onPress={() => onPressItem(item)}>
          <View className="flex-row items-center gap-3">
            <TouchableOpacity
              onPress={() => onToggle(item)}
              className={`rounded-full p-1 border mr-3 ${
                item?.completed ? 'bg-black dark:bg-white' : 'border-gray-500'
              }`}>
              <Ionicons
                name="checkmark"
                size={12}
                color={colorScheme === 'dark' ? 'black' : 'white'}
              />
            </TouchableOpacity>
            <Text className="text-lg dark:text-white">
              {item?.item_type === 'devotional' ? 'Devotional' : item?.item_key || 'Scripture'}
            </Text>
          </View>
          <Ionicons
            name="chevron-forward"
            size={22}
            color={colorScheme === 'dark' ? '#fff' : '#000'}
          />
        </TouchableOpacity>
      ))}
    </View>
  );
}
