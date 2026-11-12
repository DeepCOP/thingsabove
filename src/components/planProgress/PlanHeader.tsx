import { useTranslation } from 'react-i18next';
import { Text, View, useWindowDimensions } from 'react-native';
import PlanCoverImage from '../PlanCoverImage';
import PlanVisibilityBadge from '../PlanVisibilityBadge';

type Props = {
  coverImage?: string;
  selectedDay: number | null;
  completions?: number;
  visibility?: string | null;
};

export function PlanHeader({ coverImage, selectedDay, completions, visibility }: Props) {
  const { t } = useTranslation('plans');
  const { height: windowHeight } = useWindowDimensions();
  return (
    <>
      <View>
        <PlanCoverImage
          uri={coverImage}
          className="w-full rounded-2xl bg-gray-100 dark:bg-neutral-800"
          fitToWidth
          maxHeight={windowHeight / 2}
        />

        {(completions ?? 0) > 0 && (
          <View className="bg-black/50 py-2 rounded-b-2xl">
            <Text className="text-center text-white font-semibold">
              {t('completions', { count: completions ?? 0 })}
            </Text>
          </View>
        )}
      </View>

      <View className="px-4 pt-4">
        <View className="mb-4 flex-row items-center gap-2">
          <Text className="text-2xl font-bold dark:text-white">
            {t('dayNumber', { day: selectedDay ?? 1 })}
          </Text>
          <PlanVisibilityBadge visibility={visibility} />
        </View>
      </View>
    </>
  );
}
