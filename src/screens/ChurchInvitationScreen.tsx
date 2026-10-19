import { useTranslation } from 'react-i18next';
import UserAvatar from '@/src/components/UserAvatar';
import { Church, ProfileWithChurch } from '@/src/types/types';
import { Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type Props = {
  church: Church;
  inviter?: Pick<ProfileWithChurch, 'id' | 'first_name' | 'last_name' | 'avatar_url'> | null;
  viewerProfile?: ProfileWithChurch | null;
  hasAccepted: boolean;
  isGuest: boolean;
  isAccepting: boolean;
  onAccept: () => void;
  onSignIn: () => void;
  onCreateAccount: () => void;
  onInviterPress?: (id: string) => void;
  onOpenChurch: () => void;
};

const getDisplayName = (firstName?: string | null, lastName?: string | null) => {
  const value = [firstName, lastName].filter(Boolean).join(' ').trim();
  return value;
};

export default function ChurchInvitationScreen({
  church,
  inviter,
  viewerProfile,
  hasAccepted,
  isGuest,
  isAccepting,
  onAccept,
  onSignIn,
  onCreateAccount,
  onInviterPress,
  onOpenChurch,
}: Props) {
  const { t } = useTranslation('community');
  const insets = useSafeAreaInsets();
  const inviterName =
    getDisplayName(inviter?.first_name, inviter?.last_name) || t('churchMemberInviter');
  const currentChurchName = viewerProfile?.church?.name;
  const isSwitchingChurch =
    Boolean(currentChurchName) &&
    viewerProfile?.church?.id &&
    viewerProfile.church.id !== church.id;

  return (
    <View className="flex-1 bg-white px-6 pt-12 dark:bg-black">
      <View className="items-center mb-6">
        <TouchableOpacity
          key={inviter?.id}
          className="items-center"
          disabled={!onInviterPress}
          onPress={() => onInviterPress?.(inviter?.id as string)}>
          <UserAvatar
            uri={inviter?.avatar_url}
            first_name={inviter?.first_name}
            last_name={inviter?.last_name}
            size={96}
            border={false}
          />
        </TouchableOpacity>
      </View>

      <Text className="mb-6 text-center text-lg text-gray-900 dark:text-white">
        {t('churchSharedInvitation', { name: inviter ? inviterName : t('someone') })}
      </Text>

      <View className="mb-8 rounded-2xl bg-neutral-100 p-4 dark:bg-neutral-900">
        <Text className="mt-4 text-xl font-semibold text-gray-900 dark:text-white">
          {church.name}
        </Text>

        {!!church.address && (
          <Text className="mt-2 text-sm text-gray-600 dark:text-gray-400">{church.address}</Text>
        )}

        {!!church.website_url && (
          <Text className="mt-2 text-sm text-blue-600 dark:text-blue-400">
            {church.website_url}
          </Text>
        )}
      </View>

      {isSwitchingChurch && !hasAccepted && !isGuest && (
        <View className="mb-6 rounded-2xl border border-amber-200 bg-amber-50 px-4 py-3 dark:border-amber-900 dark:bg-amber-950/30">
          <Text className="text-sm leading-6 text-amber-900 dark:text-amber-200">
            {t('churchSwitchDescription', {
              church: church.name,
              currentChurch: currentChurchName,
            })}
          </Text>
        </View>
      )}

      {hasAccepted ? (
        <View style={{ paddingBottom: insets.bottom + 20 }}>
          <Text className="rounded-full bg-gray-200 py-3 text-center text-lg text-gray-900 dark:bg-neutral-700 dark:text-white">
            {t('joinedChurch')}
          </Text>

          <TouchableOpacity
            onPress={onOpenChurch}
            className="mt-4 rounded-full bg-black py-4 dark:bg-white">
            <Text className="text-center text-lg font-semibold text-white dark:text-black">
              {t('openChurch')}
            </Text>
          </TouchableOpacity>
        </View>
      ) : isGuest ? (
        <View style={{ paddingBottom: insets.bottom + 20 }}>
          <TouchableOpacity
            onPress={onSignIn}
            className="mb-3 rounded-full bg-black py-4 dark:bg-white">
            <Text className="text-center text-lg font-semibold text-white dark:text-black">
              {t('signInToJoin')}
            </Text>
          </TouchableOpacity>

          <TouchableOpacity
            onPress={onCreateAccount}
            className="rounded-full bg-gray-200 py-4 dark:bg-neutral-700">
            <Text className="text-center text-lg text-gray-900 dark:text-white">
              {t('createAccount')}
            </Text>
          </TouchableOpacity>
        </View>
      ) : (
        <View style={{ paddingBottom: insets.bottom + 20 }}>
          <TouchableOpacity
            onPress={onAccept}
            disabled={isAccepting}
            className="mb-3 rounded-full bg-black py-4 dark:bg-white">
            <Text className="text-center text-lg font-semibold text-white dark:text-black">
              {isAccepting ? t('joining') : t('joinChurch')}
            </Text>
          </TouchableOpacity>
        </View>
      )}
    </View>
  );
}
