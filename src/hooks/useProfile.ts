import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { Alert } from 'react-native';
import {
  deleteAvatarFromStorage,
  signInUserWithPassword,
  signUpUser,
  updateProfile,
  uploadAvatar,
} from '../api/mutations';
import { getProfile } from '../api/queries';
import { SignUpProfileInput, UpdateProfileInput } from '../types/types';

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

export const useSignUpUser = () => {
  return useMutation({
    mutationFn: async (params: SignUpProfileInput) => signUpUser(params),
    onError: (error) => {
      Alert.alert('Sign Up Error', error.message);
    },
  });
};

export const useSignInUserWithPassword = () => {
  return useMutation({
    mutationFn: async (params: { email: string; password: string }) => {
      return signInUserWithPassword(params.email, params.password);
    },
    onError: (error) => {
      Alert.alert('Sign In Error', error.message);
    },
  });
};
