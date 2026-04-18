import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useProfile } from '@/src/hooks/useProfile';
import PublicProfileScreen from '@/src/screens/PublicProfileScreen';
import { useAuth } from '@/src/state/AuthContext';
import { Href, useLocalSearchParams, useRouter } from 'expo-router';
import { Text, TouchableOpacity, View } from 'react-native';

export default function PublicProfileRoute() {
  const { userId } = useLocalSearchParams<{ userId: string }>();
  const router = useRouter();
  const { session } = useAuth();
  const profileQuery = useProfile(userId);
  const viewerProfileQuery = useProfile(session?.user?.id);

  if (profileQuery.isLoading || viewerProfileQuery.isLoading) {
    return <LoadingSpinner style={{ marginTop: 30 }} />;
  }

  if (profileQuery.error || !profileQuery.data || viewerProfileQuery.error) {
    return (
      <View className="flex-1 items-center justify-center bg-white px-6 dark:bg-black">
        <Text className="text-lg font-semibold text-gray-900 dark:text-white">
          Unable to load profile
        </Text>
        <Text className="mt-2 text-center text-sm text-gray-600 dark:text-gray-400">
          Please try again. We could not load this profile right now.
        </Text>
        <TouchableOpacity
          className="mt-5 rounded-full bg-black px-5 py-3 dark:bg-white"
          onPress={() => {
            profileQuery.refetch();
            viewerProfileQuery.refetch();
          }}>
          <Text className="font-semibold text-white dark:text-black">Try again</Text>
        </TouchableOpacity>
      </View>
    );
  }

  const viewerChurchId = viewerProfileQuery.data?.church?.id ?? null;
  const profileChurchId = profileQuery.data.church?.id ?? null;

  return (
    <PublicProfileScreen
      profile={profileQuery.data}
      isCurrentUser={session?.user?.id === profileQuery.data.id}
      canOpenChurch={Boolean(
        viewerChurchId && profileChurchId && viewerChurchId === profileChurchId,
      )}
      onOpenChurch={
        viewerChurchId && profileChurchId && viewerChurchId === profileChurchId
          ? () => router.push(`/church/${profileChurchId}` as Href)
          : undefined
      }
    />
  );
}
