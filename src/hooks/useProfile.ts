import i18n from '@/src/i18n';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { Alert } from 'react-native';
import {
  deleteAvatarFromStorage,
  saveSignupAboutDetails,
  signInUserWithAppleIdToken,
  signInUserWithGoogleIdToken,
  signInUserWithOAuth,
  signInUserWithPassword,
  signUpUser,
  updateProfile,
  uploadAvatar,
} from '../api/mutations';
import { getProfile } from '../api/queries';
import type { AppleIdentityFullName, NativeIdentityProfile, OAuthProvider } from '../lib/authOAuth';
import { SignUpAboutDetailsInput, SignUpProfileInput, UpdateProfileInput } from '../types/types';

const localizeAuthError = (error: Error) => {
  const code = (error as Error & { code?: string }).code;
  if (code === 'invalid_credentials' || error.message === 'Invalid login credentials') {
    return i18n.t('plans:profileErrorsCredentials');
  }
  if (code === 'email_not_confirmed' || error.message === 'Email not confirmed') {
    return i18n.t('plans:profileErrorsEmailNotConfirmed');
  }
  if (code === 'user_already_exists' || error.message === 'User already registered') {
    return i18n.t('plans:profileErrorsUserRegistered');
  }
  if (code === 'over_request_rate_limit' || code === 'over_email_send_rate_limit') {
    return i18n.t('plans:profileErrorsRateLimit');
  }
  return error.message;
};

export const useProfile = (userId: string | undefined) => {
  // Placeholder for future profile-related hooks
  return useQuery({
    queryKey: ['profile', userId],
    enabled: !!userId,
    queryFn: () => getProfile(userId!),
  });
};

export const useUploadAvatar = (userId: string | undefined) => {
  const qc = useQueryClient();

  return useMutation({
    mutationFn: async (params: {
      filePath: string;
      mimeType: string;
      arraybuffer: ArrayBuffer;
    }) => {
      return uploadAvatar(params.filePath, params.mimeType, params.arraybuffer);
    },

    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['profile', userId] });
    },
  });
};

export const useDeleteAvatar = (userId: string | undefined) => {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: async (filePath: string) => {
      return deleteAvatarFromStorage(filePath);
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['profile', userId] });
    },
  });
};

export const useUpdateProfile = (userId: string | undefined) => {
  const qc = useQueryClient();
  return useMutation({
    mutationKey: ['update_profile', userId],
    mutationFn: async (profileData: UpdateProfileInput) => updateProfile(profileData),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['profile', userId] });
    },
  });
};

export const useSaveSignupAboutDetails = () => {
  return useMutation({
    mutationKey: ['save_signup_about_details'],
    mutationFn: async (params: SignUpAboutDetailsInput) => saveSignupAboutDetails(params),
  });
};

export const useSignUpUser = () => {
  return useMutation({
    mutationFn: async (params: SignUpProfileInput) => signUpUser(params),
    onError: (error) => {
      Alert.alert(i18n.t('plans:profileErrorsSignUp'), localizeAuthError(error));
    },
  });
};

export const useSignInUserWithPassword = () => {
  return useMutation({
    mutationFn: async (params: { email: string; password: string }) => {
      return signInUserWithPassword(params.email, params.password);
    },
    onError: (error) => {
      Alert.alert(i18n.t('plans:profileErrorsSignIn'), localizeAuthError(error));
    },
  });
};

export const useSignInUserWithOAuth = () => {
  return useMutation({
    mutationFn: async (params: { provider: OAuthProvider }) => {
      return signInUserWithOAuth(params.provider);
    },
    onError: (error) => {
      Alert.alert(i18n.t('plans:profileErrorsOAuth'), localizeAuthError(error));
    },
  });
};

export const useSignInUserWithAppleIdToken = () => {
  return useMutation({
    mutationFn: async (params: {
      fullName?: AppleIdentityFullName | null;
      identityToken: string;
    }) => {
      return signInUserWithAppleIdToken(params);
    },
    onError: (error) => {
      Alert.alert(i18n.t('plans:profileErrorsApple'), localizeAuthError(error));
    },
  });
};

export const useSignInUserWithGoogleIdToken = () => {
  return useMutation({
    mutationFn: async (params: {
      identityToken: string;
      profile?: NativeIdentityProfile | null;
    }) => {
      return signInUserWithGoogleIdToken(params);
    },
    onError: (error) => {
      Alert.alert(i18n.t('plans:profileErrorsGoogle'), localizeAuthError(error));
    },
  });
};
