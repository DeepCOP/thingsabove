import BibleVersionsScreen from '@/src/screens/BibleVersionsScreen';
import { Stack } from 'expo-router';

export default function BibleVersionsRoute() {
  return (
    <>
      <Stack.Screen
        options={{
          title: 'Bible Versions',
          headerShadowVisible: false,
        }}
      />
      <BibleVersionsScreen />
    </>
  );
}
