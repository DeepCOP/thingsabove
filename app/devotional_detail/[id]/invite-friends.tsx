import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { useCreatePlanGroup } from '@/src/hooks/useCreatePlanGroup';
import { useFriends } from '@/src/hooks/useFriends';
import { useInviteFriends } from '@/src/hooks/useInviteFriends';
import { usePlanGroupMembers } from '@/src/hooks/usePlanGroup';
import { useProfile } from '@/src/hooks/useProfile';
import { buildPlanInvitationMessage } from '@/src/lib/planShare';
import InviteFriendsScreen from '@/src/screens/InviteFriendsScreen';
import { useAuth } from '@/src/state/AuthContext';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useState } from 'react';
import { Alert, Share } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

const getInviterName = (firstName?: string | null, lastName?: string | null) => {
  const value = [firstName, lastName].filter(Boolean).join(' ').trim();
  return value || undefined;
};

export default function InviteFriends() {
  const { session } = useAuth();
  const { id, startDate, groupId, progressId } = useLocalSearchParams<{
    id: string;
    startDate?: string;
    groupId?: string;
    progressId?: string;
  }>();
  const router = useRouter();
  const [currentGroupId, setCurrentGroupId] = useState(groupId);
  const [currentProgressId, setCurrentProgressId] = useState(progressId);
  const [isSharing, setIsSharing] = useState(false);

  const friendsQuery = useFriends(session!.user.id);
  const planQuery = useFetchDevotionalPlanById(id as string);
  const viewerProfileQuery = useProfile(session?.user?.id);
  const inviteFriendsToExistingGroup = useInviteFriends(currentGroupId ?? '');
  const planGroupMembersQuery = usePlanGroupMembers(currentGroupId ?? '');
  const [selected, setSelected] = useState<string[]>([]);
  const insets = useSafeAreaInsets();
  const createPlanGroupMutation = useCreatePlanGroup();

  if (friendsQuery.isLoading || (!!groupId && planGroupMembersQuery.isLoading)) {
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

  const ensureGroupForShare = async () => {
    if (currentGroupId) {
      return currentGroupId;
    }

    if (!startDate || !session?.user?.id || !id) {
      throw new Error('Missing plan group details');
    }

    const progress = await createPlanGroupMutation.mutateAsync({
      plan_id: id,
      invited_user_ids: [],
      user_id: session.user.id,
      start_date: startDate,
    });

    if (!progress.group_id) {
      throw new Error('Unable to create a shareable plan group');
    }

    setCurrentGroupId(progress.group_id);
    setCurrentProgressId(progress.id);

    return progress.group_id;
  };

  const handleShareInviteLink = async () => {
    try {
      setIsSharing(true);
      const shareGroupId = await ensureGroupForShare();
      const inviterName = getInviterName(
        viewerProfileQuery.data?.first_name,
        viewerProfileQuery.data?.last_name,
      );

      await Share.share({
        message: buildPlanInvitationMessage({
          planId: id,
          groupId: shareGroupId,
          invitedBy: session?.user?.id,
          inviterName,
          planTitle: planQuery.data?.title,
        }),
      });
    } catch (error) {
      console.error('Error sharing plan invitation:', error);
      Alert.alert('Unable to share invite link', 'Please try again.');
    } finally {
      setIsSharing(false);
    }
  };

  return (
    <InviteFriendsScreen
      friends={friends}
      selected={selected}
      isSubmitting={isSubmitting}
      isSharing={isSharing || isSubmitting}
      onToggle={toggle}
      onSelectAll={() => setSelected(friends.map((f) => f.id))}
      onClearSelection={() => setSelected([])}
      onShareInviteLink={handleShareInviteLink}
      onAddFriend={() => router.push('/add_friend')}
      onSubmit={() => {
        if (currentGroupId) {
          inviteFriendsToExistingGroup.mutate(selected, {
            onSuccess: () => {
              if (!currentProgressId) {
                Alert.alert('Unable to open group plan', 'Please try again.');
                return;
              }

              router.replace({
                pathname: '/plan_progress/[progressId]',
                params: {
                  groupId: currentGroupId,
                  planId: id as string,
                  progressId: currentProgressId,
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
            onSuccess: (progress) => {
              setCurrentGroupId(progress.group_id ?? undefined);
              setCurrentProgressId(progress.id);
              router.replace({
                pathname: '/plan_progress/[progressId]',
                params: { progressId: progress.id },
              });
            },
          },
        );
      }}
    />
  );
}
