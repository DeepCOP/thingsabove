import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { useStartPlanProgress, useUserPlanProgressList } from '@/src/hooks/usePlanProgress';
import DevotionalDetailScreen from '@/src/screens/DevotionalDetailScreen';
import { useAuth } from '@/src/state/AuthContext';
import { Ionicons } from '@expo/vector-icons';
import BottomSheet from '@gorhom/bottom-sheet';
import { useRef } from 'react';

import { useTogglePlanReaction } from '@/src/hooks/usePlanReactions';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { Platform, Share, TouchableOpacity, useColorScheme, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

export default function DevotionalDetail() {
  const { id } = useLocalSearchParams();
  const planId = id as string;
  const reportSheetRef = useRef<BottomSheet>(null);
  const { isGuest, session } = useAuth();
  const toggleReaction = useTogglePlanReaction(planId, session?.user?.id || '');

  const router = useRouter();
  const insets = useSafeAreaInsets();
  const colorScheme = useColorScheme();
  const startPlanProgressMutation = useStartPlanProgress();
  const userPlanProgressQuery = useUserPlanProgressList(session?.user.id);
  const userPlanProgress = userPlanProgressQuery.data || [];
  const existingSoloProgress = userPlanProgress.find(
    (progress) => progress.plan_id === planId && !progress.group_id,
  );

  const planQuery = useFetchDevotionalPlanById(planId);
  const plan = planQuery.data;
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
          headerRight: () => {
            return (
              <TouchableOpacity
                onPress={async () => {
                  const content = `Join me in reading ${plan?.title}\n\n ${process.env.EXPO_PUBLIC_BASE_URL}/devotional_detail/${plan?.id}`;
                  await Share.share({ message: content });
                }}>
                <Ionicons
                  name="share-social-outline"
                  size={24}
                  color={colorScheme === 'dark' ? '#fff' : '#111'}
                />
              </TouchableOpacity>
            );
          },
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
        isLoading={planQuery.isLoading || userPlanProgressQuery.isLoading}
        hasUserPlans={userPlanProgress.length > 0}
        onMyPlansPress={() => router.push('/PlansTab')}
        onStartPress={(mode: string) => {
          if (isGuest) {
            router.push('/(auth)/signin');
            return;
          }

          if (mode === 'group') {
            router.push(`/devotional_detail/${planId}/start-date`);
            return;
          }

          if (existingSoloProgress) {
            router.push(`/plan_progress/${existingSoloProgress.id}`);
            return;
          }

          startPlanProgressMutation.mutate(
            { plan_id: planId, user_id: session?.user.id! },
            {
              onSuccess: (progressId) => router.push(`/plan_progress/${progressId}`),
            },
          );
        }}
      />
    </>
  );
}
