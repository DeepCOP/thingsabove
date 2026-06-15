import { supabase } from '../lib/supabaseClient';
import { PrayerCategory, PrayerScope } from '../types/types';

export type SavePrayerRequestInput = {
  requestId?: string;
  scope: PrayerScope;
  category: PrayerCategory;
  content: string;
  isAnonymous: boolean;
  isUrgent: boolean;
  allowComments: boolean;
};

export const savePrayerRequest = async ({
  requestId,
  scope,
  category,
  content,
  isAnonymous,
  isUrgent,
  allowComments,
}: SavePrayerRequestInput) => {
  const args = {
    p_scope: scope,
    p_category: category,
    p_content: content,
    p_is_anonymous: isAnonymous,
    p_is_urgent: isUrgent,
    p_allow_comments: allowComments,
  };

  const { data, error } = requestId
    ? await supabase.rpc('update_prayer_request', {
        p_request_id: requestId,
        ...args,
      })
    : await supabase.rpc('create_prayer_request', args);

  if (error) throw error;

  return data;
};

export const togglePrayerRequestSupport = async (requestId: string) => {
  const { data, error } = await supabase.rpc('toggle_prayer_request_support', {
    p_request_id: requestId,
  });

  if (error) throw error;

  return Boolean(data);
};

export const addPrayerRequestEncouragement = async ({
  requestId,
  content,
}: {
  requestId: string;
  content: string;
}) => {
  const { data, error } = await supabase.rpc('add_prayer_request_encouragement', {
    p_request_id: requestId,
    p_content: content,
  });

  if (error) throw error;

  return data;
};

export const setPrayerRequestAnswered = async ({
  requestId,
  isAnswered,
  testimony,
}: {
  requestId: string;
  isAnswered: boolean;
  testimony?: string;
}) => {
  const { error } = await supabase.rpc('mark_prayer_request_answered', {
    p_request_id: requestId,
    p_is_answered: isAnswered,
    p_testimony: testimony,
  });

  if (error) throw error;
};
