import DaysPicker from '@/src/components/DaysPicker';
import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { Ionicons } from '@expo/vector-icons';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc'; // Import the plugin
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useMemo, useState } from 'react';
import {
  ActivityIndicator,
  Image,
  ScrollView,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';

import { useSafeAreaInsets } from 'react-native-safe-area-context';

dayjs.extend(utc);

export default function PickStartDateScreen() {
  const colorScheme = useColorScheme();
  const insets = useSafeAreaInsets();
  const { id } = useLocalSearchParams<{
    id: string;
  }>();

  const router = useRouter();
  const [selectedDate, setSelectedDate] = useState(dayjs().utc().startOf('day'));
  const planQuery = useFetchDevotionalPlanById(id as string);
  const plan = planQuery.data;

  const dates = useMemo(() => {
    return Array.from({ length: 14 }).map((_, i) => dayjs().utc().startOf('day').add(i, 'day'));
  }, []);

  const startDate = dayjs().utc().startOf('day');
  if (planQuery.isLoading) {
    return <ActivityIndicator style={{ marginTop: 30 }} size="large" />;
  }

  if (planQuery.isError) {
    return (
      <View className="flex-1 items-center justify-center p-4">
        <Text className="text-center text-gray-700 dark:text-gray-300">
          Failed to load this devotional. Please try again later.
        </Text>
      </View>
    );
  }

  if (!plan) {
    return (
      <View className="flex-1 items-center justify-center p-4">
        <Text className="text-center text-gray-700 dark:text-gray-300">
          This devotional could not be found.
        </Text>
      </View>
    );
  }

  return (
    <View className="flex-1 dark:bg-black items-center " style={{ paddingBottom: insets.bottom }}>
      {plan?.cover_image ? (
        <Image
          source={{ uri: plan.cover_image }}
          className="w-full max-w-72 h-56 rounded-2xl"
          resizeMode="cover"
        />
      ) : (
        <View className="w-full max-w-12 h-60 rounded-2xl bg-gray-300 dark:bg-neutral-800" />
      )}
      {/* CONTENT */}
      <View className="px-4 mt-6 items-center w-full">
        <Text className="dark:text-white text-xl font-bold mb-6">
          When do you want to start this plan?
        </Text>

        <ScrollView horizontal showsHorizontalScrollIndicator={false} className="mb-5">
          <View className="flex-row gap-3">
            {dates.map((date, index) => {
              const isSelected = date.isSame(selectedDate, 'day');
              return (
                <DaysPicker
                  key={date.toISOString()}
                  isActive={isSelected}
                  startDate={startDate.toISOString()}
                  day_number={index + 1}
                  isCurrentDay={date.isSame(dayjs(), 'day')}
                  completed={false}
                  setSelectedDate={setSelectedDate}
                />
              );
            })}
          </View>
        </ScrollView>

        <Text className="text-gray-700 dark:text-gray-200 text-sm mt-6 text-center">
          Starting on a future date gives participants time to accept your invitation.
        </Text>
      </View>

      {/* NEXT BUTTON */}
      <View
        className="absolute bottom-8 left-0 right-0 items-end px-6"
        style={{ paddingBottom: insets.bottom + 5 }}>
        <TouchableOpacity
          onPress={() => {
            router.replace({
              pathname: `/devotional_detail/[id]/invite-friends`,
              params: {
                startDate: selectedDate.toISOString(),
                id: id as string,
              },
            });
          }}
          className="w-14 h-14 rounded-full bg-black dark:bg-white items-center justify-center">
          <Ionicons
            name="arrow-forward"
            size={24}
            color={colorScheme === 'dark' ? '#000' : '#fff'}
          />
        </TouchableOpacity>
      </View>
    </View>
  );
}
