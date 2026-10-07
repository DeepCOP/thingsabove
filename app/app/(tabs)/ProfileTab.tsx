import LanguageSelector from '@/src/components/LanguageSelector';
import { useTranslation } from 'react-i18next';
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
  const { t } = useTranslation('app');
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
      onSetting={() => router.push('/app/settings')}
      onPrayerBoard={() =>
        router.navigate({
          pathname: '/app/(tabs)/CommunityTab',
          params: { section: 'prayer-board' },
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
      <Text className="text-2xl font-semibold mb-2 dark:text-white">{t('welcome')}</Text>

      <Text className="text-center text-gray-600 dark:text-gray-400 mb-6">
        {t('profileSignInDescription')}
      </Text>

      <TouchableOpacity
        onPress={() => router.push('/app/signin')}
        className="w-full bg-black dark:bg-white py-3 rounded-xl mb-3">
        <Text className="text-center text-white dark:text-black font-semibold">{t('signIn')}</Text>
      </TouchableOpacity>

      <TouchableOpacity
        onPress={() => router.push('/app/signup')}
        className="w-full border border-black dark:border-white py-3 rounded-xl">
        <Text className="text-center font-semibold dark:text-white">{t('createAccount')}</Text>
      </TouchableOpacity>
      <View className="mt-8 w-full">
        <LanguageSelector />
      </View>
    </View>
  );
}
