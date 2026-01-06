import { Image, Text, TouchableOpacity, View } from 'react-native';

type Props = {
  members: any[];
  onPress: () => void;
};

export function GroupAvatarsRow({ members, onPress }: Props) {
  const max = 6;
  const size = 32;
  const overlap = 10;

  return (
    <View className="mt-4 flex-row items-center px-4">
      {members.slice(0, max).map((m, i) => (
        <TouchableOpacity
          key={m.id}
          onPress={onPress}
          style={{ marginLeft: i === 0 ? 0 : -overlap, zIndex: 100 - i }}>
          {m.profiles.avatar_url ? (
            <Image
              source={{ uri: m.profiles.avatar_url }}
              style={{
                width: size,
                height: size,
                borderRadius: size / 2,
                borderWidth: 2,
                borderColor: 'white',
              }}
            />
          ) : (
            <View
              style={{
                width: size,
                height: size,
                borderRadius: size / 2,
                backgroundColor: '#9CA3AF',
                borderWidth: 2,
                borderColor: 'white',
              }}
            />
          )}
        </TouchableOpacity>
      ))}

      {members.length > max && (
        <View className="ml-2 px-2 py-1 rounded-full bg-gray-200 dark:bg-gray-800">
          <Text className="text-xs dark:text-white">+{members.length - max}</Text>
        </View>
      )}
    </View>
  );
}
