import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { usePlanRating } from '@/src/hooks/usePlanReactions';
import PlanCompleteScreen from '@/src/screens/PlanCompleteScreen';
import { useAuth } from '@/src/state/AuthContext';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect, useRef, useState } from 'react';
import { Animated, Share } from 'react-native';

export default function PlanComplete() {
  const { planId } = useLocalSearchParams<{ planId?: string | string[] }>();
  const resolvedPlanId = Array.isArray(planId) ? planId[0] : planId;
  const router = useRouter();
  const { session } = useAuth();
  const userId = session?.user?.id;
  const { data: plan } = useFetchDevotionalPlanById(resolvedPlanId ?? '');
  const { currentRating, ratePlan, ratingLoading, ratingSaving } = usePlanRating(
    resolvedPlanId,
    userId,
  );

  const progressAnim = useRef(new Animated.Value(0)).current;
  const [animationComplete, setAnimationComplete] = useState(false);

  useEffect(() => {
    Animated.timing(progressAnim, {
      toValue: 1,
      duration: 1000,
      useNativeDriver: false,
    }).start(() => {
      setAnimationComplete(true);
    });
  }, [progressAnim]);

  return (
    <PlanCompleteScreen
      plan={plan}
      progressAnim={progressAnim}
      animationComplete={animationComplete}
      currentRating={currentRating}
      ratingLoading={ratingLoading}
      ratingSaving={ratingSaving}
      onBack={() => router.back()}
      onFindMorePlans={() =>
        router.replace({
          pathname: '/app/(tabs)/PlansTab',
          params: { section: 'find-plans' },
        })
      }
      onRate={ratePlan}
      onShare={async () => {
        const content = `Completed reading ${plan?.title}\n\n ${process.env.EXPO_PUBLIC_BASE_URL}/app/devotional_detail/${plan?.id}`;
        await Share.share({ message: content });
      }}
    />
  );
}
