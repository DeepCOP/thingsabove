import {
  useDeleteAvatar,
  useProfile,
  useUpdateProfile,
  useUploadAvatar,
} from '@/src/hooks/useProfile';
import ProfileScreen from '@/src/screens/Profile';
import { useAuth } from '@/src/state/AuthContext';
import { useRouter } from 'expo-router';
import { Text, TouchableOpacity, View } from 'react-native';

export default function App() {
  const { session, signOut } = useAuth();
  const router = useRouter();
  const profileQuery = useProfile(session?.user?.id);
  const updateProfile = useUpdateProfile(session?.user?.id);
  const deleteAvatar = useDeleteAvatar(session?.user?.id);
  const uploadAvatar = useUploadAvatar(session?.user?.id);
  const onSignOut = async () => {
    await signOut();
  };
  return session && session.user ? (
    <ProfileScreen
      profile={profileQuery.data}
      onSignOut={onSignOut}
      onSetting={() => router.push('/settings')}
      onPrayerBoard={() =>
        router.navigate({
          pathname: '/(tabs)/CommunityTab',
          params: { section: 'prayer-requests' },
        })
      }
      handleUpdateProfile={updateProfile.mutate}
      handleUploadAvatar={uploadAvatar.mutate}
      uploading={uploadAvatar.isPending}
      updating={updateProfile.isPending}
      deleting={deleteAvatar.isPending}
      handleDeleteAvatar={deleteAvatar.mutate}
    />
  ) : (
    <View className="flex-1 items-center justify-center px-6 bg-white dark:bg-black">
      <Text className="text-2xl font-semibold mb-2 dark:text-white">Welcome 👋</Text>

      <Text className="text-center text-gray-600 dark:text-gray-400 mb-6">
        Sign in or create an account to access your profile and settings.
      </Text>

      <TouchableOpacity
        onPress={() => router.push('/(auth)/signin')}
        className="w-full bg-black dark:bg-white py-3 rounded-xl mb-3">
        <Text className="text-center text-white dark:text-black font-semibold">Sign In</Text>
      </TouchableOpacity>

      <TouchableOpacity
        onPress={() => router.push('/(auth)/signup')}
        className="w-full border border-black dark:border-white py-3 rounded-xl">
        <Text className="text-center font-semibold dark:text-white">Create Account</Text>
      </TouchableOpacity>
    </View>
  );
}
