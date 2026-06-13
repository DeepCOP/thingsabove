import { getCurrentDeviceExpoPushToken } from '../lib/pushToken';
import { supabase } from '../lib/supabaseClient';
import dayjs from '../lib/dayjs';
import {
  DayItemType,
  PlanProgress,
  ProfileLocation,
  SignUpAboutDetailsInput,
  SignUpProfileInput,
  UpdateProfileInput,
} from '../types/types';
export {
  signInUserWithAppleIdToken,
  signInUserWithGoogleIdToken,
  signInUserWithOAuth,
} from '../lib/authOAuth';

const normalizePlanStartDate = (value: string) => {
  const parsedValue = dayjs(value);
  return parsedValue.isValid() ? parsedValue.format('YYYY-MM-DD') : value;
};

export const toggleItemCompletion = async ({
  item_type,
  item_key,
  completed,
  user_id,
  plan_id,
  progress_id,
  day_id,
  groupId,
}: {
  item_type: DayItemType;
  item_key: string;
  completed: boolean;
  user_id: string;
  plan_id: string;
  progress_id: string;
  day_id: string;
  groupId?: string;
}) => {
  const { error } = await supabase.rpc('toggle_item_completion', {
    p_user_id: user_id,
    p_plan_id: plan_id,
    p_progress_id: progress_id,
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
  progress_id,
  day_id,
  groupId,
}: {
  completed: boolean;
  user_id: string;
  plan_id: string;
  progress_id: string;
  day_id: string;
  groupId?: string;
}) => {
  const { error } = await supabase.rpc('toggle_day_completion', {
    p_user_id: user_id,
    p_plan_id: plan_id,
    p_progress_id: progress_id,
    p_day_id: day_id,
    p_completed: completed,
    p_group_id: groupId,
  });

  if (error) throw error;
};

export const startPlanProgress = async ({
  user_id,
  plan_id,
  group_id,
}: {
  user_id: string;
  plan_id: string;
  group_id?: string;
}) => {
  const { data, error } = await supabase.rpc('start_private_plan_progress', {
    p_user_id: user_id,
    p_plan_id: plan_id,
    p_group_id: group_id,
  });

  if (error) throw error;
  return data as PlanProgress;
};

export const stopPlanProgress = async ({
  user_id,
  progress_id,
}: {
  user_id: string;
  progress_id: string;
}) => {
  const { error } = await supabase.rpc('stop_plan_progress', {
    p_progress_id: progress_id,
  });

  if (error) throw error;

  return { progress_id, user_id };
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

export const updatePlanDayComment = async ({
  commentId,
  content,
}: {
  commentId: string;
  content: string;
}) => {
  const trimmedContent = content.trim();
  const { error } = await supabase
    .from('comments')
    .update({ content: trimmedContent })
    .eq('id', commentId);

  if (error) throw error;
};

export const deletePlanDayComment = async ({ commentId }: { commentId: string }) => {
  const { error } = await supabase.from('comments').delete().eq('id', commentId);

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
  const { data, error } = await supabase.rpc('create_plan_group', {
    p_user_id: user_id,
    p_plan_id: plan_id,
    p_start_date: normalizePlanStartDate(start_date),
    p_friends_ids: invited_user_ids,
  });

  if (error) throw error;
  return data as PlanProgress;
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

export const inviteFriendsToPlanGroup = async ({
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

export const acceptPlanGroupInvite = async ({
  group_id,
  plan_id,
  startDate,
}: {
  group_id: string;
  plan_id: string;
  startDate: string;
}) => {
  if (!group_id || !plan_id) return;
  const { data, error } = await supabase.rpc('accept_plan_group_invite', {
    p_group_id: group_id,
    p_plan_id: plan_id,
    p_start_date: normalizePlanStartDate(startDate),
  });

  if (error) {
    throw error;
  }
  return data as PlanProgress;
};

export const declinePlanGroupInvite = async ({
  group_id,
  user_id,
}: {
  group_id: string;
  user_id?: string;
}) => {
  if (!group_id || !user_id) return;

  const { error } = await supabase
    .from('plan_group_members')
    .delete()
    .eq('group_id', group_id)
    .eq('user_id', user_id)
    .eq('status', 'pending');

  if (error) throw error;
};

export const acceptChurchInvite = async ({ churchId }: { churchId: string }) => {
  const { error } = await supabase.rpc('accept_church_invite', {
    p_church_id: churchId,
  });

  if (error) throw error;
};

export const markNotificationRead = async (p_notification_id: string) => {
  const { error } = await supabase.rpc('mark_notification_read', {
    p_notification_id,
  });
  if (error) throw error;
};

export const uploadAvatar = async (
  filePath: string,
  mimeType: string,
  arraybuffer: ArrayBuffer,
) => {
  const { data, error: uploadError } = await supabase.storage
    .from('avatars')
    .upload(filePath, arraybuffer, {
      contentType: mimeType ?? 'image/jpeg',
      upsert: true,
    });

  if (uploadError) {
    throw uploadError;
  }

  return data;
};

export const updateProfile = async ({
  first_name,
  last_name,
  avatar_url,
  bio,
  year_believed,
  year_baptized,
  church_id,
  church_name,
  church_address,
  church_website_url,
  clear_church,
}: UpdateProfileInput) => {
  const { error } = await supabase.rpc('update_profile', {
    p_first_name: first_name,
    p_last_name: last_name,
    p_avatar_url: avatar_url,
    p_bio: bio,
    p_year_believed: year_believed ?? undefined,
    p_year_baptized: year_baptized ?? undefined,
    p_church_id: church_id ?? undefined,
    p_church_name: church_name ?? undefined,
    p_church_address: church_address ?? undefined,
    p_church_website_url: church_website_url ?? undefined,
    p_clear_church: clear_church ?? false,
  });

  if (error) throw error;
};

export const saveSignupAboutDetails = async ({
  user_id,
  email,
  year_believed,
  year_baptized,
  church_id,
  church_name,
  church_address,
  church_website_url,
  clear_church,
}: SignUpAboutDetailsInput) => {
  const { error } = await supabase.rpc('save_signup_about_details', {
    p_user_id: user_id,
    p_email: email,
    p_year_believed: year_believed ?? undefined,
    p_year_baptized: year_baptized ?? undefined,
    p_church_id: church_id ?? undefined,
    p_church_name: church_name ?? undefined,
    p_church_address: church_address ?? undefined,
    p_church_website_url: church_website_url ?? undefined,
    p_clear_church: clear_church ?? false,
  });

  if (error) throw error;
};

export const deleteAvatarFromStorage = async (filePath: string) => {
  const { error } = await supabase.storage.from('avatars').remove([filePath]);

  if (error) throw error;
};

export const signUpUser = async ({
  email,
  password,
  firstName,
  lastName,
  yearBelieved,
  yearBaptized,
  churchName,
  churchAddress,
  churchWebsiteUrl,
}: SignUpProfileInput) => {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      emailRedirectTo: `${process.env.EXPO_PUBLIC_WEB_INTERFACE_URL || 'https://localhost:3000'}/auth/confirm`,
      data: {
        first_name: firstName,
        last_name: lastName,
        year_believed: yearBelieved ?? null,
        year_baptized: yearBaptized ?? null,
        church_name: churchName ?? null,
        church_address: churchAddress ?? null,
        church_website_url: churchWebsiteUrl ?? null,
      },
    },
  });
  if (error) throw error;

  // Supabase returns an obfuscated/fake user with empty identities for existing confirmed users
  // when email confirmations are enabled. Treat this as "already registered".
  if (data?.user?.identities && data.user.identities.length === 0) {
    throw new Error(
      'This email is already connected to an account. Please sign in instead, or use Google/Apple if that is how you created the account.',
    );
  }

  return data;
};

export const signInUserWithPassword = async (email: string, password: string) => {
  const { error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) throw error;
};

export const toggleDailyEncouragement = async (value: boolean, userId: string | undefined) => {
  if (!userId) return;
  const { error } = await supabase.from('notification_preferences').upsert({
    user_id: userId,
    daily: value,
    updated_at: new Date().toISOString(),
  });

  if (error) throw error;

  return value;
};

export const toggleGroupDayCompletedPushNotifications = async (
  value: boolean,
  userId: string | undefined,
) => {
  if (!userId) return;
  const { error } = await supabase.from('notification_preferences').upsert({
    user_id: userId,
    group_day_completed: value,
    updated_at: new Date().toISOString(),
  });

  if (error) throw error;

  return value;
};

export const pushNotificationSetup = async (userTimeZone: string, token: string) => {
  await supabase.rpc('upsert_push_notification_setup', {
    p_timezone: userTimeZone,
    p_expo_push_token: token,
  });
};

export const clearPushNotificationSetup = async (userId?: string) => {
  if (!userId) return;

  const currentDeviceToken = await getCurrentDeviceExpoPushToken();
  if (!currentDeviceToken) return;

  await supabase
    .from('profiles')
    .update({ expo_push_token: null })
    .eq('id', userId)
    .eq('expo_push_token', currentDeviceToken);
};

export const saveUserLocation = async ({
  userId,
  location,
}: {
  userId: string;
  location: ProfileLocation;
}) => {
  const { error } = await supabase
    .from('profiles')
    .update({
      location,
      updated_at: new Date().toISOString(),
      ...(location.timezone ? { timezone: location.timezone } : {}),
    })
    .eq('id', userId);

  if (error) throw error;

  return location;
};

export const upsertPlanRating = async ({ planId, rating }: { planId: string; rating: number }) => {
  const { error } = await (supabase as any).rpc('upsert_plan_rating', {
    p_plan_id: planId,
    p_rating: rating,
  });

  if (error) throw error;
};
