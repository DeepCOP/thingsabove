import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { useMyPlanProgressPlans, useStartPlanProgress } from '@/src/hooks/usePlanProgress';
import { useSavedPlans, useToggleSavedPlan } from '@/src/hooks/useSavedPlans';
import DevotionalDetailScreen from '@/src/screens/DevotionalDetailScreen';
import { useAuth } from '@/src/state/AuthContext';
import BottomSheet from '@gorhom/bottom-sheet';
import { useMemo, useRef } from 'react';

import { useTogglePlanReaction } from '@/src/hooks/usePlanReactions';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { Platform, useColorScheme } from 'react-native';

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
  const handleToggleReaction = () => {
    if (isGuest) {
      router.push('/(auth)/signin');
      return;
    }
    toggleReaction.mutate();
  };
  const onReportPress = () => {
    if (isGuest) {
      router.push('/(auth)/signin');
      return;
    }
    reportSheetRef.current?.expand();
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
        isLoading={planQuery.isLoading || myPlanProgressPlansQuery.isLoading}
        hasActiveSoloPlanProgress={!!currentSoloPlanProgress?.progress_id}
        hasActivePlanProgress={!!currentActivePlanProgress?.progress_id}
        canStartPlan={!!canStartPlan}
        isPrivatePlan={!!isPrivatePlan}
        onContinuePress={() => {
          if (!currentActivePlanProgress?.progress_id) return;

          router.push(`/plan_progress/${currentActivePlanProgress.progress_id}`);
        }}
        isSaved={isSaved}
        onToggleSave={() => {
          if (isGuest) {
            router.push('/(auth)/signin');
            return;
          }
          toggleSavedPlan(planId, isSaved, plan ?? undefined);
        }}
        onStartPress={(mode: string) => {
          if (isGuest) {
            router.push('/(auth)/signin');
            return;
          }

          if (plan?.visibility === 'private' && plan.author_id !== session?.user.id) {
            if (currentActivePlanProgress?.progress_id) {
              router.push(`/plan_progress/${currentActivePlanProgress.progress_id}`);
            }
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
            },
          );
        }}
      />
    </>
  );
}
