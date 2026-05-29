import { supabase } from '../lib/supabaseClient';
import type { PlanGroupMember } from '../types/types';

export const fetchPlanGroupByGroupId = async ({ groupId }: { groupId: string }) => {
  const { data, error } = await supabase
    .from('plan_groups')
    .select(`*, profiles!created_by (id, first_name, last_name, avatar_url)`)
    .eq('id', groupId!)
    .single();

  if (error) {
    throw error;
  }

  return data;
};

export type PlanGroupInvitation = {
  id: string;
  created_by: string;
  start_date: string;
  plan_id: string;
  max_members: number | null;
  completed_days: number | null;
  created_at: string | null;
  inviter: {
    id: string;
    first_name: string | null;
    last_name: string | null;
    avatar_url: string | null;
  };
  plan_title: string | null;
  plan_cover_image: string | null;
  plan_total_days: number | null;
  plan_visibility: string | null;
};

export type PlanGroupInvitationMember = {
  id: string;
  status: string;
  joined_at: string | null;
  user_id: string;
  profiles: {
    id: string;
    first_name: string | null;
    last_name: string | null;
    avatar_url: string | null;
  };
};

export const fetchPlanGroupInviteCode = async ({ groupId }: { groupId: string }) => {
  const { data, error } = await supabase.rpc('get_plan_group_invite_code', {
    p_group_id: groupId,
  });

  if (error) {
    throw error;
  }

  if (!data) {
    throw new Error('Invite code not found');
  }

  return data as string;
};

export const fetchPlanGroupInvitation = async ({ groupId }: { groupId: string }) => {
  const { data, error } = await supabase
    .rpc('get_plan_group_invitation', {
      p_group_id: groupId,
    })
    .maybeSingle();

  if (error) {
    throw error;
  }

  if (!data) {
    return null;
  }

  return {
    id: data.id,
    created_by: data.created_by,
    start_date: data.start_date,
    plan_id: data.plan_id,
    max_members: data.max_members,
    completed_days: data.completed_days,
    created_at: data.created_at,
    inviter: {
      id: data.inviter_id,
      first_name: data.inviter_first_name,
      last_name: data.inviter_last_name,
      avatar_url: data.inviter_avatar_url,
    },
    plan_title: data.plan_title,
    plan_cover_image: data.plan_cover_image,
    plan_total_days: data.plan_total_days,
    plan_visibility: data.plan_visibility,
  } satisfies PlanGroupInvitation;
};

export const fetchPlanGroupInvitationMembers = async ({ groupId }: { groupId: string }) => {
  const { data, error } = await supabase.rpc('get_plan_group_invitation_members', {
    p_group_id: groupId,
  });

  if (error) {
    throw error;
  }

  return ((data ?? []) as any[]).map(
    (member) =>
      ({
        id: member.id,
        status: member.status,
        joined_at: member.joined_at,
        user_id: member.user_id,
        profiles: {
          id: member.profile_id,
          first_name: member.first_name,
          last_name: member.last_name,
          avatar_url: member.avatar_url,
        },
      }) satisfies PlanGroupInvitationMember,
  );
};

export const fetchPlanGroupMembers = async ({ groupId }: { groupId: string }) => {
  const { data, error } = await supabase.rpc('get_plan_group_members', {
    p_group_id: groupId,
  });

  if (error) throw error;

  return (data ?? []).map(
    (member) =>
      ({
        id: member.id,
        status: member.status,
        joined_at: member.joined_at,
        user_id: member.user_id,
        profiles: {
          id: member.profile_id,
          first_name: member.first_name,
          last_name: member.last_name,
          avatar_url: member.avatar_url,
        },
      }) satisfies PlanGroupMember,
  );
};

export const fetchPlanDayComments = async ({
  planId,
  dayId,
  group_id,
}: {
  planId: string;
  dayId: string;
  group_id?: string;
}) => {
  const { data, error } = await supabase.rpc('get_plan_day_comments', {
    p_plan_id: planId!,
    p_day_id: dayId!,
    p_group_id: group_id,
  });

  if (error) throw error;
  return data;
};
