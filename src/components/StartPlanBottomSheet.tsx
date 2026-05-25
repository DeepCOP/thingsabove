import BottomSheet, { BottomSheetBackdrop, BottomSheetView } from '@gorhom/bottom-sheet';
import { forwardRef, useState } from 'react';
import PlanCoverImage from '@/src/components/PlanCoverImage';
import { ActivityIndicator, Text, TouchableOpacity, View, useColorScheme } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type Props = {
  plan: any;
  hasActiveSoloPlanProgress?: boolean;
  isStartingSoloPlan?: boolean;
  onStartPress: (mode: 'solo' | 'group') => void;
  onContinuePress?: () => void;
};

const StartPlanBottomSheet = forwardRef<BottomSheet, Props>(
  (
    {
      plan,
      hasActiveSoloPlanProgress = false,
      isStartingSoloPlan = false,
      onStartPress,
      onContinuePress,
    },
    ref,
  ) => {
    const colorScheme = useColorScheme();
    const insets = useSafeAreaInsets();
    const [showSoloOptions, setShowSoloOptions] = useState(false);
    const isShowingSoloOptions = hasActiveSoloPlanProgress && showSoloOptions;
    const soloSpinnerColor = colorScheme === 'dark' ? '#ffffff' : '#111827';

    return (
      <BottomSheet
        ref={ref}
        index={-1}
        snapPoints={['50%']}
        enablePanDownToClose
        onChange={(index) => {
          if (index < 0) {
            setShowSoloOptions(false);
          }
        }}
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
            {isShowingSoloOptions ? 'You already have a solo plan' : 'How do you want to read?'}
          </Text>

          <View className="gap-3 w-full px-4">
            {isShowingSoloOptions ? (
              <>
                {onContinuePress && (
                  <TouchableOpacity
                    onPress={onContinuePress}
                    disabled={isStartingSoloPlan}
                    className="py-4 rounded-full bg-black dark:bg-white items-center">
                    <Text className="text-lg font-bold text-white dark:text-black">
                      Continue Current Plan
                    </Text>
                  </TouchableOpacity>
                )}

                <TouchableOpacity
                  onPress={() => onStartPress('solo')}
                  disabled={isStartingSoloPlan}
                  className="py-4 rounded-full bg-gray-300 dark:bg-neutral-600 items-center">
                  {isStartingSoloPlan ? (
                    <ActivityIndicator size="small" color={soloSpinnerColor} />
                  ) : (
                    <Text className="text-lg font-bold dark:text-white">Start New Solo Plan</Text>
                  )}
                </TouchableOpacity>

                <TouchableOpacity
                  onPress={() => setShowSoloOptions(false)}
                  disabled={isStartingSoloPlan}
                  className="py-4 rounded-full border border-gray-300 dark:border-neutral-600 items-center">
                  <Text className="text-lg font-semibold text-gray-800 dark:text-gray-200">
                    Back
                  </Text>
                </TouchableOpacity>
              </>
            ) : (
              <>
                <TouchableOpacity
                  onPress={() => {
                    if (hasActiveSoloPlanProgress) {
                      setShowSoloOptions(true);
                      return;
                    }

                    onStartPress('solo');
                  }}
                  disabled={isStartingSoloPlan}
                  className="py-4 rounded-full bg-gray-300 dark:bg-neutral-600 items-center">
                  {isStartingSoloPlan ? (
                    <ActivityIndicator size="small" color={soloSpinnerColor} />
                  ) : (
                    <Text className="text-lg font-bold dark:text-white">By Yourself</Text>
                  )}
                </TouchableOpacity>

                <TouchableOpacity
                  onPress={() => onStartPress('group')}
                  disabled={isStartingSoloPlan}
                  className="py-4 rounded-full bg-gray-300 dark:bg-neutral-600 items-center">
                  <Text className="text-lg font-bold dark:text-white">With Friends</Text>
                </TouchableOpacity>
              </>
            )}
          </View>
        </BottomSheetView>
      </BottomSheet>
    );
  },
);

StartPlanBottomSheet.displayName = 'StartPlanBottomSheet';

export default StartPlanBottomSheet;
