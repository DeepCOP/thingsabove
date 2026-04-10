import PrayerBoardScreen from '@/src/screens/PrayerBoardScreen';
import { Stack } from 'expo-router';

export default function PrayerBoardRoute() {
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
