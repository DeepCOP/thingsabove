import AsyncStorage from '@react-native-async-storage/async-storage';

const OAUTH_RETURN_TO_STORAGE_KEY = 'thingsabove:oauth:return-to';

export const normalizeOAuthReturnTo = (returnTo?: string | null) => {
  const trimmed = returnTo?.trim();

  if (!trimmed) return null;
  if (!trimmed.startsWith('/app')) return null;
  if (trimmed.startsWith('/app/signin') || trimmed.startsWith('/app/signup')) return null;
  if (trimmed.includes('://') || trimmed.startsWith('//')) return null;

  return trimmed;
};

export const setPendingOAuthReturnTo = async (returnTo?: string | null) => {
  const normalizedReturnTo = normalizeOAuthReturnTo(returnTo);

  if (!normalizedReturnTo) {
    await AsyncStorage.removeItem(OAUTH_RETURN_TO_STORAGE_KEY);
    return;
  }

  await AsyncStorage.setItem(OAUTH_RETURN_TO_STORAGE_KEY, normalizedReturnTo);
};

export const consumePendingOAuthReturnTo = async () => {
  const returnTo = normalizeOAuthReturnTo(await AsyncStorage.getItem(OAUTH_RETURN_TO_STORAGE_KEY));
  await AsyncStorage.removeItem(OAUTH_RETURN_TO_STORAGE_KEY);
  return returnTo;
};

export const clearPendingOAuthReturnTo = async () => {
  await AsyncStorage.removeItem(OAUTH_RETURN_TO_STORAGE_KEY);
};
