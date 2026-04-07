import PrayerBoardScreen from '@/src/screens/PrayerBoardScreen';
import { Stack, useRouter } from 'expo-router';

export default function PrayerBoardRoute() {
  const router = useRouter();

  return (
    <>
      <Stack.Screen
        options={{
          title: 'Prayer Board',
        }}
      />
      <PrayerBoardScreen />
    </>
  );
}
