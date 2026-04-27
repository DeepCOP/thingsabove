import { Ionicons } from '@expo/vector-icons';
import {
  ActivityIndicator,
  FlatList,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import ProfileIdentityRow from '../components/ProfileIdentityRow';

type Friend = {
  id: string;
  first_name: string;
  last_name: string;
  avatar_url?: string | null;
};

type Props = {
  friends: Friend[];
  selected: string[];
  isSubmitting: boolean;
  isSharing: boolean;
  submitLabel: string;

  onToggle: (id: string) => void;
  onSelectAll: () => void;
  onClearSelection: () => void;
  onSubmit: () => void;
  onShareInviteLink: () => void;
  onAddFriend: () => void;
};

export default function InviteFriendsScreen({
  friends,
  selected,
  isSubmitting,
  isSharing,
  submitLabel,
  onToggle,
  onSelectAll,
  onClearSelection,
  onSubmit,
  onShareInviteLink,
  onAddFriend,
}: Props) {
  const insets = useSafeAreaInsets();
  const colorScheme = useColorScheme();
  const submitIndicatorColor = colorScheme === 'dark' ? '#000000' : '#ffffff';

  const renderSubmitButtonContent = (textClassName: string) => (
    <View className="items-center justify-center">
      <Text className={`${textClassName}${isSubmitting ? ' opacity-0' : ''}`}>{submitLabel}</Text>
      {isSubmitting ? (
        <ActivityIndicator
          size="small"
          color={submitIndicatorColor}
          style={{ position: 'absolute' }}
        />
      ) : null}
    </View>
  );

  return (
    <View className="flex-1 bg-white dark:bg-black px-4" style={{ paddingBottom: insets.bottom }}>
      <View className="mt-6 rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
        <Text className="text-lg font-semibold text-gray-900 dark:text-white">
          Invite friends to this plan
        </Text>
        <Text className="mt-2 text-sm leading-6 text-gray-600 dark:text-gray-400">
          Invite friends, or share a group plan invitation link
        </Text>
      </View>

      {friends.length > 0 ? (
        <>
          <View className="flex-row gap-5 mt-6 mb-4 border-b border-gray-300 dark:border-gray-700">
            <TouchableOpacity onPress={onSelectAll} className="py-3 mb-4">
              <Text className="text-gray-700 dark:text-gray-200">Select All</Text>
            </TouchableOpacity>

            {selected.length > 0 && (
              <TouchableOpacity onPress={onClearSelection} className="py-3 mb-4">
                <Text className="text-gray-700 dark:text-gray-200">Select None</Text>
              </TouchableOpacity>
            )}
          </View>

          <FlatList
            data={friends}
            keyExtractor={(item) => item.id}
            renderItem={({ item }) => {
              const isSelected = selected.includes(item.id);

              return (
                <TouchableOpacity
                  onPress={() => onToggle(item.id)}
                  className="flex-row items-center gap-2 mb-3 p-3 rounded-xl bg-gray-100 dark:bg-neutral-900">
                  <ProfileIdentityRow
                    className="flex-1"
                    first_name={item.first_name}
                    last_name={item.last_name}
                    size={34}
                    titleClassName="font-semibold dark:text-white"
                    trailing={
                      isSelected ? (
                        <Ionicons name="checkmark-circle" size={22} color="#22c55e" />
                      ) : null
                    }
                    uri={item.avatar_url}
                  />
                </TouchableOpacity>
              );
            }}
            showsVerticalScrollIndicator={false}
          />

          <TouchableOpacity
            disabled={isSubmitting}
            onPress={onSubmit}
            className="bg-black dark:bg-white py-4 rounded-full mt-4">
            {renderSubmitButtonContent('text-white dark:text-black text-center font-semibold')}
          </TouchableOpacity>

          <TouchableOpacity
            disabled={isSharing}
            onPress={onShareInviteLink}
            className="mt-3 mb-6 rounded-full border border-gray-300 py-4 dark:border-neutral-700">
            <Text className="text-center font-semibold text-gray-900 dark:text-white">
              Share Invite Link
            </Text>
          </TouchableOpacity>
        </>
      ) : (
        <View className="flex-1 items-center justify-center">
          <Ionicons name="people-outline" size={32} color="#9ca3af" />
          <Text className="mt-4 text-lg font-semibold text-gray-900 dark:text-white">
            No friends ready to invite
          </Text>
          <Text className="mt-2 text-center text-sm leading-6 text-gray-600 dark:text-gray-400">
            Add friends, start the plan now, or share a group plan invitation link.
          </Text>

          <TouchableOpacity
            disabled={isSubmitting}
            onPress={onSubmit}
            className="mt-6 rounded-full bg-black px-6 py-4 dark:bg-white">
            {renderSubmitButtonContent('font-semibold text-white dark:text-black')}
          </TouchableOpacity>

          <TouchableOpacity
            disabled={isSharing}
            onPress={onShareInviteLink}
            className="mt-3 rounded-full border border-gray-300 px-6 py-4 dark:border-neutral-700">
            <Text className="font-semibold text-gray-900 dark:text-white">Share Invite Link</Text>
          </TouchableOpacity>

          <TouchableOpacity
            onPress={onAddFriend}
            className="mt-3 rounded-full border border-gray-300 px-6 py-4 dark:border-neutral-700">
            <Text className="font-semibold text-gray-900 dark:text-white">Add Friends</Text>
          </TouchableOpacity>
        </View>
      )}
    </View>
  );
}
