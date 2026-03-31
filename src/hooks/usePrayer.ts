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
import { PrayerFilter, PrayerScope } from '@/src/types/types';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

export function usePrayerBoard(scope: PrayerScope, filter: PrayerFilter) {
  return useQuery({
    queryKey: ['prayer_requests', scope, filter],
    queryFn: async () => await fetchPrayerRequests({ scope, filter }),
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
    onSuccess: (_didPray, requestId) => {
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
