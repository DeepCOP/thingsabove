import { Text, View } from 'react-native';
import PlanCoverImage from '../PlanCoverImage';

type Props = {
  title: string;
  coverImage?: string;
  selectedDay: number | null;
  completions?: number;
};

export function PlanHeader({ title, coverImage, selectedDay, completions }: Props) {
  return (
    <>
      <View>
        <PlanCoverImage uri={coverImage} className="w-full h-60 rounded-2xl" />

        {(completions ?? 0) > 0 && (
          <View className="absolute bottom-0 left-0 right-0 bg-black/50 py-2 rounded-b-2xl">
            <Text className="text-center text-white font-semibold">
              Over {completions} completions
            </Text>
          </View>
        )}
      </View>

      <View className="px-4 pt-4">
        <Text className="text-2xl font-bold dark:text-white mb-4">Day {selectedDay}</Text>
      </View>
    </>
  );
}
