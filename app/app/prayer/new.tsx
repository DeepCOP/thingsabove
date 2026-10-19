import { useTranslation } from 'react-i18next';
import PrayerRequestComposerScreen from '@/src/screens/PrayerRequestComposerScreen';
import { Stack, useLocalSearchParams } from 'expo-router';

export default function PrayerComposerRoute() {
  const { t } = useTranslation('community');
  const { requestId } = useLocalSearchParams<{ requestId?: string }>();
  const normalizedRequestId = Array.isArray(requestId) ? requestId[0] : requestId;

  return (
    <>
      <Stack.Screen
        options={{ title: normalizedRequestId ? t('editPrayerRequest') : t('newPrayerRequest') }}
      />
      <PrayerRequestComposerScreen requestId={normalizedRequestId} />
    </>
  );
}
