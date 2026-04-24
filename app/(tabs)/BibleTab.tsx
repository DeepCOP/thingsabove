import BibleReaderView from '@/src/screens/BibleReaderViewScreen';
import Ionicons from '@expo/vector-icons/Ionicons';
import { useRouter } from 'expo-router';
import { useRef } from 'react';
import {
  ActivityIndicator,
  Animated,
  NativeScrollEvent,
  NativeSyntheticEvent,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useBible } from '../../src/state/BibleContext';

export default function BibleTab() {
  const router = useRouter();
  const insets = useSafeAreaInsets();
  const headerHeight = 90;
  const headerTranslateY = useRef(new Animated.Value(0)).current;
  const lastScrollY = useRef(0);
  const isHeaderHidden = useRef(false);

  const { loadingVersionId, version } = useBible();

  const animateHeader = (toValue: number) => {
    Animated.timing(headerTranslateY, {
      toValue,
      duration: 160,
      useNativeDriver: true,
    }).start();
  };

  const onScroll = (event: NativeSyntheticEvent<NativeScrollEvent>) => {
    const y = event.nativeEvent.contentOffset.y;
    const lastY = lastScrollY.current;

    if (y <= 0) {
      if (isHeaderHidden.current) {
        isHeaderHidden.current = false;
        animateHeader(0);
      }
      lastScrollY.current = 0;
      return;
    }

    if (Math.abs(y - lastY) < 2) return;

    if (y > lastY && !isHeaderHidden.current) {
      isHeaderHidden.current = true;
      animateHeader(-headerHeight);
    } else if (y < lastY && isHeaderHidden.current) {
      isHeaderHidden.current = false;
      animateHeader(0);
    }

    lastScrollY.current = y;
  };

  const AnimatedHeader = ({
    headerTranslateY: translateY,
  }: {
    headerTranslateY: Animated.Value;
  }) => {
    return (
      <Animated.View
        style={{
          transform: [{ translateY }],
          height: headerHeight,
          paddingTop: insets.top,
          justifyContent: 'center',
          paddingHorizontal: 16,
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          zIndex: 10,
        }}
        className="bg-white dark:bg-black">
        <View className="mr-2 flex-1 flex-row items-center justify-end">
          <TouchableOpacity
            onPress={() => router.push('/bible/versions')}
            disabled={Boolean(loadingVersionId)}
            style={{ opacity: loadingVersionId ? 0.7 : 1 }}
            className="mr-1 flex-row items-center rounded-full bg-blue-100 px-3 py-1.5">
            <Ionicons name="globe-outline" size={16} />
            {loadingVersionId ? (
              <ActivityIndicator size="small" className="ml-2" />
            ) : (
              <>
                <Text className="ml-2 font-semibold">{version}</Text>
                <Ionicons
                  name="chevron-forward"
                  size={14}
                  color="#1f2937"
                  style={{ marginLeft: 4 }}
                />
              </>
            )}
          </TouchableOpacity>
        </View>
      </Animated.View>
    );
  };

  return (
    <>
      <AnimatedHeader headerTranslateY={headerTranslateY} />
      <BibleReaderView onScroll={onScroll} />
    </>
  );
}
