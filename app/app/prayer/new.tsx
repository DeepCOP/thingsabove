import PrayerRequestComposerScreen from '@/src/screens/PrayerRequestComposerScreen';
import { Stack, useLocalSearchParams } from 'expo-router';

export default function PrayerComposerRoute() {
  const { requestId } = useLocalSearchParams<{ requestId?: string }>();
  const normalizedRequestId = Array.isArray(requestId) ? requestId[0] : requestId;

  return (
    <>
      <Stack.Screen
        options={{ title: normalizedRequestId ? 'Edit Prayer Request' : 'New Prayer Request' }}
      />
      <PrayerRequestComposerScreen requestId={normalizedRequestId} />
    </>
  );
}
