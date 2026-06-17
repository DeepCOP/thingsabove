import * as Linking from 'expo-linking';
import * as WebBrowser from 'expo-web-browser';

import { supabase } from './supabaseClient';

export type OAuthProvider = 'google' | 'apple';

export type AppleIdentityFullName = {
  givenName?: string | null;
  middleName?: string | null;
  familyName?: string | null;
};

export type NativeIdentityProfile = {
  email?: string | null;
  familyName?: string | null;
  fullName?: string | null;
  givenName?: string | null;
  photoUrl?: string | null;
};

const OAUTH_CALLBACK_PATH = 'auth/callback';
const OAUTH_PROVIDER_SCOPES: Record<OAuthProvider, string> = {
  google: 'email profile',
  apple: 'name email',
};
const DEFAULT_PROFILE_FIRST_NAME = 'Member';
const DEFAULT_PROFILE_LAST_NAME = 'Member';

const getOAuthRedirectUrl = () => Linking.createURL(OAUTH_CALLBACK_PATH);

const cleanNamePart = (value?: string | null) => {
  const trimmed = value?.trim();
  return trimmed ? trimmed : null;
};

const isValidProfileNamePart = (value?: string | null) => {
  const trimmed = cleanNamePart(value);
  return Boolean(trimmed && trimmed.length >= 2 && trimmed.length <= 50);
};

const isMissingText = (value?: string | null) => !cleanNamePart(value);

const getMetadataText = (metadata: Record<string, unknown>, key: string) => {
  const value = metadata[key];
  return typeof value === 'string' ? value : null;
};

const isMissingProfileFirstName = (value?: string | null) => {
  const trimmed = cleanNamePart(value);
  return !trimmed || trimmed === DEFAULT_PROFILE_FIRST_NAME;
};

const isMissingProfileLastName = (value?: string | null) => {
  const trimmed = cleanNamePart(value);
  return !trimmed || trimmed === DEFAULT_PROFILE_LAST_NAME;
};

const getIdentityProfileMetadata = (profile?: NativeIdentityProfile | null) => {
  const givenName = cleanNamePart(profile?.givenName);
  const familyName = cleanNamePart(profile?.familyName);
  const fullName = cleanNamePart(profile?.fullName);
  const photoUrl = cleanNamePart(profile?.photoUrl);
  const email = cleanNamePart(profile?.email);

  if (!givenName && !familyName && !fullName && !photoUrl && !email) {
    return null;
  }

  return {
    fullName,
    givenName,
    familyName,
    photoUrl,
    email,
  };
};

const getAppleFullNameMetadata = (fullName?: AppleIdentityFullName | null) => {
  const givenName = cleanNamePart(fullName?.givenName);
  const middleName = cleanNamePart(fullName?.middleName);
  const familyName = cleanNamePart(fullName?.familyName);
  const fullNameText = [givenName, middleName, familyName].filter(Boolean).join(' ').trim();

  return getIdentityProfileMetadata({
    familyName,
    fullName: fullNameText,
    givenName,
  });
};

const saveNativeIdentityProfile = async (profile?: NativeIdentityProfile | null) => {
  const metadata = getIdentityProfileMetadata(profile);
  if (!metadata) return;

  const { data: userData, error: getUserError } = await supabase.auth.getUser();
  if (getUserError) throw getUserError;

  const currentAuthMetadata = (userData.user?.user_metadata ?? {}) as Record<string, unknown>;
  const authMetadataUpdates: Record<string, string> = {};

  if (metadata.fullName && isMissingText(getMetadataText(currentAuthMetadata, 'full_name'))) {
    authMetadataUpdates.full_name = metadata.fullName;
  }

  if (metadata.givenName) {
    if (isMissingText(getMetadataText(currentAuthMetadata, 'given_name'))) {
      authMetadataUpdates.given_name = metadata.givenName;
    }

    if (isMissingText(getMetadataText(currentAuthMetadata, 'first_name'))) {
      authMetadataUpdates.first_name = metadata.givenName;
    }
  }

  if (metadata.familyName) {
    if (isMissingText(getMetadataText(currentAuthMetadata, 'family_name'))) {
      authMetadataUpdates.family_name = metadata.familyName;
    }

    if (isMissingText(getMetadataText(currentAuthMetadata, 'last_name'))) {
      authMetadataUpdates.last_name = metadata.familyName;
    }
  }

  if (metadata.photoUrl && isMissingText(getMetadataText(currentAuthMetadata, 'avatar_url'))) {
    authMetadataUpdates.avatar_url = metadata.photoUrl;
  }

  if (Object.keys(authMetadataUpdates).length > 0) {
    const { error: updateUserError } = await supabase.auth.updateUser({
      data: authMetadataUpdates,
    });

    if (updateUserError) throw updateUserError;
  }

  if (!userData.user?.id) return;

  const { data: currentProfile, error: getProfileError } = await supabase
    .from('profiles')
    .select('first_name,last_name,avatar_url')
    .eq('id', userData.user.id)
    .maybeSingle();

  if (getProfileError) throw getProfileError;
  if (!currentProfile) return;

  const profileUpdates: {
    p_avatar_url?: string;
    p_first_name?: string;
    p_last_name?: string;
  } = {};

  if (
    isValidProfileNamePart(metadata.givenName) &&
    metadata.givenName &&
    isMissingProfileFirstName(currentProfile.first_name)
  ) {
    profileUpdates.p_first_name = metadata.givenName;
  }

  if (
    isValidProfileNamePart(metadata.familyName) &&
    metadata.familyName &&
    isMissingProfileLastName(currentProfile.last_name)
  ) {
    profileUpdates.p_last_name = metadata.familyName;
  }

  if (metadata.photoUrl && isMissingText(currentProfile.avatar_url)) {
    profileUpdates.p_avatar_url = metadata.photoUrl;
  }

  if (Object.keys(profileUpdates).length > 0) {
    const { error: updateProfileError } = await supabase.rpc('update_profile', {
      ...profileUpdates,
      p_clear_church: false,
    });

    if (updateProfileError) throw updateProfileError;
  }
};

const getCallbackParam = (url: string, key: string) => {
  const parsedUrl = new URL(url);
  const searchParams = new URLSearchParams(parsedUrl.search);
  const hashParams = new URLSearchParams(parsedUrl.hash.replace(/^#/, ''));

  return hashParams.get(key) ?? searchParams.get(key);
};

const getExistingAuthSessionData = async () => {
  const { data } = await supabase.auth.getSession();

  if (!data.session) return null;

  return {
    session: data.session,
    user: data.session.user,
  };
};

export const createSessionFromCallbackUrl = async (url: string) => {
  const errorDescription = getCallbackParam(url, 'error_description');
  const error = getCallbackParam(url, 'error');

  if (errorDescription || error) {
    throw new Error(errorDescription ?? error ?? 'OAuth sign in failed.');
  }

  const code = getCallbackParam(url, 'code');
  if (code) {
    const { data, error } = await supabase.auth.exchangeCodeForSession(code);
    if (error) {
      const existingSessionData = await getExistingAuthSessionData();
      if (existingSessionData) return existingSessionData;

      throw error;
    }
    return data;
  }

  const accessToken = getCallbackParam(url, 'access_token');
  const refreshToken = getCallbackParam(url, 'refresh_token');

  if (!accessToken || !refreshToken) {
    throw new Error('Unable to complete OAuth sign in. Please try again.');
  }

  const { data, error: sessionError } = await supabase.auth.setSession({
    access_token: accessToken,
    refresh_token: refreshToken,
  });

  if (sessionError) {
    const existingSessionData = await getExistingAuthSessionData();
    if (existingSessionData) return existingSessionData;

    throw sessionError;
  }

  return data;
};

export const signInUserWithOAuth = async (provider: OAuthProvider) => {
  const redirectTo = getOAuthRedirectUrl();
  const { data, error } = await supabase.auth.signInWithOAuth({
    provider,
    options: {
      redirectTo,
      scopes: OAUTH_PROVIDER_SCOPES[provider],
      skipBrowserRedirect: true,
    },
  });

  if (error) throw error;
  if (!data?.url) {
    throw new Error('Unable to start OAuth sign in. Please try again.');
  }

  const result = await WebBrowser.openAuthSessionAsync(data.url, redirectTo);
  if (result.type !== 'success') {
    return null;
  }

  return createSessionFromCallbackUrl(result.url);
};

export const signInUserWithAppleIdToken = async ({
  fullName,
  identityToken,
}: {
  fullName?: AppleIdentityFullName | null;
  identityToken: string;
}) => {
  const { data, error } = await supabase.auth.signInWithIdToken({
    provider: 'apple',
    token: identityToken,
  });

  if (error) throw error;

  await saveNativeIdentityProfile(getAppleFullNameMetadata(fullName));

  return data;
};

export const signInUserWithGoogleIdToken = async ({
  identityToken,
  profile,
}: {
  identityToken: string;
  profile?: NativeIdentityProfile | null;
}) => {
  const { data, error } = await supabase.auth.signInWithIdToken({
    provider: 'google',
    token: identityToken,
  });

  if (error) throw error;

  await saveNativeIdentityProfile(profile);

  return data;
};
