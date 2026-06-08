import { Link, Stack } from 'expo-router';
import { Text, TouchableOpacity, View } from 'react-native';

export default function NotFoundScreen() {
  return (
    <>
      {/* Optional: hide header */}
      <Stack.Screen options={{ title: 'Not Found' }} />

      <View className="flex-1 items-center justify-center bg-white dark:bg-black px-6">
        <Text className="text-3xl font-bold text-gray-900 dark:text-white mb-2">404</Text>

        <Text className="text-lg text-gray-600 dark:text-gray-300 text-center mb-6">
          Oops! The page you’re looking for doesn’t exist.
        </Text>

        <Link href="/app/(tabs)/PlansTab" asChild>
          <TouchableOpacity className="bg-[#040c1f] px-6 py-3 rounded-full">
            <Text className="text-white font-semibold">Go Home</Text>
          </TouchableOpacity>
        </Link>
      </View>
    </>
  );
}
