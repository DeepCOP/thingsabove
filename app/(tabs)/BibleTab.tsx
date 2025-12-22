import BibleReaderView from '@/components/BibleReaderView';
import { Ionicons } from '@expo/vector-icons';
import { Tabs, useRouter } from 'expo-router';
import { useRef } from 'react';
import { Animated, Text, TouchableOpacity, useColorScheme, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useBible } from '../../context/BibleContext';

export default function BibleTab() {
  const insets = useSafeAreaInsets();
  const headerY = useRef(new Animated.Value(0)).current; // 0 shown, -80 hidden
  const tabY = useRef(new Animated.Value(0)).current; // 0 shown, 80 hidden
  const TAB_BAR_HEIGHT = 56;
  const hideDistance = Math.abs(TAB_BAR_HEIGHT);

  const router = useRouter();

  const { version, setVersion } = useBible();

  const lastScrollY = useRef(0);

  const onScroll = (e: any) => {
    const y = e.nativeEvent.contentOffset.y;
    const last = lastScrollY.current;
    if (Math.abs(y - last) < 2) return;

    // TOP → always show
    if (y <= 0) {
      Animated.timing(headerY, {
        toValue: 0,
        duration: 150,
        useNativeDriver: true,
      }).start();

      Animated.timing(tabY, {
        toValue: 0,
        duration: 150,
        useNativeDriver: true,
      }).start();
    }
    // SCROLLING DOWN → hide immediately
    else if (y > last) {
      Animated.timing(headerY, {
        toValue: -80,
        duration: 150,
        useNativeDriver: true,
      }).start();

      Animated.timing(tabY, {
        toValue: hideDistance,
        duration: 150,
        useNativeDriver: true,
      }).start();
    }
    // SCROLLING UP → show
    else if (y < last) {
      Animated.timing(headerY, {
        toValue: 0,
        duration: 150,
        useNativeDriver: true,
      }).start();

      Animated.timing(tabY, {
        toValue: 0,
        duration: 150,
        useNativeDriver: true,
      }).start();
    }

    lastScrollY.current = y;
  };

  const AnimatedHeader = ({
    headerTranslateY,
  }: {
    headerTranslateY: Animated.AnimatedInterpolation<string | number>;
  }) => {
    const colorScheme = useColorScheme();

    return (
      <Animated.View
        style={{
          transform: [{ translateY: headerTranslateY }],
          height: 90,
          justifyContent: 'center',
          paddingHorizontal: 16,
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          zIndex: 10,
        }}
        className={'dark:bg-black bg-white'}>
        <View className="flex-row items-center mr-2 flex-1 justify-end mt-4">
          {/* Search */}
          <TouchableOpacity onPress={() => router.push('../search')} className="mr-4 ">
            <Ionicons
              name="search-outline"
              size={22}
              color={colorScheme === 'dark' ? 'white' : 'black'}
            />
          </TouchableOpacity>

          {/* Version Switch */}
          <TouchableOpacity
            onPress={() => setVersion(version === 'KJV' ? 'ASV' : 'KJV')}
            className="flex-row items-center bg-blue-100 px-3 py-1.5 rounded-full mr-1">
            <Ionicons name="globe-outline" size={16} />
            <Text className="ml-2 font-semibold">{version}</Text>
          </TouchableOpacity>
        </View>
      </Animated.View>
    );
  };

  return (
    <>
      {/* TOP NAV BAR */}
      <Tabs.Screen
        options={{
          headerStyle: {
            transform: [{ translateY: headerY }],
          },
          tabBarStyle: {
            transform: [{ translateY: tabY }],
            position: 'absolute',
            elevation: 0,
            height: TAB_BAR_HEIGHT + insets.bottom,
          },
          title: 'bible',

          headerTitleAlign: 'center',
          headerShadowVisible: false,
        }}
      />
      <AnimatedHeader headerTranslateY={headerY} />

      <BibleReaderView onScroll={onScroll} headerTranslateY={tabY} />
    </>
  );
}
