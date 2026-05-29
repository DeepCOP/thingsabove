import { ScrollView, Text, TouchableOpacity, View } from 'react-native';

type Props = {
  tags: string[];
  selectedTags: string[];
  isLoading?: boolean;
  onToggleTag: (tag: string) => void;
  onClear: () => void;
};

export default function PlanTagFilterChips({
  tags,
  selectedTags,
  isLoading = false,
  onToggleTag,
  onClear,
}: Props) {
  if (!isLoading && tags.length === 0) return null;

  const hasSelectedTags = selectedTags.length > 0;

  return (
    <View className="mb-3">
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={{ paddingRight: 16 }}>
        <TouchableOpacity
          onPress={onClear}
          className={`mr-2 h-9 flex-row items-center rounded-full px-4 ${
            hasSelectedTags ? 'bg-gray-200 dark:bg-neutral-800' : 'bg-black dark:bg-white'
          }`}>
          <Text
            className={`text-sm font-semibold ${
              hasSelectedTags ? 'text-gray-700 dark:text-gray-200' : 'text-white dark:text-black'
            }`}>
            All
          </Text>
        </TouchableOpacity>

        {isLoading
          ? [1, 2, 3].map((item) => (
              <View
                key={item}
                className="mr-2 h-9 w-24 rounded-full bg-gray-200 dark:bg-neutral-800"
              />
            ))
          : tags.map((tag) => {
              const isSelected = selectedTags.includes(tag);

              return (
                <TouchableOpacity
                  key={tag}
                  onPress={() => onToggleTag(tag)}
                  className={`mr-2 h-9 flex-row items-center rounded-full px-4 ${
                    isSelected
                      ? 'bg-emerald-600 dark:bg-emerald-400'
                      : 'bg-white dark:bg-neutral-900'
                  }`}>
                  <Text
                    numberOfLines={1}
                    className={`text-sm font-semibold ${
                      isSelected
                        ? 'text-white dark:text-emerald-950'
                        : 'text-gray-700 dark:text-gray-200'
                    }`}>
                    {tag}
                  </Text>
                </TouchableOpacity>
              );
            })}
      </ScrollView>
    </View>
  );
}
