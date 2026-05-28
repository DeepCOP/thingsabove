import { Text, TouchableOpacity, View } from 'react-native';

type Props = {
  canOpenWebsite: boolean;
  isInviting?: boolean;
  isJoining?: boolean;
  onInvitePress?: () => void;
  onJoinPress?: () => void;
  onSharePress?: () => void;
  onOpenWebsitePress?: () => void;
};

export default function ChurchActionsCard({
  canOpenWebsite,
  isInviting,
  isJoining,
  onInvitePress,
  onJoinPress,
  onSharePress,
  onOpenWebsitePress,
}: Props) {
  return (
    <View className="gap-3">
      {onInvitePress ? (
        <TouchableOpacity
          className="rounded-full bg-black py-4 dark:bg-white"
          disabled={isInviting}
          onPress={onInvitePress}>
          <Text className="text-center text-lg font-semibold text-white dark:text-black">
            {isInviting ? 'Preparing invite...' : 'Share Invite Link'}
          </Text>
        </TouchableOpacity>
      ) : onJoinPress ? (
        <TouchableOpacity
          className="rounded-full bg-black py-4 dark:bg-white"
          disabled={isJoining}
          onPress={onJoinPress}>
          <Text className="text-center text-lg font-semibold text-white dark:text-black">
            {isJoining ? 'Joining...' : 'Join Church'}
          </Text>
        </TouchableOpacity>
      ) : null}

      <TouchableOpacity
        className="rounded-full border border-gray-300 py-4 dark:border-neutral-700"
        onPress={onSharePress}>
        <Text className="text-center text-base font-semibold text-gray-900 dark:text-white">
          Share Church
        </Text>
      </TouchableOpacity>

      {canOpenWebsite ? (
        <TouchableOpacity
          className="rounded-full border border-gray-300 py-4 dark:border-neutral-700"
          onPress={onOpenWebsitePress}>
          <Text className="text-center text-base font-semibold text-gray-900 dark:text-white">
            Open Website
          </Text>
        </TouchableOpacity>
      ) : null}
    </View>
  );
}
