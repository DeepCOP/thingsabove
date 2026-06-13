import { deleteAccount } from '@/src/api/mutations';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useNotificationSettings } from '@/src/hooks/useNotificationSetting';
import { registerForPushNotificationsAsync } from '@/src/hooks/usePushNotifications';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import * as Application from 'expo-application';
import Constants from 'expo-constants';
import { useState } from 'react';
import { Alert, Switch, Text, TouchableOpacity, View } from 'react-native';

export default function NotificationSettingsScreen() {
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
    Application.nativeApplicationVersion ?? Constants.expoConfig?.version ?? 'Unknown';
  const buildNumber =
    Application.nativeBuildVersion ??
    String(
      Constants.expoConfig?.ios?.buildNumber ??
        Constants.expoConfig?.android?.versionCode ??
        'Unknown',
    );

  if (loading) {
    return (
      <View className="flex-1 items-center justify-center">
        <LoadingSpinner />
      </View>
    );
  }

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
      Alert.alert('Error', 'You need to be signed in to delete your account.');
      return;
    }

    setDeletingAccount(true);

    try {
      await deleteAccount(userId);
    } catch {
      Alert.alert('Error', 'Failed to delete account. Please try again.');
    } finally {
      setDeletingAccount(false);
    }
  };

  const confirmDeleteAccount = () => {
    Alert.alert(
      'Delete Account',
      'Are you sure you want to permanently delete your account? This action cannot be undone. All your data will be lost.',
      [
        { text: 'Cancel', style: 'cancel' },
        { text: 'Delete', style: 'destructive', onPress: handleDeleteAccount },
      ],
    );
  };

  return (
    <View className="flex-1 bg-white dark:bg-black px-4 pt-6">
      <Text className="text-xl font-bold dark:text-white mb-6">Notifications</Text>

      {/* OCCASIONAL AI NOTIFICATIONS */}
      <View className="flex-row items-center justify-between py-4 border-b border-gray-200 dark:border-neutral-800">
        <View className="flex-1 pr-4">
          <Text className="font-semibold dark:text-white">Encouragement Notifications</Text>
          <Text className="text-xs text-gray-500 mt-1">
            Receive Scripture-based encouragement and spiritual prompts
          </Text>
        </View>

        <Switch value={aiNotificationsEnabled} onValueChange={handleToggleDailyEncouragement} />
      </View>

      <View className="flex-row items-center justify-between py-4 border-b border-gray-200 dark:border-neutral-800">
        <View className="flex-1 pr-4">
          <Text className="font-semibold dark:text-white">Group Progress Notifications</Text>
          <Text className="text-xs text-gray-500 mt-1">
            Receive updates when group members complete plan days
          </Text>
        </View>

        <Switch
          value={groupDayCompletedPushNotificationsEnabled}
          onValueChange={handleToggleGroupDayCompleted}
        />
      </View>

      {/* THEME */}
      <View className="mt-8">
        <Text className="text-lg font-semibold dark:text-white mb-3">Appearance</Text>

        {(['system', 'light', 'dark'] as const).map((option) => (
          <TouchableOpacity
            key={option}
            onPress={() => setTheme(option)}
            className="flex-row items-center justify-between py-3 border-b border-gray-200 dark:border-neutral-800">
            <Text className="capitalize dark:text-white">{option}</Text>

            {theme === option && (
              <Text className="text-xs text-blue-500 font-semibold">Active</Text>
            )}
          </TouchableOpacity>
        ))}
      </View>

      <View className="mt-8">
        <Text className="text-lg font-semibold dark:text-white mb-3">About</Text>

        <View className="py-3 border-b border-gray-200 dark:border-neutral-800">
          <Text className="dark:text-white">
            Version {appVersion} ({buildNumber})
          </Text>
        </View>
      </View>

      <View className="mt-8">
        <Text className="text-lg font-semibold dark:text-white mb-3">Account</Text>

        <TouchableOpacity
          onPress={confirmDeleteAccount}
          disabled={deletingAccount}
          className="flex-row items-center justify-between rounded-xl border border-red-200 bg-red-50 px-4 py-4 dark:border-red-900 dark:bg-red-950/30">
          <View className="flex-1 pr-4">
            <Text className="font-semibold text-red-600">
              {deletingAccount ? 'Deleting Account...' : 'Delete Account'}
            </Text>
            <Text className="mt-1 text-xs text-red-700 dark:text-red-300">
              Permanently remove your account and profile data.
            </Text>
          </View>
          <Text className="text-xs font-semibold text-red-600">Delete</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}
