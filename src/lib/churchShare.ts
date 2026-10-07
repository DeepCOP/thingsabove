import i18n from '@/src/i18n';
import * as ExpoLinking from 'expo-linking';
import { Church } from '../types/types';

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

export const buildChurchShareUrl = (churchId: string) => {
  return buildUrl(`/app/church/${churchId}`);
};

export const buildChurchInvitationUrl = ({
  churchId,
  invitedBy,
  inviteCode,
}: {
  churchId: string;
  invitedBy?: string;
  inviteCode?: string;
}) => {
  if (inviteCode?.trim()) {
    return buildUrl(`/app/invite/${encodeURIComponent(inviteCode.trim())}`);
  }

  return buildUrl(`/app/church/${churchId}/invitation`, {
    invitedBy,
  });
};

export const buildChurchShareMessage = (church: Church) => {
  const lines = [
    i18n.t('churchShareJoin', { ns: 'community', church: church.name }),
    buildChurchShareUrl(church.id),
  ];

  if (church.address) {
    lines.splice(1, 0, church.address);
  }

  if (church.website_url) {
    lines.push(church.website_url);
  }

  return lines.join('\n\n');
};

export const buildChurchInvitationMessage = ({
  church,
  invitedBy,
  inviterName,
  inviteCode,
}: {
  church: Church;
  invitedBy?: string;
  inviterName?: string;
  inviteCode?: string;
}) => {
  const invitationUrl = buildChurchInvitationUrl({
    churchId: church.id,
    invitedBy,
    inviteCode,
  });

  const lines = [
    inviterName
      ? i18n.t('churchInviteNamed', { ns: 'community', name: inviterName, church: church.name })
      : i18n.t('churchInvite', { ns: 'community', church: church.name }),
    invitationUrl,
  ];

  if (church.address) {
    lines.splice(1, 0, church.address);
  }

  return lines.join('\n\n');
};
