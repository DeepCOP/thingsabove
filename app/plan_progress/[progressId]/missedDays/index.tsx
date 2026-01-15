/* eslint-disable react-hooks/exhaustive-deps */
import { useDayItemsProgress } from '@/src/hooks/useDayItemsProgress';
import { usePlanProgress } from '@/src/hooks/usePlanProgress';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import dayjs from 'dayjs';
import { useLocalSearchParams } from 'expo-router';
import React, { useEffect } from 'react';
import { FlatList, Text, TouchableOpacity, useColorScheme, View } from 'react-native';

const MissedDays = () => {
  const colorScheme = useColorScheme();
  const { progressId } = useLocalSearchParams();
  const { missedDays, setMissedDays } = useAppStore();
  const { session } = useAuth();
  const { planProgressQuery } = usePlanProgress(progressId as string, session?.user?.id as string);
  const { toggleDayCompletion } = useDayItemsProgress({
    user_id: session?.user?.id || '',
    progress_id: progressId as string,
    day_id: missedDays?.[0]?.id || '',
    plan_id: planProgressQuery.data?.plan_id as string,
    group_id: planProgressQuery.data?.group_id as string,
  });

  useEffect(() => {
    const newMissedDays = missedDays?.filter((day) => {
      const isCompleted = planProgressQuery.data?.completed_days?.includes(day.day_number);
      return !isCompleted;
    });
    setMissedDays(newMissedDays || []);
  }, [planProgressQuery.data]);
  const planProgress = planProgressQuery.data;

  return (
    <>
      {missedDays && missedDays.length > 0 ? (
        <FlatList
          data={missedDays}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => (
            <View className="p-4 flex-row items-center justify-start border-b border-gray-200 dark:border-gray-700">
              <TouchableOpacity
                onPress={() =>
                  toggleDayCompletion.mutate({
                    completed: true,
                  })
                }
                className={`rounded-full p-1 border mr-3  ${
                  planProgress?.completed_days?.includes(item?.day_number)
                    ? 'bg-black dark:bg-white'
                    : 'border-gray-500'
                }`}>
                <Ionicons
                  name="checkmark"
                  size={12}
                  color={colorScheme === 'dark' ? 'black' : 'white'}
                />
              </TouchableOpacity>
              <Text className="text-gray-900 font-semibold  dark:text-gray-100">
                {dayjs(planProgress?.created_at)
                  .startOf('day')
                  .add(item?.day_number - 1, 'day')
                  .format('MMMM DD, YYYY')}
              </Text>
            </View>
          )}
        />
      ) : (
        <View className="flex-1 justify-center items-center">
          <Text className="text-gray-500 dark:text-gray-400">No missed days! 🎉</Text>
        </View>
      )}
    </>
  );
};

export default MissedDays;
