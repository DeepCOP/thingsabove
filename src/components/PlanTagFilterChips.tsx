import Ionicons from '@expo/vector-icons/Ionicons';
import { useRef, useState } from 'react';
import {
  NativeScrollEvent,
  NativeSyntheticEvent,
  ScrollView,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';

type Props = {
  tags: string[];
  selectedTags: string[];
  isLoading?: boolean;
  containerClassName?: string;
  onToggleTag: (tag: string) => void;
  onClear: () => void;
};

export default function PlanTagFilterChips({
  tags,
  selectedTags,
  isLoading = false,
  containerClassName = 'mb-3',
  onToggleTag,
  onClear,
}: Props) {
  const colorScheme = useColorScheme();
  const scrollViewRef = useRef<ScrollView | null>(null);
  const [containerWidth, setContainerWidth] = useState(0);
  const [contentWidth, setContentWidth] = useState(0);
  const [scrollX, setScrollX] = useState(0);

  if (!isLoading && tags.length === 0) return null;

  const hasSelectedTags = selectedTags.length > 0;
  const hasOverflow = contentWidth > containerWidth + 8;
  const canScrollLeft = hasOverflow && scrollX > 8;
  const canScrollRight = hasOverflow && scrollX < contentWidth - containerWidth - 8;
  const chevronColor = colorScheme === 'dark' ? '#FFFFFF' : '#111827';

  const handleScroll = (event: NativeSyntheticEvent<NativeScrollEvent>) => {
    setScrollX(event.nativeEvent.contentOffset.x);
  };

  const handleScrollToStart = () => {
    scrollViewRef.current?.scrollTo({ x: 0, animated: true });
  };

  const handleScrollToEnd = () => {
    scrollViewRef.current?.scrollTo({
      x: Math.max(contentWidth - containerWidth, 0),
      animated: true,
    });
  };

  return (
    <View
      className={`${containerClassName} rounded-full bg-gray-800 p-1 `}
      onLayout={(event) => setContainerWidth(event.nativeEvent.layout.width)}>
      <ScrollView
        ref={scrollViewRef}
        horizontal
        showsHorizontalScrollIndicator={false}
        onContentSizeChange={(width) => setContentWidth(width)}
        onScroll={handleScroll}
        scrollEventThrottle={16}
        contentContainerStyle={{ paddingRight: 32 }}>
        <TouchableOpacity
          onPress={onClear}
          className={`mr-2 h-9 flex-row items-center rounded-full px-4 ${
            hasSelectedTags
              ? 'bg-gray-200 dark:bg-neutral-800'
              : 'bg-emerald-600 dark:bg-emerald-400'
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
      {canScrollLeft && (
        <TouchableOpacity
          accessibilityRole="button"
          accessibilityLabel="Scroll tags to the start"
          onPress={handleScrollToStart}
          className="absolute left-0 rounded-full bg-black/10 p-1 dark:bg-white/10"
          style={{ top: '50%', transform: [{ translateY: -12 }] }}>
          <Ionicons name="chevron-back" size={16} color={chevronColor} />
        </TouchableOpacity>
      )}
      {canScrollRight && (
        <TouchableOpacity
          accessibilityRole="button"
          accessibilityLabel="Scroll tags to the end"
          onPress={handleScrollToEnd}
          className="absolute right-0 rounded-full bg-black/10 p-1 dark:bg-white/10"
          style={{ top: '50%', transform: [{ translateY: -12 }] }}>
          <Ionicons name="chevron-forward" size={16} color={chevronColor} />
        </TouchableOpacity>
      )}
    </View>
  );
}
