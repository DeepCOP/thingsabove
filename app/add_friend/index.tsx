import { useAddFriend, useGetUserByEmail } from '@/src/hooks/useFriends';
import { buildFriendInviteMessage } from '@/src/lib/planShare';
import AddFriendScreen from '@/src/screens/AddFriendScreen';
import { useAuth } from '@/src/state/AuthContext';
import { isValidEmail, useDebounce } from '@/src/utils';
import { useState } from 'react';
import { Share } from 'react-native';

export default function AddFriend() {
  const { session } = useAuth();
  const userId = session?.user?.id!;

  const [email, setEmail] = useState('');
  const debouncedEmail = useDebounce(email.trim(), 500);

  const isEmailValid = isValidEmail(debouncedEmail.trim());

  const userQuery = useGetUserByEmail({
    query: isEmailValid ? debouncedEmail : '',
    userId,
  });

  const addFriend = useAddFriend();

  return (
    <AddFriendScreen
      email={email}
      onEmailChange={setEmail}
      isEmailValid={isEmailValid}
      user={userQuery.data}
      isSearching={userQuery.isLoading}
      isAdding={addFriend.isPending}
      onAddFriend={(friendId) =>
        addFriend.mutate({
          friendId,
          userId,
        })
      }
      onShareInviteLink={() => Share.share({ message: buildFriendInviteMessage() })}
    />
  );
}
