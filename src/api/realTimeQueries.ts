import { supabase } from '../lib/supabaseClient';

export const commentsRealTimeChannel = async (group_id: string, onNew: () => void) => {
  return supabase
    .channel('comments')
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'comments',
        filter: `group_id=eq.${group_id}`,
      },
      () => {
        onNew();
      },
    )
    .subscribe();
};

export const scriptureNotesRealTimeChannel = async ({
  scopeKey,
  onNew,
}: {
  scopeKey: string;
  onNew: () => void;
}) => {
  return supabase
    .channel(`scripture_notes:${scopeKey}`)
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'scripture_notes',
        filter: `scope_key=eq.${scopeKey}`,
      },
      onNew,
    )
    .subscribe();
};

export const FriendRequestRealTime = async ({
  userId: userId,
  onNew,
}: {
  userId: string;
  onNew: () => void;
}) => {
  return supabase
    .channel(`friends:requester:${userId}`)
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'friends',
        filter: `requester_id=eq.${userId}`,
      },
      onNew,
    )
    .subscribe();
};

export const FriendRequestRealTimeReceiver = async ({
  userId: userId,
  onNew,
}: {
  userId: string;
  onNew: () => void;
}) => {
  return supabase
    .channel(`friends:receiver:${userId}`)
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'friends',
        filter: `receiver_id=eq.${userId}`,
      },
      onNew,
    )
    .subscribe();
};

export const notificationsRealTime = async (userId: string, onNew: () => void) => {
  return supabase
    .channel('notifications')
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'notifications',
        filter: `user_id=eq.${userId}`,
      },
      () => {
        onNew(); // refetch notifications
      },
    )
    .subscribe();
};
