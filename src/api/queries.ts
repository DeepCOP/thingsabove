import { supabase } from '../lib/supabaseClient';
import { ProfileLocation, ProfilesUpdate, ProfileWithChurch } from '../types/types';

export type PlanCursor = {
  created_at: string;
  id: string;
};

export const searchRelatedPlans = async (currentPlanId: string, tags: string[]) => {
  if (!tags.length) return [];
  const { data, error } = await supabase.rpc('get_related_public_plans', {
    p_current_plan_id: currentPlanId,
    p_tags: tags,
    p_limit_count: 10,
  });
  if (error) throw error;

  return data ?? [];
};

export const searchPlans = async ({
  pageParam,
  query,
}: {
  pageParam: PlanCursor | null;
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
  const items = data ?? [];
  const last = items[items.length - 1];

  return {
    items,
    nextCursor: last?.created_at && last.id ? { created_at: last.created_at, id: last.id } : null,
  };
};

export const fetchPlans = async ({ pageParam }: { pageParam: PlanCursor | null }) => {
  const PAGE_SIZE = 10;
  const { created_at, id } = pageParam ?? {};

  const { data, error } = await supabase.rpc('get_discover_plans', {
    p_limit_count: PAGE_SIZE,
    p_cursor_created_at: created_at ?? undefined,
    p_cursor_id: id ?? undefined,
  });
  if (error) throw error;

  const items = data ?? [];

  // last item becomes the new cursor
  const last = items[items.length - 1];

  return {
    items,
    nextCursor: last ? { created_at: last.created_at, id: last.id } : null,
  };
};

export const fetchPlanById = async (id: string) => {
  const { data, error } = await supabase.rpc('get_published_plan_by_id', {
    p_plan_id: id,
  });

  if (error) throw error;

  const plan = data?.[0];

  if (!plan) {
    throw new Error('Plan not found');
  }

  return plan;
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
  if (!planId.length) {
    return [];
  }

  const { data, error } = await supabase.rpc('get_published_plans_by_ids', {
    p_plan_ids: planId,
  });
  if (error) throw error;
  return data ?? [];
};

export const fetchMySavedPlans = async () => {
  const { data, error } = await supabase.rpc('get_my_saved_plans');

  if (error) throw error;

  const items = data ?? [];

  return items;
};

export const fetchMyDevotionalPlans = async () => {
  const { data, error } = await supabase.rpc('get_my_devotional_plans');

  if (error) throw error;

  return data ?? [];
};

export const fetchMyPlanProgressPlans = async () => {
  const { data, error } = await supabase.rpc('get_my_plan_progress_plans');

  if (error) throw error;

  const items = data ?? [];

  return items;
};

export const savePlanForUser = async (userId: string, planId: string) => {
  if (!userId || !planId) return;
  const { error } = await supabase
    .from('saved_plans')
    .upsert({ user_id: userId, plan_id: planId }, { onConflict: 'user_id,plan_id' });

  if (error) throw error;
};

export const removeSavedPlanForUser = async (userId: string, planId: string) => {
  if (!userId || !planId) return;
  const { error } = await supabase
    .from('saved_plans')
    .delete()
    .eq('user_id', userId)
    .eq('plan_id', planId);

  if (error) throw error;
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

export const reportPlan = async (reason: string, planId: string) => {
  const { error } = await supabase.rpc('report_plan', {
    p_plan_id: planId,
    p_reason: reason,
  });
  if (error) throw error;
};

export const getProfile = async (userId: string) => {
  const { data, error } = await supabase.rpc('get_profile', {
    p_user_id: userId,
  });

  if (error) {
    throw error;
  }

  if (!data) {
    throw new Error('Profile not found');
  }

  return data as ProfileWithChurch;
};

export const resolveApproximateLocationFromIp = async () => {
  const { data, error } = await supabase.functions.invoke('resolve-ip-location');

  if (error) {
    throw error;
  }

  const location = data?.location as ProfileLocation | undefined;

  if (!location) {
    throw new Error('Approximate location not found');
  }

  return location;
};

export const searchChurches = async (query: string) => {
  const trimmed = query.trim();
  if (!trimmed) return [];
  const sanitized = trimmed.replace(/,/g, ' ');

  const { data, error } = await supabase
    .from('churches')
    .select('id, name, address, website_url')
    .or(`name.ilike.%${sanitized}%,address.ilike.%${sanitized}%,website_url.ilike.%${sanitized}%`)
    .order('name')
    .limit(8);

  if (error) throw error;
  return data ?? [];
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

export const syncProfilePresence = async ({
  userId,
  deviceOs,
  deviceOsVersion,
  appVersion,
  deviceLanguageTag,
  deviceLanguageCode,
}: {
  userId: string;
  deviceOs?: string | null;
  deviceOsVersion?: string | null;
  appVersion?: string | null;
  deviceLanguageTag?: string | null;
  deviceLanguageCode?: string | null;
}) => {
  const updates: ProfilesUpdate = {
    last_seen: new Date().toISOString(),
    ...(appVersion != null ? { app_version: appVersion } : {}),
    ...(deviceOs != null ? { device_os: deviceOs } : {}),
    ...(deviceOsVersion != null ? { device_os_version: deviceOsVersion } : {}),
    ...(deviceLanguageTag != null ? { device_language_tag: deviceLanguageTag } : {}),
    ...(deviceLanguageCode != null ? { device_language_code: deviceLanguageCode } : {}),
  };

  await supabase.from('profiles').update(updates).eq('id', userId);
};

export const fetchMyPlanRating = async (planId: string) => {
  const { data, error } = await (supabase as any).rpc('get_my_plan_rating', {
    p_plan_id: planId,
  });

  if (error) throw error;
  return typeof data === 'number' ? data : null;
};
