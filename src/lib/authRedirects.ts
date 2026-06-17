import { normalizeOAuthReturnTo } from './oauthReturnTo';

export type AuthRedirectSearchParams = {
  redirectChurchId?: string | string[];
  redirectChurchInvitedBy?: string | string[];
  redirectGroupId?: string | string[];
  redirectInvitedBy?: string | string[];
  redirectPlanId?: string | string[];
  returnTo?: string | string[];
};

type AuthRedirectParams = Record<string, string>;

const getFirstParam = (value?: string | string[] | null) => {
  const firstValue = Array.isArray(value) ? value[0] : value;
  const trimmed = firstValue?.trim();

  return trimmed || null;
};

export const buildPathWithParams = (path: string, params?: AuthRedirectParams) => {
  const searchParams = new URLSearchParams();

  Object.entries(params ?? {}).forEach(([key, value]) => {
    if (!value) return;
    searchParams.set(key, value);
  });

  const search = searchParams.toString();
  return search ? `${path}?${search}` : path;
};

export const getAuthRedirectParams = (params: AuthRedirectSearchParams) => {
  const redirectParams: AuthRedirectParams = {};
  const redirectChurchId = getFirstParam(params.redirectChurchId);
  const redirectChurchInvitedBy = getFirstParam(params.redirectChurchInvitedBy);
  const redirectPlanId = getFirstParam(params.redirectPlanId);
  const redirectGroupId = getFirstParam(params.redirectGroupId);
  const redirectInvitedBy = getFirstParam(params.redirectInvitedBy);
  const returnTo = normalizeOAuthReturnTo(getFirstParam(params.returnTo));

  if (redirectChurchId) {
    redirectParams.redirectChurchId = redirectChurchId;
  }

  if (redirectChurchInvitedBy) {
    redirectParams.redirectChurchInvitedBy = redirectChurchInvitedBy;
  }

  if (redirectPlanId) {
    redirectParams.redirectPlanId = redirectPlanId;
  }

  if (redirectGroupId) {
    redirectParams.redirectGroupId = redirectGroupId;
  }

  if (redirectInvitedBy) {
    redirectParams.redirectInvitedBy = redirectInvitedBy;
  }

  if (returnTo) {
    redirectParams.returnTo = returnTo;
  }

  return redirectParams;
};

export const getPlanInvitationReturnTo = (params: AuthRedirectSearchParams) => {
  const redirectPlanId = getFirstParam(params.redirectPlanId);
  const redirectGroupId = getFirstParam(params.redirectGroupId);
  const redirectInvitedBy = getFirstParam(params.redirectInvitedBy);

  if (!redirectPlanId || !redirectGroupId) return null;

  return buildPathWithParams(
    `/app/devotional_detail/${encodeURIComponent(redirectPlanId)}/invitation`,
    {
      groupId: redirectGroupId,
      ...(redirectInvitedBy ? { invitedBy: redirectInvitedBy } : {}),
    },
  );
};

export const getChurchInvitationReturnTo = (params: AuthRedirectSearchParams) => {
  const redirectChurchId = getFirstParam(params.redirectChurchId);
  const redirectChurchInvitedBy = getFirstParam(params.redirectChurchInvitedBy);

  if (!redirectChurchId) return null;

  return buildPathWithParams(`/app/church/${encodeURIComponent(redirectChurchId)}/invitation`, {
    ...(redirectChurchInvitedBy ? { invitedBy: redirectChurchInvitedBy } : {}),
  });
};

export const getAuthRedirectReturnTo = (params: AuthRedirectSearchParams) =>
  getPlanInvitationReturnTo(params) ??
  getChurchInvitationReturnTo(params) ??
  normalizeOAuthReturnTo(getFirstParam(params.returnTo));

export const getAboutDetailsPath = (params: AuthRedirectSearchParams) =>
  buildPathWithParams('/app/about-details', getAuthRedirectParams(params));
