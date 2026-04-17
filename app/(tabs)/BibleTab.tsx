import BibleVersionsMenu from '@/src/components/BibleVersionsMenu';
import BibleReaderView from '@/src/screens/BibleReaderViewScreen';
import Ionicons from '@expo/vector-icons/Ionicons';
import BottomSheet from '@gorhom/bottom-sheet';
import { Tabs } from 'expo-router';
import { useRef } from 'react';
import { ActivityIndicator, Animated, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useBible } from '../../src/state/BibleContext';

export default function BibleTab() {
  const insets = useSafeAreaInsets();
  const headerY = useRef(new Animated.Value(0)).current; // 0 shown, -80 hidden
  const tabY = useRef(new Animated.Value(0)).current; // 0 shown, 80 hidden
  const TAB_BAR_HEIGHT = 56;
  const hideDistance = Math.abs(TAB_BAR_HEIGHT);
  const versionsSheetRef = useRef<BottomSheet>(null);

  const { loadingVersionId, version } = useBible();

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
        toValue: -80 - insets.top,
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
    return (
      <Animated.View
        style={{
          transform: [{ translateY: headerTranslateY }],
          height: 90,
          paddingTop: insets.top,
          justifyContent: 'center',
          paddingHorizontal: 16,
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          zIndex: 10,
        }}
        className={'dark:bg-black bg-white'}>
        <View className="flex-row items-center mr-2 flex-1 justify-end ">
          {/* Version Switch */}
          <TouchableOpacity
            onPress={() => versionsSheetRef.current?.expand()}
            disabled={Boolean(loadingVersionId)}
            style={{ opacity: loadingVersionId ? 0.7 : 1 }}
            className="flex-row items-center bg-blue-100 px-3 py-1.5 rounded-full mr-1">
            <Ionicons name="globe-outline" size={16} />
            {loadingVersionId ? (
              <ActivityIndicator size="small" className="ml-2" />
            ) : (
              <Text className="ml-2 font-semibold">{version}</Text>
            )}
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
      <BibleVersionsMenu ref={versionsSheetRef} />
    </>
  );
}
