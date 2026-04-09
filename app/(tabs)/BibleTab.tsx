import BibleVersionsMenu from '@/src/components/BibleVersionsMenu';
import BibleReaderView from '@/src/screens/BibleReaderViewScreen';
import Ionicons from '@expo/vector-icons/Ionicons';
import { Tabs, useRouter } from 'expo-router';
import { useMemo, useRef, useState } from 'react';
import {
  Animated,
  Text,
  TouchableOpacity,
  useColorScheme,
  useWindowDimensions,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useBible } from '../../src/state/BibleContext';

export default function BibleTab() {
  const insets = useSafeAreaInsets();
  const { width: screenWidth, height: screenHeight } = useWindowDimensions();
  const headerY = useRef(new Animated.Value(0)).current; // 0 shown, -80 hidden
  const tabY = useRef(new Animated.Value(0)).current; // 0 shown, 80 hidden
  const TAB_BAR_HEIGHT = 56;
  const hideDistance = Math.abs(TAB_BAR_HEIGHT);
  const versionButtonRef = useRef<View | null>(null);
  const [showVersionsMenu, setShowVersionsMenu] = useState(false);
  const [versionMenuAnchor, setVersionMenuAnchor] = useState({
    x: 0,
    y: 0,
    width: 0,
    height: 0,
  });

  const router = useRouter();

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

  const openVersionsMenu = () => {
    versionButtonRef.current?.measureInWindow((x, y, width, height) => {
      setVersionMenuAnchor({ x, y, width, height });
      setShowVersionsMenu(true);
    });
  };

  const versionMenuStyle = useMemo(() => {
    const menuWidth = Math.min(340, screenWidth - 24);
    const rightAlignedLeft = versionMenuAnchor.x + versionMenuAnchor.width - menuWidth;
    const left = Math.min(Math.max(12, rightAlignedLeft), screenWidth - menuWidth - 12);
    const top = versionMenuAnchor.y + versionMenuAnchor.height + 8;
    const maxHeight = Math.max(220, screenHeight - top - insets.bottom - 16);

    return {
      top,
      left,
      width: menuWidth,
      maxHeight,
    };
  }, [insets.bottom, screenHeight, screenWidth, versionMenuAnchor]);

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
          <View ref={versionButtonRef} collapsable={false}>
            <TouchableOpacity
              onPress={openVersionsMenu}
              className="flex-row items-center bg-blue-100 px-3 py-1.5 rounded-full mr-1">
              <Ionicons name="globe-outline" size={16} />
              <Text className="ml-2 font-semibold">
                {loadingVersionId ? `${version}...` : version}
              </Text>
            </TouchableOpacity>
          </View>
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
      <BibleVersionsMenu
        visible={showVersionsMenu}
        menuStyle={versionMenuStyle}
        onClose={() => setShowVersionsMenu(false)}
      />
    </>
  );
}
