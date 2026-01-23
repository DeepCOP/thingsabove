import { Image, Text, View } from 'react-native';

type Props = {
  uri?: string | null;
  initial: string;
  size?: number;
  border?: boolean;
};

export default function UserAvatar({ uri, initial, size = 96, border = true }: Props) {
  const borderSize = border ? 2 : 0;

  return (
    <View
      style={{
        width: size,
        height: size,
        borderRadius: size / 2,
        borderWidth: borderSize,
      }}
      className="items-center bg-gray-800 justify-center border-white border dark:border-white">
      {uri ? (
        <Image source={{ uri }} style={{ width: size, height: size, borderRadius: size / 2 }} />
      ) : (
        <Text style={{ fontSize: size * 0.35 }} className="font-bold text-gray-200">
          {initial}
        </Text>
      )}
    </View>
  );
}
