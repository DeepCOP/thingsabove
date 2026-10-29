import { useTranslation } from 'react-i18next';
import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { useStartPlanProgress } from '@/src/hooks/usePlanProgress';
import dayjs from '@/src/lib/dayjs';
import PickStartDateScreen from '@/src/screens/PickStartDateScreen';
import { useAuth } from '@/src/state/AuthContext';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useMemo, useState } from 'react';
import { ActivityIndicator, Alert, Text, View } from 'react-native';

const DATE_PAGE_SIZE = 14;

export default function PickStartDate() {
  const { t } = useTranslation('plans');
  const { planId, mode } = useLocalSearchParams<{
    planId: string;
    mode?: 'solo' | 'group';
  }>();

  const router = useRouter();
  const { isGuest, session } = useAuth();
  const [selectedDate, setSelectedDate] = useState(() => dayjs().startOf('day'));
  const [dateRangeStart, setDateRangeStart] = useState(() => dayjs().startOf('day'));
  const startPlanProgressMutation = useStartPlanProgress();
  const planQuery = useFetchDevotionalPlanById(planId);
  const plan = planQuery.data;
  const isSoloPlan = mode === 'solo';

  const dates = useMemo(
    () => Array.from({ length: DATE_PAGE_SIZE }, (_, i) => dateRangeStart.add(i, 'day')),
    [dateRangeStart],
  );

  const handleNext = () => {
    if (startPlanProgressMutation.isPending) return;

    if (isGuest || !session?.user.id) {
      router.push({
        pathname: '/app/signin',
        params: { returnTo: `/app/devotional_detail/${encodeURIComponent(planId)}` },
      });
      return;
    }

    const startDate = selectedDate.format('YYYY-MM-DD');
    if (!isSoloPlan) {
      router.replace({
        pathname: '/app/devotional_detail/[planId]/invite-friends',
        params: { planId, startDate },
      });
      return;
    }

    startPlanProgressMutation.mutate(
      { plan_id: planId, user_id: session.user.id, start_date: startDate },
      {
        onSuccess: (progress) => router.replace(`/app/plan_progress/${progress.id}`),
        onError: (error) => {
          Alert.alert(
            t('couldNotStart'),
            error instanceof Error ? error.message : t('pleaseTryAgain'),
          );
        },
      },
    );
  };

  if (planQuery.isLoading) {
    return <ActivityIndicator style={{ marginTop: 30 }} size="large" />;
  }

  if (planQuery.isError) {
    return (
      <View className="flex-1 items-center justify-center p-4">
        <Text className="text-center text-gray-700 dark:text-gray-300">
          {t('devotionalLoadError')}
        </Text>
      </View>
    );
  }

  if (!plan) {
    return (
      <View className="flex-1 items-center justify-center p-4">
        <Text className="text-center text-gray-700 dark:text-gray-300">
          {t('devotionalNotFound')}
        </Text>
      </View>
    );
  }

  return (
    <PickStartDateScreen
      coverImage={plan.cover_image}
      dates={dates}
      selectedDate={selectedDate}
      onSelectDate={setSelectedDate}
      onEarlierDates={() => setDateRangeStart((date) => date.subtract(DATE_PAGE_SIZE, 'day'))}
      onLaterDates={() => setDateRangeStart((date) => date.add(DATE_PAGE_SIZE, 'day'))}
      isSoloPlan={isSoloPlan}
      isSubmitting={startPlanProgressMutation.isPending}
      onNext={handleNext}
    />
  );
}
