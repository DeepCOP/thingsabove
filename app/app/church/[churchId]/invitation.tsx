import ChurchHeader from '@/src/components/church/ChurchHeader';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useChurch } from '@/src/hooks/useChurch';
import { useAcceptChurchInvite } from '@/src/hooks/useChurchInvitation';
import { useProfile } from '@/src/hooks/useProfile';
import ChurchInvitationScreen from '@/src/screens/ChurchInvitationScreen';
import { useAuth } from '@/src/state/AuthContext';
import { Href, Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { Text, TouchableOpacity, View } from 'react-native';

export default function ChurchInvitationRoute() {
  const { churchId, invitedBy } = useLocalSearchParams<{ churchId: string; invitedBy?: string }>();
  const router = useRouter();
  const { session, isGuest } = useAuth();

  const churchQuery = useChurch(churchId);
  const inviterQuery = useProfile(invitedBy);
  const viewerProfileQuery = useProfile(session?.user?.id);
  const acceptMutation = useAcceptChurchInvite(churchId, session?.user?.id);
  const headerTitle = churchQuery.data?.name ?? 'Church Invitation';

  const handleBackPress = () => {
    if (router.canGoBack()) {
      router.back();
      return;
    }

    router.replace('/app' as Href);
  };

  if (
    churchQuery.isLoading ||
    (Boolean(invitedBy) && inviterQuery.isLoading) ||
    (!isGuest && viewerProfileQuery.isLoading)
  ) {
    return (
      <>
        <Stack.Screen options={{ headerShown: false }} />
        <View className="flex-1 bg-white dark:bg-black">
          <ChurchHeader title={headerTitle} onBackPress={handleBackPress} />
          <LoadingSpinner style={{ marginTop: 30 }} />
        </View>
      </>
    );
  }

  if (churchQuery.error || !churchQuery.data || inviterQuery.error || viewerProfileQuery.error) {
    return (
      <>
        <Stack.Screen options={{ headerShown: false }} />
        <View className="flex-1 bg-white dark:bg-black">
          <ChurchHeader title={headerTitle} onBackPress={handleBackPress} />
          <View className="flex-1 items-center justify-center px-6">
            <Text className="text-lg font-semibold text-gray-900 dark:text-white">
              Unable to load invitation
            </Text>
            <Text className="mt-2 text-center text-sm text-gray-600 dark:text-gray-400">
              Please try opening the invite again.
            </Text>
            <TouchableOpacity
              className="mt-5 rounded-full bg-black px-5 py-3 dark:bg-white"
              onPress={() => router.replace('/app' as Href)}>
              <Text className="font-semibold text-white dark:text-black">Go home</Text>
            </TouchableOpacity>
          </View>
        </View>
      </>
    );
  }

  const viewerProfile = viewerProfileQuery.data ?? null;
  const hasAccepted = viewerProfile?.church?.id === churchId;
  const onInviterPress = (userId: string) => {
    router.push(`/app/profile/${userId}` as Href);
  };

  return (
    <>
      <Stack.Screen options={{ headerShown: false }} />
      <View className="flex-1 bg-white dark:bg-black">
        <ChurchHeader title={headerTitle} onBackPress={handleBackPress} />
        <ChurchInvitationScreen
          church={churchQuery.data}
          inviter={inviterQuery.data ?? null}
          viewerProfile={viewerProfile}
          hasAccepted={hasAccepted}
          isGuest={isGuest}
          isAccepting={acceptMutation.isPending}
          onAccept={() => {
            acceptMutation.mutate(undefined, {
              onSuccess: () => {
                router.replace(`/app/church/${churchId}` as Href);
              },
            });
          }}
          onSignIn={() => router.push('/app/(auth)/signin')}
          onCreateAccount={() => router.push('/app/signup')}
          onOpenChurch={() => router.replace(`/app/church/${churchId}` as Href)}
          onInviterPress={onInviterPress}
        />
      </View>
    </>
  );
}
