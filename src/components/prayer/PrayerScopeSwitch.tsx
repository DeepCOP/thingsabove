import { PrayerScope } from '@/src/types/types';
import { Text, TouchableOpacity, View } from 'react-native';

type Props = {
  hasChurch: boolean;
  scope: PrayerScope;
  onChange: (scope: PrayerScope) => void;
};

export default function PrayerScopeSwitch({ hasChurch, scope, onChange }: Props) {
  return (
    <View className="rounded-full bg-gray-100 p-1 dark:bg-neutral-900">
      <View className="flex-row">
        <TouchableOpacity
          className={`flex-1 rounded-full px-4 py-3 ${scope === 'public' ? 'bg-white dark:bg-black' : ''}`}
          onPress={() => onChange('public')}>
          <Text
            className={`text-center font-semibold ${
              scope === 'public'
                ? 'text-gray-900 dark:text-white'
                : 'text-gray-500 dark:text-gray-400'
            }`}>
            Public
          </Text>
        </TouchableOpacity>

        <TouchableOpacity
          className={`flex-1 rounded-full px-4 py-3 ${scope === 'church' ? 'bg-white dark:bg-black' : ''}`}
          onPress={() => onChange('church')}>
          <Text
            className={`text-center font-semibold ${
              scope === 'church'
                ? 'text-gray-900 dark:text-white'
                : hasChurch
                  ? 'text-gray-500 dark:text-gray-400'
                  : 'text-gray-400 dark:text-gray-500'
            }`}>
            My Church
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}
