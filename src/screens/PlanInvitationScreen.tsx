import { ActivityIndicator, Image, Text, TouchableOpacity, View } from 'react-native';
import { ScrollView } from 'react-native-gesture-handler';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import UserAvatar from '../components/UserAvatar';

type Props = {
  firstName: string;
  lastName: string;
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
  isDeclining: boolean;
  isContinuing?: boolean;

  onAccept: () => void;
  onContinue?: () => void;
  onDecline: () => void;
};

export default function PlanInvitationScreen({
  firstName,
  lastName,
  inviterAvatar,
  planTitle,
  planCover,
  totalDays,
  members,
  startDateLabel,
  hasAccepted,
  isAccepting,
  isDeclining,
  isContinuing,
  onAccept,
  onContinue,
  onDecline,
}: Props) {
  const insets = useSafeAreaInsets();
  const inviterName = [firstName, lastName].filter(Boolean).join(' ').trim();
  const isBusy = isAccepting || isDeclining;

  return (
    <View className="flex-1 bg-white dark:bg-black px-6 ">
      <ScrollView
        className="flex-1"
        contentContainerStyle={{ paddingBottom: 125 + insets.bottom, paddingTop: 24 }}
        showsVerticalScrollIndicator={false}>
        {/* Avatar */}
        <View className="items-center mb-6">
          <UserAvatar uri={inviterAvatar} first_name={firstName} last_name={lastName} size={96} />
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
      </ScrollView>
      {/* Actions */}
      {!hasAccepted ? (
        <View className="absolute left-0 right-0 px-6" style={{ bottom: insets.bottom + 20 }}>
          <TouchableOpacity
            onPress={onAccept}
            disabled={isBusy}
            className="bg-black dark:bg-white py-2 rounded-full mb-3">
            {isAccepting ? (
              <ActivityIndicator color="#9ca3af" />
            ) : (
              <Text className="text-center font-semibold text-lg dark:text-black text-white">
                ACCEPT
              </Text>
            )}
          </TouchableOpacity>

          <TouchableOpacity
            onPress={onDecline}
            disabled={isBusy}
            className="py-2 rounded-full bg-gray-300 dark:bg-neutral-600">
            {isDeclining ? (
              <ActivityIndicator color="#6b7280" />
            ) : (
              <Text className="text-center text-lg dark:text-white">DECLINE</Text>
            )}
          </TouchableOpacity>
        </View>
      ) : (
        <View className="absolute left-0 right-0 px-6" style={{ bottom: insets.bottom + 20 }}>
          <TouchableOpacity
            onPress={onContinue}
            disabled={!onContinue || isContinuing}
            className={`rounded-full py-3 ${!onContinue || isContinuing ? 'bg-gray-300 dark:bg-neutral-600' : 'bg-black dark:bg-white'}`}>
            {isContinuing ? (
              <ActivityIndicator color="#9ca3af" />
            ) : (
              <Text
                className={`text-center text-lg font-semibold ${!onContinue ? 'text-gray-600 dark:text-gray-300' : 'text-white dark:text-black'}`}>
                Continue to Plan
              </Text>
            )}
          </TouchableOpacity>
        </View>
      )}
    </View>
  );
}
