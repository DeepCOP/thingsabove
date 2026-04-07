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
} from '@/src/api/prayerQueries';
import {
  PrayerFilter,
  PrayerRequestCursor,
  PrayerRequestDetail,
  PrayerRequestFeedItem,
  PrayerRequestPage,
  PrayerScope,
} from '@/src/types/types';
import {
  InfiniteData,
  useInfiniteQuery,
  useMutation,
  useQuery,
  useQueryClient,
} from '@tanstack/react-query';
import { PRAYER_REQUESTS_PAGE_SIZE } from '@/src/api/prayerQueries';

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
  return useInfiniteQuery({
    queryKey: ['prayer_requests', scope, filter],
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
  return useQuery({
    queryKey: ['prayer_request', requestId],
    enabled: !!requestId,
    queryFn: async () => await fetchPrayerRequestDetail(requestId!),
  });
}

export function usePrayerRequestEncouragements(requestId: string | undefined) {
  return useQuery({
    queryKey: ['prayer_encouragements', requestId],
    enabled: !!requestId,
    queryFn: async () => await fetchPrayerRequestEncouragements(requestId!),
  });
}

export function useSavePrayerRequest() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (input: SavePrayerRequestInput) => await savePrayerRequest(input),
    onSuccess: (requestId, variables) => {
      queryClient.invalidateQueries({ queryKey: ['prayer_requests'] });
      queryClient.invalidateQueries({
        queryKey: ['prayer_request', variables.requestId ?? requestId],
      });
    },
  });
}

export function useTogglePrayerRequestSupport() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (requestId: string) => await togglePrayerRequestSupport(requestId),
    onMutate: async (requestId) => {
      await queryClient.cancelQueries({ queryKey: ['prayer_requests'] });
      await queryClient.cancelQueries({ queryKey: ['prayer_request', requestId] });

      const previousPrayerRequestLists = queryClient.getQueriesData<
        InfiniteData<PrayerRequestPage>
      >({
        queryKey: ['prayer_requests'],
      });
      const previousPrayerRequestDetail = queryClient.getQueryData<PrayerRequestDetail | null>([
        'prayer_request',
        requestId,
      ]);

      queryClient.setQueriesData<InfiniteData<PrayerRequestPage>>(
        { queryKey: ['prayer_requests'] },
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
        ['prayer_request', requestId],
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
      queryClient.setQueryData(['prayer_request', requestId], context?.previousPrayerRequestDetail);
    },
    onSettled: (_didPray, _error, requestId) => {
      queryClient.invalidateQueries({ queryKey: ['prayer_requests'] });
      queryClient.invalidateQueries({ queryKey: ['prayer_request', requestId] });
    },
  });
}

export function useAddPrayerRequestEncouragement() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ requestId, content }: { requestId: string; content: string }) =>
      await addPrayerRequestEncouragement({ requestId, content }),
    onSuccess: (_encouragementId, variables) => {
      queryClient.invalidateQueries({ queryKey: ['prayer_requests'] });
      queryClient.invalidateQueries({ queryKey: ['prayer_request', variables.requestId] });
      queryClient.invalidateQueries({
        queryKey: ['prayer_encouragements', variables.requestId],
      });
    },
  });
}

export function useSetPrayerRequestAnswered() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ requestId, isAnswered }: { requestId: string; isAnswered: boolean }) =>
      await setPrayerRequestAnswered({ requestId, isAnswered }),
    onSuccess: (_data, variables) => {
      queryClient.invalidateQueries({ queryKey: ['prayer_requests'] });
      queryClient.invalidateQueries({ queryKey: ['prayer_request', variables.requestId] });
    },
  });
}
