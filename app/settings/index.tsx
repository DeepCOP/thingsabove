import LoadingSpinner from '@/src/components/LoadingSpinner';
import { ensurePushReady, useNotificationSettings } from '@/src/hooks/useNotificationSetting';
import { useAppStore } from '@/src/state/useAppStore';
import { Switch, Text, TouchableOpacity, View } from 'react-native';

export default function NotificationSettingsScreen() {
  const { dailyEncouragement, toggleDailyEncouragementMutation, loading } =
    useNotificationSettings();

  const { theme, setTheme } = useAppStore();

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
      const token = await ensurePushReady();
      if (!token) return;
    }
    toggleDailyEncouragementMutation(nextValue);
  };

  return (
    <View className="flex-1 bg-white dark:bg-black px-4 pt-6">
      <Text className="text-xl font-bold dark:text-white mb-6">Notifications</Text>

      {/* DAILY ENCOURAGEMENT */}
      <View className="flex-row items-center justify-between py-4 border-b border-gray-200 dark:border-neutral-800">
        <View className="flex-1 pr-4">
          <Text className="font-semibold dark:text-white">Daily Encouragement</Text>
          <Text className="text-xs text-gray-500 mt-1">
            Receive a daily faith-based encouragement
          </Text>
        </View>

        <Switch value={dailyEncouragement} onValueChange={handleToggleDailyEncouragement} />
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

      {/* FUTURE TOPICS */}
      <View className="mt-8 opacity-40">
        <Text className="font-semibold dark:text-white">More coming soon</Text>
        <Text className="text-xs text-gray-500 mt-1">
          Comments • Group activity • Streak reminders
        </Text>
      </View>
    </View>
  );
}
