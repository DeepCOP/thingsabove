import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useNotificationSettings } from '@/src/hooks/useNotificationSetting';
import { registerForPushNotificationsAsync } from '@/src/hooks/usePushNotifications';
import { useAppStore } from '@/src/state/useAppStore';
import * as Application from 'expo-application';
import Constants from 'expo-constants';
import { Switch, Text, TouchableOpacity, View } from 'react-native';

export default function NotificationSettingsScreen() {
  const {
    aiNotificationsEnabled,
    groupDayCompletedPushNotificationsEnabled,
    toggleAiNotifications,
    toggleGroupDayCompletedPushNotifications,
    loading,
  } = useNotificationSettings();

  const { theme, setTheme } = useAppStore();
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
    </View>
  );
}
