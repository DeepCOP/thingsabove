import { Ionicons } from '@expo/vector-icons';
import { UseMutateFunction } from '@tanstack/react-query';
import * as ImagePicker from 'expo-image-picker';
import { Alert, StyleSheet, TouchableOpacity, View } from 'react-native';
import { useAuth } from '../state/AuthContext';
import { Profiles, UpdateProfileInput } from '../types/types';
import UserAvatar from './UserAvatar';

type AvatarProfile = Pick<Profiles, 'avatar_url' | 'first_name' | 'last_name'>;

interface Props {
  size: number;
  handleUpdateProfile: UseMutateFunction<void, Error, UpdateProfileInput, unknown>;
  handleUploadAvatar: UseMutateFunction<
    {
      id: string;
      path: string;
      fullPath: string;
    },
    Error,
    {
      filePath: string;
      mimeType: string;
      arraybuffer: ArrayBuffer;
    },
    unknown
  >;
  uploading?: boolean;
  updating?: boolean;
  deleting?: boolean;
  handleDeleteAvatar: UseMutateFunction<void, Error, string, unknown>;
  profile: AvatarProfile | undefined;
}

export default function Avatar({
  size = 150,
  handleUpdateProfile,
  handleUploadAvatar,
  uploading,
  updating,
  deleting,
  profile,
  handleDeleteAvatar,
}: Props) {
  const avatarSize = { height: size, width: size };
  const { session } = useAuth();

  async function removeAvatar(filePath: string) {
    if (!session?.user?.id || !filePath) return;

    // 1️⃣ Delete from storage
    handleDeleteAvatar(filePath, {
      onSuccess: () => {
        handleUpdateProfile({
          avatar_url: '',
        });
      },
    });

    // 2️⃣ Update profile
  }

  const confirmRemoveAvatar = () => {
    Alert.alert('Remove avatar', 'Are you sure you want to remove your profile picture?', [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Remove',
        style: 'destructive',
        onPress: async () => {
          const filePath = profile?.avatar_url?.split('/').pop() ?? '';
          await removeAvatar(filePath);
        },
      },
    ]);
  };

  async function uploadAvatar() {
    try {
      const result = await ImagePicker.launchImageLibraryAsync({
        mediaTypes: ImagePicker.MediaTypeOptions.Images,
        allowsMultipleSelection: false,
        allowsEditing: true,
        quality: 1,
        exif: false,
      });

      if (result.canceled || !result.assets?.length) {
        return;
      }

      const image = result.assets[0];

      if (!image.uri) {
        throw new Error('No image uri!');
      }

      const arraybuffer = await fetch(image.uri).then((res) => res.arrayBuffer());
      const fileExt = image.uri.split('.').pop()?.toLowerCase() ?? 'jpeg';
      const path = `${session?.user?.id}.${Date.now()}.${fileExt}`;

      handleUploadAvatar(
        {
          filePath: path,
          mimeType: image.mimeType ?? 'image/jpeg',
          arraybuffer,
        },
        {
          onSuccess: (data) => {
            const currnentFilePath = profile?.avatar_url?.split('/').pop() ?? '';
            handleUpdateProfile(
              {
                avatar_url: `${process.env.EXPO_PUBLIC_SUPABASE_PROJECT_URL}/storage/v1/object/public/${data.fullPath}`,
              },
              {
                onSuccess: () => {
                  if (currnentFilePath) {
                    handleDeleteAvatar(currnentFilePath);
                  }
                },
              },
            );
          },
        },
      );
    } catch (error) {
      console.log('Error uploading image:', error);
    }
  }
  return (
    <View style={{ alignItems: 'center' }}>
      <View style={{ position: 'relative' }}>
        <UserAvatar
          uri={profile?.avatar_url}
          first_name={profile?.first_name}
          last_name={profile?.last_name}
          size={avatarSize.width}
        />

        {/* Plus button */}
        <TouchableOpacity
          onPress={uploadAvatar}
          disabled={uploading || updating || deleting}
          style={[ButtonStyles.plusButton, uploading && { opacity: 0.6 }]}>
          <Ionicons name="add" size={20} color="#fff" />
        </TouchableOpacity>
        {profile?.avatar_url && (
          <TouchableOpacity
            disabled={uploading || updating || deleting}
            onPress={confirmRemoveAvatar}
            style={[styles.actionBtn, styles.removeBtn, deleting && { opacity: 0.6 }]}>
            <Ionicons name="trash-outline" size={16} color="#fff" />
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
}

const ButtonStyles = StyleSheet.create({
  plusButton: {
    position: 'absolute',
    bottom: 4,
    right: 4,
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: '#4F46E5', // indigo
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: '#fff',
  },
});

const styles = StyleSheet.create({
  avatar: {
    borderRadius: 5,
    overflow: 'hidden',
    maxWidth: '100%',
  },
  image: {
    objectFit: 'cover',
    paddingTop: 0,
  },
  noImage: {
    backgroundColor: '#333',
    borderWidth: 1,
    borderStyle: 'solid',
    borderColor: 'rgb(200, 200, 200)',
    borderRadius: 5,
  },
  actionBtn: {
    position: 'absolute',
    width: 32,
    height: 32,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
  },
  removeBtn: {
    top: 4,
    right: 4,
    backgroundColor: '#DC2626',
  },
});
