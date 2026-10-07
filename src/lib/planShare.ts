import i18n from '@/src/i18n';
import * as ExpoLinking from 'expo-linking';

const trimTrailingSlash = (value: string) => value.replace(/\/+$/, '');

const buildUrl = (path: string, params?: Record<string, string | undefined>) => {
  const searchParams = new URLSearchParams();

  Object.entries(params ?? {}).forEach(([key, value]) => {
    if (!value) return;
    searchParams.set(key, value);
  });

  const suffix = searchParams.toString() ? `${path}?${searchParams.toString()}` : path;
  const baseUrl = process.env.EXPO_PUBLIC_BASE_URL?.trim();

  if (baseUrl) {
    return `${trimTrailingSlash(baseUrl)}${suffix}`;
  }

  return ExpoLinking.createURL(suffix);
};

export const buildPlanInvitationUrl = ({
  planId,
  groupId,
  invitedBy,
  inviteCode,
}: {
  planId: string;
  groupId: string;
  invitedBy?: string;
  inviteCode?: string;
}) => {
  if (inviteCode?.trim()) {
    return buildUrl(`/app/invite/${encodeURIComponent(inviteCode.trim())}`);
  }

  return buildUrl(`/app/devotional_detail/${planId}/invite`, {
    groupId,
    invitedBy,
  });
};

export const buildPlanInvitationMessage = ({
  planId,
  groupId,
  invitedBy,
  inviterName,
  inviteCode,
  planTitle,
}: {
  planId: string;
  groupId: string;
  invitedBy?: string;
  inviterName?: string;
  inviteCode?: string;
  planTitle?: string | null;
}) => {
  const invitationUrl = buildPlanInvitationUrl({
    planId,
    groupId,
    invitedBy,
    inviteCode,
  });
  const formattedPlanTitle = planTitle?.trim()
    ? i18n.t('sharePlanTitle', { ns: 'community', title: planTitle.trim() })
    : i18n.t('shareThisPlan', { ns: 'community' });

  return [
    inviterName
      ? i18n.t('planInviteNamed', { ns: 'community', plan: formattedPlanTitle, name: inviterName })
      : i18n.t('planInvite', { ns: 'community', plan: formattedPlanTitle }),
    invitationUrl,
  ].join('\n\n');
};

export const buildFriendInviteUrl = () => buildUrl('/app/signup');

export const buildFriendInviteMessage = () => {
  const invitationUrl = buildFriendInviteUrl();

  return [
    i18n.t('friendInviteJoin', { ns: 'community' }),
    i18n.t('friendInviteConnect', { ns: 'community' }),
    invitationUrl,
  ].join('\n\n');
};
