import {
  useAcceptFriendRequest,
  useDeclineFriendRequest,
  usePendingFriendRequests,
} from '@/src/hooks/useFriends';
import AcceptFriendRequestsScreen from '@/src/screens/AcceptFriendRequestsScreen';

export default function AcceptFriendRequests() {
  const { data, isLoading } = usePendingFriendRequests();
  const acceptMutation = useAcceptFriendRequest();
  const declineMutation = useDeclineFriendRequest();

  return (
    <AcceptFriendRequestsScreen
      data={data}
      isLoading={isLoading}
      onAccept={(friendId) => acceptMutation.mutate({ friendId })}
      onDecline={(friendId) => declineMutation.mutate({ friendId })}
      isAccepting={acceptMutation.isPending}
      isDeclining={declineMutation.isPending}
    />
  );
}
