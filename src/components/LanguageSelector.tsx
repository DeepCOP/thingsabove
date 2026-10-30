import { useAppStore } from '@/src/state/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import { useColorScheme } from 'nativewind';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  Modal,
  Pressable,
  ScrollView,
  Text,
  TouchableOpacity,
  useWindowDimensions,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

export default function LanguageSelector() {
  const { t } = useTranslation('app');
  const { colorScheme } = useColorScheme();
  const { height } = useWindowDimensions();
  const insets = useSafeAreaInsets();
  const [open, setOpen] = useState(false);
  const language = useAppStore((state) => state.language);
  const setLanguage = useAppStore((state) => state.setLanguage);
  const iconColor = colorScheme === 'dark' ? '#d1d5db' : '#4b5563';
  const options = [
    { value: 'system', label: t('followDeviceLanguage') },
    { value: 'en', label: 'English' },
    { value: 'es', label: 'Español' },
    { value: 'pt', label: 'Português' },
    { value: 'zh-Hans', label: '简体中文' },
    { value: 'zh-Hant', label: '繁體中文' },
    { value: 'fr', label: 'Français' },
    { value: 'id', label: 'Bahasa Indonesia' },
    { value: 'ko', label: '한국어' },
    { value: 'fil', label: 'Filipino (Tagalog)' },
    { value: 'sw', label: 'Kiswahili' },
    { value: 'hi', label: 'हिन्दी' },
  ] as const;
  const selectedOption = options.find((option) => option.value === language) ?? options[0];
  const close = () => setOpen(false);

  return (
    <View className="mb-8">
      <Text className="mb-3 text-lg font-semibold text-gray-900 dark:text-white">
        {t('language')}
      </Text>
      <TouchableOpacity
        accessibilityRole="button"
        accessibilityLabel={t('language')}
        accessibilityValue={{ text: selectedOption.label }}
        accessibilityState={{ expanded: open }}
        onPress={() => setOpen(true)}
        className="min-h-14 flex-row items-center rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 dark:border-neutral-700 dark:bg-neutral-900">
        <Ionicons name="language-outline" size={22} color={iconColor} accessible={false} />
        <Text className="mx-3 flex-1 text-base text-gray-900 dark:text-white">
          {selectedOption.label}
        </Text>
        <Ionicons
          name={open ? 'chevron-up' : 'chevron-down'}
          size={18}
          color={iconColor}
          accessible={false}
        />
      </TouchableOpacity>

      <Modal visible={open} transparent animationType="fade" onRequestClose={close}>
        <View
          className="flex-1 items-center justify-center px-6"
          style={{ paddingTop: insets.top + 24, paddingBottom: insets.bottom + 24 }}>
          <Pressable
            accessible={false}
            importantForAccessibility="no"
            className="absolute inset-0 bg-black/40"
            onPress={close}
          />
          <View
            accessibilityViewIsModal
            onAccessibilityEscape={close}
            className="w-full max-w-md overflow-hidden rounded-2xl border border-gray-200 bg-white dark:border-neutral-700 dark:bg-neutral-900"
            style={{ maxHeight: Math.min(560, height - insets.top - insets.bottom - 48) }}>
            <View className="flex-row items-center border-b border-gray-100 px-4 py-2 dark:border-neutral-800">
              <Text
                accessibilityRole="header"
                className="mr-3 flex-1 text-lg font-semibold text-gray-900 dark:text-white">
                {t('language')}
              </Text>
              <TouchableOpacity
                accessibilityRole="button"
                accessibilityLabel={t('close')}
                onPress={close}
                className="h-11 w-11 items-center justify-center rounded-full">
                <Ionicons name="close" size={24} color={iconColor} accessible={false} />
              </TouchableOpacity>
            </View>
            <ScrollView style={{ flexGrow: 0 }} contentContainerStyle={{ padding: 8 }}>
              <View accessibilityRole="radiogroup" accessibilityLabel={t('language')}>
                {options.map((option) => {
                  const selected = language === option.value;
                  return (
                    <TouchableOpacity
                      key={option.value}
                      accessibilityRole="radio"
                      accessibilityLabel={option.label}
                      accessibilityState={{ checked: selected }}
                      onPress={() => {
                        setLanguage(option.value);
                        close();
                      }}
                      className={`min-h-12 flex-row items-center rounded-xl px-3 py-3 ${
                        selected ? 'bg-blue-50 dark:bg-blue-950' : ''
                      }`}>
                      <Text
                        className={`mr-3 flex-1 text-base ${
                          selected
                            ? 'font-semibold text-blue-700 dark:text-blue-300'
                            : 'text-gray-900 dark:text-white'
                        }`}>
                        {option.label}
                      </Text>
                      {selected ? (
                        <Ionicons
                          name="checkmark"
                          size={22}
                          color={colorScheme === 'dark' ? '#93c5fd' : '#1d4ed8'}
                          accessible={false}
                        />
                      ) : null}
                    </TouchableOpacity>
                  );
                })}
              </View>
            </ScrollView>
          </View>
        </View>
      </Modal>
    </View>
  );
}
