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
  return buildUrl(`/church/${churchId}`);
};

export const buildChurchInvitationUrl = ({
  churchId,
  invitedBy,
}: {
  churchId: string;
  invitedBy?: string;
}) => {
  return buildUrl(`/church/${churchId}/invitation`, {
    invitedBy,
  });
};

export const buildChurchShareMessage = (church: Church) => {
  const lines = [`Come join us at ${church.name} on ThingsAbove.`, buildChurchShareUrl(church.id)];

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
}: {
  church: Church;
  invitedBy?: string;
  inviterName?: string;
}) => {
  const invitationUrl = buildChurchInvitationUrl({
    churchId: church.id,
    invitedBy,
  });

  const lines = [
    inviterName
      ? `${inviterName} invited you to join ${church.name} on ThingsAbove.`
      : `You are invited to join ${church.name} on ThingsAbove.`,
    invitationUrl,
  ];

  if (church.address) {
    lines.splice(1, 0, church.address);
  }

  return lines.join('\n\n');
};
