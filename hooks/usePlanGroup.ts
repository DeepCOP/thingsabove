import { fetchPlanGroupByGroupId, fetchPlanGroupMembers } from '@/api/queries';
import { useQuery } from '@tanstack/react-query';

export function usePlanGroup(groupId: string) {
  return useQuery({
    queryKey: ['plan-group', groupId],
    enabled: !!groupId,
    queryFn: async () => await fetchPlanGroupByGroupId({ groupId }),
  });
}

export function usePlanGroupMembers(groupId: string) {
  return useQuery({
    queryKey: ['plan-group-members', groupId],
    enabled: !!groupId,
    staleTime: 0,
    queryFn: async () => await fetchPlanGroupMembers({ groupId }),
  });
}
