import { Image, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import UserAvatar from '../components/UserAvatar';

type Props = {
  inviterName: string;
  inviterAvatar?: string | null;

  planTitle?: string;
  planCover?: string | null;
  totalDays?: number;

  members?: any[];
  diffDays: number;
  startDateLabel: string;

  hasAccepted: boolean;
  isGuest: boolean;
  isAccepting: boolean;

  onAccept: () => void;
  onDecline: () => void;
};

export default function PlanInvitationScreen({
  inviterName,
  inviterAvatar,
  planTitle,
  planCover,
  totalDays,
  members,
  diffDays,
  startDateLabel,
  hasAccepted,
  isGuest,
  isAccepting,
  onAccept,
  onDecline,
}: Props) {
  const insets = useSafeAreaInsets();
  const inviterNameParts = inviterName.trim().split(/\s+/).filter(Boolean);
  const inviterFirstName = inviterNameParts[0] ?? '';
  const inviterLastName = inviterNameParts.slice(1).join(' ');

  return (
    <View className="flex-1 bg-white dark:bg-black px-6 pt-12">
      {/* Avatar */}
      <View className="items-center mb-6">
        <UserAvatar
          uri={inviterAvatar}
          first_name={inviterFirstName}
          last_name={inviterLastName}
          size={96}
        />
      </View>

      {/* Invitation text */}
      <Text className="text-center dark:text-white text-lg mb-6">
        <Text className="font-semibold">{inviterName}</Text> wants to read this plan with you.
      </Text>

      {/* Plan Card */}
      <View className="bg-neutral-300 dark:bg-neutral-800 rounded-2xl p-4 mb-10">
        {planCover ? (
          <Image source={{ uri: planCover }} className="w-full h-44 rounded-lg" />
        ) : (
          <View className="w-full h-44 bg-gray-300 dark:bg-neutral-800" />
        )}

        <Text className="dark:text-white text-lg font-semibold mt-3">{planTitle}</Text>
        <Text className="dark:text-gray-400 text-sm mb-3">{totalDays} Days</Text>

        {/* Participants */}
        <Text className="dark:text-gray-400 text-sm mb-1">Participants</Text>
        <View className="flex-row mb-3">
          {members?.slice(0, 3).map((m) => (
            <View
              key={m.user_id}
              className="w-8 h-8 rounded-full border dark:border-white mr-2 items-center justify-center">
              <UserAvatar
                uri={m.profiles?.avatar_url}
                first_name={m.profiles?.first_name}
                last_name={m.profiles?.last_name}
                size={32}
              />
            </View>
          ))}
        </View>

        {/* Start date */}
        <Text className="dark:text-gray-400 text-sm">{startDateLabel}</Text>
      </View>

      {/* Actions */}
      {!hasAccepted ? (
        <View className="absolute left-0 right-0 px-6" style={{ bottom: insets.bottom + 20 }}>
          <TouchableOpacity
            onPress={onAccept}
            disabled={isAccepting}
            className="bg-black dark:bg-white py-4 rounded-full mb-3">
            <Text className="text-center font-semibold text-lg dark:text-black text-white">
              ACCEPT
            </Text>
          </TouchableOpacity>

          <TouchableOpacity
            onPress={onDecline}
            className="py-3 rounded-full bg-gray-300 dark:bg-neutral-600">
            <Text className="text-center text-lg dark:text-white">DECLINE</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <View style={{ paddingBottom: insets.bottom + 20 }}>
          <Text className="text-center dark:text-white text-lg bg-gray-300 dark:bg-neutral-600 rounded-full py-3">
            You have accepted the invitation
          </Text>
        </View>
      )}
    </View>
  );
}
