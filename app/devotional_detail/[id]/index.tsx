import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { usePlanProgress, useUserPlanProgressList } from '@/src/hooks/usePlanProgress';
import DevotionalDetailScreen from '@/src/screens/DevotionalDetailScreen';
import { useAuth } from '@/src/state/AuthContext';
import { Ionicons } from '@expo/vector-icons';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { Share, TouchableOpacity, useColorScheme } from 'react-native';

export default function DevotionalDetail() {
  const { id } = useLocalSearchParams();
  const router = useRouter();
  const colorScheme = useColorScheme();
  const { isGuest, session } = useAuth();
  const { startPlanProgressMutation, planProgressQuery } = usePlanProgress(
    id as string,
    session?.user?.id,
  );
  const userPlanProgressQuery = useUserPlanProgressList(session?.user.id);
  const userPlanProgress = userPlanProgressQuery.data || [];

  const planQuery = useFetchDevotionalPlanById(id as string);
  const plan = planQuery.data;

  return (
    <>
      <Stack.Screen
        options={{
          headerRight: () => {
            return (
              <TouchableOpacity
                onPress={async () => {
                  const content = `Join me in reading ${plan?.title}\n\n ${process.env.EXPO_BASE_URL}/devotional_detail/${plan?.id}`;
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
        }}
      />
      <DevotionalDetailScreen
        plan={planQuery.data}
        isLoading={planQuery.isLoading || planProgressQuery.isLoading}
        hasUserPlans={userPlanProgress.length > 0}
        onMyPlansPress={() => router.push('/PlansTab')}
        onStartPress={(mode: string) => {
          if (isGuest) {
            router.push('/login/signin');
            return;
          }

          if (mode === 'group') {
            router.push(`/devotional_detail/${id}/start-date`);
            return;
          }

          if (planProgressQuery.data) {
            router.push(`/plan_progress/${planProgressQuery.data}`);
            return;
          }

          startPlanProgressMutation.mutate(
            { plan_id: id as string, user_id: session?.user.id! },
            {
              onSuccess: (progressId) => router.push(`/plan_progress/${progressId}`),
            },
          );
        }}
      />
    </>
  );
}
