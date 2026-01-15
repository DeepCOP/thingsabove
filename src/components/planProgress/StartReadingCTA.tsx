import { Animated, Text, TouchableOpacity } from 'react-native';

type Props = {
  bottomInset: number;
  visible: boolean;
  onPress: () => void;
};

export function StartReadingCTA({ bottomInset, visible, onPress }: Props) {
  if (!visible) return null;

  return (
    <Animated.View
      style={{
        position: 'absolute',
        bottom: 0,
        left: 0,
        right: 0,
        paddingBottom: bottomInset,
        alignItems: 'center',
      }}>
      <TouchableOpacity
        className="bg-black dark:bg-white min-w-[80%] py-4 rounded-full mb-5"
        onPress={onPress}>
        <Text className="text-white dark:text-black font-semibold text-lg text-center">
          Start Reading
        </Text>
      </TouchableOpacity>
    </Animated.View>
  );
}
