import ChurchMembersScreen from '@/src/screens/ChurchMembersScreen';
import { useLocalSearchParams } from 'expo-router';

export default function ChurchMembersRoute() {
  const { churchId } = useLocalSearchParams<{ churchId: string }>();

  return <ChurchMembersScreen churchId={churchId} />;
}
