import { PlanProgressInsert } from '@/types/types';
import { supabase } from './supabaseClient';
export const searchRelatedPlans = async (currentPlanId: string, tags: string) => {
  const { data, error } = await supabase
    .from('devotional_plans')
    .select('id, title, cover_image, total_days, tags, description')
    .neq('id', currentPlanId)
    .textSearch('tags', tags, { type: 'websearch' })
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
  let { data, error } = await supabase.from('devotional_plans').select('*').eq('id', id).single();

  if (error) throw error;

  return data;
};

export const fetchDayItems = async ({
  user_id,
  plan_id,
  day_id,
  groupId,
}: {
  user_id: string;
  plan_id: string;
  day_id: string;
  groupId?: string;
}) => {
  let query = supabase
    .from('day_items_progress')
    .select('*')
    .eq('user_id', user_id)
    .eq('plan_id', plan_id)
    .eq('day_id', day_id);
  if (groupId) {
    query = query.eq('group_id', groupId);
  } else {
    query = query.is('group_id', null);
  }
  const { data, error } = await query;

  if (error) throw error;
  // Return mapped progress
  return data;
};

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

export const loadDayItems = async ({
  user_id,
  plan_id,
  day_id,
  groupId,
}: {
  user_id: string;
  plan_id: string;
  day_id: string;
  groupId?: string;
}) => {
  const { error } = await supabase.rpc('ensure_day_items_exist', {
    p_user_id: user_id,
    p_plan_id: plan_id,
    p_day_id: day_id,
    p_group_id: groupId,
  });

  if (error) throw error;
};

export const fetchPlanProgress = async ({
  plan_id,
  user_id,
  groupId,
}: {
  plan_id: string;
  user_id: string;
  groupId?: string;
}) => {
  let query = supabase
    .from('plan_progress')
    .select('*')
    .eq('plan_id', plan_id)
    .eq('user_id', user_id);

  if (groupId) {
    query = query.eq('group_id', groupId);
  } else {
    query = query.is('group_id', null);
  }
  const { data, error } = await query.single();

  if (error && error.code !== 'PGRST116') throw error;
  return data;
};

export const fetchUserPlanProgress = async ({ user_id }: { user_id: string }) => {
  let { data, error } = await supabase.from('plan_progress').select('*').eq('user_id', user_id);

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

export const insertToPlanProgress = async (payload: PlanProgressInsert) => {
  const { data, error } = await supabase.from('plan_progress').insert(payload).select('*').single();

  if (error) throw error;
  return data;
};

export const fetchPlanDayView = async (day_id: string) => {
  const { data, error } = await supabase
    .from('plan_day_view')
    .select('*')
    .eq('day_id', day_id ?? '')
    .single();

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

export const commentsRealTimeChannel = async (group_id: string, onNew: () => void) => {
  return supabase
    .channel('comments')
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'comments',
        filter: `group_id=eq.${group_id}`,
      },
      () => {
        onNew();
      },
    )
    .subscribe();
};

export const fetchUserPlans = async (planId: string[]) => {
  const { data, error } = await supabase.from('devotional_plans_view').select('*').in('id', planId);
  if (error) throw error;
  return data;
};

export const addFriend = async ({ receiver_id }: { receiver_id: string }) => {
  const { error } = await supabase.rpc('send_friend_request', {
    p_receiver_id: receiver_id,
  });
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

export const fetchPendingFriendRequests = async () => {
  const { data, error } = await supabase.rpc('get_pending_friend_requests');
  if (error) throw error;
  return data;
};

export const FriendRequestRealTime = async ({
  userId: userId,
  onNew,
}: {
  userId: string;
  onNew: () => void;
}) => {
  return supabase
    .channel(`friends:requester:${userId}`)
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'friends',
        filter: `requester_id=eq.${userId}`,
      },
      onNew,
    )
    .subscribe();
};

export const FriendRequestRealTimeReceiver = async ({
  userId: userId,
  onNew,
}: {
  userId: string;
  onNew: () => void;
}) => {
  return supabase
    .channel(`friends:receiver:${userId}`)
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'friends',
        filter: `receiver_id=eq.${userId}`,
      },
      onNew,
    )
    .subscribe();
};

export const InviteFriendsToPlanGroup = async ({
  groupId,
  userIds,
}: {
  groupId: string;
  userIds: string[];
}) => {
  const { error } = await supabase.rpc('invite_friends_to_plan_group', {
    p_group_id: groupId,
    p_user_ids: userIds,
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

export const markNotificationRead = async (p_notification_id: string) => {
  const { error } = await supabase.rpc('mark_notification_read', {
    p_notification_id,
  });
  if (error) throw error;
};

export const notificationsRealTime = async (userId: string, onNew: () => void) => {
  return supabase
    .channel('notifications')
    .on(
      'postgres_changes',
      {
        event: '*',
        schema: 'public',
        table: 'notifications',
        filter: `user_id=eq.${userId}`,
      },
      () => {
        onNew(); // refetch notifications
      },
    )
    .subscribe();
};
