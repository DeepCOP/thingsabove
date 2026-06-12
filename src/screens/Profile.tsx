import { Ionicons } from '@expo/vector-icons';
import { UseMutateFunction } from '@tanstack/react-query';
import { useRouter } from 'expo-router';
import { useEffect, useState } from 'react';
import {
  ActivityIndicator,
  Alert,
  Text,
  TouchableOpacity,
  View,
  useColorScheme,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import AboutDetailsForm from '../components/AboutDetailsForm';
import Avatar from '../components/Avatar';
import MyPlansList from '../components/plansList/MyPlansList';
import {
  ProfileDetailsFormErrors,
  buildProfileDetailsFormValues,
  hasProfileDetailsErrors,
  toUpdateProfileInput,
  validateProfileDetailsForm,
} from '../profileDetails';
import { ProfileWithChurch, UpdateProfileInput } from '../types/types';

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
  onPrayerBoard,
}: {
  profile: ProfileWithChurch | undefined;
  onSignOut: () => Promise<void> | void;
  onSetting: () => void;
  onPrayerBoard: () => void;
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
  const router = useRouter();
  const [detailsForm, setDetailsForm] = useState(() => buildProfileDetailsFormValues(profile));
  const [detailsErrors, setDetailsErrors] = useState<ProfileDetailsFormErrors>({});
  const [showDetailsForm, setShowDetailsForm] = useState(false);
  const [isSigningOut, setIsSigningOut] = useState(false);
  const actionColor = colorScheme === 'dark' ? '#60a5fa' : '#2563eb';

  const churchName = profile?.church?.name ?? '';
  const churchAddress = profile?.church?.address ?? '';
  const churchWebsite = profile?.church?.website_url ?? '';
  const linkedChurchId = profile?.church?.id ?? null;
  const displayBio = profile?.bio?.trim() ?? '';
  const hasAboutDetails = Boolean(
    profile?.year_believed ||
    profile?.year_baptized ||
    churchName ||
    churchAddress ||
    churchWebsite,
  );

  useEffect(() => {
    setDetailsForm(buildProfileDetailsFormValues(profile));
    setDetailsErrors({});
  }, [profile]);

  useEffect(() => {
    if (hasAboutDetails) {
      setShowDetailsForm(false);
    }
  }, [hasAboutDetails]);

  const onSaveDetails = () => {
    const nextErrors = validateProfileDetailsForm(detailsForm);
    setDetailsErrors(nextErrors);

    if (hasProfileDetailsErrors(nextErrors)) {
      return;
    }

    handleUpdateProfile(toUpdateProfileInput(detailsForm), {
      onSuccess: () => setShowDetailsForm(false),
    });
  };

  const handleSignOut = async () => {
    setIsSigningOut(true);

    try {
      await onSignOut();
    } catch (error) {
      setIsSigningOut(false);
      Alert.alert('Log out failed', error instanceof Error ? error.message : 'Please try again.');
    }
  };

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

              <View className="mt-5 w-full max-w-sm flex-row gap-3 px-6">
                <TouchableOpacity
                  className="h-12 flex-1 items-center justify-center rounded-full bg-black px-4 dark:bg-white"
                  onPress={onPrayerBoard}>
                  <Text className="text-center font-semibold text-white dark:text-black">
                    Prayer Board
                  </Text>
                </TouchableOpacity>

                <TouchableOpacity
                  className="h-12 flex-1 flex-row items-center justify-center rounded-full border border-blue-600 bg-blue-50/70 px-4 dark:border-blue-400 dark:bg-blue-950/30"
                  onPress={() =>
                    router.push({
                      pathname: '/app/(tabs)/CommunityTab',
                      params: { section: 'friends' },
                    })
                  }>
                  <Ionicons name="people-outline" size={16} color={actionColor} />
                  <Text className="ml-2 text-sm font-semibold text-blue-600 dark:text-blue-400">
                    Friends
                  </Text>
                </TouchableOpacity>
              </View>
            </View>

            {displayBio ? (
              <View className="mt-4 px-6 w-full">
                <Text className="text-center text-gray-600 dark:text-gray-400">{displayBio}</Text>
              </View>
            ) : null}

            <View className="mt-4 px-6">
              <View className="rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
                <View className="flex-row items-center justify-between">
                  <Text className="text-lg font-semibold text-gray-900 dark:text-white">About</Text>
                  {!showDetailsForm ? (
                    hasAboutDetails ? (
                      <TouchableOpacity
                        onPress={() => setShowDetailsForm(true)}
                        disabled={updating}>
                        <Text className="text-sm font-medium text-blue-600 dark:text-blue-400">
                          Edit
                        </Text>
                      </TouchableOpacity>
                    ) : (
                      <TouchableOpacity
                        onPress={() => setShowDetailsForm(true)}
                        disabled={updating}>
                        <Text className="text-sm font-medium text-blue-600 dark:text-blue-400">
                          Add About Info
                        </Text>
                      </TouchableOpacity>
                    )
                  ) : null}
                </View>

                {showDetailsForm ? (
                  <View className="mt-4">
                    <AboutDetailsForm
                      values={detailsForm}
                      errors={detailsErrors}
                      onChange={(patch) => {
                        setDetailsForm((current) => ({ ...current, ...patch }));
                        setDetailsErrors((current) => {
                          const next = { ...current };
                          for (const key of Object.keys(
                            patch,
                          ) as (keyof ProfileDetailsFormErrors)[]) {
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
                          setShowDetailsForm(false);
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
                ) : hasAboutDetails ? (
                  <View className="mt-4 space-y-4">
                    <View>
                      <Text className="text-xs uppercase tracking-wide text-gray-500 dark:text-gray-400">
                        Year You Believed
                      </Text>
                      <Text className="mt-1 text-base text-gray-900 dark:text-white">
                        {profile?.year_believed ? String(profile.year_believed) : 'Not provided'}
                      </Text>
                    </View>

                    <View>
                      <Text className="text-xs uppercase tracking-wide text-gray-500 dark:text-gray-400">
                        Year You Were Baptized
                      </Text>
                      <Text className="mt-1 text-base text-gray-900 dark:text-white">
                        {profile?.year_baptized ? String(profile.year_baptized) : 'Not provided'}
                      </Text>
                    </View>

                    <View>
                      <Text className="text-xs uppercase tracking-wide text-gray-500 dark:text-gray-400">
                        Church
                      </Text>
                      {linkedChurchId ? (
                        <TouchableOpacity
                          className="mt-1 rounded-2xl bg-gray-50 p-3 dark:bg-neutral-900"
                          onPress={() =>
                            router.navigate({
                              pathname: '/app/(tabs)/CommunityTab',
                              params: { section: 'my-church' },
                            })
                          }>
                          <View className="flex-row items-center justify-between gap-3">
                            <View className="flex-1">
                              <Text className="text-base text-gray-900 dark:text-white">
                                {churchName}
                              </Text>
                              {churchAddress ? (
                                <Text className="mt-1 text-sm text-gray-600 dark:text-gray-400">
                                  {churchAddress}
                                </Text>
                              ) : null}
                              {churchWebsite ? (
                                <Text className="mt-1 text-sm text-blue-600 dark:text-blue-400">
                                  {churchWebsite}
                                </Text>
                              ) : null}
                            </View>
                            <Ionicons name="chevron-forward" size={18} color="#9ca3af" />
                          </View>
                        </TouchableOpacity>
                      ) : (
                        <>
                          <Text className="mt-1 text-base text-gray-900 dark:text-white">
                            {churchName || 'Not provided'}
                          </Text>
                          {churchAddress ? (
                            <Text className="mt-1 text-sm text-gray-600 dark:text-gray-400">
                              {churchAddress}
                            </Text>
                          ) : null}
                          {churchWebsite ? (
                            <Text className="mt-1 text-sm text-blue-600 dark:text-blue-400">
                              {churchWebsite}
                            </Text>
                          ) : null}
                        </>
                      )}
                    </View>
                  </View>
                ) : (
                  <View className="mt-4 items-center rounded-2xl border border-gray-200 bg-gray-50 px-4 py-6 dark:border-neutral-800 dark:bg-neutral-900">
                    <View className="mb-3 h-12 w-12 items-center justify-center rounded-2xl bg-blue-50 dark:bg-blue-950/40">
                      <Ionicons name="book-outline" size={24} color={actionColor} />
                    </View>
                    <Text className="text-base font-semibold text-gray-900 dark:text-white">
                      Share a little about your faith journey
                    </Text>
                    <Text className="mt-1 text-center text-sm text-gray-600 dark:text-gray-400">
                      Add your bio, church, or favorite verse.
                    </Text>
                    <TouchableOpacity
                      className="mt-4 flex-row items-center rounded-full border border-blue-600 px-4 py-2"
                      onPress={() => setShowDetailsForm(true)}
                      disabled={updating}>
                      <Ionicons name="add" size={16} color={actionColor} />
                      <Text className="ml-1 text-sm font-semibold text-blue-600 dark:text-blue-400">
                        Add About Info
                      </Text>
                    </TouchableOpacity>
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
        disabled={isSigningOut}
        onPress={() => {
          if (isSigningOut) return;

          Alert.alert('Log out', 'Are you sure you want to log out?', [
            { text: 'Cancel', style: 'cancel' },
            { text: 'Log out', style: 'destructive', onPress: handleSignOut },
          ]);
        }}
        className="absolute bottom-0 left-0 right-0 flex-row items-center justify-between border-t border-gray-200 bg-white px-4 py-5 dark:border-neutral-800 dark:bg-black"
        style={{ opacity: isSigningOut ? 0.7 : 1 }}>
        <Text className="text-base text-red-600">
          {isSigningOut ? 'Logging out...' : 'Log Out'}
        </Text>
        {isSigningOut ? (
          <ActivityIndicator color="#dc2626" />
        ) : (
          <Ionicons name="chevron-forward" size={20} color="#9ca3af" />
        )}
      </TouchableOpacity>
    </View>
  );
}
