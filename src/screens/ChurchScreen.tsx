import { useTranslation } from 'react-i18next';
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
  const { t } = useTranslation('community');
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
      Alert.alert(t('shareInviteError'), t('pleaseTryAgain'));
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
        Alert.alert(t('joinChurchError'), t('pleaseTryAgain'));
      },
    });
  };

  const handleJoinChurch = () => {
    if (!church || acceptChurchMutation.isPending) return;

    const currentChurchName = viewerProfileQuery.data?.church?.name;

    if (currentChurchName && viewerChurchId !== churchId) {
      Alert.alert(
        t('joinChurchConfirm'),
        t('churchSwitchDescription', { church: church.name, currentChurch: currentChurchName }),
        [
          { text: t('cancel'), style: 'cancel' },
          { text: t('joinChurch'), onPress: joinChurch },
        ],
      );
      return;
    }

    joinChurch();
  };

  const handleOpenMembers = () => {
    router.push(`/app/church/${churchId}/members` as Href);
  };

  const handleOpenMemberProfile = (userId: string) => {
    router.push(`/app/profile/${userId}` as Href);
  };

  const handleOpenPlan = (planId: string) => {
    router.push({
      pathname: '/app/devotional_detail/[planId]',
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
            title={t('churchDetailsError')}
            description={t('churchDetailsUnavailable')}
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
            title={t('churchNotFound')}
            description={t('churchNotFoundDescription')}
          />
        )}
      </View>

      <View className="mt-4 px-4">
        {analyticsQuery.isLoading ? (
          <ChurchStatGridSkeleton />
        ) : analyticsQuery.error ? (
          <ChurchSectionErrorCard
            title={t('churchStatsError')}
            description={t('churchStatsUnavailable')}
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
            title={t('snapshotError')}
            description={t('snapshotUnavailable')}
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
            title={t('topDevotionalsError')}
            description={t('topDevotionalsUnavailable')}
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
            title={t('membersError')}
            description={t('membersPreviewUnavailable')}
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
            title={t('recentActivityError')}
            description={t('recentActivityUnavailable')}
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
            title={t('churchActionsError')}
            description={t('churchActionsUnavailable')}
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
