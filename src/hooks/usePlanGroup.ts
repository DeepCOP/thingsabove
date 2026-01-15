import { useQuery } from '@tanstack/react-query';
import { fetchPlanGroupByGroupId, fetchPlanGroupMembers } from '../api/groupQueries';

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
    staleTime: 1000 * 60 * 30,
    queryFn: async () => await fetchPlanGroupMembers({ groupId }),
  });
}
