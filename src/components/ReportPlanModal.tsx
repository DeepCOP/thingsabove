import BottomSheet, { BottomSheetBackdrop, BottomSheetView } from '@gorhom/bottom-sheet';
import { forwardRef, useMemo, useState } from 'react';
import { Text, TextInput, TouchableOpacity, useColorScheme, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useReportPlan } from '../hooks/usePlanReactions';

type Props = {
  planId: string;
};

const REPORT_REASONS = [
  'Inappropriate content',
  'Spam or misleading',
  'Hate or abusive content',
  'Copyright issue',
  'Other',
];

const ReportPlanSheet = forwardRef<BottomSheet, Props>(({ planId }, ref) => {
  const snapPoints = useMemo(() => ['50%'], []);
  const [reason, setReason] = useState('');
  const [customReason, setCustomReason] = useState('');
  const reportPlan = useReportPlan(planId);
  const colorScheme = useColorScheme();
  const insets = useSafeAreaInsets();
  const isValid = reason && (reason !== 'Other' || customReason.trim().length > 5);

  return (
    <BottomSheet
      ref={ref}
      snapPoints={snapPoints}
      index={-1}
      enablePanDownToClose
      keyboardBehavior="interactive"
      backgroundStyle={{ backgroundColor: colorScheme === 'dark' ? '#171717' : '#fff' }}
      keyboardBlurBehavior="restore"
      backdropComponent={(props) => (
        <BottomSheetBackdrop
          {...props}
          opacity={0.7}
          pressBehavior="close"
          disappearsOnIndex={-1}
          appearsOnIndex={0}
        />
      )}>
      <BottomSheetView className="px-4 py-3">
        <View style={{ marginBottom: insets.bottom }}>
          <Text className="text-lg font-bold mb-3 dark:text-white">Report this plan</Text>

          {REPORT_REASONS.map((r) => (
            <TouchableOpacity
              key={r}
              className={`py-3 px-3 rounded-lg mb-2 ${
                reason === r ? 'bg-red-100 dark:bg-red-900' : 'bg-gray-100 dark:bg-neutral-800'
              }`}
              onPress={() => {
                if (reason === r) {
                  setReason('');
                } else {
                  setReason(r);
                }
              }}>
              <Text className="dark:text-white">{r}</Text>
            </TouchableOpacity>
          ))}

          {reason === 'Other' && (
            <TextInput
              placeholder="Describe the issue"
              placeholderTextColor="#888"
              className="border rounded-lg p-3 mt-2 dark:text-white dark:border-neutral-700"
              multiline
              onChangeText={setCustomReason}
              value={customReason}
              numberOfLines={4}
              maxLength={200}
              autoFocus={true}
            />
          )}

          <TouchableOpacity
            className={`mt-4 bg-red-600 py-4 rounded-full ${isValid ? '' : 'opacity-50'}`}
            disabled={reportPlan.isPending || !isValid}
            onPress={() => {
              const finalReason = reason === 'Other' ? customReason.trim() : reason;
              if (!finalReason) return;
              reportPlan.mutate(finalReason, {
                onSuccess: () => {
                  setReason('');
                  setCustomReason('');
                  if (ref && typeof ref !== 'function') {
                    ref?.current?.close();
                  }
                },
              });
            }}>
            <Text className="text-center text-white font-semibold">Submit Report</Text>
          </TouchableOpacity>
        </View>
      </BottomSheetView>
    </BottomSheet>
  );
});

ReportPlanSheet.displayName = 'ReportPlanSheet';
export default ReportPlanSheet;
