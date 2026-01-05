import { AccpetPlanGroupInvite, InviteFriendsToPlanGroup } from '@/api/queries';
import { useMutation, useQueryClient } from '@tanstack/react-query';

export function useInviteFriends(groupId: string) {
  const qc = useQueryClient();

  return useMutation({
    mutationFn: async (userIds: string[]) => await InviteFriendsToPlanGroup({ groupId, userIds }),
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
      await AccpetPlanGroupInvite({ group_id, plan_id, startDate }),
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
    },
    onError: (e) => {},
  });
}
