import { ReactNode } from 'react';
import { Animated, View } from 'react-native';

type ReaderBottomBarProps = {
  translateY?: Animated.AnimatedInterpolation<string | number> | number;
  bottom?: number;
  paddingBottom?: number;
  barPaddingHorizontal?: number;
  left: ReactNode;
  center: ReactNode;
  right: ReactNode;
};

export default function ReaderBottomBar({
  translateY = 0,
  bottom = 0,
  paddingBottom = 0,
  barPaddingHorizontal = 24,
  left,
  center,
  right,
}: ReaderBottomBarProps) {
  return (
    <Animated.View
      className="items-center pb-4 bg-transparent"
      style={{
        transform: [{ translateY }],
        position: 'absolute',
        bottom,
        left: 0,
        right: 0,
        paddingBottom,
        zIndex: 10,
      }}>
      <View
        className="flex-row bg-black py-3 rounded-full items-center"
        style={{ paddingHorizontal: barPaddingHorizontal }}>
        {left}
        {center}
        {right}
      </View>
    </Animated.View>
  );
}
