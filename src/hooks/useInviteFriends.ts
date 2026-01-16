import { acceptPlanGroupInvite, inviteFriendsToPlanGroup } from '@/src/api/mutations';
import { useMutation, useQueryClient } from '@tanstack/react-query';

export function useInviteFriends(groupId: string) {
  const qc = useQueryClient();

  return useMutation({
    mutationFn: async (userIds: string[]) => {
      if (!groupId) return;
      await inviteFriendsToPlanGroup({ groupId, userIds });
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['plan-group-members', groupId] });
    },
  });
}

export function useAcceptPlanInvite(group_id: string, plan_id: string, user_id: string) {
  const qc = useQueryClient();

  return useMutation({
    mutationKey: ['accept_plan_invitation'],
    mutationFn: async ({ startDate }: { startDate: string }) =>
      await acceptPlanGroupInvite({ group_id, plan_id, startDate }),
    onSuccess: () => {
      qc.invalidateQueries({
        queryKey: ['plan_progress', plan_id, user_id, group_id],
      });
      qc.invalidateQueries({
        queryKey: ['plan-group-members', group_id],
      });
      qc.invalidateQueries({
        queryKey: ['plan-group', group_id],
      });
      qc.invalidateQueries({ queryKey: ['user_plans_progressess', user_id] });
    },
    onError: (e) => {},
  });
}
