import React, { useEffect, useRef } from 'react';
import { Animated, Image, Text, useColorScheme } from 'react-native';

const AnimatedImage = Animated.createAnimatedComponent(Image);
const AnimatedText = Animated.createAnimatedComponent(Text);

export function TabIcon({ focused, icon, title }: { focused: boolean; icon: any; title: string }) {
  const colorScheme = useColorScheme();

  const anim = useRef(new Animated.Value(focused ? 1 : 0)).current;

  // Animate on focus change
  useEffect(() => {
    Animated.spring(anim, {
      toValue: focused ? 1 : 0,
      useNativeDriver: true,
      speed: 12,
      bounciness: 6,
    }).start();
  }, [focused, anim]);

  // Interpolate tint color for the icon
  const tintColor = anim.interpolate({
    inputRange: [0, 1],
    outputRange: [colorScheme === 'dark' ? 'white' : 'black', '#1FB1F9FF'],
  });

  // Interpolate opacity for text
  const textOpacity = anim.interpolate({
    inputRange: [0, 1],
    outputRange: [0.6, 1],
  });

  // Animate scale to make selection feel smoother
  const scale = anim.interpolate({
    inputRange: [0, 1],
    outputRange: [1, 1.15],
  });

  return (
    <Animated.View
      style={{
        flex: 1,
        transform: [{ scale }],
        justifyContent: 'center',
        alignItems: 'center',
        paddingTop: 20,
        minWidth: 80,
        minHeight: 80,
      }}>
      <AnimatedImage
        className={'dark:text-gray-100'}
        source={icon}
        style={{ width: 24, height: 24, tintColor: tintColor }}
      />

      <AnimatedText
        style={{
          marginTop: 3,
          fontSize: 12,
          opacity: textOpacity,
          color: tintColor,
        }}
        className={'dark:text-gray-100'}>
        {title}
      </AnimatedText>
    </Animated.View>
  );
}

export default TabIcon;
