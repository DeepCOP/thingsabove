import Ionicons from '@expo/vector-icons/Ionicons';
import { useRef, useState } from 'react';
import {
  NativeScrollEvent,
  NativeSyntheticEvent,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';

type Tab = {
  key: string;
  label: string;
};

type Props = {
  activeTab: string;
  onChange: (
    key: 'my-plans' | 'private-plans' | 'saved-plans' | 'completed-plans' | 'find-plans',
  ) => void;
};

const tabs: Tab[] = [
  { key: 'private-plans', label: 'Private' },
  { key: 'find-plans', label: 'Find Plans' },
  { key: 'my-plans', label: 'My Plans' },
  { key: 'saved-plans', label: 'Saved' },
  { key: 'completed-plans', label: 'Completed' },
];

export function MyPlansToggle({ activeTab, onChange }: Props) {
  const scrollViewRef = useRef<ScrollView | null>(null);
  const [containerWidth, setContainerWidth] = useState(0);
  const [contentWidth, setContentWidth] = useState(0);
  const [scrollX, setScrollX] = useState(0);
  const hasOverflow = contentWidth > containerWidth + 8;
  const canScrollLeft = hasOverflow && scrollX > 8;
  const canScrollRight = hasOverflow && scrollX < contentWidth - containerWidth - 8;

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
      className="mb-4 rounded-full bg-neutral-900 p-1"
      onLayout={(event) => setContainerWidth(event.nativeEvent.layout.width)}>
      <ScrollView
        ref={scrollViewRef}
        horizontal
        showsHorizontalScrollIndicator={false}
        onContentSizeChange={(width) => setContentWidth(width)}
        onScroll={handleScroll}
        scrollEventThrottle={16}>
        <View className="flex-row items-center gap-1">
          {tabs.map((tab) => {
            const isActive = activeTab === tab.key;

            return (
              <TouchableOpacity
                key={tab.key}
                onPress={() =>
                  onChange(
                    tab.key as
                      | 'my-plans'
                      | 'private-plans'
                      | 'saved-plans'
                      | 'completed-plans'
                      | 'find-plans',
                  )
                }
                className={`h-10 w-[108px] rounded-full items-center justify-center px-4 ${
                  isActive ? 'bg-white' : ''
                }`}>
                <Text
                  numberOfLines={1}
                  className={`text-center font-semibold text-sm ${
                    isActive ? 'text-black' : 'text-gray-400'
                  }`}>
                  {tab.label}
                </Text>
              </TouchableOpacity>
            );
          })}
        </View>
      </ScrollView>
      {canScrollLeft && (
        <TouchableOpacity
          accessibilityRole="button"
          accessibilityLabel="Scroll tabs to the start"
          onPress={handleScrollToStart}
          className="absolute left-2 rounded-full bg-white/10 p-1"
          style={{ top: '50%', transform: [{ translateY: -12 }] }}>
          <Ionicons name="chevron-back" size={16} color="#FFFFFF" />
        </TouchableOpacity>
      )}
      {canScrollRight && (
        <TouchableOpacity
          accessibilityRole="button"
          accessibilityLabel="Scroll tabs to the end"
          onPress={handleScrollToEnd}
          className="absolute right-2 rounded-full bg-white/10 p-1"
          style={{ top: '50%', transform: [{ translateY: -12 }] }}>
          <Ionicons name="chevron-forward" size={16} color="#FFFFFF" />
        </TouchableOpacity>
      )}
    </View>
  );
}
