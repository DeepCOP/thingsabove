import { supabase } from '../lib/supabaseClient';
import {
  PrayerEncouragementListItem,
  PrayerRequestCursor,
  PrayerFilter,
  PrayerRequestDetail,
  PrayerRequestFeedItem,
  PrayerRequestPage,
  PrayerScope,
} from '../types/types';

export const PRAYER_REQUESTS_PAGE_SIZE = 20;

export const fetchPrayerRequests = async ({
  scope,
  filter,
  limit = PRAYER_REQUESTS_PAGE_SIZE,
  cursor,
}: {
  scope: PrayerScope;
  filter: PrayerFilter;
  limit?: number;
  cursor?: PrayerRequestCursor | null;
}) => {
  const { data, error } = await supabase.rpc('get_prayer_requests', {
    p_scope: scope,
    p_filter: filter,
    p_limit: limit,
    p_before_created_at: cursor?.beforeCreatedAt,
    p_before_id: cursor?.beforeId,
    p_before_is_urgent: cursor?.beforeIsUrgent,
  });

  if (error) throw error;

  const items = (data ?? []) as PrayerRequestFeedItem[];
  const lastItem = items.at(-1);

  return {
    items,
    nextCursor:
      lastItem && items.length === limit
        ? {
            beforeCreatedAt: lastItem.created_at,
            beforeId: lastItem.id,
            beforeIsUrgent: lastItem.is_urgent,
          }
        : undefined,
  } satisfies PrayerRequestPage;
};

export const fetchPrayerRequestDetail = async (requestId: string) => {
  const { data, error } = await supabase.rpc('get_prayer_request_detail', {
    p_request_id: requestId,
  });

  if (error) throw error;

  return (data?.[0] ?? null) as PrayerRequestDetail | null;
};

export const fetchPrayerRequestEncouragements = async (requestId: string) => {
  const { data, error } = await supabase
    .from('prayer_request_encouragements')
    .select(
      `
        id,
        request_id,
        user_id,
        content,
        created_at,
        author:profiles!prayer_request_encouragements_user_id_fkey (
          id,
          first_name,
          last_name,
          avatar_url
        )
          
      `,
    )
    .eq('request_id', requestId)
    .order('created_at', { ascending: false });

  if (error) throw error;

  return (data ?? []) as PrayerEncouragementListItem[];
};
