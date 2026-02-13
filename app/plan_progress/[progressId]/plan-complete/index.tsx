import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import PlanCompleteScreen from '@/src/screens/PlanCompleteScreen';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect, useRef, useState } from 'react';
import { Animated, Share } from 'react-native';

export default function PlanComplete() {
  const { planId } = useLocalSearchParams();
  const router = useRouter();
  const { data: plan } = useFetchDevotionalPlanById(planId as string);

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
      onBack={() => router.back()}
      onShare={async () => {
        const content = `Completed reading ${plan?.title}\n\n ${process.env.EXPO_PUBLIC_BASE_URL}/devotional_detail/${plan?.id}`;
        await Share.share({ message: content });
      }}
    />
  );
}
