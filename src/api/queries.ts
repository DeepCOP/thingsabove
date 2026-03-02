import { supabase } from '../lib/supabaseClient';

export const searchRelatedPlans = async (currentPlanId: string, tags: string[]) => {
  if (!tags.length) return [];
  const { data, error } = await supabase
    .from('devotional_plans')
    .select('id, title, cover_image, total_days, tags, description')
    .neq('id', currentPlanId)
    .neq('status', 'draft')
    .overlaps('tags', tags)
    .limit(10);
  if (error) throw error;

  return data;
};

export const searchPlans = async ({
  pageParam,
  query,
}: {
  pageParam: { created_at: string | null; id: string | null };
  query: string;
}) => {
  const PAGE_SIZE = 10;

  const { data, error } = await supabase.rpc('search_plans', {
    search_query: query,
    limit_count: PAGE_SIZE,
    cursor_created_at: pageParam?.created_at ?? undefined,
    cursor_id: pageParam?.id ?? undefined,
  });

  if (error) throw error;
  const last = data?.[data.length - 1] ?? null;

  return {
    items: data,
    nextCursor: last ? { created_at: last.created_at, id: last.id } : null,
  };
};

export const fetchPlans = async ({
  pageParam,
}: {
  pageParam: { created_at: string | null; id: string | null };
}) => {
  const PAGE_SIZE = 10;
  const { created_at, id } = pageParam ?? {};

  let query = supabase
    .from('devotional_plans_view')
    .select('*')
    .neq('status', 'draft')
    .order('created_at', { ascending: false })
    .order('id', { ascending: false }) // secondary key for stable ordering
    .limit(PAGE_SIZE);

  if (created_at && id) {
    query = query.or(`created_at.lt.${created_at},and(created_at.eq.${created_at},id.lt.${id})`);
  }

  const { data, error } = await query;
  if (error) throw error;

  // last item becomes the new cursor
  const last = data[data.length - 1];

  return {
    items: data,
    nextCursor: last ? { created_at: last.created_at, id: last.id } : null,
  };
};

export const fetchPlanById = async (id: string) => {
  let { data, error } = await supabase
    .from('devotional_plans')
    .select('*')
    .eq('id', id)
    .neq('status', 'draft')
    .single();

  if (error) throw error;

  return data;
};

export const fetchDayItems = async ({
  user_id,
  plan_id,
  progress_id,
  day_id,
  groupId,
}: {
  user_id: string;
  plan_id: string;
  progress_id: string;
  day_id: string;
  groupId?: string;
}) => {
  const { data, error } = await supabase.rpc('get_day_items_progress', {
    p_user_id: user_id,
    p_plan_id: plan_id,
    p_progress_id: progress_id,
    p_day_id: day_id,
    p_group_id: groupId,
  });

  if (error) throw error;
  // Return mapped progress
  return data;
};

export const fetchPlanProgress = async ({
  progress_id,
  user_id,
}: {
  progress_id: string;
  user_id: string;
}) => {
  let { data, error } = await supabase
    .from('plan_progress')
    .select('*')
    .eq('id', progress_id)
    .eq('user_id', user_id)
    .single();

  if (error && error.code !== 'PGRST116') throw error;
  return data;
};

export const fetchUserPlanProgressList = async ({ user_id }: { user_id: string }) => {
  let { data, error } = await supabase.from('plan_progress').select('*').eq('user_id', user_id);

  if (error && error.code !== 'PGRST116') throw error;
  return data;
};

export const fetchGroupPlanProgressList = async ({
  userIds,
  groupId,
}: {
  userIds: string[];
  groupId: string;
}) => {
  let { data, error } = await supabase
    .from('plan_progress')
    .select('*')
    .eq('group_id', groupId)
    .in('user_id', userIds);
  if (error && error.code !== 'PGRST116') throw error;
  return data;
};

export const fetchPlanDays = async ({ plan_id }: { plan_id: string }) => {
  const { data, error } = await supabase
    .from('devotional_days')
    .select('*')
    .eq('plan_id', plan_id)
    .order('day_number');

  if (error) throw error;
  return data;
};

export const fetchUserFriends = async ({ userId }: { userId: string }) => {
  const { data, error } = await supabase
    .from('friends')
    .select(
      `
          id,
          requester_id,
          receiver_id,
          status,
          requester:profiles!requester_id ( id, first_name, last_name, avatar_url ),
          receiver:profiles!receiver_id ( id, first_name, last_name, avatar_url )
        `,
    )
    .eq('status', 'accepted')
    .or(`requester_id.eq.${userId},receiver_id.eq.${userId}`);

  if (error) throw error;

  // Normalize → always return "the other user"
  return data.map((f) => (f.requester.id === userId ? f.receiver : f.requester));
};

export const fetchUserPlans = async (planId: string[]) => {
  const { data, error } = await supabase
    .from('devotional_plans_view')
    .select('*')
    .neq('status', 'draft')
    .in('id', planId);
  if (error) throw error;
  return data;
};

export const getUserByEmail = async (email: string) => {
  const { data, error } = await supabase
    .rpc('get_user_by_email', {
      p_email: email,
    })
    .single();
  if (error) {
    throw error;
  }
  return data;
};

export const fetchPendingFriendRequests = async () => {
  const { data, error } = await supabase.rpc('get_pending_friend_requests');
  if (error) throw error;
  return data;
};

export const getUserNotifications = async () => {
  const { data, error } = await supabase.rpc('get_my_notifications');
  if (error) throw error;
  return data;
};

export const getUserNotificationsCount = async () => {
  const { count, error } = await supabase
    .from('notifications')
    .select('*', { count: 'exact', head: true })
    .eq('is_read', false);
  if (error) throw error;
  return count;
};

export const togglePlanReaction = async (planId: string, userId: string) => {
  if (!planId || !userId) {
    return null;
  }
  const { data, error } = await supabase.rpc('toggle_reaction', {
    p_plan_id: planId,
    p_reaction_type: 'helpful',
  });

  if (error) throw error;
  return data;
};

export type PlanReactionSummary = {
  helpful_count: number;
  user_reaction: 'helpful' | null;
};

export const getPlanReactionSummary = async (planId: string) => {
  const { data, error } = await supabase
    .rpc('get_plan_reaction_summary', { p_plan_id: planId })
    .single();

  if (error) throw error;

  const raw = data as {
    helpful_count?: number | null;
    user_reaction?: string | null;
  } | null;
  const reaction = raw?.user_reaction === 'helpful' ? ('helpful' as const) : null;

  return {
    helpful_count: raw?.helpful_count ?? 0,
    user_reaction: reaction,
  } as PlanReactionSummary;
};

export const reportPlan = async (reason: string, planId: string) => {
  const { error } = await supabase.rpc('report_plan', {
    p_plan_id: planId,
    p_reason: reason,
  });
  if (error) throw error;
};

export const getProfile = async (userId: string) => {
  const { data, error } = await supabase.from('profiles').select(`*`).eq('id', userId).single();
  if (error) {
    throw error;
  }
  return data;
};

export const getNotificationsPreferences = async (userId: string) => {
  const { data, error } = await supabase
    .from('notification_preferences')
    .select('*')
    .eq('user_id', userId!)
    .single();

  if (error && error.code !== 'PGRST116') {
    throw error;
  }

  return data;
};

export const updateLastSeen = async (userId: string) => {
  await supabase.from('profiles').update({ last_seen: new Date().toISOString() }).eq('id', userId);
};
