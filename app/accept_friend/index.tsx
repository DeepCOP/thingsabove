import {
  useAcceptFriendRequest,
  useDeclineFriendRequest,
  usePendingFriendRequests,
} from '@/src/hooks/useFriends';
import AcceptFriendRequestsScreen from '@/src/screens/AcceptFriendRequestsScreen';
import { useAuth } from '@/src/state/AuthContext';

export default function AcceptFriendRequests() {
  const { session, loading: sessionLoading } = useAuth();
  const { data, isLoading } = usePendingFriendRequests(session?.user.id);
  const acceptMutation = useAcceptFriendRequest();
  const declineMutation = useDeclineFriendRequest();

  return (
    <AcceptFriendRequestsScreen
      data={data}
      isLoading={isLoading || sessionLoading}
      onAccept={(friendId) => acceptMutation.mutate({ friendId })}
      onDecline={(friendId) => declineMutation.mutate({ friendId })}
      isAccepting={acceptMutation.isPending}
      isDeclining={declineMutation.isPending}
    />
  );
}
