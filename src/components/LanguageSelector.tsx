import { useAppStore } from '@/src/state/useAppStore';
import { useTranslation } from 'react-i18next';
import { Text, TouchableOpacity, View } from 'react-native';

export default function LanguageSelector() {
  const { t } = useTranslation('app');
  const language = useAppStore((state) => state.language);
  const setLanguage = useAppStore((state) => state.setLanguage);
  const options = [
    { value: 'system', label: t('followDeviceLanguage') },
    { value: 'en', label: 'English' },
    { value: 'zh-Hans', label: '简体中文' },
  ] as const;

  return (
    <View className="mb-8">
      <Text className="mb-3 text-lg font-semibold text-gray-900 dark:text-white">
        {t('language')}
      </Text>
      <View accessibilityRole="radiogroup">
        {options.map((option) => (
          <TouchableOpacity
            key={option.value}
            accessibilityRole="radio"
            accessibilityState={{ checked: language === option.value }}
            onPress={() => setLanguage(option.value)}
            className="flex-row items-center justify-between border-b border-gray-200 py-3 dark:border-neutral-800">
            <Text className="text-gray-900 dark:text-white">{option.label}</Text>
            {language === option.value ? (
              <Text className="text-xs font-semibold text-blue-500">{t('active')}</Text>
            ) : null}
          </TouchableOpacity>
        ))}
      </View>
    </View>
  );
}
