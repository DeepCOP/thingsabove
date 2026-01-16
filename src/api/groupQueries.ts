import { supabase } from '../lib/supabaseClient';

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

export const fetchPlanGroupMembers = async ({ groupId }: { groupId: string }) => {
  const { data, error } = await supabase
    .from('plan_group_members')
    .select(
      `
          id,
          status,
          joined_at,
          user_id,
          profiles!user_id (
            id,
            first_name,
            last_name,
            avatar_url
          )
        `,
    )
    .eq('group_id', groupId!)
    .eq('status', 'accepted')
    .order('joined_at', { ascending: true });

  if (error) throw error;
  return data;
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
