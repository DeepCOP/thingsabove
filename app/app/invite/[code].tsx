import LoadingSpinner from '@/src/components/LoadingSpinner';
import { resolveInviteCode } from '@/src/api/inviteQueries';
import { useQuery } from '@tanstack/react-query';
import { Href, Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect } from 'react';
import { Text, TouchableOpacity, View } from 'react-native';

const getFirstParam = (value: string | string[] | undefined) =>
  Array.isArray(value) ? value[0] : value;

export default function InviteCodeHandoff() {
  const { code } = useLocalSearchParams<{ code?: string | string[] }>();
  const router = useRouter();
  const inviteCode = getFirstParam(code)?.trim().toLowerCase() ?? '';
  const inviteQuery = useQuery({
    queryKey: ['invite_redirect', inviteCode],
    enabled: !!inviteCode,
    queryFn: async () => await resolveInviteCode({ code: inviteCode }),
  });
  const invite = inviteQuery.data;

  useEffect(() => {
    if (!invite) return;

    if (invite.type === 'plan_group') {
      router.replace({
        pathname: '/app/devotional_detail/[planId]/invite',
        params: {
          planId: invite.plan_id,
          groupId: invite.group_id,
          invitedBy: invite.invited_by,
        },
      } as Href);
      return;
    }

    router.replace({
      pathname: '/app/church/[churchId]/invitation',
      params: {
        churchId: invite.church_id,
        invitedBy: invite.invited_by,
      },
    } as Href);
  }, [invite, router]);

  const hasLookupFailed = !inviteCode || inviteQuery.isError || (!inviteQuery.isLoading && !invite);

  if (hasLookupFailed) {
    return (
      <View className="flex-1 items-center justify-center bg-white px-6 dark:bg-black">
        <Stack.Screen options={{ title: 'Invitation' }} />
        <Text className="text-lg font-semibold text-gray-900 dark:text-white">
          Invite link not found
        </Text>
        <Text className="mt-2 text-center text-sm text-gray-600 dark:text-gray-400">
          This invite may be unavailable, expired, or typed incorrectly.
        </Text>
        <TouchableOpacity
          className="mt-5 rounded-full bg-black px-5 py-3 dark:bg-white"
          onPress={() => inviteQuery.refetch()}>
          <Text className="font-semibold text-white dark:text-black">Try again</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <>
      <Stack.Screen options={{ title: 'Invitation' }} />
      <LoadingSpinner />
    </>
  );
}
