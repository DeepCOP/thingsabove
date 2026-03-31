import { supabase } from '../lib/supabaseClient';
import {
  PrayerEncouragementListItem,
  PrayerFilter,
  PrayerRequestDetail,
  PrayerRequestFeedItem,
  PrayerScope,
} from '../types/types';

export const fetchPrayerRequests = async ({
  scope,
  filter,
}: {
  scope: PrayerScope;
  filter: PrayerFilter;
}) => {
  const { data, error } = await supabase.rpc('get_prayer_requests', {
    p_scope: scope,
    p_filter: filter,
  });

  if (error) throw error;

  return (data ?? []) as PrayerRequestFeedItem[];
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
