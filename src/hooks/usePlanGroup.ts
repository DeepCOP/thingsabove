import { useQuery } from '@tanstack/react-query';
import {
  fetchPlanGroupByGroupId,
  fetchPlanGroupInvitation,
  fetchPlanGroupInvitationMembers,
  fetchPlanGroupMembers,
} from '../api/groupQueries';

export function usePlanGroup(groupId: string) {
  return useQuery({
    queryKey: ['plan_group', groupId],
    enabled: !!groupId,
    queryFn: async () => await fetchPlanGroupByGroupId({ groupId }),
  });
}

export function usePlanGroupMembers(groupId: string) {
  return useQuery({
    queryKey: ['plan_group_members', groupId],
    enabled: !!groupId,
    staleTime: 1000 * 60 * 30,
    queryFn: async () => await fetchPlanGroupMembers({ groupId }),
  });
}

export function usePlanGroupInvitation(groupId: string) {
  return useQuery({
    queryKey: ['plan_group_invitation', groupId],
    enabled: !!groupId,
    queryFn: async () => await fetchPlanGroupInvitation({ groupId }),
  });
}

export function usePlanGroupInvitationMembers(groupId: string) {
  return useQuery({
    queryKey: ['plan_group_invitation_members', groupId],
    enabled: !!groupId,
    staleTime: 1000 * 60 * 30,
    queryFn: async () => await fetchPlanGroupInvitationMembers({ groupId }),
  });
}
