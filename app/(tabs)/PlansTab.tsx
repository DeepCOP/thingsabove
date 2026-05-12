import { useNotifications } from '@/src/hooks/useNotifications';
import { useMyPlanProgressPlans } from '@/src/hooks/usePlanProgress';
import PlansScreen from '@/src/screens/PlansScreen';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import { openExternalUrl } from '@/src/utils';
import { router, useLocalSearchParams } from 'expo-router';
import { useEffect, useRef, useState } from 'react';

type PlansTabKey = 'my-plans' | 'private-plans' | 'saved-plans' | 'completed-plans' | 'find-plans';

const isPlansTabKey = (value: string | undefined): value is PlansTabKey => {
  return (
    value === 'my-plans' ||
    value === 'private-plans' ||
    value === 'saved-plans' ||
    value === 'completed-plans' ||
    value === 'find-plans'
  );
};

export default function PlansTab() {
  const { session } = useAuth();
  const { section } = useLocalSearchParams<{ section?: string | string[] }>();
  const requestedSection = Array.isArray(section) ? section[0] : section;
  const userId = session?.user?.id;
  const [activeTab, setActiveTab] = useState<PlansTabKey>('find-plans');
  const hasUserSelectedTabRef = useRef(false);
  const previousUserIdRef = useRef<string | undefined>(undefined);
  const { notificationsCountQuery } = useNotifications(userId);
  const myPlanProgressPlansQuery = useMyPlanProgressPlans(userId);

  const { sort, setSort, isGrid, setIsGrid } = useAppStore();

  useEffect(() => {
    if (previousUserIdRef.current === userId) return;

    previousUserIdRef.current = userId;
    hasUserSelectedTabRef.current = false;
    setActiveTab('find-plans');
  }, [userId]);

  useEffect(() => {
    if (!isPlansTabKey(requestedSection)) return;

    hasUserSelectedTabRef.current = true;
    setActiveTab(requestedSection);
  }, [requestedSection]);

  useEffect(() => {
    if (!userId || hasUserSelectedTabRef.current || activeTab !== 'find-plans') return;
    if (!myPlanProgressPlansQuery.isSuccess) return;

    const hasActivePlanProgress = (myPlanProgressPlansQuery.data ?? []).some((plan) => {
      const totalDays = typeof plan.total_days === 'number' ? plan.total_days : 0;
      return totalDays > 0 && (plan.completed_days ?? 0) < totalDays;
    });

    if (hasActivePlanProgress) {
      setActiveTab('my-plans');
    }
  }, [activeTab, myPlanProgressPlansQuery.data, userId]);

  const handleChangeTab = (tab: PlansTabKey) => {
    hasUserSelectedTabRef.current = true;
    setActiveTab(tab);
  };

  return (
    <PlansScreen
      isGrid={isGrid}
      sort={sort}
      activeTab={activeTab}
      isAuthenticated={!!session}
      onToggleGrid={() => setIsGrid(!isGrid)}
      onChangeTab={handleChangeTab}
      onChangeSort={setSort}
      onSearch={() => router.push('/search/devotionals')}
      onNotifications={() => router.push('/notifications')}
      onPrayerBoard={() =>
        router.navigate({
          pathname: '/(tabs)/CommunityTab',
          params: { section: 'prayer-board' },
        })
      }
      notificationCount={notificationsCountQuery.data ?? 0}
      onLogin={() => router.push('/(auth)/signin')}
      onContribute={() => openExternalUrl(`${process.env.EXPO_PUBLIC_WEB_INTERFACE_URL}/plans/new`)}
    />
  );
}
