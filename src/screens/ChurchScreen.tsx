import ChurchActionsCard from '@/src/components/church/ChurchActionsCard';
import ChurchHeroCard from '@/src/components/church/ChurchHeroCard';
import ChurchMembersPreview from '@/src/components/church/ChurchMembersPreview';
import {
  ChurchCardSkeleton,
  ChurchHeroCardSkeleton,
  ChurchMembersPreviewSkeleton,
  ChurchSectionErrorCard,
  ChurchStatGridSkeleton,
  ChurchTopPlansListSkeleton,
} from '@/src/components/church/ChurchSectionStates';
import ChurchSnapshotCard from '@/src/components/church/ChurchSnapshotCard';
import ChurchStatGrid from '@/src/components/church/ChurchStatGrid';
import ChurchTopPlansList from '@/src/components/church/ChurchTopPlansList';
import { getOrCreateChurchInviteCode } from '@/src/api/churchQueries';
import { useChurch } from '@/src/hooks/useChurch';
import { useChurchAnalytics } from '@/src/hooks/useChurchAnalytics';
import { useAcceptChurchInvite } from '@/src/hooks/useChurchInvitation';
import { useChurchMembers } from '@/src/hooks/useChurchMembers';
import { useProfile } from '@/src/hooks/useProfile';
import { buildChurchInvitationMessage, buildChurchShareMessage } from '@/src/lib/churchShare';
import { useAuth } from '@/src/state/AuthContext';
import { Href, useRouter } from 'expo-router';
import { useState } from 'react';
import { Alert, ScrollView, Share, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import ChurchRecentActivityCard from '../components/church/ChurchRecentActivityCard';
import { openExternalUrl } from '../utils';

type Props = {
  churchId: string;
};

const getInviterName = (firstName?: string | null, lastName?: string | null) => {
  const value = [firstName, lastName].filter(Boolean).join(' ').trim();
  return value || undefined;
};

export default function ChurchScreen({ churchId }: Props) {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const { session } = useAuth();
  const [isSharingInvite, setIsSharingInvite] = useState(false);

  const viewerProfileQuery = useProfile(session?.user?.id);
  const viewerChurchId = viewerProfileQuery.data?.church?.id ?? null;
  const canInviteMembers = viewerChurchId === churchId;
  const canShowMembershipAction =
    Boolean(viewerProfileQuery.data && churchId) && !viewerProfileQuery.error;
  const churchQuery = useChurch(churchId);
  const analyticsQuery = useChurchAnalytics(churchId);
  const { membersQuery, members } = useChurchMembers(churchId);
  const acceptChurchMutation = useAcceptChurchInvite(churchId, session?.user?.id);

  const church = churchQuery.data;
  const stats = analyticsQuery.data?.stats;
  const topPlans = analyticsQuery.data?.topPlans ?? [];
  const membersPreview = members.slice(0, 4);

  const handleShareChurch = async () => {
    if (!church) return;
    await Share.share({ message: buildChurchShareMessage(church) });
  };

  const handleOpenWebsite = async () => {
    if (!church?.website_url) return;
    await openExternalUrl(church.website_url);
  };

  const handleInviteMembers = async () => {
    if (!canInviteMembers || !church) return;

    try {
      setIsSharingInvite(true);
      const inviteCode = await getOrCreateChurchInviteCode({ churchId });

      await Share.share({
        message: buildChurchInvitationMessage({
          church,
          invitedBy: session?.user?.id,
          inviteCode,
          inviterName: getInviterName(
            viewerProfileQuery.data?.first_name,
            viewerProfileQuery.data?.last_name,
          ),
        }),
      });
    } catch (error) {
      console.error('Error sharing church invitation:', error);
      Alert.alert('Unable to share invite link', 'Please try again.');
    } finally {
      setIsSharingInvite(false);
    }
  };

  const joinChurch = () => {
    acceptChurchMutation.mutate(undefined, {
      onSuccess: () => {
        viewerProfileQuery.refetch();
        analyticsQuery.refetch();
        membersQuery.refetch();
      },
      onError: () => {
        Alert.alert('Unable to join church', 'Please try again.');
      },
    });
  };

  const handleJoinChurch = () => {
    if (!church || acceptChurchMutation.isPending) return;

    const currentChurchName = viewerProfileQuery.data?.church?.name;

    if (currentChurchName && viewerChurchId !== churchId) {
      Alert.alert(
        'Join this church?',
        `Joining ${church.name} will update the church on your profile from ${currentChurchName}.`,
        [
          { text: 'Cancel', style: 'cancel' },
          { text: 'Join Church', onPress: joinChurch },
        ],
      );
      return;
    }

    joinChurch();
  };

  const handleOpenMembers = () => {
    router.push(`/church/${churchId}/members` as Href);
  };

  const handleOpenMemberProfile = (userId: string) => {
    router.push(`/profile/${userId}` as Href);
  };

  const handleOpenPlan = (planId: string) => {
    router.push({
      pathname: '/devotional_detail/[planId]',
      params: { planId },
    });
  };

  return (
    <ScrollView
      className="flex-1 bg-white dark:bg-black"
      contentContainerStyle={{
        paddingTop: 16,
        paddingBottom: insets.bottom + 24,
      }}
      showsVerticalScrollIndicator={false}>
      <View className="px-4">
        {churchQuery.isLoading ? (
          <ChurchHeroCardSkeleton />
        ) : churchQuery.error ? (
          <ChurchSectionErrorCard
            title="Unable to load church details"
            description="We could not load the church information right now."
            onRetry={() => churchQuery.refetch()}
          />
        ) : church ? (
          <ChurchHeroCard
            church={church}
            memberCount={stats?.memberCount}
            onOpenWebsite={handleOpenWebsite}
          />
        ) : (
          <ChurchSectionErrorCard
            title="Church not found"
            description="This church could not be found."
          />
        )}
      </View>

      <View className="mt-4 px-4">
        {analyticsQuery.isLoading ? (
          <ChurchStatGridSkeleton />
        ) : analyticsQuery.error ? (
          <ChurchSectionErrorCard
            title="Unable to load church stats"
            description="We could not load the church stats right now."
            onRetry={() => analyticsQuery.refetch()}
          />
        ) : stats ? (
          <ChurchStatGrid stats={stats} />
        ) : null}
      </View>

      <View className="mt-6 px-4">
        {analyticsQuery.isLoading ? (
          <ChurchCardSkeleton rows={2} />
        ) : analyticsQuery.error ? (
          <ChurchSectionErrorCard
            title="Unable to load the snapshot"
            description="The church snapshot is unavailable right now."
            onRetry={() => analyticsQuery.refetch()}
          />
        ) : stats ? (
          <ChurchSnapshotCard stats={stats} />
        ) : null}
      </View>

      <View className="mt-6 px-4">
        {analyticsQuery.isLoading ? (
          <ChurchTopPlansListSkeleton />
        ) : analyticsQuery.error ? (
          <ChurchSectionErrorCard
            title="Unable to load top devotionals"
            description="We could not load the top devotional activity right now."
            onRetry={() => analyticsQuery.refetch()}
          />
        ) : (
          <ChurchTopPlansList plans={topPlans} onPlanPress={handleOpenPlan} />
        )}
      </View>

      <View className="mt-6 px-4">
        {membersQuery.isLoading ? (
          <ChurchMembersPreviewSkeleton />
        ) : membersQuery.error ? (
          <ChurchSectionErrorCard
            title="Unable to load members"
            description="We could not load the member preview right now."
            onRetry={() => membersQuery.refetch()}
          />
        ) : (
          <ChurchMembersPreview
            members={membersPreview}
            onSeeAll={handleOpenMembers}
            onMemberPress={handleOpenMemberProfile}
          />
        )}
      </View>

      <View className="mt-6 px-4">
        {analyticsQuery.isLoading ? (
          <ChurchCardSkeleton rows={2} />
        ) : analyticsQuery.error ? (
          <ChurchSectionErrorCard
            title="Unable to load recent activity"
            description="Recent church activity is unavailable right now."
            onRetry={() => analyticsQuery.refetch()}
          />
        ) : stats ? (
          <ChurchRecentActivityCard stats={stats} />
        ) : null}
      </View>

      <View className="mt-6 px-4">
        {churchQuery.isLoading ? (
          <ChurchCardSkeleton rows={3} />
        ) : churchQuery.error ? (
          <ChurchSectionErrorCard
            title="Unable to load church actions"
            description="The church actions are unavailable right now."
            onRetry={() => churchQuery.refetch()}
          />
        ) : church ? (
          <ChurchActionsCard
            canOpenWebsite={Boolean(church.website_url)}
            isInviting={isSharingInvite}
            isJoining={acceptChurchMutation.isPending}
            onInvitePress={
              canShowMembershipAction && canInviteMembers ? handleInviteMembers : undefined
            }
            onJoinPress={
              canShowMembershipAction && !canInviteMembers ? handleJoinChurch : undefined
            }
            onSharePress={handleShareChurch}
            onOpenWebsitePress={handleOpenWebsite}
          />
        ) : null}
      </View>
    </ScrollView>
  );
}
