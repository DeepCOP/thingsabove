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
  const targetUserProfile = useProfile(userId);

  if (targetUserProfile.isLoading) {
    return <LoadingSpinner style={{ marginTop: 30 }} />;
  }

  if (targetUserProfile.error || !targetUserProfile.data) {
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
            targetUserProfile.refetch();
          }}>
          <Text className="font-semibold text-white dark:text-black">Try again</Text>
        </TouchableOpacity>
      </View>
    );
  }

  const profileChurchId = targetUserProfile.data.church?.id ?? null;

  return (
    <PublicProfileScreen
      profile={targetUserProfile.data}
      isCurrentUser={session?.user?.id === targetUserProfile.data.id}
      canOpenChurch={Boolean(profileChurchId)}
      onOpenChurch={
        profileChurchId ? () => router.push(`/church/${profileChurchId}` as Href) : undefined
      }
    />
  );
}
