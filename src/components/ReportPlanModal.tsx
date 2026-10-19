import { useTranslation } from 'react-i18next';
import BottomSheet, {
  BottomSheetBackdrop,
  BottomSheetTextInput,
  BottomSheetView,
} from '@gorhom/bottom-sheet';
import { forwardRef, useMemo, useState } from 'react';
import { Text, TouchableOpacity, useColorScheme } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useReportPlan } from '../hooks/usePlanReactions';

type Props = {
  planId: string;
};

const REPORT_REASONS = [
  { value: 'Inappropriate content', label: 'reportInappropriate' },
  { value: 'Spam or misleading', label: 'reportSpam' },
  { value: 'Hate or abusive content', label: 'reportHate' },
  { value: 'Copyright issue', label: 'reportCopyright' },
  { value: 'Other', label: 'reportOther' },
];

const ReportPlanSheet = forwardRef<BottomSheet, Props>(({ planId }, ref) => {
  const { t } = useTranslation('plans');
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
      bottomInset={insets.bottom + 5}
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
        <Text className="text-lg font-bold mb-3 dark:text-white">{t('reportPlan')}</Text>

        {REPORT_REASONS.map((r) => (
          <TouchableOpacity
            key={r.value}
            className={`py-3 px-3 rounded-lg mb-2 ${
              reason === r.value ? 'bg-red-100 dark:bg-red-900' : 'bg-gray-100 dark:bg-neutral-800'
            }`}
            onPress={() => {
              if (reason === r.value) {
                setReason('');
              } else {
                setReason(r.value);
              }
            }}>
            <Text className="dark:text-white">{t(r.label)}</Text>
          </TouchableOpacity>
        ))}

        {reason === 'Other' && (
          <BottomSheetTextInput
            placeholder={t('describeIssue')}
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
          <Text className="text-center text-white font-semibold">{t('submitReport')}</Text>
        </TouchableOpacity>
      </BottomSheetView>
    </BottomSheet>
  );
});

ReportPlanSheet.displayName = 'ReportPlanSheet';
export default ReportPlanSheet;
