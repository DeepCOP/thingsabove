import PrayerBoardScreen from '@/src/screens/PrayerBoardScreen';
import { Stack, useRouter } from 'expo-router';
import { Text, TouchableOpacity } from 'react-native';

export default function PrayerBoardRoute() {
  const router = useRouter();

  return (
    <>
      <Stack.Screen
        options={{
          title: 'Prayer Board',
          headerRight: () => (
            <TouchableOpacity onPress={() => router.push('/prayer/new')}>
              <Text className="font-semibold text-blue-600 dark:text-blue-400">New</Text>
            </TouchableOpacity>
          ),
        }}
      />
      <PrayerBoardScreen />
    </>
  );
}
