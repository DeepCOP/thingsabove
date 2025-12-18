import { useRouter } from 'expo-router';
import { ScrollView, Text, TouchableOpacity, View } from 'react-native';
// import { usePlanProgress } from '@/hooks/usePlanProgress';
// import { Ionicons } from '@expo/vector-icons';
// import { useUserStore } from '@/store/useUserStore';
import { useAuth } from '@/context/AuthContext';
import { usePlanProgress } from '@/hooks/usePLanProgress';
import { PlanProgress } from '@/types/types';
import { useEffect } from 'react';

export function PlanProgressPage({
  plan_id,
  progress,
}: {
  plan_id: string;
  progress: PlanProgress;
}) {
  const router = useRouter();

  const { session, loading, isGuest } = useAuth();
  const { toggleDayCompletion, progressQuery, daysQuery } = usePlanProgress(
    plan_id,
    session?.user?.id ?? '',
  );
  const plan = progressQuery.data;
  const days = daysQuery.data;
  useEffect(() => {
    if (isGuest) {
      router.push('/login');
    }
  }, [isGuest]);
  return (
    <ScrollView className="flex-1 bg-white dark:bg-black px-4 pb-20">
      {/* Title */}
      <Text className="text-2xl font-bold mt-4 dark:text-white">{plan.title}</Text>

      {/* Day Tabs */}
      <ScrollView horizontal showsHorizontalScrollIndicator={false} className="mt-4">
        {days?.map((d) => (
          <TouchableOpacity
            key={d.day_number}
            className={`px-4 py-2 rounded-xl mr-2 ${
              progress.current_day === d.day_number
                ? 'bg-black dark:bg-white'
                : 'bg-gray-200 dark:bg-neutral-800'
            }`}>
            <Text
              className={`${
                progress.current_day === d.day_number
                  ? 'text-white dark:text-black'
                  : 'text-gray-700 dark:text-gray-300'
              }`}>
              {d.day_number}
            </Text>
          </TouchableOpacity>
        ))}
      </ScrollView>

      {/* Day Content */}
      {days?.map((d) => {
        const isComplete = progress.completed_days?.includes(d.day_number);

        return (
          <View key={d.id} className="mt-8">
            <Text className="text-xl font-bold dark:text-white">
              Day {d.day_number} of {plan.total_days}
            </Text>

            {/* Devotional */}
            <TouchableOpacity
              onPress={() =>
                toggleDayCompletion.mutate({
                  user_id: session?.user?.id ?? '',
                  plan_id: plan_id,
                  day_number: d.day_number,
                  completed: isComplete,
                })
              }
              className="flex-row items-center mt-4">
              <View
                className={`h-6 w-6 rounded-full border mr-3 ${
                  isComplete ? 'bg-black dark:bg-white' : 'border-gray-500'
                }`}
              />
              <Text className="text-lg dark:text-gray-200">Devotional</Text>
            </TouchableOpacity>

            {/* Scripture */}
            <TouchableOpacity className="flex-row items-center mt-4">
              <View className="h-6 w-6 rounded-full border border-gray-500 mr-3" />
              <Text className="text-lg dark:text-gray-200">{d.scripture_refs?.join(', ')}</Text>
            </TouchableOpacity>
          </View>
        );
      })}

      {/* Bottom Button */}
      <TouchableOpacity
        className="mt-10 bg-black dark:bg-white py-4 rounded-full"
        onPress={() => {}}>
        <Text className="text-center text-white dark:text-black font-semibold text-lg">
          Start Reading
        </Text>
      </TouchableOpacity>
    </ScrollView>
  );
}
