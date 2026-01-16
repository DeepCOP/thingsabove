import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useCreatePlanGroup } from '@/src/hooks/useCreatePlanGroup';
import { useFriends } from '@/src/hooks/useFriends';
import { useInviteFriends } from '@/src/hooks/useInviteFriends';
import { usePlanGroupMembers } from '@/src/hooks/usePlanGroup';
import InviteFriendsScreen from '@/src/screens/InviteFriendsScreen';
import { useAuth } from '@/src/state/AuthContext';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useState } from 'react';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

export default function InviteFriends() {
  const { session } = useAuth();
  const { id, startDate, groupId, progressId } = useLocalSearchParams();
  const router = useRouter();

  const friendsQuery = useFriends(session!.user.id);
  const inviteFriendsToExistingGroup = useInviteFriends(groupId as string);
  const planGroupMembersQuery = usePlanGroupMembers(groupId as string);
  const [selected, setSelected] = useState<string[]>([]);
  const insets = useSafeAreaInsets();
  const createPlanGroupMutation = useCreatePlanGroup();
  if (friendsQuery.isLoading || planGroupMembersQuery.isLoading) {
    return (
      <LoadingSpinner style={{ marginTop: 30 }} ViewStyles={{ paddingBottom: insets.bottom }} />
    );
  }
  const friends =
    friendsQuery.data?.filter((friend) => {
      return !planGroupMembersQuery.data?.some((member) => member.user_id === friend.id);
    }) || [];

  const toggle = (id: string) => {
    setSelected((prev) => (prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]));
  };

  const isSubmitting = inviteFriendsToExistingGroup.isPending || createPlanGroupMutation.isPending;
  return (
    <InviteFriendsScreen
      friends={friends}
      selected={selected}
      isSubmitting={isSubmitting}
      onToggle={toggle}
      onSelectAll={() => setSelected(friends.map((f) => f.id))}
      onClearSelection={() => setSelected([])}
      onAddFriend={() => router.push('/add_friend')}
      onSubmit={() => {
        if (groupId) {
          inviteFriendsToExistingGroup.mutate(selected, {
            onSuccess: () => {
              router.replace({
                pathname: '/plan_progress/[progressId]',
                params: {
                  groupId,
                  planId: id as string,
                  progressId: progressId as string,
                },
              });
            },
          });
          return;
        }

        createPlanGroupMutation.mutate(
          {
            plan_id: id as string,
            invited_user_ids: selected,
            user_id: session?.user?.id as string,
            start_date: startDate as string,
          },
          {
            onSuccess: (newProgressId) => {
              router.replace({
                pathname: '/plan_progress/[progressId]',
                params: { progressId: newProgressId as string },
              });
            },
          },
        );
      }}
    />
  );
}
