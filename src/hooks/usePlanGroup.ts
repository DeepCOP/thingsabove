import { useQuery } from '@tanstack/react-query';
import { useAuth } from '../state/AuthContext';
import { COMMUNITY_STALE_TIME } from '../lib/queryCache';
import { cacheStaleTime } from '../lib/queryCachePolicy';
import {
  fetchPlanGroupByGroupId,
  fetchPlanGroupInvitation,
  fetchPlanGroupInvitationMembers,
  fetchPlanGroupMembers,
} from '../api/groupQueries';

export function usePlanGroup(groupId: string) {
  const { session } = useAuth();
  return useQuery({
    queryKey: ['plan_group', groupId, session?.user.id ?? 'guest'],
    enabled: !!groupId,
    queryFn: async () => await fetchPlanGroupByGroupId({ groupId }),
  });
}

export function usePlanGroupMembers(groupId: string) {
  const { session } = useAuth();
  return useQuery({
    queryKey: ['plan_group_members', groupId, session?.user.id ?? 'guest'],
    enabled: !!groupId,
    staleTime: cacheStaleTime(COMMUNITY_STALE_TIME),
    queryFn: async () => await fetchPlanGroupMembers({ groupId }),
  });
}

export function usePlanGroupInvitation(groupId: string) {
  const { session } = useAuth();
  return useQuery({
    queryKey: ['plan_group_invitation', groupId, session?.user.id ?? 'guest'],
    enabled: !!groupId,
    queryFn: async () => await fetchPlanGroupInvitation({ groupId }),
  });
}

export function usePlanGroupInvitationMembers(groupId: string) {
  const { session } = useAuth();
  return useQuery({
    queryKey: ['plan_group_invitation_members', groupId, session?.user.id ?? 'guest'],
    enabled: !!groupId,
    staleTime: cacheStaleTime(COMMUNITY_STALE_TIME),
    queryFn: async () => await fetchPlanGroupInvitationMembers({ groupId }),
  });
}
