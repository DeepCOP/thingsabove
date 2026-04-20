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
}: {
  planId: string;
  groupId: string;
  invitedBy?: string;
}) => {
  return buildUrl(`/devotional_detail/${planId}/invite`, {
    groupId,
    invitedBy,
  });
};

export const buildPlanInvitationMessage = ({
  planId,
  groupId,
  invitedBy,
  inviterName,
  planTitle,
}: {
  planId: string;
  groupId: string;
  invitedBy?: string;
  inviterName?: string;
  planTitle?: string | null;
}) => {
  const invitationUrl = buildPlanInvitationUrl({
    planId,
    groupId,
    invitedBy,
  });
  const formattedPlanTitle = planTitle?.trim() ? `"${planTitle.trim()}"` : 'this devotional plan';

  return [
    inviterName
      ? `Join me on this devotional 🙏\n${formattedPlanTitle}\n\n• ${inviterName}`
      : `You are invited to read ${formattedPlanTitle} on ThingsAbove.`,
    invitationUrl,
  ].join('\n\n');
};

export const buildFriendInviteUrl = () => buildUrl('/signup');

export const buildFriendInviteMessage = () => {
  const invitationUrl = buildFriendInviteUrl();

  return [
    'Join me on ThingsAbove.',
    "Create your account and let's connect there.",
    invitationUrl,
  ].join('\n\n');
};
