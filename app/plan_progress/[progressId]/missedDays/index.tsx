/* eslint-disable react-hooks/exhaustive-deps */
import { useDayItemsProgress } from '@/src/hooks/useDayItemsProgress';
import { usePlanProgress } from '@/src/hooks/usePlanProgress';
import MissedDaysScreen from '@/src/screens/MissedDaysScreen';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import { useLocalSearchParams } from 'expo-router';
import React, { useEffect } from 'react';

const MissedDays = () => {
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
    <MissedDaysScreen
      missedDays={missedDays || []}
      completedDays={planProgress?.completed_days || []}
      createdAt={planProgress?.created_at || ''}
      onToggleDay={(dayId) =>
        toggleDayCompletion.mutate({
          completed: true,
          day_id: dayId,
        })
      }
    />
  );
};

export default MissedDays;
