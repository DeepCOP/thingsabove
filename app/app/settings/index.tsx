import { useTranslation } from 'react-i18next';
import { deleteAccount } from '@/src/api/mutations';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import LanguageSelector from '@/src/components/LanguageSelector';
import { useNotificationSettings } from '@/src/hooks/useNotificationSetting';
import { registerForPushNotificationsAsync } from '@/src/hooks/usePushNotifications';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import * as Application from 'expo-application';
import Constants from 'expo-constants';
import { useState } from 'react';
import { Alert, ScrollView, Switch, Text, TouchableOpacity, View } from 'react-native';

export default function NotificationSettingsScreen() {
  const { t } = useTranslation('app');
  const {
    aiNotificationsEnabled,
    groupDayCompletedPushNotificationsEnabled,
    toggleAiNotifications,
    toggleGroupDayCompletedPushNotifications,
    loading,
  } = useNotificationSettings();

  const { session } = useAuth();
  const { theme, setTheme } = useAppStore();
  const [deletingAccount, setDeletingAccount] = useState(false);
  const appVersion =
    Application.nativeApplicationVersion ?? Constants.expoConfig?.version ?? t('unknown');
  const buildNumber =
    Application.nativeBuildVersion ??
    String(
      Constants.expoConfig?.ios?.buildNumber ??
        Constants.expoConfig?.android?.versionCode ??
        t('unknown'),
    );

  const handleToggleDailyEncouragement = async (nextValue: boolean) => {
    // Only when enabling
    if (nextValue) {
      const token = await registerForPushNotificationsAsync();
      if (!token) return;
    }
    toggleAiNotifications(nextValue);
  };

  const handleToggleGroupDayCompleted = async (nextValue: boolean) => {
    if (nextValue) {
      const token = await registerForPushNotificationsAsync();
      if (!token) return;
    }
    toggleGroupDayCompletedPushNotifications(nextValue);
  };

  const handleDeleteAccount = async () => {
    const userId = session?.user?.id;

    if (!userId) {
      Alert.alert(t('error'), t('signInToDelete'));
      return;
    }

    setDeletingAccount(true);

    try {
      await deleteAccount(userId);
    } catch {
      Alert.alert(t('error'), t('deleteAccountError'));
    } finally {
      setDeletingAccount(false);
    }
  };

  const confirmDeleteAccount = () => {
    Alert.alert(t('deleteAccount'), t('deleteAccountConfirmation'), [
      { text: t('cancel'), style: 'cancel' },
      { text: t('delete'), style: 'destructive', onPress: handleDeleteAccount },
    ]);
  };

  return (
    <ScrollView
      className="flex-1 bg-white dark:bg-black px-4 pt-6"
      contentContainerStyle={{ paddingBottom: 48 }}>
      <LanguageSelector />
      <Text className="text-xl font-bold dark:text-white mb-6">{t('notifications')}</Text>
      {loading ? <LoadingSpinner /> : null}

      {/* OCCASIONAL AI NOTIFICATIONS */}
      <View className="flex-row items-center justify-between py-4 border-b border-gray-200 dark:border-neutral-800">
        <View className="flex-1 pr-4">
          <Text className="font-semibold dark:text-white">{t('encouragementNotifications')}</Text>
          <Text className="text-xs text-gray-500 mt-1">{t('encouragementDescription')}</Text>
        </View>

        <Switch
          disabled={loading}
          value={aiNotificationsEnabled}
          onValueChange={handleToggleDailyEncouragement}
        />
      </View>

      <View className="flex-row items-center justify-between py-4 border-b border-gray-200 dark:border-neutral-800">
        <View className="flex-1 pr-4">
          <Text className="font-semibold dark:text-white">{t('groupProgressNotifications')}</Text>
          <Text className="text-xs text-gray-500 mt-1">{t('groupProgressDescription')}</Text>
        </View>

        <Switch
          disabled={loading}
          value={groupDayCompletedPushNotificationsEnabled}
          onValueChange={handleToggleGroupDayCompleted}
        />
      </View>

      {/* THEME */}
      <View className="mt-8">
        <Text className="text-lg font-semibold dark:text-white mb-3">{t('appearance')}</Text>

        {(['system', 'light', 'dark'] as const).map((option) => (
          <TouchableOpacity
            key={option}
            onPress={() => setTheme(option)}
            className="flex-row items-center justify-between py-3 border-b border-gray-200 dark:border-neutral-800">
            <Text className="capitalize dark:text-white">{t(`theme_${option}`)}</Text>

            {theme === option && (
              <Text className="text-xs text-blue-500 font-semibold">{t('active')}</Text>
            )}
          </TouchableOpacity>
        ))}
      </View>

      <View className="mt-8">
        <Text className="text-lg font-semibold dark:text-white mb-3">{t('about')}</Text>

        <View className="py-3 border-b border-gray-200 dark:border-neutral-800">
          <Text className="dark:text-white">
            {t('appVersion', { version: appVersion, build: buildNumber })}
          </Text>
        </View>
      </View>

      <View className="mt-8">
        <Text className="text-lg font-semibold dark:text-white mb-3">{t('account')}</Text>

        <TouchableOpacity
          onPress={confirmDeleteAccount}
          disabled={deletingAccount}
          className="flex-row items-center justify-between rounded-xl border border-red-200 bg-red-50 px-4 py-4 dark:border-red-900 dark:bg-red-950/30">
          <View className="flex-1 pr-4">
            <Text className="font-semibold text-red-600">
              {deletingAccount ? t('deletingAccount') : t('deleteAccount')}
            </Text>
            <Text className="mt-1 text-xs text-red-700 dark:text-red-300">
              {t('deleteAccountDescription')}
            </Text>
          </View>
          <Text className="text-xs font-semibold text-red-600">{t('delete')}</Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
}
