import React from 'react';
import { ActivityIndicator, StyleProp, View, ViewStyle } from 'react-native';

const LoadingSpinner = ({
  size = 'large',
  style,
  ViewStyles,
}: {
  size?: number | 'small' | 'large' | undefined;
  style?: StyleProp<ViewStyle>;
  ViewStyles?: StyleProp<ViewStyle>;
}) => {
  return (
    <View style={ViewStyles} className="flex-1 justify-center items-center">
      <ActivityIndicator size={size} style={style} />
    </View>
  );
};

export default LoadingSpinner;
