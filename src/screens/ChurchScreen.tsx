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
import { useChurchAnalytics } from '@/src/hooks/useChurchAnalytics';
import { useChurch } from '@/src/hooks/useChurch';
import { useChurchMembers } from '@/src/hooks/useChurchMembers';
import { useProfile } from '@/src/hooks/useProfile';
import { useAuth } from '@/src/state/AuthContext';
import { Href, useRouter } from 'expo-router';
import { ScrollView, Share, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import ChurchRecentActivityCard from '../components/church/ChurchRecentActivityCard';
import { openExternalUrl } from '../utils';

type Props = {
  churchId: string;
};

export default function ChurchScreen({ churchId }: Props) {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const { session } = useAuth();

  const viewerProfileQuery = useProfile(session?.user?.id);
  const viewerChurchId = viewerProfileQuery.data?.church?.id ?? null;
  const canInviteMembers = viewerChurchId === churchId;
  const churchQuery = useChurch(churchId);
  const analyticsQuery = useChurchAnalytics(churchId);
  const { membersQuery, members } = useChurchMembers(churchId);

  const church = churchQuery.data;
  const stats = analyticsQuery.data?.stats;
  const topPlans = analyticsQuery.data?.topPlans ?? [];
  const membersPreview = members.slice(0, 4);

  const handleShareChurch = async () => {
    if (!church) return;

    const websiteLine = church.website_url ? `\n${church.website_url}` : '';
    await Share.share({
      message: `Join ${church.name} on ThingsAbove.${websiteLine}`,
    });
  };

  const handleOpenWebsite = async () => {
    if (!church?.website_url) return;
    await openExternalUrl(church.website_url);
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
            onInvitePress={canInviteMembers ? handleShareChurch : undefined}
            onSharePress={handleShareChurch}
            onOpenWebsitePress={handleOpenWebsite}
          />
        ) : null}
      </View>
    </ScrollView>
  );
}
