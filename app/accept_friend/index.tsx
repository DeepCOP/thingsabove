import {
  useAcceptFriendRequest,
  useDeclineFriendRequest,
  usePendingFriendRequests,
} from '@/src/hooks/useFriends';
import AcceptFriendRequestsScreen from '@/src/screens/AcceptFriendRequestsScreen';
import { useAuth } from '@/src/state/AuthContext';
import { Href, useRouter } from 'expo-router';

export default function AcceptFriendRequests() {
  const { session, loading: sessionLoading } = useAuth();
  const router = useRouter();
  const { data, isLoading } = usePendingFriendRequests(session?.user.id);
  const acceptMutation = useAcceptFriendRequest();
  const declineMutation = useDeclineFriendRequest();

  return (
    <AcceptFriendRequestsScreen
      data={data}
      isLoading={isLoading || sessionLoading}
      onAccept={(friendId) => acceptMutation.mutate({ friendId })}
      onDecline={(friendId) => declineMutation.mutate({ friendId })}
      onPressProfile={(friendId) => router.push(`/profile/${friendId}` as Href)}
      isAccepting={acceptMutation.isPending}
      isDeclining={declineMutation.isPending}
    />
  );
}
