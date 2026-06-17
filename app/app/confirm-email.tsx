import { getAuthRedirectParams, type AuthRedirectSearchParams } from '@/src/lib/authRedirects';
import { Ionicons } from '@expo/vector-icons';
import { Href, useLocalSearchParams, useRouter } from 'expo-router';
import { Text, TouchableOpacity, useColorScheme, View } from 'react-native';

export default function ConfirmEmailScreen() {
  const router = useRouter();
  const colorScheme = useColorScheme();
  const searchParams = useLocalSearchParams<{ email?: string } & AuthRedirectSearchParams>();
  const { email } = searchParams;
  const authRedirectParams = getAuthRedirectParams(searchParams);

  return (
    <View className="flex-1 items-center justify-center px-6 bg-white dark:bg-black">
      <View className="w-full max-w-96 rounded-2xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-neutral-900 p-6 items-center">
        <View className="w-16 h-16 rounded-full items-center justify-center bg-blue-100 dark:bg-blue-900/40 mb-4">
          <Ionicons
            name="mail-outline"
            size={30}
            color={colorScheme === 'dark' ? '#93C5FD' : '#1D4ED8'}
          />
        </View>

        <Text className="text-2xl font-bold text-gray-900 dark:text-white text-center">
          Confirm Your Email
        </Text>
        <Text className="text-gray-600 dark:text-gray-300 text-center mt-3">
          We sent a confirmation link to
        </Text>
        <Text className="text-gray-900 dark:text-white text-center font-semibold mt-1">
          {email || 'your email address'}
        </Text>
        <Text className="text-gray-600 dark:text-gray-300 text-center mt-3">
          Verify your email, then sign in to continue.
        </Text>

        <TouchableOpacity
          className="w-full mt-6 p-3 rounded-lg bg-black dark:bg-white"
          onPress={() =>
            router.replace({
              pathname: '/app/signin',
              params: authRedirectParams,
            } as Href)
          }>
          <Text className="text-center font-bold text-white dark:text-black">Go to Sign In</Text>
        </TouchableOpacity>

        <TouchableOpacity
          className="mt-4"
          onPress={() =>
            router.replace({
              pathname: '/app/signup',
              params: authRedirectParams,
            } as Href)
          }>
          <Text className="text-blue-600 dark:text-blue-400 font-semibold">
            Use a different email
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}
