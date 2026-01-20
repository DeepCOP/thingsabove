import { Ionicons } from '@expo/vector-icons';
import { UseMutateFunction } from '@tanstack/react-query';
import { useState } from 'react';
import { Text, TextInput, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import Avatar from '../components/Avatar';
import MyPlansList from '../components/plansList/MyPlansList';
import { Profiles } from '../types/types';

export default function ProfileScreen({
  profile,
  onSignOut,
  handleUpdateProfile,
  handleUploadAvatar,
  updating,
  uplaoding,
  deleting,
  deleteAvatar,
}: {
  profile: Profiles | undefined;
  onSignOut: () => void;
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
  deleteAvatar: (filePath: string) => void;
}) {
  const insets = useSafeAreaInsets();
  const [isEditingBio, setIsEditingBio] = useState(false);
  const [bio, setBio] = useState(profile?.bio ?? '');
  const onSaveBio = () => {
    if (!bio.trim() || bio.trim() === profile?.bio?.trim()) return;
    handleUpdateProfile({ bio }, { onSuccess: () => setIsEditingBio(false) });
  };
  return (
    <View
      className="flex-1 bg-white dark:bg-black "
      style={{ paddingTop: insets.top, paddingBottom: insets.bottom }}>
      {/* Header */}

      {/* Your Plans */}
      <MyPlansList
        listHeaderComponent={
          <>
            <View className="py-4 border-b border-gray-200 dark:border-neutral-800">
              <Text className="text-center text-lg font-semibold dark:text-white">Profile</Text>
            </View>
            {/* User Info */}
            <View className="items-center mt-6">
              <Avatar
                url={profile?.avatar_url}
                size={150}
                handleUploadAvatar={handleUploadAvatar}
                handleUpdateProfile={handleUpdateProfile}
                uplaoding={uplaoding}
                updating={updating}
                deleteAvatar={deleteAvatar}
                deleting={deleting}
              />

              <Text className="mt-4 text-xl font-semibold dark:text-white">
                {profile?.first_name} {profile?.last_name}
              </Text>

              <View className="mt-4 px-6 w-full">
                {!isEditingBio ? (
                  <>
                    <Text className="text-center text-gray-600 dark:text-gray-400">
                      {profile?.bio || 'No bio yet'}
                    </Text>

                    <TouchableOpacity
                      onPress={() => setIsEditingBio(true)}
                      className="mt-2 self-center">
                      <Text className="text-sm font-medium text-blue-600 dark:text-blue-400">
                        Edit bio
                      </Text>
                    </TouchableOpacity>
                  </>
                ) : (
                  <>
                    <TextInput
                      value={bio}
                      onChangeText={setBio}
                      placeholder="Write something about yourself"
                      multiline
                      className="border border-gray-300 dark:border-neutral-700 rounded-xl p-3 text-gray-900 dark:text-white"
                      placeholderTextColor="#9ca3af"
                    />

                    <View className="flex-row justify-end gap-3 mt-3">
                      <TouchableOpacity
                        onPress={() => {
                          setBio(profile?.bio ?? '');
                          setIsEditingBio(false);
                        }}>
                        <Text className="text-gray-500">Cancel</Text>
                      </TouchableOpacity>

                      <TouchableOpacity onPress={onSaveBio} disabled={updating}>
                        <Text className="font-semibold text-blue-600 dark:text-blue-400">
                          {uplaoding ? 'Uploading...' : 'Save'}
                        </Text>
                      </TouchableOpacity>
                    </View>
                  </>
                )}
              </View>
            </View>
            {/* Plans title */}
            <View className="mt-10 px-4">
              <Text className="text-lg font-semibold dark:text-white mb-4">Your Plans</Text>
            </View>
          </>
        }
      />

      {/* Logout */}
      <TouchableOpacity
        onPress={onSignOut}
        className="absolute border-t border-gray-200 dark:border-neutral-800 bottom-0 left-0 right-0 bg-white dark:bg-black flex-row items-center justify-between px-4 py-5">
        <Text className="text-base text-red-600">Log Out</Text>
        <Ionicons name="chevron-forward" size={20} color="#9ca3af" />
      </TouchableOpacity>
    </View>
  );
}
