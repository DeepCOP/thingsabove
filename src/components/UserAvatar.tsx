import { Image, Text, View } from 'react-native';
import { getAvatarInitials } from '../utils';

type Props = {
  uri?: string | null;
  first_name?: string | null;
  last_name?: string | null;
  size?: number;
  border?: boolean;
};


export default function UserAvatar({
  uri,
  first_name,
  last_name,
  size = 96,
  border = true,
}: Props) {
  const borderSize = border ? 2 : 0;
  const fallbackInitials = getAvatarInitials(first_name, last_name);
  const fallbackFontSize = size * (fallbackInitials.length > 1 ? 0.28 : 0.35);

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
        <Text style={{ fontSize: fallbackFontSize }} className="font-bold text-gray-200">
          {fallbackInitials}
        </Text>
      )}
    </View>
  );
}
