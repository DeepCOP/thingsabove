import PrayerScopeSwitch from '@/src/components/prayer/PrayerScopeSwitch';
import { usePrayerRequest, useSavePrayerRequest } from '@/src/hooks/usePrayer';
import { useProfile } from '@/src/hooks/useProfile';
import { useAuth } from '@/src/state/AuthContext';
import { PrayerCategory, PrayerScope } from '@/src/types/types';
import { getDisplayName } from '@/src/utils';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import { useEffect, useMemo, useRef, useState } from 'react';
import {
  Alert,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  Switch,
  Text,
  TextInput,
  TouchableOpacity,
  View,
  useColorScheme,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

const CATEGORIES: PrayerCategory[] = ['Health', 'Family', 'Work', 'Spiritual', 'Other'];

type Props = {
  requestId?: string;
};

export default function PrayerRequestComposerScreen({ requestId }: Props) {
  const { session } = useAuth();
  const router = useRouter();
  const colorScheme = useColorScheme();
  const insets = useSafeAreaInsets();
  const profileQuery = useProfile(session?.user?.id);
  const requestQuery = usePrayerRequest(requestId);
  const saveMutation = useSavePrayerRequest();

  const [scope, setScope] = useState<PrayerScope>('public');
  const [category, setCategory] = useState<PrayerCategory>('Family');
  const [requestText, setRequestText] = useState('');
  const [isAnonymous, setIsAnonymous] = useState(false);
  const [isUrgent, setIsUrgent] = useState(false);
  const [allowComments, setAllowComments] = useState(true);
  const hasInitializedScopeRef = useRef(false);

  const hasChurch = Boolean(profileQuery.data?.church?.id);
  const isEditing = Boolean(requestId);
  const switchTrackColor =
    colorScheme === 'dark'
      ? { false: '#3f3f46', true: '#2563eb' }
      : { false: '#d1d5db', true: '#2563eb' };

  useEffect(() => {
    if (!requestQuery.data) {
      return;
    }

    setScope(requestQuery.data.scope as PrayerScope);
    setCategory(requestQuery.data.category as PrayerCategory);
    setRequestText(requestQuery.data.content);
    setIsAnonymous(requestQuery.data.is_anonymous);
    setIsUrgent(requestQuery.data.is_urgent);
    setAllowComments(requestQuery.data.allow_comments);
  }, [requestQuery.data]);

  useEffect(() => {
    if (isEditing || hasInitializedScopeRef.current || profileQuery.isLoading) {
      return;
    }

    setScope(hasChurch ? 'church' : 'public');
    hasInitializedScopeRef.current = true;
  }, [hasChurch, isEditing, profileQuery.isLoading]);

  const hasLoadedEditableRequest = !isEditing || Boolean(requestQuery.data?.viewer_is_owner);
  const isSubmitDisabled =
    saveMutation.isPending ||
    !requestText.trim() ||
    requestText.trim().length > 500 ||
    (scope === 'church' && !hasChurch);

  const previewName = getDisplayName({
    isAnonymous,
    firstName: profileQuery.data?.first_name,
    lastName: profileQuery.data?.last_name,
    fallbackLabel: 'Your name',
  });

  const previewScopeLabel = useMemo(() => {
    if (scope === 'church') {
      return profileQuery.data?.church?.name || 'My Church';
    }

    return profileQuery.data?.church?.name || 'Public';
  }, [profileQuery.data?.church?.name, scope]);

  const handleSubmit = () => {
    saveMutation.mutate(
      {
        requestId,
        scope,
        category,
        content: requestText.trim(),
        isAnonymous,
        isUrgent,
        allowComments,
      },
      {
        onSuccess: (nextRequestId) => {
          router.replace({
            pathname: '/app/prayer/[requestId]',
            params: { requestId: nextRequestId },
          });
        },
        onError: (error) => {
          Alert.alert('Unable to save prayer request', error.message);
        },
      },
    );
  };

  if (isEditing && requestQuery.isLoading) {
    return (
      <View className="flex-1 items-center justify-center bg-white dark:bg-black">
        <Text className="text-gray-600 dark:text-gray-400">Loading prayer request...</Text>
      </View>
    );
  }

  if (isEditing && !hasLoadedEditableRequest) {
    return (
      <View className="flex-1 items-center justify-center bg-white px-6 dark:bg-black">
        <Text className="text-center text-lg font-semibold text-gray-900 dark:text-white">
          You can only edit your own prayer requests
        </Text>
        <TouchableOpacity
          className="mt-5 rounded-full bg-black px-5 py-3 dark:bg-white"
          onPress={() => router.back()}>
          <Text className="font-semibold text-white dark:text-black">Go Back</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      className="flex-1 bg-white dark:bg-black">
      <ScrollView
        className="flex-1"
        contentContainerStyle={{
          paddingHorizontal: 16,
          paddingTop: 16,
          paddingBottom: insets.bottom + 24,
        }}>
        <PrayerScopeSwitch hasChurch={hasChurch} scope={scope} onChange={setScope} />

        {scope === 'church' && !hasChurch ? (
          <View className="mt-4 rounded-2xl border border-amber-200 bg-amber-50 p-4 dark:border-amber-900 dark:bg-amber-950/30">
            <Text className="font-semibold text-amber-800 dark:text-amber-200">
              Add your church in Profile first
            </Text>
            <Text className="mt-1 text-sm text-amber-700 dark:text-amber-300">
              Church-only requests are available once your profile is linked to a church.
            </Text>
            <TouchableOpacity
              className="mt-4 self-start rounded-full bg-black px-4 py-2 dark:bg-white"
              onPress={() => router.navigate('/app/(tabs)/ProfileTab')}>
              <Text className="font-semibold text-white dark:text-black">Open Profile</Text>
            </TouchableOpacity>
          </View>
        ) : null}

        <View className="mt-4 rounded-3xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
          <Text className="text-sm font-semibold uppercase tracking-wide text-gray-500 dark:text-gray-400">
            Request
          </Text>

          <TextInput
            multiline
            value={requestText}
            onChangeText={setRequestText}
            placeholder="What do you need prayer for? (e.g. job decision, family situation, health concern)"
            placeholderTextColor="#9ca3af"
            maxLength={500}
            className="mt-3 min-h-36 rounded-3xl border border-gray-200 p-4 text-base text-gray-900 dark:border-neutral-700 dark:text-white"
            textAlignVertical="top"
          />

          <Text className="mt-2 text-right text-xs text-gray-500 dark:text-gray-400">
            {requestText.trim().length}/500
          </Text>
        </View>

        <View className="mt-4 rounded-3xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
          <Text className="text-sm font-semibold uppercase tracking-wide text-gray-500 dark:text-gray-400">
            Category
          </Text>

          <View className="mt-3 flex-row flex-wrap gap-2">
            {CATEGORIES.map((item) => {
              const active = category === item;

              return (
                <TouchableOpacity
                  key={item}
                  className={`rounded-full px-4 py-2 ${
                    active ? 'bg-black dark:bg-white' : 'bg-gray-100 dark:bg-neutral-900'
                  }`}
                  onPress={() => setCategory(item)}>
                  <Text
                    className={`text-sm font-medium ${
                      active ? 'text-white dark:text-black' : 'text-gray-700 dark:text-gray-300'
                    }`}>
                    {item}
                  </Text>
                </TouchableOpacity>
              );
            })}
          </View>
        </View>

        <View className="mt-4 rounded-3xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
          <Text className="text-sm font-semibold uppercase tracking-wide text-gray-500 dark:text-gray-400">
            Visibility
          </Text>

          <View className="mt-4 flex-row items-center justify-between">
            <View className="flex-1 pr-4">
              <Text className="text-base font-medium text-gray-900 dark:text-white">
                Post anonymously
              </Text>
              <Text className="mt-1 text-sm text-gray-500 dark:text-gray-400">
                Hide your name on the prayer board.
              </Text>
            </View>
            <Switch
              value={isAnonymous}
              onValueChange={setIsAnonymous}
              trackColor={switchTrackColor}
            />
          </View>

          <View className="mt-4 flex-row items-center justify-between">
            <View className="flex-1 pr-4">
              <Text className="text-base font-medium text-gray-900 dark:text-white">
                Mark as urgent
              </Text>
              <Text className="mt-1 text-sm text-gray-500 dark:text-gray-400">
                Helps others notice time-sensitive prayer needs.
              </Text>
            </View>
            <Switch value={isUrgent} onValueChange={setIsUrgent} trackColor={switchTrackColor} />
          </View>

          <View className="mt-4 flex-row items-center justify-between">
            <View className="flex-1 pr-4">
              <Text className="text-base font-medium text-gray-900 dark:text-white">
                Allow encouragements
              </Text>
              <Text className="mt-1 text-sm text-gray-500 dark:text-gray-400">
                Let others post a short prayer or encouragement beneath your request.
              </Text>
            </View>
            <Switch
              value={allowComments}
              onValueChange={setAllowComments}
              trackColor={switchTrackColor}
            />
          </View>
        </View>

        <View className="mt-4 rounded-3xl border border-gray-200 bg-gray-50 p-4 dark:border-neutral-800 dark:bg-neutral-900">
          <View className="flex-row items-center gap-2">
            <Ionicons name="eye-outline" size={18} color="#6b7280" />
            <Text className="text-sm font-semibold text-gray-700 dark:text-gray-300">Preview</Text>
          </View>

          <View className="mt-3 rounded-3xl border border-gray-200 bg-white p-4 dark:border-neutral-700 dark:bg-neutral-950">
            <View className="flex-row flex-wrap items-center gap-2">
              <Text className="font-semibold text-gray-900 dark:text-white">{previewName}</Text>
              <View className="rounded-full bg-gray-100 px-2 py-1 dark:bg-neutral-900">
                <Text className="text-xs text-gray-600 dark:text-gray-400">
                  {previewScopeLabel}
                </Text>
              </View>
              {isUrgent ? (
                <View className="rounded-full bg-red-50 px-2 py-1 dark:bg-red-950/40">
                  <Text className="text-xs text-red-700 dark:text-red-300">Urgent</Text>
                </View>
              ) : null}
            </View>

            <Text className="mt-4 text-base leading-7 text-gray-800 dark:text-gray-200">
              {requestText.trim() || 'Your prayer request preview will appear here.'}
            </Text>

            <View className="mt-4 self-start rounded-full bg-blue-50 px-2 py-1 dark:bg-blue-950/40">
              <Text className="text-xs text-blue-700 dark:text-blue-300">{category}</Text>
            </View>
          </View>
        </View>

        <TouchableOpacity
          disabled={isSubmitDisabled}
          onPress={handleSubmit}
          className={`mt-6 rounded-full px-6 py-4 ${
            isSubmitDisabled ? 'bg-gray-300 dark:bg-neutral-700' : 'bg-black dark:bg-white'
          }`}>
          <Text
            className={`text-center font-semibold ${
              isSubmitDisabled ? 'text-gray-500 dark:text-gray-300' : 'text-white dark:text-black'
            }`}>
            {saveMutation.isPending
              ? 'Saving...'
              : isEditing
                ? 'Save Prayer Request'
                : 'Post Prayer Request'}
          </Text>
        </TouchableOpacity>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}
