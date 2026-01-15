import { Image, Text, View } from 'react-native';

type Props = {
  title: string;
  coverImage?: string;
  selectedDay: number | null;
};

export function PlanHeader({ title, coverImage, selectedDay }: Props) {
  return (
    <>
      <View className="px-4">
        <Image
          source={{ uri: coverImage }}
          className="w-full h-60 rounded-2xl"
          resizeMode="cover"
        />
      </View>

      <View className="px-4 pt-4">
        <Text className="text-2xl font-bold dark:text-white mb-4">Day {selectedDay}</Text>
      </View>
    </>
  );
}
