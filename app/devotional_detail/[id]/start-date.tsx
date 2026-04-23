import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import dayjs from '@/src/lib/dayjs';
import PickStartDateScreen from '@/src/screens/PickStartDateScreen';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useMemo, useState } from 'react';
import { ActivityIndicator, Text, View } from 'react-native';

export default function PickStartDate() {
  const { id } = useLocalSearchParams<{
    id: string;
  }>();

  const router = useRouter();
  const [selectedDate, setSelectedDate] = useState(dayjs().startOf('day'));
  const planQuery = useFetchDevotionalPlanById(id as string);
  const plan = planQuery.data;

  const dates = useMemo(() => {
    return Array.from({ length: 14 }).map((_, i) => dayjs().startOf('day').add(i, 'day'));
  }, []);

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
    <PickStartDateScreen
      coverImage={planQuery?.data?.cover_image}
      dates={dates}
      selectedDate={selectedDate}
      onSelectDate={setSelectedDate}
      onNext={() =>
        router.replace({
          pathname: '/devotional_detail/[id]/invite-friends',
          params: {
            id,
            startDate: selectedDate.toISOString(),
          },
        })
      }
    />
  );
}
