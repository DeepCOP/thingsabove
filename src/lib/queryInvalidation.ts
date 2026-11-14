import type { QueryClient } from '@tanstack/react-query';
import { groupProgressKey } from './queryKeys';

export function invalidateFriendQueries(client: QueryClient, userId: string | undefined) {
  if (!userId) return Promise.resolve();

  return Promise.all([
    client.invalidateQueries({ queryKey: ['friends', userId] }),
    client.invalidateQueries({ queryKey: ['friend_requests', userId] }),
    client.invalidateQueries({ queryKey: ['friendship', userId] }),
    client.invalidateQueries({
      predicate: ({ queryKey }) =>
        (queryKey[0] === 'get_user_by_email' || queryKey[0] === 'search_users_by_name') &&
        queryKey[2] === userId,
    }),
  ]);
}

export function invalidateGroupProgress(client: QueryClient, groupId?: string | null) {
  if (!groupId) return Promise.resolve();
  return client.invalidateQueries({ queryKey: groupProgressKey(groupId) });
}
