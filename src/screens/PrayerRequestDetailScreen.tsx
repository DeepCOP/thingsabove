import LoadingSpinner from '@/src/components/LoadingSpinner';
import PrayerEmptyState from '@/src/components/prayer/PrayerEmptyState';
import UserAvatar from '@/src/components/UserAvatar';
import {
  useAddPrayerRequestEncouragement,
  usePrayerRequest,
  usePrayerRequestEncouragements,
  useSetPrayerRequestAnswered,
  useTogglePrayerRequestSupport,
} from '@/src/hooks/usePrayer';
import { formatRelativeTime } from '@/src/lib/relativeTime';
import { getAvatarNameParts, getDisplayName } from '@/src/utils';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import { useState } from 'react';
import {
  Alert,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type Props = {
  requestId: string;
};

export default function PrayerRequestDetailScreen({ requestId }: Props) {
  const router = useRouter();
  const insets = useSafeAreaInsets();
  const detailQuery = usePrayerRequest(requestId);
  const encouragementsQuery = usePrayerRequestEncouragements(requestId);
  const togglePrayerMutation = useTogglePrayerRequestSupport();
  const addEncouragementMutation = useAddPrayerRequestEncouragement();
  const markAnsweredMutation = useSetPrayerRequestAnswered();
  const [encouragementText, setEncouragementText] = useState('');

  const request = detailQuery.data;

  const handleSubmitEncouragement = () => {
    if (!encouragementText.trim()) {
      return;
    }

    addEncouragementMutation.mutate(
      {
        requestId,
        content: encouragementText.trim(),
      },
      {
        onSuccess: () => setEncouragementText(''),
        onError: (error) => {
          Alert.alert('Unable to post encouragement', error.message);
        },
      },
    );
  };

  if (detailQuery.isLoading) {
    return <LoadingSpinner ViewStyles={{ flex: 1 }} />;
  }

  if (!request) {
    return (
      <View className="flex-1 bg-white px-4 pt-6 dark:bg-black">
        <PrayerEmptyState
          icon="document-text-outline"
          title="Prayer request not found"
          description="It may have been removed, or you may not have access to it anymore."
          ctaLabel="Back to Prayer Board"
          onCta={() => router.replace('/prayer')}
        />
      </View>
    );
  }

  const displayName = getDisplayName({
    isAnonymous: request.is_anonymous,
    firstName: request.author_first_name,
    lastName: request.author_last_name,
  });
  const avatarName = getAvatarNameParts({
    isAnonymous: request.is_anonymous,
    firstName: request.author_first_name,
    lastName: request.author_last_name,
  });
  const scopeLabel =
    request.scope === 'church'
      ? request.church_name || 'My Church'
      : request.church_name || 'Public';

  return (
    <KeyboardAvoidingView
      className="flex-1 bg-white dark:bg-black"
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <ScrollView
        className="flex-1"
        contentContainerStyle={{
          paddingHorizontal: 16,
          paddingTop: 16,
          paddingBottom: insets.bottom + 24,
        }}>
        <View className="rounded-3xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
          <View className="flex-row items-start gap-3">
            <UserAvatar
              uri={request.is_anonymous ? null : request.author_avatar_url}
              first_name={avatarName.firstName}
              last_name={avatarName.lastName}
              size={48}
              border={false}
            />

            <View className="flex-1">
              <View className="flex-row flex-wrap items-center gap-2">
                <Text className="font-semibold text-gray-900 dark:text-white">{displayName}</Text>

                <View className="rounded-full bg-gray-100 px-2 py-1 dark:bg-neutral-900">
                  <Text className="text-xs text-gray-600 dark:text-gray-400">{scopeLabel}</Text>
                </View>

                {request.is_urgent ? (
                  <View className="rounded-full bg-red-50 px-2 py-1 dark:bg-red-950/40">
                    <Text className="text-xs text-red-700 dark:text-red-300">Urgent</Text>
                  </View>
                ) : null}

                {request.is_answered ? (
                  <View className="rounded-full bg-emerald-50 px-2 py-1 dark:bg-emerald-950/40">
                    <Text className="text-xs text-emerald-700 dark:text-emerald-300">Answered</Text>
                  </View>
                ) : null}
              </View>

              <Text className="mt-1 text-xs text-gray-500 dark:text-gray-400">
                {formatRelativeTime(request.created_at)}
              </Text>
            </View>
          </View>

          <Text className="mt-5 text-base leading-7 text-gray-800 dark:text-gray-200">
            {request.content}
          </Text>

          <View className="mt-4 self-start rounded-full bg-blue-50 px-2 py-1 dark:bg-blue-950/40">
            <Text className="text-xs text-blue-700 dark:text-blue-300">{request.category}</Text>
          </View>

          <View className="mt-6 flex-row items-center gap-5">
            <TouchableOpacity
              className="flex-row items-center gap-2"
              onPress={() => togglePrayerMutation.mutate(request.id)}>
              <Text className="text-base" style={{ opacity: request.viewer_has_prayed ? 1 : 0.55 }}>
                🙏
              </Text>
              <Text className="text-sm text-gray-600 dark:text-gray-400">
                {request.viewer_has_prayed
                  ? `Praying ${request.prayer_count}`
                  : `Pray ${request.prayer_count}`}
              </Text>
            </TouchableOpacity>

            <View className="flex-row items-center gap-2">
              <Ionicons name="chatbubble-outline" size={18} color="#6b7280" />
              <Text className="text-sm text-gray-600 dark:text-gray-400">
                Encourage {request.encouragement_count}
              </Text>
            </View>
          </View>
        </View>

        {request.viewer_is_owner ? (
          <View className="mt-4 rounded-3xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
            <Text className="text-sm font-semibold uppercase tracking-wide text-gray-500 dark:text-gray-400">
              Owner Actions
            </Text>

            <View className="mt-4 gap-3">
              <TouchableOpacity
                className="rounded-full bg-black py-4 dark:bg-white"
                onPress={() =>
                  markAnsweredMutation.mutate({
                    requestId: request.id,
                    isAnswered: !request.is_answered,
                  })
                }>
                <Text className="text-center font-semibold text-white dark:text-black">
                  {markAnsweredMutation.isPending
                    ? 'Saving...'
                    : request.is_answered
                      ? 'Mark as Unanswered'
                      : 'Mark as Answered'}
                </Text>
              </TouchableOpacity>

              <TouchableOpacity
                className="rounded-full border border-gray-300 py-4 dark:border-neutral-700"
                onPress={() =>
                  router.push({
                    pathname: '/prayer/new',
                    params: { requestId: request.id },
                  })
                }>
                <Text className="text-center font-semibold text-gray-900 dark:text-white">
                  Edit Request
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        ) : null}

        {request.allow_comments ? (
          <View className="mt-4 rounded-3xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
            <Text className="text-sm font-semibold uppercase tracking-wide text-gray-500 dark:text-gray-400">
              Send Encouragement
            </Text>

            <TextInput
              multiline
              placeholder="Write a short encouragement or prayer..."
              placeholderTextColor="#9ca3af"
              maxLength={300}
              value={encouragementText}
              onChangeText={setEncouragementText}
              className="mt-3 min-h-24 rounded-3xl border border-gray-200 p-4 text-base text-gray-900 dark:border-neutral-700 dark:text-white"
              textAlignVertical="top"
            />

            <TouchableOpacity
              className={`mt-4 rounded-full py-4 ${
                encouragementText.trim()
                  ? 'bg-black dark:bg-white'
                  : 'bg-gray-300 dark:bg-neutral-700'
              }`}
              disabled={!encouragementText.trim() || addEncouragementMutation.isPending}
              onPress={handleSubmitEncouragement}>
              <Text
                className={`text-center font-semibold ${
                  encouragementText.trim()
                    ? 'text-white dark:text-black'
                    : 'text-gray-500 dark:text-gray-300'
                }`}>
                {addEncouragementMutation.isPending ? 'Posting...' : 'Post Encouragement'}
              </Text>
            </TouchableOpacity>
          </View>
        ) : (
          <View className="mt-4 rounded-3xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
            <Text className="text-base font-semibold text-gray-900 dark:text-white">
              Replies are turned off
            </Text>
            <Text className="mt-2 text-sm leading-6 text-gray-600 dark:text-gray-400">
              The person who shared this request chose not to receive encouragement replies.
            </Text>
          </View>
        )}

        <View className="mt-4 rounded-3xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
          <View className="flex-row items-center justify-between">
            <Text className="text-lg font-semibold text-gray-900 dark:text-white">
              Encouragements
            </Text>
            <Text className="text-sm text-gray-500 dark:text-gray-400">
              {request.encouragement_count}
            </Text>
          </View>

          {encouragementsQuery.isLoading ? (
            <View className="py-6">
              <LoadingSpinner />
            </View>
          ) : encouragementsQuery.data && encouragementsQuery.data.length > 0 ? (
            <View className="mt-4 gap-4">
              {encouragementsQuery.data.map((item) => {
                const authorName = getDisplayName({
                  firstName: item.author?.first_name,
                  lastName: item.author?.last_name,
                });
                const authorAvatarName = getAvatarNameParts({
                  firstName: item.author?.first_name,
                  lastName: item.author?.last_name,
                });

                return (
                  <View key={item.id} className="rounded-3xl bg-gray-50 p-4 dark:bg-neutral-900">
                    <View className="flex-row items-start gap-3">
                      <UserAvatar
                        uri={item.author?.avatar_url}
                        first_name={authorAvatarName.firstName}
                        last_name={authorAvatarName.lastName}
                        size={38}
                        border={false}
                      />

                      <View className="flex-1">
                        <View className="flex-row items-center justify-between gap-3">
                          <Text className="font-medium text-gray-900 dark:text-white">
                            {authorName}
                          </Text>
                          <Text className="text-xs text-gray-500 dark:text-gray-400">
                            {formatRelativeTime(item.created_at)}
                          </Text>
                        </View>

                        <Text className="mt-2 text-sm leading-6 text-gray-700 dark:text-gray-300">
                          {item.content}
                        </Text>
                      </View>
                    </View>
                  </View>
                );
              })}
            </View>
          ) : (
            <View className="mt-4 rounded-3xl bg-gray-50 p-5 dark:bg-neutral-900">
              <Text className="text-center text-sm leading-6 text-gray-600 dark:text-gray-400">
                No encouragements yet. Be the first to send a short prayer or uplifting note.
              </Text>
            </View>
          )}
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}
