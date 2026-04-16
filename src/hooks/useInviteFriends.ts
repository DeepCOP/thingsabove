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
      qc.invalidateQueries({ queryKey: ['plan_group_members', groupId] });
    },
  });
}

export function useAcceptPlanInvite(
  group_id: string,
  plan_id: string,
  user_id: string | undefined,
) {
  const qc = useQueryClient();

  return useMutation({
    mutationKey: ['accept_plan_invitation'],
    mutationFn: async ({ startDate }: { startDate: string }) =>
      await acceptPlanGroupInvite({ group_id, plan_id, startDate }),
    onSuccess: () => {
      qc.setQueryData(['has_user_plan_progress', user_id], true);
      qc.invalidateQueries({ queryKey: ['plan_group_members', group_id] });
      qc.invalidateQueries({ queryKey: ['plan_group_invitation_members', group_id] });
      qc.invalidateQueries({ queryKey: ['my_plan_progress_plans', user_id] });
    },
    onError: (e) => {},
  });
}
