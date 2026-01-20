import { Ionicons } from '@expo/vector-icons';
import { UseMutateFunction } from '@tanstack/react-query';
import * as ImagePicker from 'expo-image-picker';
import { Alert, StyleSheet, TouchableOpacity, View } from 'react-native';
import { useAuth } from '../state/AuthContext';
import UserAvatar from './UserAvatar';

interface Props {
  size: number;
  url: string | undefined | null;
  onUpload?: (filePath: string) => void;
  handleUpdateProfile: UseMutateFunction<
    void,
    Error,
    {
      first_name?: string;
      last_name?: string;
      avatar_url?: string;
      bio?: string;
    },
    unknown
  >;
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
  uplaoding?: boolean;
  updating?: boolean;
  deleting?: boolean;
  deleteAvatar: UseMutateFunction<void, Error, string, unknown>;
}

export default function Avatar({
  url,
  size = 150,
  onUpload,
  handleUpdateProfile,
  handleUploadAvatar,
  uplaoding,
  updating,
  deleting,
  deleteAvatar,
}: Props) {
  const avatarSize = { height: size, width: size };
  const { session } = useAuth();

  async function removeAvatar(filePath: string) {
    if (!session?.user?.id) return;

    // 1️⃣ Delete from storage
    deleteAvatar(filePath, {
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
          const filePath = url?.split('/').pop()!;
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
        console.log('User cancelled image picker.');
        return;
      }

      const image = result.assets[0];

      if (!image.uri) {
        throw new Error('No image uri!');
      }

      const arraybuffer = await fetch(image.uri).then((res) => res.arrayBuffer());

      const fileExt = image.uri.split('.').pop()?.toLowerCase() ?? 'jpeg';

      const path = `${session?.user?.id}.${Date.now()}.${fileExt}`;
      if (url) {
        const oldPath = url.split('/').pop()!;
        await removeAvatar(oldPath);
      }

      handleUploadAvatar(
        {
          filePath: path,
          mimeType: image.mimeType ?? 'image/jpeg',
          arraybuffer,
        },
        {
          onSuccess: (data) => {
            console.log('Upload successful:', data);

            handleUpdateProfile({
              avatar_url: `${process.env.EXPO_PUBLIC_SUPABASE_PROJECT_URL}/storage/v1/object/public/${data.fullPath}`,
            });
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
          uri={url}
          initial={session?.user?.user_metadata.first_name?.[0] ?? 'U'}
          size={avatarSize.width}
        />

        {/* Plus button */}
        <TouchableOpacity
          onPress={uploadAvatar}
          disabled={uplaoding || updating || deleting}
          style={[ButtonStyles.plusButton, uplaoding && { opacity: 0.6 }]}>
          <Ionicons name="add" size={20} color="#fff" />
        </TouchableOpacity>
        {url && (
          <TouchableOpacity
            disabled={uplaoding || updating || deleting}
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
