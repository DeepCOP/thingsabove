import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { useStartPlanProgress } from '@/src/hooks/usePlanProgress';
import PickStartDateScreen from '@/src/screens/PickStartDateScreen';
import { useAuth } from '@/src/state/AuthContext';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc'; // Import the plugin
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useMemo, useState } from 'react';
import { ActivityIndicator, Text, View } from 'react-native';

dayjs.extend(utc);

export default function PickStartDate() {
  const { id, mode } = useLocalSearchParams<{
    id: string;
    mode?: 'solo' | 'group';
  }>();

  const router = useRouter();
  const { session } = useAuth();
  const startPlanProgressMutation = useStartPlanProgress();
  const [selectedDate, setSelectedDate] = useState(dayjs().utc().startOf('day'));
  const planQuery = useFetchDevotionalPlanById(id as string);
  const plan = planQuery.data;
  const startMode = mode ?? 'group';

  const dates = useMemo(() => {
    return Array.from({ length: 14 }).map((_, i) => dayjs().utc().startOf('day').add(i, 'day'));
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
      onNext={() => {
        if (startMode === 'solo') {
          if (!session?.user?.id) {
            router.push('/(auth)/signin');
            return;
          }
          startPlanProgressMutation.mutate(
            {
              plan_id: id as string,
              user_id: session.user.id,
              start_date: selectedDate.toISOString(),
            },
            {
              onSuccess: (progressId) => router.replace(`/plan_progress/${progressId}`),
            },
          );
          return;
        }

        router.replace({
          pathname: '/devotional_detail/[id]/invite-friends',
          params: {
            id,
            startDate: selectedDate.toISOString(),
          },
        });
      }}
    />
  );
}
