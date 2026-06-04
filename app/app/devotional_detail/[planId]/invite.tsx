import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useAuth } from '@/src/state/AuthContext';
import { Href, useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect } from 'react';

export default function PlanInviteHandoff() {
  const { planId, groupId, invitedBy } = useLocalSearchParams<{
    planId: string;
    groupId: string;
    invitedBy?: string;
  }>();
  const { session, loading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (loading || !planId || !groupId) return;

    if (session) {
      router.replace({
        pathname: '/app/devotional_detail/[planId]/invitation',
        params: {
          planId,
          groupId,
          ...(invitedBy ? { invitedBy } : {}),
        },
      } as Href);
      return;
    }

    router.replace({
      pathname: '/app/(auth)/signin',
      params: {
        redirectPlanId: planId,
        redirectGroupId: groupId,
        ...(invitedBy ? { redirectInvitedBy: invitedBy } : {}),
      },
    } as Href);
  }, [loading, session, planId, groupId, invitedBy, router]);

  return <LoadingSpinner />;
}
