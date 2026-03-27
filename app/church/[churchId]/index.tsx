import ChurchScreen from '@/src/screens/ChurchScreen';
import { useLocalSearchParams } from 'expo-router';

export default function ChurchRoute() {
  const { churchId } = useLocalSearchParams<{ churchId: string }>();

  return <ChurchScreen churchId={churchId} />;
}
