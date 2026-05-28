import { resolveChurchInviteCode } from './churchQueries';
import { resolvePlanGroupInviteCode } from './groupQueries';

export type InviteRedirect =
  | {
      type: 'plan_group';
      invite_code: string;
      group_id: string;
      plan_id: string;
      invited_by: string;
    }
  | {
      type: 'church';
      invite_code: string;
      church_id: string;
      invited_by: string;
    };

export const resolveInviteCode = async ({
  code,
}: {
  code: string;
}): Promise<InviteRedirect | null> => {
  const planGroupInvite = await resolvePlanGroupInviteCode({ code });

  if (planGroupInvite) {
    return {
      type: 'plan_group',
      ...planGroupInvite,
    };
  }

  const churchInvite = await resolveChurchInviteCode({ code });

  if (churchInvite) {
    return {
      type: 'church',
      ...churchInvite,
    };
  }

  return null;
};
