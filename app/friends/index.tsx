import { useFriends, usePendingFriendRequests } from '@/src/hooks/useFriends';
import FriendsScreen from '@/src/screens/FriendsScreen';
import { useAuth } from '@/src/state/AuthContext';
import { useRouter } from 'expo-router';

export default function FriendsRoute() {
  const { session, loading: sessionLoading } = useAuth();
  const router = useRouter();

  const friendsQuery = useFriends(session?.user?.id);
  const pendingRequestsQuery = usePendingFriendRequests(session?.user?.id);

  return (
    <FriendsScreen
      friends={friendsQuery.data ?? []}
      isLoading={sessionLoading || friendsQuery.isLoading || pendingRequestsQuery.isLoading}
      pendingCount={pendingRequestsQuery.data?.length ?? 0}
      onAddFriend={() => router.push('/add_friend')}
      onFriendRequests={() => router.push('/accept_friend')}
    />
  );
}
