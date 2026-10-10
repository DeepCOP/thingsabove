import { useTranslation } from 'react-i18next';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import ProfileIdentityRow from '@/src/components/ProfileIdentityRow';
import { Text, TouchableOpacity, View } from 'react-native';

type Mode = 'requester' | 'receiver' | 'friends';

type Props = {
  id: string;
  first_name: string;
  last_name: string;
  avatar_url?: string | null;

  mode: Mode;

  statusText?: string; // "Pending", "Not friends", etc.

  onAdd?: (id: string) => void;
  onAccept?: (id: string) => void;
  onDecline?: (id: string) => void;

  isAdding?: boolean;
  isAccepting?: boolean;
  isDeclining?: boolean;
};

export default function FriendRequestCard({
  id,
  first_name,
  last_name,
  avatar_url,
  mode,
  statusText,
  onAdd,
  onAccept,
  onDecline,
  isAdding,
  isAccepting,
  isDeclining,
}: Props) {
  const { t } = useTranslation('community');
  return (
    <View className="flex-row items-center p-3 mb-3 rounded-xl bg-gray-100 dark:bg-neutral-900">
      <ProfileIdentityRow
        className="flex-1"
        first_name={first_name}
        last_name={last_name}
        size={34}
        subtitle={mode === 'receiver' ? t('friendRequestReceived') : statusText}
        subtitleClassName="text-xs text-gray-500"
        titleClassName="font-semibold dark:text-white"
        uri={avatar_url}
        userId={id}
      />

      {/* REQUESTER */}
      {mode === 'requester' && onAdd && (
        <TouchableOpacity
          onPress={() => onAdd(id)}
          className="bg-black dark:bg-white px-4 py-2 rounded-full"
          disabled={isAdding}>
          {isAdding ? (
            <LoadingSpinner size="small" />
          ) : (
            <Text className="text-white dark:text-black font-semibold">{t('add')}</Text>
          )}
        </TouchableOpacity>
      )}

      {/* RECEIVER */}
      {mode === 'receiver' && (
        <View className="flex-row gap-2">
          <TouchableOpacity
            onPress={() => onDecline?.(id)}
            disabled={isDeclining}
            className="px-3 py-2 rounded-full bg-gray-300 dark:bg-neutral-700">
            {isDeclining ? (
              <LoadingSpinner size="small" />
            ) : (
              <Text className="text-black dark:text-white text-sm">{t('decline')}</Text>
            )}
          </TouchableOpacity>

          <TouchableOpacity
            onPress={() => onAccept?.(id)}
            disabled={isAccepting}
            className="px-4 py-2 rounded-full bg-black dark:bg-white">
            {isAccepting ? (
              <LoadingSpinner size="small" />
            ) : (
              <Text className="text-white dark:text-black text-sm font-semibold">
                {t('accept')}
              </Text>
            )}
          </TouchableOpacity>
        </View>
      )}
    </View>
  );
}
