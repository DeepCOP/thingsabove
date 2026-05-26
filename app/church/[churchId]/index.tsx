import ChurchHeader from '@/src/components/church/ChurchHeader';
import { useChurch } from '@/src/hooks/useChurch';
import ChurchScreen from '@/src/screens/ChurchScreen';
import { Href, Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { View } from 'react-native';

export default function ChurchRoute() {
  const { churchId } = useLocalSearchParams<{ churchId: string }>();
  const router = useRouter();

  const churchQuery = useChurch(churchId);

  const church = churchQuery.data;

  const handleBackPress = () => {
    if (router.canGoBack()) {
      router.back();
      return;
    }

    router.replace('/' as Href);
  };

  return (
    <>
      <Stack.Screen options={{ headerShown: false }} />
      <View className="flex-1 bg-white dark:bg-black">
        <ChurchHeader title={church?.name ?? 'Church'} onBackPress={handleBackPress} />
        <ChurchScreen churchId={churchId} />
      </View>
    </>
  );
}
