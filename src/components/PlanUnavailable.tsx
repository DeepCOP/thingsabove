import { useTranslation } from 'react-i18next';
import { useRouter } from 'expo-router';
import { Pressable, Text, View } from 'react-native';

export default function PlanUnavailable() {
  const { t } = useTranslation('plans');
  const router = useRouter();
  return (
    <View className="flex-1 items-center justify-center bg-white p-4 dark:bg-black">
      <Text className="text-center text-gray-700 dark:text-gray-300">
        {t('devotionalNotFound')}
      </Text>
      <Pressable
        accessibilityRole="button"
        className="mt-4 rounded-full bg-black px-6 py-3 dark:bg-white"
        onPress={() => {
          if (router.canGoBack()) router.back();
          else router.replace('/app/(tabs)/PlansTab');
        }}>
        <Text className="font-semibold text-white dark:text-black">{t('back')}</Text>
      </Pressable>
    </View>
  );
}
