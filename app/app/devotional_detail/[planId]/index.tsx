import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import {
  useDayItemTemplates,
  useDevotionalDays,
  useMyPlanProgressPlans,
  useStartPlanProgress,
} from '@/src/hooks/usePlanProgress';
import { useSavedPlans, useToggleSavedPlan } from '@/src/hooks/useSavedPlans';
import DevotionalDetailScreen from '@/src/screens/DevotionalDetailScreen';
import { useAuth } from '@/src/state/AuthContext';
import { sortDayItems } from '@/src/utils';
import BottomSheet from '@gorhom/bottom-sheet';
import { useEffect, useMemo, useRef, useState } from 'react';

import { useTogglePlanReaction } from '@/src/hooks/usePlanReactions';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { Alert, Platform, useColorScheme } from 'react-native';

export default function DevotionalDetail() {
  const { planId } = useLocalSearchParams<{ planId: string }>();
  const reportSheetRef = useRef<BottomSheet>(null);
  const { isGuest, session } = useAuth();
  const savedPlansQuery = useSavedPlans(session?.user?.id);
  const savedPlanIds = useMemo(
    () =>
      (savedPlansQuery.data ?? [])
        .map((savedPlan) => savedPlan.id)
        .filter((savedPlanId): savedPlanId is string => typeof savedPlanId === 'string'),
    [savedPlansQuery.data],
  );
  const { toggleSavedPlan } = useToggleSavedPlan(session?.user?.id);
  const isSaved = savedPlanIds.includes(planId);
  const toggleReaction = useTogglePlanReaction(planId, session?.user?.id || '');

  const router = useRouter();
  const colorScheme = useColorScheme();
  const startPlanProgressMutation = useStartPlanProgress();
  const myPlanProgressPlansQuery = useMyPlanProgressPlans(session?.user.id);
  const planQuery = useFetchDevotionalPlanById(planId);
  const plan = planQuery.data;
  const daysQuery = useDevotionalDays(planId);
  const previewDays = useMemo(() => daysQuery.data ?? [], [daysQuery.data]);
  const [selectedPreviewDay, setSelectedPreviewDay] = useState(1);
  const selectedPreviewDayData = previewDays.find((day) => day.day_number === selectedPreviewDay);
  const dayItemsQuery = useDayItemTemplates(planId, selectedPreviewDayData?.id ?? '');
  const previewItems = useMemo(
    () => [...(dayItemsQuery.data ?? [])].sort(sortDayItems),
    [dayItemsQuery.data],
  );
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
  const currentReaction = {
    helpful_count: plan?.helpful_count ?? 0,
    user_reaction: plan?.user_reaction === 'helpful' ? ('helpful' as const) : null,
  };

  useEffect(() => {
    if (!previewDays.length) return;

    const selectedDayExists = previewDays.some((day) => day.day_number === selectedPreviewDay);
    if (!selectedDayExists) {
      setSelectedPreviewDay(previewDays[0].day_number);
    }
  }, [previewDays, selectedPreviewDay]);

  const handleToggleReaction = () => {
    if (isGuest) {
      router.push('/app/(auth)/signin');
      return;
    }
    toggleReaction.mutate();
  };
  const onReportPress = () => {
    if (isGuest) {
      router.push('/app/(auth)/signin');
      return;
    }
    reportSheetRef.current?.expand();
  };
  const handleContinuePress = () => {
    if (!currentActivePlanProgress?.progress_id) return;

    router.push(`/app/plan_progress/${currentActivePlanProgress.progress_id}`);
  };

  const handleStartPress = (mode: 'solo' | 'group') => {
    if (startPlanProgressMutation.isPending) return;

    if (isGuest) {
      router.push('/(auth)/signin');
      return;
    }

    if (plan?.visibility === 'private' && plan.author_id !== session?.user.id) {
      handleContinuePress();
      return;
    }

    if (mode === 'group') {
      router.push(`/app/devotional_detail/${planId}/start-date`);
      return;
    }

    startPlanProgressMutation.mutate(
      { plan_id: planId, user_id: session?.user.id! },
      {
        onSuccess: (progress) => router.push(`/app/plan_progress/${progress.id}`),
        onError: (error) => {
          Alert.alert(
            'Could not start plan',
            error instanceof Error ? error.message : 'Please try again.',
          );
        },
      },
    );
  };

  return (
    <>
      <Stack.Screen
        options={{
          headerTransparent: true,
          headerBlurEffect:
            Platform.OS === 'ios'
              ? colorScheme === 'dark'
                ? 'systemMaterialDark'
                : 'systemMaterialLight'
              : undefined,
          headerStyle: {
            backgroundColor:
              Platform.OS === 'ios'
                ? 'transparent'
                : colorScheme === 'dark'
                  ? 'rgba(0, 0, 0, 0.65)'
                  : 'rgba(255, 255, 255, 0.65)',
          },
        }}
      />
      <DevotionalDetailScreen
        onReportPress={onReportPress}
        handleToggleReaction={handleToggleReaction}
        currentReaction={currentReaction}
        plan={planQuery.data}
        reportSheetRef={reportSheetRef}
        isLoading={planQuery.isLoading || myPlanProgressPlansQuery.isLoading || daysQuery.isLoading}
        previewDays={previewDays}
        selectedPreviewDay={selectedPreviewDay}
        selectedPreviewDayData={selectedPreviewDayData}
        previewItems={previewItems}
        previewItemsLoading={dayItemsQuery.isLoading}
        hasActiveSoloPlanProgress={!!currentSoloPlanProgress?.progress_id}
        hasActivePlanProgress={!!currentActivePlanProgress?.progress_id}
        canStartPlan={!!canStartPlan}
        isPrivatePlan={!!isPrivatePlan}
        isStartingSoloPlan={startPlanProgressMutation.isPending}
        onSelectPreviewDay={setSelectedPreviewDay}
        onContinuePress={handleContinuePress}
        isSaved={isSaved}
        onToggleSave={() => {
          if (isGuest) {
            router.push('/app/(auth)/signin');
            return;
          }
          toggleSavedPlan(planId, isSaved, plan ?? undefined);
        }}
        onStartPress={handleStartPress}
      />
    </>
  );
}
