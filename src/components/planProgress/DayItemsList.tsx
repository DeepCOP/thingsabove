import { DayItemsProgress } from '@/src/types/types';
import { Ionicons } from '@expo/vector-icons';
import { Text, TouchableOpacity, useColorScheme, View } from 'react-native';

type Props = {
  items: DayItemsProgress[];
  commentLabel?: string;
  onPressItem: (item: DayItemsProgress) => void;
  onToggle: (item: DayItemsProgress) => void;
  toggleLoading: boolean;
};

function getItemLabel(item: DayItemsProgress, commentLabel: string) {
  if (item.item_type === 'devotional') return 'Devotional';
  if (item.item_type === 'comment') return commentLabel;
  return item.item_key || 'Scripture';
}

export function DayItemsList({
  items,
  commentLabel = 'Reflect & Share',
  onPressItem,
  onToggle,
  toggleLoading,
}: Props) {
  const colorScheme = useColorScheme();
  return (
    <View className="mt-4 space-y-6 px-4">
      {items.map((item) => {
        return (
          <TouchableOpacity
            key={item.id}
            className="flex-row items-center justify-between mb-3"
            onPress={() => onPressItem(item)}>
            <View className="flex-row items-center gap-3">
              <TouchableOpacity
                disabled={toggleLoading}
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

              <Text className="text-lg dark:text-white">{getItemLabel(item, commentLabel)}</Text>
            </View>

            <Ionicons
              name="chevron-forward"
              size={22}
              color={colorScheme === 'dark' ? '#fff' : '#000'}
            />
          </TouchableOpacity>
        );
      })}
    </View>
  );
}
