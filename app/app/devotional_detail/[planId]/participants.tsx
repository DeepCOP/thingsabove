import LoadingSpinner from '@/src/components/LoadingSpinner';
import { usePlanGroupMembers } from '@/src/hooks/usePlanGroup';
import { useGroupPlanProgressList } from '@/src/hooks/usePlanProgress';
import ParticipantsScreen from '@/src/screens/ParticipantsScreen';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useMemo, useState } from 'react';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

export default function Participants() {
  const { planId, groupId, progressId, totalDays } = useLocalSearchParams<{
    planId: string;
    groupId: string;
    totalDays: string;
    progressId: string;
  }>();
  const router = useRouter();

  const planGroupMembersQuery = usePlanGroupMembers(groupId as string);
  const usersIds = useMemo(() => {
    return planGroupMembersQuery.data?.map((member) => member.user_id) || [];
  }, [planGroupMembersQuery.data]);
  const usersPlanProgresses = useGroupPlanProgressList(usersIds, groupId as string);
  const [refreshing, setRefreshing] = useState(false);

  const insets = useSafeAreaInsets();

  const onRefresh = async () => {
    setRefreshing(true);

    await planGroupMembersQuery.refetch();
    await usersPlanProgresses.refetch();

    setRefreshing(false);
  };

  if (planGroupMembersQuery.isLoading) {
    return (
      <LoadingSpinner style={{ marginTop: 30 }} ViewStyles={{ paddingBottom: insets.bottom }} />
    );
  }

  return (
    <ParticipantsScreen
      members={planGroupMembersQuery.data || []}
      totalDays={Number(totalDays)}
      progresses={usersPlanProgresses.data || []}
      refreshing={refreshing}
      onRefresh={onRefresh}
      onInvite={() =>
        router.push({
          pathname: '/app/devotional_detail/[planId]/invite-friends',
          params: {
            planId,
            groupId,
            progressId,
          },
        })
      }
    />
  );
}
