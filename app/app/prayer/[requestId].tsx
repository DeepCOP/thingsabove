import { useTranslation } from 'react-i18next';
import PrayerRequestDetailScreen from '@/src/screens/PrayerRequestDetailScreen';
import { Stack, useLocalSearchParams } from 'expo-router';

export default function PrayerRequestDetailRoute() {
  const { t } = useTranslation('community');
  const { requestId } = useLocalSearchParams<{ requestId: string }>();
  const normalizedRequestId = Array.isArray(requestId) ? requestId[0] : requestId;

  return (
    <>
      <Stack.Screen options={{ title: t('prayerRequest') }} />
      <PrayerRequestDetailScreen requestId={normalizedRequestId} />
    </>
  );
}
