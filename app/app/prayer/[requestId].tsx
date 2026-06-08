import PrayerRequestDetailScreen from '@/src/screens/PrayerRequestDetailScreen';
import { Stack, useLocalSearchParams } from 'expo-router';

export default function PrayerRequestDetailRoute() {
  const { requestId } = useLocalSearchParams<{ requestId: string }>();
  const normalizedRequestId = Array.isArray(requestId) ? requestId[0] : requestId;

  return (
    <>
      <Stack.Screen options={{ title: 'Prayer Request' }} />
      <PrayerRequestDetailScreen requestId={normalizedRequestId} />
    </>
  );
}
