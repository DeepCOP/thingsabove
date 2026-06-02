import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import {
  useDayItemTemplates,
  useDevotionalDays,
  useMyPlanProgressPlans,
  useStartPlanProgress,
} from '@/src/hooks/usePlanProgress';
import PlanPreviewScreen from '@/src/screens/PlanPreviewScreen';
import { useAuth } from '@/src/state/AuthContext';
import { sortDayItems } from '@/src/utils';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect, useMemo, useState } from 'react';
import { Alert, Platform, Text, View, useColorScheme } from 'react-native';

export default function DevotionalPlanPreview() {
  const { planId } = useLocalSearchParams<{ planId: string }>();
  const router = useRouter();
  const colorScheme = useColorScheme();
  const { isGuest, session } = useAuth();
  const planQuery = useFetchDevotionalPlanById(planId);
  const plan = planQuery.data;
  const daysQuery = useDevotionalDays(planId);
  const days = useMemo(() => daysQuery.data ?? [], [daysQuery.data]);
  const [selectedDayNumber, setSelectedDayNumber] = useState(1);
  const selectedDay = days.find((day) => day.day_number === selectedDayNumber);
  const dayItemsQuery = useDayItemTemplates(planId, selectedDay?.id ?? '');
  const startPlanProgressMutation = useStartPlanProgress();
  const myPlanProgressPlansQuery = useMyPlanProgressPlans(session?.user.id);
  const isPrivatePlan = plan?.visibility === 'private';
  const canStartPlan = !isPrivatePlan || plan?.author_id === session?.user.id;
  const activePlanProgresses = useMemo(
    () =>
      (myPlanProgressPlansQuery.data ?? []).filter((userPlan) => {
        const totalDays = typeof userPlan.total_days === 'number' ? userPlan.total_days : 0;
        const completedDays = userPlan.completed_days ?? 0;

        return userPlan.plan_id === planId && completedDays < totalDays;
      }),
    [myPlanProgressPlansQuery.data, planId],
  );
  const currentSoloPlanProgress = useMemo(
    () => activePlanProgresses.find((userPlan) => !userPlan.group_id),
    [activePlanProgresses],
  );
  const currentActivePlanProgress = currentSoloPlanProgress ?? activePlanProgresses[0];
  const previewItems = useMemo(
    () => [...(dayItemsQuery.data ?? [])].sort(sortDayItems),
    [dayItemsQuery.data],
  );

  useEffect(() => {
    if (!days.length) return;

    const selectedDayExists = days.some((day) => day.day_number === selectedDayNumber);
    if (!selectedDayExists) {
      setSelectedDayNumber(days[0].day_number);
    }
  }, [days, selectedDayNumber]);

  const continueCurrentPlan = () => {
    if (!currentActivePlanProgress?.progress_id) return;

    router.push(`/plan_progress/${currentActivePlanProgress.progress_id}`);
  };

  const handleStartPress = (mode: 'solo' | 'group') => {
    if (startPlanProgressMutation.isPending) return;

    if (isGuest) {
      router.push('/(auth)/signin');
      return;
    }

    if (plan?.visibility === 'private' && plan.author_id !== session?.user.id) {
      continueCurrentPlan();
      return;
    }

    if (mode === 'group') {
      router.push(`/devotional_detail/${planId}/start-date`);
      return;
    }

    startPlanProgressMutation.mutate(
      { plan_id: planId, user_id: session?.user.id! },
      {
        onSuccess: (progress) => router.push(`/plan_progress/${progress.id}`),
        onError: (error) => {
          Alert.alert(
            'Could not start plan',
            error instanceof Error ? error.message : 'Please try again.',
          );
        },
      },
    );
  };

  if (planQuery.isLoading || daysQuery.isLoading || myPlanProgressPlansQuery.isLoading) {
    return <LoadingSpinner />;
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
    <>
      <Stack.Screen
        options={{
          title: 'Plan Preview',
          headerTransparent: false,
          headerBlurEffect:
            Platform.OS === 'ios'
              ? colorScheme === 'dark'
                ? 'systemMaterialDark'
                : 'systemMaterialLight'
              : undefined,
          headerStyle: {
            backgroundColor: colorScheme === 'dark' ? '#000' : '#fff',
          },
        }}
      />

      <PlanPreviewScreen
        plan={plan}
        days={days}
        selectedDay={selectedDayNumber}
        selectedDayData={selectedDay}
        items={previewItems}
        itemsLoading={dayItemsQuery.isLoading}
        isStartingSoloPlan={startPlanProgressMutation.isPending}
        hasActiveSoloPlanProgress={!!currentSoloPlanProgress?.progress_id}
        hasActivePlanProgress={!!currentActivePlanProgress?.progress_id}
        canStartPlan={!!canStartPlan}
        isPrivatePlan={!!isPrivatePlan}
        onSelectDay={setSelectedDayNumber}
        onContinuePress={continueCurrentPlan}
        onStartPress={handleStartPress}
      />
    </>
  );
}
