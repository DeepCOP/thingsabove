import { supabase } from '../lib/supabaseClient';

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
  const { data, error } = await supabase
    .rpc('resolve_invite_code', {
      p_invite_code: code,
    })
    .maybeSingle();

  if (error) {
    throw error;
  }

  if (!data) {
    return null;
  }

  if (data.invite_type === 'plan_group' && data.group_id && data.plan_id) {
    return {
      type: 'plan_group',
      invite_code: data.invite_code,
      group_id: data.group_id,
      plan_id: data.plan_id,
      invited_by: data.invited_by,
    };
  }

  if (data.invite_type === 'church' && data.church_id) {
    return {
      type: 'church',
      invite_code: data.invite_code,
      church_id: data.church_id,
      invited_by: data.invited_by,
    };
  }

  throw new Error('Resolved invite is missing details');
};
