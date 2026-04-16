import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useAuth } from '@/src/state/AuthContext';
import { Href, useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect } from 'react';

export default function PlanInviteHandoff() {
  const { id, groupId, invitedBy } = useLocalSearchParams<{
    id: string;
    groupId: string;
    invitedBy?: string;
  }>();
  const { session, loading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (loading || !id || !groupId) return;

    if (session) {
      router.replace({
        pathname: '/devotional_detail/[id]/invitation',
        params: {
          id,
          groupId,
          ...(invitedBy ? { invitedBy } : {}),
        },
      } as Href);
      return;
    }

    router.replace({
      pathname: '/(auth)/signin',
      params: {
        redirectPlanId: id,
        redirectGroupId: groupId,
        ...(invitedBy ? { redirectInvitedBy: invitedBy } : {}),
      },
    } as Href);
  }, [loading, session, id, groupId, invitedBy]);

  return <LoadingSpinner />;
}
