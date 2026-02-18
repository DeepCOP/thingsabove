import BottomSheet, { BottomSheetBackdrop, BottomSheetView } from '@gorhom/bottom-sheet';
import { forwardRef } from 'react';
import PlanCoverImage from '@/src/components/PlanCoverImage';
import { Text, TouchableOpacity, View, useColorScheme } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type Props = {
  plan: any;
  onStartPress: (mode: 'solo' | 'group') => void;
};

const StartPlanBottomSheet = forwardRef<BottomSheet, Props>(({ plan, onStartPress }, ref) => {
  const colorScheme = useColorScheme();
  const insets = useSafeAreaInsets();

  return (
    <BottomSheet
      ref={ref}
      index={-1}
      snapPoints={['50%']}
      enablePanDownToClose
      backgroundStyle={{
        backgroundColor: colorScheme === 'dark' ? '#171717' : '#fff',
      }}
      backdropComponent={(props) => (
        <BottomSheetBackdrop
          {...props}
          opacity={0.7}
          pressBehavior="close"
          disappearsOnIndex={-1}
          appearsOnIndex={0}
        />
      )}>
      <BottomSheetView
        className="flex-1 px-4 pt-4 items-center justify-center"
        style={{ paddingBottom: insets.bottom + 16 }}>
        <PlanCoverImage uri={plan.cover_image} className="w-28 h-28 rounded-2xl mb-3" />

        <Text className="text-2xl text-center font-bold dark:text-white mb-4">
          How do you want to read?
        </Text>

        <View className="gap-3 w-full px-4">
          <TouchableOpacity
            onPress={() => onStartPress('solo')}
            className="py-4 rounded-full bg-gray-300 dark:bg-neutral-600 items-center">
            <Text className="text-lg font-bold dark:text-white">By Yourself</Text>
          </TouchableOpacity>

          <TouchableOpacity
            onPress={() => onStartPress('group')}
            className="py-4 rounded-full bg-gray-300 dark:bg-neutral-600 items-center">
            <Text className="text-lg font-bold dark:text-white">With Friends</Text>
          </TouchableOpacity>
        </View>
      </BottomSheetView>
    </BottomSheet>
  );
});

StartPlanBottomSheet.displayName = 'StartPlanBottomSheet';

export default StartPlanBottomSheet;
