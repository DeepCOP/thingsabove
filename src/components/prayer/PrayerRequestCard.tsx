import UserAvatar from '@/src/components/UserAvatar';
import { formatRelativeTime } from '@/src/lib/relativeTime';
import { PrayerRequestDetail, PrayerRequestFeedItem } from '@/src/types/types';
import { Ionicons } from '@expo/vector-icons';
import { Text, TouchableOpacity, View } from 'react-native';

type PrayerItem = PrayerRequestFeedItem | PrayerRequestDetail;

type Props = {
  item: PrayerItem;
  onPress: () => void;
  onTogglePraying: () => void;
  onEncourage: () => void;
  onMarkAnswered?: () => void;
  answering?: boolean;
};

function getDisplayName(item: PrayerItem) {
  if (item.is_anonymous) {
    return 'Anonymous';
  }

  const name = [item.author_first_name, item.author_last_name].filter(Boolean).join(' ').trim();
  return name || 'Member';
}

function getScopeLabel(item: PrayerItem) {
  if (item.scope === 'church') {
    return item.church_name ? item.church_name : 'My Church';
  }

  return item.church_name ? item.church_name : 'Public';
}

export default function PrayerRequestCard({
  item,
  onPress,
  onTogglePraying,
  onEncourage,
  onMarkAnswered,
  answering,
}: Props) {
  const displayName = getDisplayName(item);
  const initial = displayName.slice(0, 1).toUpperCase() || 'P';
  const scopeLabel = getScopeLabel(item);

  return (
    <View className="rounded-3xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
      <TouchableOpacity activeOpacity={0.9} onPress={onPress}>
        <View className="flex-row items-start gap-3">
          <UserAvatar
            uri={item.is_anonymous ? null : item.author_avatar_url}
            initial={initial}
            size={42}
            border={false}
          />

          <View className="flex-1">
            <View className="flex-row flex-wrap items-center gap-2">
              <Text className="font-semibold text-gray-900 dark:text-white">{displayName}</Text>

              <View className="rounded-full bg-gray-100 px-2 py-1 dark:bg-neutral-900">
                <Text className="text-xs text-gray-600 dark:text-gray-400">{scopeLabel}</Text>
              </View>

              {item.is_urgent ? (
                <View className="rounded-full bg-red-50 px-2 py-1 dark:bg-red-950/40">
                  <Text className="text-xs text-red-700 dark:text-red-300">Urgent</Text>
                </View>
              ) : null}

              {item.is_answered ? (
                <View className="rounded-full bg-emerald-50 px-2 py-1 dark:bg-emerald-950/40">
                  <Text className="text-xs text-emerald-700 dark:text-emerald-300">Answered</Text>
                </View>
              ) : null}
            </View>

            <Text className="mt-1 text-xs text-gray-500 dark:text-gray-400">
              {formatRelativeTime(item.created_at)}
            </Text>
          </View>
        </View>

        <Text
          className="mt-4 text-base leading-7 text-gray-800 dark:text-gray-200"
          numberOfLines={3}>
          {item.content}
        </Text>

        <View className="mt-4 flex-row flex-wrap items-center gap-2">
          <View className="rounded-full bg-blue-50 px-2 py-1 dark:bg-blue-950/40">
            <Text className="text-xs text-blue-700 dark:text-blue-300">{item.category}</Text>
          </View>
        </View>
      </TouchableOpacity>

      <View className="mt-5 flex-row items-center justify-between gap-3">
        <TouchableOpacity className="flex-row items-center gap-2" onPress={onTogglePraying}>
          <Text className="text-base" style={{ opacity: item.viewer_has_prayed ? 1 : 0.55 }}>
            🙏
          </Text>
          <Text className="text-sm text-gray-600 dark:text-gray-400">
            {item.viewer_has_prayed ? `Praying ${item.prayer_count}` : `Pray ${item.prayer_count}`}
          </Text>
        </TouchableOpacity>

        <TouchableOpacity
          className="flex-row items-center gap-2"
          onPress={onEncourage}
          disabled={!item.allow_comments}>
          <Ionicons
            name="chatbubble-outline"
            size={18}
            color={item.allow_comments ? '#6b7280' : '#9ca3af'}
          />
          <Text className="text-sm text-gray-600 dark:text-gray-400">
            {item.allow_comments ? `Encourage ${item.encouragement_count}` : 'Replies Off'}
          </Text>
        </TouchableOpacity>

        {item.viewer_is_owner && !item.is_answered && onMarkAnswered ? (
          <TouchableOpacity className="flex-row items-center gap-2" onPress={onMarkAnswered}>
            <Ionicons name="checkmark-circle-outline" size={18} color="#16a34a" />
            <Text className="text-sm font-medium text-emerald-600 dark:text-emerald-400">
              {answering ? 'Saving...' : 'Answered'}
            </Text>
          </TouchableOpacity>
        ) : (
          <TouchableOpacity className="flex-row items-center gap-2" onPress={onPress}>
            <Ionicons name="arrow-forward" size={18} color="#2563eb" />
            <Text className="text-sm font-medium text-blue-600 dark:text-blue-400">View</Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
}
