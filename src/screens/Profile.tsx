import { Ionicons } from '@expo/vector-icons';
import { UseMutateFunction } from '@tanstack/react-query';
import { useEffect, useState } from 'react';
import { Alert, Text, TextInput, TouchableOpacity, View, useColorScheme } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import ProfileDetailsForm from '../components/ProfileDetailsForm';
import Avatar from '../components/Avatar';
import MyPlansList from '../components/plansList/MyPlansList';
import {
  ProfileDetailsFormErrors,
  buildProfileDetailsFormValues,
  getYearsFollowingJesus,
  hasProfileDetailsErrors,
  toUpdateProfileInput,
  validateProfileDetailsForm,
} from '../profileDetails';
import { ProfileWithChurch, UpdateProfileInput } from '../types/types';

function ProfileDetailRow({ label, value }: { label: string; value: string | null | undefined }) {
  return (
    <View className="mb-3">
      <Text className="text-xs font-semibold uppercase tracking-wide text-gray-500 dark:text-gray-400">
        {label}
      </Text>
      <Text className="mt-1 text-sm text-gray-900 dark:text-white">
        {value || 'Not shared yet'}
      </Text>
    </View>
  );
}

const formatBoolean = (value: boolean | null | undefined, { falseLabel = 'No' } = {}) => {
  if (value === true) return 'Yes';
  if (value === false) return falseLabel;
  return 'Not shared yet';
};

export default function ProfileScreen({
  profile,
  onSignOut,
  handleUpdateProfile,
  handleUploadAvatar,
  updating,
  uploading,
  deleting,
  handleDeleteAvatar,
  onSetting,
}: {
  profile: ProfileWithChurch | undefined;
  onSignOut: () => void;
  onSetting: () => void;
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
  handleDeleteAvatar: (filePath: string) => void;
}) {
  const colorScheme = useColorScheme();
  const insets = useSafeAreaInsets();
  const [isEditingBio, setIsEditingBio] = useState(false);
  const [isEditingDetails, setIsEditingDetails] = useState(false);
  const [bio, setBio] = useState(profile?.bio ?? '');
  const [detailsForm, setDetailsForm] = useState(() => buildProfileDetailsFormValues(profile));
  const [detailsErrors, setDetailsErrors] = useState<ProfileDetailsFormErrors>({});

  useEffect(() => {
    if (!isEditingBio) {
      setBio(profile?.bio ?? '');
    }

    if (!isEditingDetails) {
      setDetailsForm(buildProfileDetailsFormValues(profile));
      setDetailsErrors({});
    }
  }, [profile, isEditingBio, isEditingDetails]);

  const onSaveBio = () => {
    if (bio.trim() === profile?.bio?.trim()) {
      setIsEditingBio(false);
      return;
    }

    handleUpdateProfile({ bio }, { onSuccess: () => setIsEditingBio(false) });
  };

  const onSaveDetails = () => {
    const nextErrors = validateProfileDetailsForm(detailsForm, {
      requireName: true,
      requireChoices: true,
    });
    setDetailsErrors(nextErrors);

    if (hasProfileDetailsErrors(nextErrors)) {
      return;
    }

    handleUpdateProfile(toUpdateProfileInput(detailsForm), {
      onSuccess: () => setIsEditingDetails(false),
    });
  };

  const yearsFollowingJesus = getYearsFollowingJesus(profile?.year_believed);

  return (
    <View
      className="flex-1 bg-white dark:bg-black"
      style={{ paddingTop: insets.top, paddingBottom: insets.bottom }}>
      <MyPlansList
        containterStyle={{ paddingBottom: 120 }}
        listHeaderComponent={
          <>
            <View className="relative h-14 px-4 border-b border-gray-200 dark:border-neutral-800 justify-center">
              <View
                pointerEvents="none"
                className="absolute top-0 bottom-0 left-0 right-0 items-center justify-center">
                <Text className="text-center text-lg font-semibold dark:text-white">Profile</Text>
              </View>

              <View className="flex-row justify-end items-center">
                <TouchableOpacity onPress={onSetting} hitSlop={8}>
                  <Ionicons
                    name="settings-outline"
                    size={22}
                    color={colorScheme === 'dark' ? '#fff' : '#222'}
                  />
                </TouchableOpacity>
              </View>
            </View>

            <View className="items-center mt-6">
              <Avatar
                profile={profile}
                size={150}
                handleUploadAvatar={handleUploadAvatar}
                handleUpdateProfile={handleUpdateProfile}
                uploading={uploading}
                updating={updating}
                handleDeleteAvatar={handleDeleteAvatar}
                deleting={deleting}
              />

              <Text className="mt-4 text-xl font-semibold dark:text-white">
                {profile?.first_name} {profile?.last_name}
              </Text>
              <Text className="text-sm text-gray-500 dark:text-gray-400 mt-1">
                {profile?.email}
              </Text>
            </View>

            <View className="mt-6 px-6">
              <View className="rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
                <Text className="text-lg font-semibold text-gray-900 dark:text-white">About</Text>

                {!isEditingBio ? (
                  <>
                    <Text className="mt-3 text-gray-600 dark:text-gray-400">
                      {profile?.bio || 'No bio yet'}
                    </Text>

                    <TouchableOpacity
                      onPress={() => setIsEditingBio(true)}
                      className="mt-3 self-start">
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
                      className="mt-3 rounded-xl border border-gray-300 p-3 text-gray-900 dark:border-neutral-700 dark:text-white"
                      placeholderTextColor="#9ca3af"
                    />

                    <View className="mt-3 flex-row justify-end gap-3">
                      <TouchableOpacity
                        onPress={() => {
                          setBio(profile?.bio ?? '');
                          setIsEditingBio(false);
                        }}>
                        <Text className="text-gray-500">Cancel</Text>
                      </TouchableOpacity>

                      <TouchableOpacity onPress={onSaveBio} disabled={updating}>
                        <Text className="font-semibold text-blue-600 dark:text-blue-400">
                          {updating ? 'Saving...' : 'Save'}
                        </Text>
                      </TouchableOpacity>
                    </View>
                  </>
                )}
              </View>
            </View>

            <View className="mt-4 px-6">
              <View className="rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
                <View className="flex-row items-center justify-between">
                  <Text className="text-lg font-semibold text-gray-900 dark:text-white">
                    Faith Journey
                  </Text>

                  {!isEditingDetails ? (
                    <TouchableOpacity onPress={() => setIsEditingDetails(true)}>
                      <Text className="text-sm font-medium text-blue-600 dark:text-blue-400">
                        Edit details
                      </Text>
                    </TouchableOpacity>
                  ) : null}
                </View>

                {!isEditingDetails ? (
                  <View className="mt-4">
                    <ProfileDetailRow
                      label="Believes In Jesus"
                      value={formatBoolean(profile?.is_believer, { falseLabel: 'Not yet' })}
                    />
                    {profile?.is_believer ? (
                      <>
                        <ProfileDetailRow
                          label="Year Believed"
                          value={profile?.year_believed ? String(profile.year_believed) : null}
                        />
                        <ProfileDetailRow
                          label="Years Following Jesus"
                          value={
                            yearsFollowingJesus !== null
                              ? `${yearsFollowingJesus} year${yearsFollowingJesus === 1 ? '' : 's'}`
                              : null
                          }
                        />
                        <ProfileDetailRow
                          label="Baptized"
                          value={formatBoolean(profile?.is_baptized)}
                        />
                        {profile?.is_baptized ? (
                          <ProfileDetailRow
                            label="Year Baptized"
                            value={profile?.year_baptized ? String(profile.year_baptized) : null}
                          />
                        ) : null}
                      </>
                    ) : null}
                    <ProfileDetailRow
                      label="Meets At A Church Regularly"
                      value={formatBoolean(profile?.attends_church_regularly)}
                    />
                    {profile?.attends_church_regularly ? (
                      <>
                        <ProfileDetailRow label="Church Name" value={profile?.church?.name} />
                        <ProfileDetailRow label="Church Address" value={profile?.church?.address} />
                        <ProfileDetailRow
                          label="Church Website"
                          value={profile?.church?.website_url}
                        />
                      </>
                    ) : null}
                  </View>
                ) : (
                  <View className="mt-4">
                    <ProfileDetailsForm
                      values={detailsForm}
                      errors={detailsErrors}
                      onChange={(patch) => {
                        setDetailsForm((current) => ({ ...current, ...patch }));
                        setDetailsErrors((current) => {
                          const next = { ...current };
                          for (const key of Object.keys(patch) as Array<
                            keyof ProfileDetailsFormErrors
                          >) {
                            delete next[key];
                          }
                          return next;
                        });
                      }}
                    />

                    <View className="flex-row justify-end gap-3 px-2">
                      <TouchableOpacity
                        onPress={() => {
                          setDetailsForm(buildProfileDetailsFormValues(profile));
                          setDetailsErrors({});
                          setIsEditingDetails(false);
                        }}>
                        <Text className="text-gray-500">Cancel</Text>
                      </TouchableOpacity>

                      <TouchableOpacity onPress={onSaveDetails} disabled={updating}>
                        <Text className="font-semibold text-blue-600 dark:text-blue-400">
                          {updating ? 'Saving...' : 'Save'}
                        </Text>
                      </TouchableOpacity>
                    </View>
                  </View>
                )}
              </View>
            </View>

            <View className="mt-10 px-4 border-b border-gray-500">
              <Text className="mb-4 text-lg font-semibold dark:text-white">Your Plans</Text>
            </View>
          </>
        }
      />

      <TouchableOpacity
        onPress={() => {
          Alert.alert('Log out', 'Are you sure you want to log out?', [
            { text: 'Cancel', style: 'cancel' },
            { text: 'Log out', style: 'destructive', onPress: onSignOut },
          ]);
        }}
        className="absolute bottom-0 left-0 right-0 flex-row items-center justify-between border-t border-gray-200 bg-white px-4 py-5 dark:border-neutral-800 dark:bg-black">
        <Text className="text-base text-red-600">Log Out</Text>
        <Ionicons name="chevron-forward" size={20} color="#9ca3af" />
      </TouchableOpacity>
    </View>
  );
}
