import PlansScreen from '@/src/screens/PlansScreen';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import { router } from 'expo-router';
import { useState } from 'react';

export default function PlansTab() {
  const { session } = useAuth();
  const [activeTab, setActiveTab] = useState<'my-plans' | 'find-plans'>('my-plans');

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
      onLogin={() => router.push('/(auth)/signin')}
      onSetting={() => router.push('/settings')}
    />
  );
}
