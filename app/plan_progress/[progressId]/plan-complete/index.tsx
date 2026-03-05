import { upsertPlanRating } from '@/src/api/mutations';
import { fetchMyPlanRating } from '@/src/api/queries';
import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import PlanCompleteScreen from '@/src/screens/PlanCompleteScreen';
import { useAuth } from '@/src/state/AuthContext';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect, useRef, useState } from 'react';
import { Animated, Share } from 'react-native';

export default function PlanComplete() {
  const { planId } = useLocalSearchParams<{ planId?: string | string[] }>();
  const resolvedPlanId = Array.isArray(planId) ? planId[0] : planId;
  const router = useRouter();
  const { session } = useAuth();
  const userId = session?.user?.id;
  const qc = useQueryClient();
  const { data: plan } = useFetchDevotionalPlanById(resolvedPlanId ?? '');

  const progressAnim = useRef(new Animated.Value(0)).current;
  const [animationComplete, setAnimationComplete] = useState(false);
  const [selectedRating, setSelectedRating] = useState<number>(0);
  const ratingKey = ['plan-rating', resolvedPlanId ?? 'unknown', userId ?? 'guest'] as const;

  const planRatingQuery = useQuery({
    queryKey: ratingKey,
    enabled: !!resolvedPlanId && !!userId,
    queryFn: () => fetchMyPlanRating(resolvedPlanId!),
  });

  useEffect(() => {
    if (typeof planRatingQuery.data === 'number') {
      setSelectedRating(planRatingQuery.data);
    }
  }, [planRatingQuery.data]);

  const ratePlanMutation = useMutation({
    mutationFn: async (rating: number) => {
      if (!resolvedPlanId) return;
      await upsertPlanRating({ planId: resolvedPlanId, rating });
    },
    onMutate: async (rating: number) => {
      await qc.cancelQueries({ queryKey: ratingKey });
      const previous = qc.getQueryData<number | null>(ratingKey);
      qc.setQueryData(ratingKey, rating);
      setSelectedRating(rating);
      return { previous };
    },
    onError: (_error, _rating, context) => {
      if (!context) return;
      qc.setQueryData(ratingKey, context.previous ?? null);
      setSelectedRating(typeof context.previous === 'number' ? context.previous : 0);
    },
    onSettled: () => {
      qc.invalidateQueries({ queryKey: ratingKey });
    },
  });

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
      currentRating={selectedRating}
      ratingLoading={planRatingQuery.isLoading}
      ratingSaving={ratePlanMutation.isPending}
      onBack={() => router.back()}
      onRate={(rating) => {
        if (!resolvedPlanId || !userId) return;
        ratePlanMutation.mutate(rating);
      }}
      onShare={async () => {
        const content = `Completed reading ${plan?.title}\n\n ${process.env.EXPO_PUBLIC_BASE_URL}/devotional_detail/${plan?.id}`;
        await Share.share({ message: content });
      }}
    />
  );
}
