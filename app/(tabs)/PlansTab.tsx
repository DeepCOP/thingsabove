import { useNotifications } from '@/src/hooks/useNotifications';
import PlansScreen from '@/src/screens/PlansScreen';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import { openExternalUrl } from '@/src/utils';
import { router } from 'expo-router';
import { useState } from 'react';

export default function PlansTab() {
  const { session } = useAuth();
  const [activeTab, setActiveTab] = useState<
    'my-plans' | 'saved-plans' | 'completed-plans' | 'find-plans'
  >('my-plans');
  const { notificationsCountQuery } = useNotifications(session?.user?.id);

  const { sort, setSort, isGrid, setIsGrid } = useAppStore();

  return (
    <PlansScreen
      isGrid={isGrid}
      sort={sort}
      activeTab={activeTab}
      isAuthenticated={!!session}
      onToggleGrid={() => setIsGrid(!isGrid)}
      onChangeTab={setActiveTab}
      onChangeSort={setSort}
      onSearch={() => router.push('/search/devotionals')}
      onNotifications={() => router.push('/notifications')}
      onPrayerBoard={() => router.push('/prayer')}
      notificationCount={notificationsCountQuery.data ?? 0}
      onLogin={() => router.push('/(auth)/signin')}
      onContribute={() => openExternalUrl(`${process.env.EXPO_PUBLIC_WEB_INTERFACE_URL}/plans/new`)}
    />
  );
}
