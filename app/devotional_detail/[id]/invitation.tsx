import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { useAcceptPlanInvite } from '@/src/hooks/useInviteFriends';
import { usePlanGroup, usePlanGroupMembers } from '@/src/hooks/usePlanGroup';
import { useAuth } from '@/src/state/AuthContext';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import { useLocalSearchParams, useRouter } from 'expo-router';
import React from 'react';
import { Image, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

dayjs.extend(utc);

export default function PlanInvitation() {
  const { groupId, id } = useLocalSearchParams<{
    groupId: string;
    invitedBy: string;
    id: string;
  }>();

  const { session, isGuest } = useAuth();
  const router = useRouter();
  const insets = useSafeAreaInsets();

  const acceptInvitationMutation = useAcceptPlanInvite(groupId, id, session?.user?.id);

  const planGroupQuery = usePlanGroup(groupId);
  const planGroupMembersQuery = usePlanGroupMembers(groupId);
  const planGroupMembers = planGroupMembersQuery.data;
  const planGroup = planGroupQuery.data;
  const planQuery = useFetchDevotionalPlanById(id as string);
  const plan = planQuery.data;
  const currentUser = planGroupMembers?.find((member) => member.user_id === session?.user?.id);
  if (planGroupQuery.isLoading || planQuery.isLoading) {
    return <LoadingSpinner />;
  }

  const inviterInitial = planGroup?.profiles?.first_name?.[0] || 'U';
  const today = dayjs().utc().startOf('day');
  const startDate = dayjs(planGroup?.start_date);

  const diffDays = startDate.diff(today, 'day');

  return (
    <View className="flex-1 bg-white dark:bg-black px-6 pt-12">
      {/* Avatar */}
      {planGroup?.profiles?.avatar_url ? (
        <View className="items-center mb-6">
          <View className=" rounded-full border-2 dark:border-white border-black items-center justify-center">
            <Image
              source={{ uri: planGroup?.profiles?.avatar_url }}
              className="w-24 h-24 rounded-full"
              resizeMode="cover"
            />
          </View>
        </View>
      ) : (
        <View className="items-center mb-6">
          <View className="w-24 h-24 rounded-full border-2 dark:border-white border-black items-center justify-center">
            <Text className="dark:text-gray-200 text-gray-900 text-3xl font-bold">
              {inviterInitial}
            </Text>
          </View>
        </View>
      )}
      {/* Invitation text */}
      <Text className="text-center dark:text-white text-lg mb-6">
        <Text className="font-semibold">
          {planGroup?.profiles?.first_name} {planGroup?.profiles?.last_name}
        </Text>{' '}
        wants to read this Plan with you.
      </Text>

      {/* Plan Card */}
      <View className="dark:bg-neutral-800 bg-neutral-300 rounded-2xl overflow-hidden mb-10 p-4">
        {plan?.cover_image ? (
          <Image
            source={{ uri: plan?.cover_image }}
            className="w-full h-44 rounded-lg"
            resizeMode="cover"
          />
        ) : (
          <View className="w-full h-44 bg-gray-300 dark:bg-neutral-800" />
        )}

        <View>
          <Text className="dark:text-white text-lg font-semibold mb-1">{plan?.title}</Text>

          <Text className="dark:text-gray-400 text-sm mb-3">{plan?.total_days} Days</Text>

          {/* Participants */}
          <Text className="dark:text-gray-400 text-sm mb-1">Participants</Text>
          <View className="flex-row mb-3">
            {planGroupMembers?.slice(0, 3).map((m) => {
              if (m.profiles.avatar_url) {
                return (
                  <View
                    key={m.user_id}
                    className="rounded-full border dark:border-white mr-2 items-center justify-center">
                    <Image
                      source={{ uri: m.profiles.avatar_url }}
                      className="w-8 h-8 rounded-full"
                    />
                  </View>
                );
              }

              return (
                <View
                  key={m.user_id}
                  className="w-8 h-8 rounded-full border dark:border-white mr-2 items-center justify-center">
                  <Text className="dark:text-white text-xs">
                    {m.profiles?.first_name?.[0] ?? 'U'}
                  </Text>
                </View>
              );
            })}
          </View>

          {/* Start date */}
          <Text className="dark:text-gray-400 text-sm">
            {diffDays > 0 ? (
              <>
                Starts in{' '}
                <Text className="dark:text-white">
                  {diffDays} days ({startDate.format('MMM DD')})
                </Text>
              </>
            ) : diffDays === 0 ? (
              <Text className="dark:text-white">Starts today</Text>
            ) : (
              <Text className="dark:text-white">Started {Math.abs(diffDays)} days ago</Text>
            )}
          </Text>
        </View>
      </View>

      {/* Actions */}
      {!currentUser ? (
        <View
          className="absolute bottom-0 left-0 right-0 px-6"
          style={{ paddingBottom: insets.bottom + 20 }}>
          <TouchableOpacity
            onPress={() => {
              if (isGuest) {
                router.push({
                  pathname: '/login/signin',
                  params: { redirectTo: `/plan_progress/${id}` },
                });
                return;
              }

              acceptInvitationMutation.mutate(
                {
                  startDate: planGroup?.start_date || dayjs().utc().startOf('day').toISOString(),
                },
                {
                  onSuccess: (progressId) => {
                    router.replace({
                      pathname: `/plan_progress/[progressId]`,
                      params: { progressId: progressId as string },
                    });
                  },
                },
              );
            }}
            className="dark:bg-white bg-black py-4 rounded-full mb-3">
            <Text className="dark:text-black text-white text-center font-semibold text-lg">
              ACCEPT
            </Text>
          </TouchableOpacity>

          <TouchableOpacity
            onPress={() => router.back()}
            className="py-3 rounded-full bg-gray-300 dark:bg-neutral-600">
            <Text className="text-center dark:text-white text-black text-lg">DECLINE</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <View className=" px-6" style={{ paddingBottom: insets.bottom + 20 }}>
          <Text className="text-center dark:text-white text-black text-lg rounded-full bg-gray-300 dark:bg-neutral-600">
            You Have Accepted The Invitation
          </Text>
        </View>
      )}
    </View>
  );
}
