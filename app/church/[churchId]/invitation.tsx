import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useChurch } from '@/src/hooks/useChurch';
import { useAcceptChurchInvite } from '@/src/hooks/useChurchInvitation';
import { useProfile } from '@/src/hooks/useProfile';
import ChurchInvitationScreen from '@/src/screens/ChurchInvitationScreen';
import { useAuth } from '@/src/state/AuthContext';
import { Ionicons } from '@expo/vector-icons';
import { Href, Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { Text, TouchableOpacity, View, useColorScheme } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type ChurchHeaderProps = {
  title: string;
  topInset: number;
  onBackPress: () => void;
};

function ChurchHeader({ title, topInset, onBackPress }: ChurchHeaderProps) {
  const colorScheme = useColorScheme();
  const isDark = colorScheme === 'dark';
  const backIconColor = isDark ? '#f9fafb' : '#111827';

  return (
    <View
      className="border-b border-gray-200 bg-white px-4 pb-3 dark:border-neutral-900 dark:bg-black"
      style={{ paddingTop: topInset + 8 }}>
      <View className="relative flex-row items-center justify-center">
        <TouchableOpacity
          accessibilityLabel="Go back"
          accessibilityRole="button"
          className="absolute left-0 z-10 h-10 w-10 items-center justify-center rounded-full bg-gray-100 dark:bg-neutral-900"
          onPress={onBackPress}>
          <Ionicons name="chevron-back" size={22} color={backIconColor} />
        </TouchableOpacity>

        <View className="min-h-10 max-w-[70%] justify-center">
          <Text
            className="text-center text-lg font-semibold text-gray-900 dark:text-white"
            numberOfLines={1}>
            {title}
          </Text>
        </View>
      </View>
    </View>
  );
}

export default function ChurchInvitationRoute() {
  const { churchId, invitedBy } = useLocalSearchParams<{ churchId: string; invitedBy?: string }>();
  const router = useRouter();
  const insets = useSafeAreaInsets();
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

    router.replace('/' as Href);
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
          <ChurchHeader title={headerTitle} topInset={insets.top} onBackPress={handleBackPress} />
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
          <ChurchHeader title={headerTitle} topInset={insets.top} onBackPress={handleBackPress} />
          <View className="flex-1 items-center justify-center px-6">
            <Text className="text-lg font-semibold text-gray-900 dark:text-white">
              Unable to load invitation
            </Text>
            <Text className="mt-2 text-center text-sm text-gray-600 dark:text-gray-400">
              Please try opening the invite again.
            </Text>
            <TouchableOpacity
              className="mt-5 rounded-full bg-black px-5 py-3 dark:bg-white"
              onPress={() => router.replace('/' as Href)}>
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
    router.push(`/profile/${userId}` as Href);
  };

  return (
    <>
      <Stack.Screen options={{ headerShown: false }} />
      <View className="flex-1 bg-white dark:bg-black">
        <ChurchHeader title={headerTitle} topInset={insets.top} onBackPress={handleBackPress} />
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
                router.replace(`/church/${churchId}` as Href);
              },
            });
          }}
          onSignIn={() => router.push('/(auth)/signin')}
          onCreateAccount={() => router.push('/(auth)/signup')}
          onOpenChurch={() => router.replace(`/church/${churchId}` as Href)}
          onInviterPress={onInviterPress}
        />
      </View>
    </>
  );
}
