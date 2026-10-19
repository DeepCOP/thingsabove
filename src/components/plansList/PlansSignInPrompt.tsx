import { useTranslation } from 'react-i18next';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { Text, TouchableOpacity, useColorScheme, View } from 'react-native';

type Props = {
  title: string;
  hint: string;
};

export default function PlansSignInPrompt({ title, hint }: Props) {
  const { t } = useTranslation('plans');
  const colorScheme = useColorScheme();

  return (
    <View className="flex-1 items-center justify-center px-4">
      <View className="w-full max-w-72 bg-white dark:bg-neutral-900 border border-gray-200 dark:border-neutral-800 rounded-2xl px-6 py-8 items-center">
        <View className="w-14 h-14 rounded-full bg-gray-100 dark:bg-neutral-800 items-center justify-center mb-4">
          <Ionicons
            name="lock-closed"
            size={24}
            color={colorScheme === 'dark' ? '#E5E7EB' : '#6B7280'}
          />
        </View>
        <Text className="text-lg font-semibold text-gray-900 dark:text-white mb-2 text-center">
          {title}
        </Text>
        <Text className="text-center text-gray-600 dark:text-gray-400 mb-6">{hint}</Text>
        <TouchableOpacity
          accessibilityRole="button"
          onPress={() => router.push('/app/signin')}
          className="w-full bg-black dark:bg-white py-3 rounded-xl mb-3">
          <Text className="text-center text-white dark:text-black font-semibold">
            {t('signIn')}
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          accessibilityRole="button"
          onPress={() => router.push('/app/signup')}
          className="w-full border border-black dark:border-white py-3 rounded-xl">
          <Text className="text-center font-semibold dark:text-white">{t('createAccount')}</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}
