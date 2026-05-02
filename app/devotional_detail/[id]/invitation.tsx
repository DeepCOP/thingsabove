import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { useAcceptPlanInvite, useDeclinePlanInvite } from '@/src/hooks/useInviteFriends';
import { usePlanGroupInvitation, usePlanGroupInvitationMembers } from '@/src/hooks/usePlanGroup';
import { useMyPlanProgressPlans } from '@/src/hooks/usePlanProgress';
import dayjs from '@/src/lib/dayjs';
import PlanInvitationScreen from '@/src/screens/PlanInvitationScreen';
import { useAuth } from '@/src/state/AuthContext';
import Ionicons from '@expo/vector-icons/Ionicons';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import React from 'react';
import { Text, TouchableOpacity, View, useColorScheme } from 'react-native';

export default function PlanInvitation() {
  const { groupId, id } = useLocalSearchParams<{
    groupId: string;
    invitedBy?: string;
    id: string;
  }>();
  const { session, isGuest, loading: authLoading } = useAuth();
  const router = useRouter();
  const colorScheme = useColorScheme();

  const acceptMutation = useAcceptPlanInvite(groupId, id, session?.user?.id);
  const declineMutation = useDeclinePlanInvite(groupId, session?.user?.id);
  const myPlanProgressPlansQuery = useMyPlanProgressPlans(session?.user?.id);

  const planGroupQuery = usePlanGroupInvitation(groupId);
  const planGroupMembersQuery = usePlanGroupInvitationMembers(groupId);
  const members = planGroupMembersQuery.data ?? [];
  const group = planGroupQuery.data;
  const planQuery = useFetchDevotionalPlanById(id as string);
  const plan = planQuery.data;
  const currentUser = members?.find((member) => member.user_id === session?.user?.id);
  const existingProgress = myPlanProgressPlansQuery.data?.find(
    (progress) => progress.group_id === groupId && progress.id === id,
  );
  const handleLeaveInvitation = () => {
    if (router.canGoBack()) {
      router.back();
      return;
    }

    router.replace('/(tabs)/PlansTab');
  };

  if (authLoading || planGroupQuery.isLoading || planQuery.isLoading) {
    return <LoadingSpinner />;
  }

  if (planGroupQuery.error || planQuery.error || !group) {
    return (
      <View className="flex-1 items-center justify-center bg-white px-6 dark:bg-black">
        <Text className="text-lg font-semibold text-gray-900 dark:text-white">
          Unable to load invitation
        </Text>
        <Text className="mt-2 text-center text-sm text-gray-600 dark:text-gray-400">
          This invitation may be unavailable, expired, or the group could not be found.
        </Text>
        <TouchableOpacity
          className="mt-5 rounded-full bg-black px-5 py-3 dark:bg-white"
          onPress={() => {
            planGroupQuery.refetch();
            planGroupMembersQuery.refetch();
            planQuery.refetch();
          }}>
          <Text className="font-semibold text-white dark:text-black">Try again</Text>
        </TouchableOpacity>
      </View>
    );
  }

  const today = dayjs().startOf('day');
  const startDate = group?.start_date ? dayjs(group.start_date).startOf('day') : today;

  const diffDays = startDate.diff(today, 'day');
  const startDateLabel =
    diffDays > 0
      ? `Starts in ${diffDays} days (${startDate.format('MMM DD')})`
      : diffDays === 0
        ? 'Starts today'
        : `Started ${Math.abs(diffDays)} days ago`;

  return (
    <>
      <Stack.Screen
        options={{
          title: 'Invitation',
          headerBackVisible: false,
          headerLeft: () => (
            <TouchableOpacity
              accessibilityRole="button"
              accessibilityLabel="Leave invitation"
              className="h-10 w-10 items-center justify-center"
              onPress={handleLeaveInvitation}>
              <Ionicons
                name="chevron-back"
                size={28}
                color={colorScheme === 'dark' ? '#fff' : '#111'}
              />
            </TouchableOpacity>
          ),
        }}
      />
      <PlanInvitationScreen
        firstName={group.inviter.first_name ?? ''}
        lastName={group.inviter.last_name ?? ''}
        inviterAvatar={group.inviter.avatar_url}
        planTitle={plan?.title ?? undefined}
        planCover={plan?.cover_image}
        totalDays={plan?.total_days ?? undefined}
        members={members}
        diffDays={diffDays}
        startDateLabel={startDateLabel}
        hasAccepted={!!currentUser}
        isGuest={isGuest}
        isAccepting={acceptMutation.isPending}
        isDeclining={declineMutation.isPending}
        isContinuing={myPlanProgressPlansQuery.isLoading}
        onAccept={() => {
          if (isGuest) {
            router.push('/(auth)/signin');
            return;
          }

          acceptMutation.mutate(
            {
              startDate: group?.start_date ?? dayjs().format('YYYY-MM-DD'),
            },
            {
              onSuccess: (progress) => {
                if (!progress) return;
                router.replace({
                  pathname: '/plan_progress/[progressId]',
                  params: { progressId: progress.id },
                });
              },
            },
          );
        }}
        onContinue={
          existingProgress?.progress_id
            ? () => {
                router.push({
                  pathname: '/plan_progress/[progressId]',
                  params: { progressId: existingProgress.progress_id },
                });
              }
            : undefined
        }
        onDecline={() => {
          if (isGuest) {
            handleLeaveInvitation();
            return;
          }

          declineMutation.mutate(undefined, {
            onSuccess: () => {
              handleLeaveInvitation();
            },
          });
        }}
      />
    </>
  );
}
