import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { useAcceptPlanInvite } from '@/src/hooks/useInviteFriends';
import { usePlanGroup, usePlanGroupMembers } from '@/src/hooks/usePlanGroup';
import PlanInvitationScreen from '@/src/screens/PlanInvitationScreen';
import { useAuth } from '@/src/state/AuthContext';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import { useLocalSearchParams, useRouter } from 'expo-router';
import React from 'react';

dayjs.extend(utc);

export default function PlanInvitation() {
  const { groupId, id } = useLocalSearchParams<{
    groupId: string;
    invitedBy: string;
    id: string;
  }>();

  const { session, isGuest } = useAuth();
  const router = useRouter();

  const acceptMutation = useAcceptPlanInvite(groupId, id, session?.user?.id);

  const planGroupQuery = usePlanGroup(groupId);
  const planGroupMembersQuery = usePlanGroupMembers(groupId);
  const members = planGroupMembersQuery.data;
  const group = planGroupQuery.data;
  const planQuery = useFetchDevotionalPlanById(id as string);
  const plan = planQuery.data;
  const currentUser = members?.find((member) => member.user_id === session?.user?.id);
  if (planGroupQuery.isLoading || planQuery.isLoading) {
    return <LoadingSpinner />;
  }

  const today = dayjs().utc().startOf('day');
  const startDate = dayjs(group?.start_date);

  const diffDays = startDate.diff(today, 'day');
  const startDateLabel =
    diffDays > 0
      ? `Starts in ${diffDays} days (${startDate.format('MMM DD')})`
      : diffDays === 0
        ? 'Starts today'
        : `Started ${Math.abs(diffDays)} days ago`;

  return (
    <PlanInvitationScreen
      inviterName={`${group?.profiles?.first_name} ${group?.profiles?.last_name}`}
      inviterInitial={group?.profiles?.first_name?.[0] ?? 'U'}
      inviterAvatar={group?.profiles?.avatar_url}
      planTitle={plan?.title}
      planCover={plan?.cover_image}
      totalDays={plan?.total_days}
      members={members}
      diffDays={diffDays}
      startDateLabel={startDateLabel}
      hasAccepted={!!currentUser}
      isGuest={isGuest}
      isAccepting={acceptMutation.isPending}
      onAccept={() => {
        if (isGuest) {
          router.push('/login/signin');
          return;
        }

        acceptMutation.mutate(
          {
            startDate: group?.start_date ?? dayjs().utc().toISOString(),
          },
          {
            onSuccess: (progressId) => {
              router.replace({
                pathname: '/plan_progress/[progressId]',
                params: { progressId: progressId as string },
              });
            },
          },
        );
      }}
      onDecline={() => router.back()}
    />
  );
}
