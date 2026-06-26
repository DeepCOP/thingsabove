import UserAvatar from '@/src/components/UserAvatar';
import { Friendship, ProfileWithChurch } from '@/src/types/types';
import { Ionicons } from '@expo/vector-icons';
import {
  ActivityIndicator,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
  useColorScheme,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type Props = {
  profile: ProfileWithChurch;
  canOpenChurch?: boolean;
  isCurrentUser?: boolean;
  viewerUserId?: string;
  friendship?: Friendship | null;
  isFriendshipLoading?: boolean;
  isAddingFriend?: boolean;
  isAcceptingFriend?: boolean;
  isDecliningFriend?: boolean;
  onOpenChurch?: () => void;
  onAddFriend?: () => void;
  onAcceptFriendRequest?: () => void;
  onDeclineFriendRequest?: () => void;
};

const DetailRow = ({ label, value }: { label: string; value: string }) => (
  <View className="mb-4">
    <Text className="text-xs uppercase tracking-wide text-gray-500 dark:text-gray-400">
      {label}
    </Text>
    <Text className="mt-1 text-base text-gray-900 dark:text-white">{value}</Text>
  </View>
);

export default function PublicProfileScreen({
  profile,
  canOpenChurch = false,
  isCurrentUser = false,
  viewerUserId,
  friendship,
  isFriendshipLoading = false,
  isAddingFriend = false,
  isAcceptingFriend = false,
  isDecliningFriend = false,
  onOpenChurch,
  onAddFriend,
  onAcceptFriendRequest,
  onDeclineFriendRequest,
}: Props) {
  const insets = useSafeAreaInsets();
  const colorScheme = useColorScheme();
  const displayBio = profile.bio?.trim() ?? '';
  const churchName = profile.church?.name ?? 'Not provided';
  const churchAddress = profile.church?.address ?? '';
  const churchWebsite = profile.church?.website_url ?? '';
  const hasAboutDetails = Boolean(
    profile.year_believed ||
    profile.year_baptized ||
    profile.church?.name ||
    profile.church?.address ||
    profile.church?.website_url,
  );
  const isPendingFriendship = friendship?.status === 'pending';
  const isAcceptedFriendship = friendship?.status === 'accepted';
  const isIncomingFriendRequest = isPendingFriendship && friendship?.receiver_id === viewerUserId;
  const isHandlingFriendRequest = isAcceptingFriend || isDecliningFriend;
  const showFriendAction =
    !isCurrentUser && Boolean(isFriendshipLoading || friendship || onAddFriend);
  const canSendFriendRequest =
    !friendship && !isFriendshipLoading && !isAddingFriend && Boolean(onAddFriend);
  const isPrimaryFriendAction = canSendFriendRequest || isAddingFriend;
  const primaryActionColor = colorScheme === 'dark' ? '#000000' : '#ffffff';
  const secondaryActionColor = isAcceptedFriendship ? '#16a34a' : '#6b7280';
  const friendActionIconColor = isPrimaryFriendAction ? primaryActionColor : secondaryActionColor;
  const friendActionLabel = isAddingFriend
    ? 'Sending...'
    : isFriendshipLoading
      ? 'Checking...'
      : isAcceptedFriendship
        ? 'Friends'
        : isPendingFriendship
          ? isIncomingFriendRequest
            ? 'Request Pending'
            : 'Request Sent'
          : 'Add Friend';
  const friendActionLabelClassName = isPrimaryFriendAction
    ? 'text-white dark:text-black'
    : isAcceptedFriendship
      ? 'text-green-700 dark:text-green-400'
      : 'text-gray-600 dark:text-gray-300';

  return (
    <ScrollView
      className="flex-1 bg-white dark:bg-black"
      contentContainerStyle={{ paddingTop: 24, paddingBottom: insets.bottom + 24 }}
      showsVerticalScrollIndicator={false}>
      <View className="items-center px-6">
        <UserAvatar
          uri={profile.avatar_url}
          first_name={profile.first_name}
          last_name={profile.last_name}
          size={150}
        />

        <Text className="mt-4 text-xl font-semibold text-gray-900 dark:text-white">
          {profile.first_name} {profile.last_name}
        </Text>

        {isCurrentUser ? (
          <Text className="mt-1 text-sm text-gray-500 dark:text-gray-400">
            This is your public profile
          </Text>
        ) : null}

        {showFriendAction ? (
          isIncomingFriendRequest && onAcceptFriendRequest && onDeclineFriendRequest ? (
            <View className="mt-4 items-center">
              <Text className="text-sm text-gray-600 dark:text-gray-300">
                {profile.first_name} sent you a friend request
              </Text>

              <View className="mt-3 flex-row gap-3">
                <TouchableOpacity
                  className="flex-row items-center justify-center rounded-full border border-gray-300 px-4 py-3 dark:border-neutral-700"
                  disabled={isHandlingFriendRequest}
                  onPress={onDeclineFriendRequest}>
                  {isDecliningFriend ? (
                    <ActivityIndicator color="#6b7280" size="small" />
                  ) : (
                    <Ionicons color="#6b7280" name="close-circle-outline" size={18} />
                  )}
                  <Text className="ml-2 font-semibold text-gray-600 dark:text-gray-300">
                    Decline
                  </Text>
                </TouchableOpacity>

                <TouchableOpacity
                  className="flex-row items-center justify-center rounded-full bg-black px-4 py-3 dark:bg-white"
                  disabled={isHandlingFriendRequest}
                  onPress={onAcceptFriendRequest}>
                  {isAcceptingFriend ? (
                    <ActivityIndicator color={primaryActionColor} size="small" />
                  ) : (
                    <Ionicons
                      color={primaryActionColor}
                      name="checkmark-circle-outline"
                      size={18}
                    />
                  )}
                  <Text className="ml-2 font-semibold text-white dark:text-black">Accept</Text>
                </TouchableOpacity>
              </View>
            </View>
          ) : (
            <TouchableOpacity
              className={`mt-4 flex-row items-center justify-center rounded-full px-5 py-3 ${
                isPrimaryFriendAction
                  ? 'bg-black dark:bg-white'
                  : 'border border-gray-200 bg-gray-50 dark:border-neutral-800 dark:bg-neutral-900'
              }`}
              disabled={!canSendFriendRequest}
              onPress={onAddFriend}>
              {isAddingFriend || isFriendshipLoading ? (
                <ActivityIndicator color={friendActionIconColor} size="small" />
              ) : (
                <Ionicons
                  color={friendActionIconColor}
                  name={
                    isAcceptedFriendship
                      ? 'checkmark-circle-outline'
                      : isPendingFriendship
                        ? 'time-outline'
                        : 'person-add-outline'
                  }
                  size={18}
                />
              )}
              <Text className={`ml-2 font-semibold ${friendActionLabelClassName}`}>
                {friendActionLabel}
              </Text>
            </TouchableOpacity>
          )
        ) : null}
      </View>

      {displayBio ? (
        <View className="mt-4 px-6">
          <Text className="text-center text-gray-600 dark:text-gray-400">{displayBio}</Text>
        </View>
      ) : null}

      <View className="mt-6 px-6">
        <View className="rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
          <Text className="text-lg font-semibold text-gray-900 dark:text-white">About</Text>

          {hasAboutDetails ? (
            <View className="mt-4">
              <DetailRow
                label="Year Believed"
                value={profile.year_believed ? String(profile.year_believed) : 'Not provided'}
              />
              <DetailRow
                label="Year Baptized"
                value={profile.year_baptized ? String(profile.year_baptized) : 'Not provided'}
              />

              <View>
                <Text className="text-xs uppercase tracking-wide text-gray-500 dark:text-gray-400">
                  Church
                </Text>

                {canOpenChurch && onOpenChurch ? (
                  <TouchableOpacity
                    className="mt-1 rounded-2xl bg-gray-50 p-3 dark:bg-neutral-900"
                    onPress={onOpenChurch}>
                    <Text className="text-base text-gray-900 dark:text-white">{churchName}</Text>
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
                  </TouchableOpacity>
                ) : (
                  <>
                    <Text className="mt-1 text-base text-gray-900 dark:text-white">
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
                  </>
                )}
              </View>
            </View>
          ) : (
            <View className="mt-4 rounded-2xl border border-gray-200 bg-gray-50 px-4 py-6 dark:border-neutral-800 dark:bg-neutral-900">
              <Text className="text-center text-sm text-gray-600 dark:text-gray-400">
                No additional profile details yet.
              </Text>
            </View>
          )}
        </View>
      </View>
    </ScrollView>
  );
}
