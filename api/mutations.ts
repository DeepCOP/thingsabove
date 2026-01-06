import { PlanProgressInsert } from '@/types/types';
import { supabase } from './supabaseClient';

export const toggleItemCompletion = async ({
  item_type,
  item_key,
  completed,
  user_id,
  plan_id,
  day_id,
  groupId,
}: {
  item_type: 'devotional' | 'scripture';
  item_key: string;
  completed: boolean;
  user_id: string;
  plan_id: string;
  day_id: string;
  groupId?: string;
}) => {
  const { error } = await supabase.rpc('toggle_item_completion', {
    p_user_id: user_id,
    p_plan_id: plan_id,
    p_day_id: day_id,
    p_item_type: item_type,
    p_item_key: item_key,
    p_completed: completed,
    p_group_id: groupId,
  });

  if (error) throw error;
};

export const toggleDayCompletion = async ({
  completed,
  user_id,
  plan_id,
  day_id,
  groupId,
}: {
  completed: boolean;
  user_id: string;
  plan_id: string;
  day_id: string;
  groupId?: string;
}) => {
  const { error } = await supabase.rpc('toggle_day_completion', {
    p_user_id: user_id,
    p_plan_id: plan_id,
    p_day_id: day_id,
    p_completed: completed,
    p_group_id: groupId,
  });

  if (error) throw error;
};

export const insertToPlanProgress = async (payload: PlanProgressInsert) => {
  const { data, error } = await supabase.from('plan_progress').insert(payload).select('*').single();

  if (error) throw error;
  return data;
};

export const addPlanDayComment = async ({
  planId,
  dayId,
  content,
  group_id,
}: {
  planId: string;
  dayId: string;
  content: string;
  group_id?: string;
}) => {
  const { error } = await supabase.rpc('add_plan_day_comment', {
    p_plan_id: planId,
    p_day_id: dayId,
    p_content: content,
    p_group_id: group_id,
  });

  if (error) throw error;
};

export const createPlanGroup = async ({
  user_id,
  plan_id,
  start_date,
  invited_user_ids,
}: {
  user_id: string;
  plan_id: string;
  start_date: string;
  invited_user_ids: string[];
}) => {
  const { data: groupId, error } = await supabase.rpc('create_plan_group', {
    p_user_id: user_id,
    p_plan_id: plan_id,
    p_start_date: start_date, // YYYY-MM-DD,
    p_friends_ids: invited_user_ids,
  });

  if (error) throw error;
  return groupId;
};

export const addFriend = async ({ receiver_id }: { receiver_id: string }) => {
  const { error } = await supabase.rpc('send_friend_request', {
    p_receiver_id: receiver_id,
  });
  if (error) throw error;
};

export const acceptFriendRequest = async (requester_id: string) => {
  const { error } = await supabase.rpc('accept_friend_request', {
    p_requester_id: requester_id,
  });

  if (error) throw error;
};

export const declineFriendRequest = async (requester_id: string) => {
  const { error } = await supabase.rpc('decline_friend_request', {
    p_requester_id: requester_id,
  });

  if (error) throw error;
};

export const InviteFriendsToPlanGroup = async ({
  groupId,
  userIds,
}: {
  groupId: string;
  userIds: string[];
}) => {
  const { error } = await supabase.rpc('add_user_to_existing_plan_group', {
    p_group_id: groupId,
    p_friends_ids: userIds,
  });

  if (error) throw error;
};

export const AccpetPlanGroupInvite = async ({
  group_id,
  plan_id,
  startDate,
}: {
  group_id: string;
  plan_id: string;
  startDate: string;
}) => {
  if (!group_id || !plan_id) return;
  const { error } = await supabase.rpc('accept_plan_group_invite', {
    p_group_id: group_id,
    p_plan_id: plan_id,
    p_start_date: startDate,
  });

  if (error) throw error;
};

export const markNotificationRead = async (p_notification_id: string) => {
  const { error } = await supabase.rpc('mark_notification_read', {
    p_notification_id,
  });
  if (error) throw error;
};
