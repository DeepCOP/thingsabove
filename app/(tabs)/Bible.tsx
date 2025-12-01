import VersesScreen from '@/components/BibleScreen';
import { Ionicons } from '@expo/vector-icons';
import { Tabs, useRouter } from 'expo-router';
import { useRef } from 'react';
import { Animated, Text, TouchableOpacity, useColorScheme, View } from 'react-native';
import { useBible } from '../../context/BibleContext';

export default function BibleVersesScreen() {
  const headerY = useRef(new Animated.Value(0)).current; // 0 shown, -80 hidden
  const tabY = useRef(new Animated.Value(0)).current; // 0 shown, 80 hidden

  const router = useRouter();
  const { version, setVersion } = useBible();

  let last = 0;

  const onScroll = (e: any) => {
    const y = e.nativeEvent.contentOffset.y;

    if (y < 0.5) {
      Animated.timing(headerY, {
        toValue: 0,
        duration: 180,
        useNativeDriver: true,
      }).start();

      Animated.timing(tabY, {
        toValue: 0,
        duration: 180,
        useNativeDriver: true,
      }).start();
    } else if (y > last) {
      // scrolling DOWN → animate HIDE
      Animated.timing(headerY, {
        toValue: -80,
        duration: 180,
        useNativeDriver: true,
      }).start();

      Animated.timing(tabY, {
        toValue: 80,
        duration: 180,
        useNativeDriver: true,
      }).start();
    } else if (y < last) {
      Animated.timing(headerY, {
        toValue: 0,
        duration: 180,
        useNativeDriver: true,
      }).start();

      Animated.timing(tabY, {
        toValue: 0,
        duration: 180,
        useNativeDriver: true,
      }).start();
    }

    last = y;
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
            height: 80,
          },
          title: '',

          headerTitleAlign: 'center',
          headerShadowVisible: false,
        }}
      />
      <AnimatedHeader headerTranslateY={headerY} />

      <VersesScreen onScroll={onScroll} headerTranslateY={tabY} />
    </>
  );
}
