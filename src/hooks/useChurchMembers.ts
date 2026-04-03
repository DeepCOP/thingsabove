import { CHURCH_MEMBERS_PAGE_SIZE, fetchChurchMembers } from '../api/churchQueries';
import { useInfiniteQuery } from '@tanstack/react-query';
import { useMemo } from 'react';
import { useAuth } from '../state/AuthContext';

export const useChurchMembers = (churchId: string | undefined, search = '') => {
  const { session } = useAuth();
  const userId = session?.user?.id ?? null;

  const membersQuery = useInfiniteQuery<Awaited<ReturnType<typeof fetchChurchMembers>>>({
    queryKey: ['church-members', userId, churchId, search],
    enabled: Boolean(churchId),
    initialPageParam: 0,
    placeholderData: (previousData) => previousData,
    queryFn: async ({ pageParam }) =>
      await fetchChurchMembers({
        churchId: churchId!,
        offset: pageParam as number,
        search,
      }),
    getNextPageParam: (lastPage) => lastPage.nextOffset ?? undefined,
  });

  const members = useMemo(
    () => membersQuery.data?.pages.flatMap((page) => page.items) ?? [],
    [membersQuery.data],
  );

  return {
    membersQuery,
    members,
    pageSize: CHURCH_MEMBERS_PAGE_SIZE,
  };
};
