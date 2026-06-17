import {
  addPrayerRequestEncouragement,
  savePrayerRequest,
  setPrayerRequestAnswered,
  togglePrayerRequestSupport,
  type SavePrayerRequestInput,
} from '@/src/api/prayerMutations';
import {
  fetchPrayerRequestDetail,
  fetchPrayerRequestEncouragements,
  fetchPrayerRequests,
  PRAYER_REQUESTS_PAGE_SIZE,
} from '@/src/api/prayerQueries';
import {
  PrayerFilter,
  PrayerRequestCursor,
  PrayerRequestDetail,
  PrayerRequestPage,
  PrayerScope,
} from '@/src/types/types';
import { useAuth } from '@/src/state/AuthContext';
import {
  InfiniteData,
  useInfiniteQuery,
  useMutation,
  useQuery,
  useQueryClient,
} from '@tanstack/react-query';

const prayerRequestsKey = (userId: string | undefined) => ['prayer_requests', userId] as const;

const prayerBoardKey = (userId: string | undefined, scope: PrayerScope, filter: PrayerFilter) =>
  [...prayerRequestsKey(userId), scope, filter] as const;

const prayerRequestKey = (userId: string | undefined, requestId: string | undefined) =>
  ['prayer_request', userId, requestId] as const;

const prayerEncouragementsKey = (userId: string | undefined, requestId: string | undefined) =>
  ['prayer_encouragements', userId, requestId] as const;

const togglePrayerSupportFields = <
  T extends {
    id: string;
    prayer_count: number;
    viewer_has_prayed: boolean;
  },
>(
  item: T,
) => {
  const nextHasPrayed = !item.viewer_has_prayed;

  return {
    ...item,
    viewer_has_prayed: nextHasPrayed,
    prayer_count: Math.max(0, item.prayer_count + (nextHasPrayed ? 1 : -1)),
  };
};

export function usePrayerBoard(scope: PrayerScope, filter: PrayerFilter) {
  const { session } = useAuth();
  const userId = session?.user?.id;

  return useInfiniteQuery({
    queryKey: prayerBoardKey(userId, scope, filter),
    initialPageParam: null as PrayerRequestCursor | null,
    queryFn: async ({ pageParam }) =>
      await fetchPrayerRequests({
        scope,
        filter,
        limit: PRAYER_REQUESTS_PAGE_SIZE,
        cursor: pageParam,
      }),
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });
}

export function usePrayerRequest(requestId: string | undefined) {
  const { session } = useAuth();
  const userId = session?.user?.id;

  return useQuery({
    queryKey: prayerRequestKey(userId, requestId),
    enabled: !!requestId,
    queryFn: async () => await fetchPrayerRequestDetail(requestId!),
  });
}

export function usePrayerRequestEncouragements(requestId: string | undefined) {
  const { session } = useAuth();
  const userId = session?.user?.id;

  return useQuery({
    queryKey: prayerEncouragementsKey(userId, requestId),
    enabled: !!requestId,
    queryFn: async () => await fetchPrayerRequestEncouragements(requestId!),
  });
}

export function useSavePrayerRequest() {
  const { session } = useAuth();
  const userId = session?.user?.id;
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (input: SavePrayerRequestInput) => await savePrayerRequest(input),
    onSuccess: (requestId, variables) => {
      queryClient.invalidateQueries({ queryKey: prayerRequestsKey(userId) });
      queryClient.invalidateQueries({
        queryKey: prayerRequestKey(userId, variables.requestId ?? requestId),
      });
    },
  });
}

export function useTogglePrayerRequestSupport() {
  const { session } = useAuth();
  const userId = session?.user?.id;
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (requestId: string) => await togglePrayerRequestSupport(requestId),
    onMutate: async (requestId) => {
      await queryClient.cancelQueries({ queryKey: prayerRequestsKey(userId) });
      await queryClient.cancelQueries({ queryKey: prayerRequestKey(userId, requestId) });

      const previousPrayerRequestLists = queryClient.getQueriesData<
        InfiniteData<PrayerRequestPage>
      >({
        queryKey: prayerRequestsKey(userId),
      });
      const previousPrayerRequestDetail = queryClient.getQueryData<PrayerRequestDetail | null>(
        prayerRequestKey(userId, requestId),
      );

      queryClient.setQueriesData<InfiniteData<PrayerRequestPage>>(
        { queryKey: prayerRequestsKey(userId) },
        (current) =>
          current
            ? {
                ...current,
                pages: current.pages.map((page) => ({
                  ...page,
                  items: page.items.map((item) =>
                    item.id === requestId ? togglePrayerSupportFields(item) : item,
                  ),
                })),
              }
            : current,
      );

      queryClient.setQueryData<PrayerRequestDetail | null>(
        prayerRequestKey(userId, requestId),
        (current) => (current ? togglePrayerSupportFields(current) : current),
      );

      return {
        previousPrayerRequestLists,
        previousPrayerRequestDetail,
      };
    },
    onError: (_error, requestId, context) => {
      context?.previousPrayerRequestLists.forEach(([queryKey, data]) => {
        queryClient.setQueryData(queryKey, data);
      });
      queryClient.setQueryData(
        prayerRequestKey(userId, requestId),
        context?.previousPrayerRequestDetail,
      );
    },
    onSettled: (_didPray, _error, requestId) => {
      queryClient.invalidateQueries({ queryKey: prayerRequestsKey(userId) });
      queryClient.invalidateQueries({ queryKey: prayerRequestKey(userId, requestId) });
    },
  });
}

export function useAddPrayerRequestEncouragement() {
  const { session } = useAuth();
  const userId = session?.user?.id;
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ requestId, content }: { requestId: string; content: string }) =>
      await addPrayerRequestEncouragement({ requestId, content }),
    onSuccess: (_encouragementId, variables) => {
      queryClient.invalidateQueries({ queryKey: prayerRequestsKey(userId) });
      queryClient.invalidateQueries({ queryKey: prayerRequestKey(userId, variables.requestId) });
      queryClient.invalidateQueries({
        queryKey: prayerEncouragementsKey(userId, variables.requestId),
      });
    },
  });
}

export function useSetPrayerRequestAnswered() {
  const { session } = useAuth();
  const userId = session?.user?.id;
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (variables: { requestId: string; isAnswered: boolean; testimony?: string }) =>
      await setPrayerRequestAnswered(variables),
    onSuccess: (_data, variables) => {
      queryClient.invalidateQueries({ queryKey: prayerRequestsKey(userId) });
      queryClient.invalidateQueries({ queryKey: prayerRequestKey(userId, variables.requestId) });
    },
  });
}
