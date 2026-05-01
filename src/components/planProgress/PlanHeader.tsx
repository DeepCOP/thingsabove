import Ionicons from '@expo/vector-icons/Ionicons';
import { Text, View } from 'react-native';
import PlanCoverImage from '../PlanCoverImage';

type Props = {
  coverImage?: string;
  selectedDay: number | null;
  completions?: number;
  visibility?: string | null;
};

export function PlanHeader({ coverImage, selectedDay, completions, visibility }: Props) {
  return (
    <>
      <View>
        <PlanCoverImage uri={coverImage} className="w-full h-60 rounded-2xl" />

        {(completions ?? 0) > 0 && (
          <View className="absolute bottom-0 left-0 right-0 bg-black/50 py-2 rounded-b-2xl">
            <Text className="text-center text-white font-semibold">{completions} completions</Text>
          </View>
        )}
      </View>

      <View className="px-4 pt-4">
        <View className="mb-4 flex-row items-center gap-2">
          <Text className="text-2xl font-bold dark:text-white">Day {selectedDay}</Text>
          {visibility === 'private' && (
            <View className="flex-row items-center gap-1 rounded-full bg-amber-100 px-2 py-1 dark:bg-amber-900/40">
              <Ionicons name="lock-closed" size={12} color="#b45309" />
              <Text className="text-[10px] font-semibold uppercase tracking-wide text-amber-700 dark:text-amber-200">
                Private
              </Text>
            </View>
          )}
        </View>
      </View>
    </>
  );
}
