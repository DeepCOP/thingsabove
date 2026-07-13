import { useAppStore } from '@/src/state/useAppStore';
import { Redirect } from 'expo-router';

export default function Index() {
  const hasCompletedOnboarding = useAppStore((state) => state.hasCompletedOnboarding);

  return <Redirect href={hasCompletedOnboarding ? '/app/(tabs)/PlansTab' : '/app/onboarding'} />;
}
