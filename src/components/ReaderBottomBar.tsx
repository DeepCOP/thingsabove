import Ionicons from '@expo/vector-icons/Ionicons';
import type { ComponentProps } from 'react';
import { Animated, Text, TouchableOpacity, View } from 'react-native';

type ReaderBottomBarSideAction = {
  icon: ComponentProps<typeof Ionicons>['name'];
  onPress?: () => void;
  disabled?: boolean;
  variant?: 'default' | 'complete';
};

type ReaderBottomBarCenterAction = {
  label: string;
  onPress?: () => void;
  disabled?: boolean;
  muted?: boolean;
};

type ReaderBottomBarProps = {
  translateY?: Animated.AnimatedInterpolation<string | number> | number;
  bottom?: number;
  paddingBottom?: number;
  barPaddingHorizontal?: number;
  leftAction: ReaderBottomBarSideAction;
  centerAction: ReaderBottomBarCenterAction;
  rightAction: ReaderBottomBarSideAction;
};

export default function ReaderBottomBar({
  translateY = 0,
  bottom = 0,
  paddingBottom = 0,
  leftAction,
  centerAction,
  rightAction,
}: ReaderBottomBarProps) {
  const renderSideAction = (action: ReaderBottomBarSideAction, side: 'left' | 'right') => {
    const disabled = action.disabled || !action.onPress;
    const isComplete = action.variant === 'complete';
    const className = isComplete
      ? ` py-2 px-4   border border-white rounded-full items-center justify-center`
      : `py-2 px-4  border border-white rounded-full  items-center justify-center`;

    return (
      <TouchableOpacity
        className={className}
        disabled={disabled}
        style={{ opacity: disabled ? 0.35 : 1 }}
        onPress={action.onPress}>
        <Ionicons name={action.icon} size={20} color="white" />
      </TouchableOpacity>
    );
  };

  const centerDisabled = centerAction.disabled || !centerAction.onPress;

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
      <View className="flex-row bg-black py-3 px-3 rounded-full items-center justify-between gap-6">
        {renderSideAction(leftAction, 'left')}
        <TouchableOpacity
          className="py-2 px-2 border border-white rounded-full items-center justify-center"
          disabled={centerDisabled}
          onPress={centerAction.onPress}>
          <Text
            className={`mx-4 font-semibold ${
              centerAction.muted || centerAction.disabled ? 'text-white/70' : 'text-white'
            }`}>
            {centerAction.label}
          </Text>
        </TouchableOpacity>
        {renderSideAction(rightAction, 'right')}
      </View>
    </Animated.View>
  );
}
