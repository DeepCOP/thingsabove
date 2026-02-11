import LoadingSpinner from '@/src/components/LoadingSpinner';
import { Ionicons } from '@expo/vector-icons';
import { FlatList, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import UserAvatar from '../components/UserAvatar';

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

  onToggle: (id: string) => void;
  onSelectAll: () => void;
  onClearSelection: () => void;
  onSubmit: () => void;
  onAddFriend: () => void;
};

export default function InviteFriendsScreen({
  friends,
  selected,
  isSubmitting,
  onToggle,
  onSelectAll,
  onClearSelection,
  onSubmit,
  onAddFriend,
}: Props) {
  const insets = useSafeAreaInsets();

  return (
    <View className="flex-1 bg-white dark:bg-black px-4" style={{ paddingBottom: insets.bottom }}>
      {friends.length > 0 ? (
        <>
          {/* Selection controls */}
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

          {/* Friends list */}
          <FlatList
            data={friends}
            keyExtractor={(item) => item.id}
            renderItem={({ item }) => {
              const isSelected = selected.includes(item.id);

              return (
                <TouchableOpacity
                  onPress={() => onToggle(item.id)}
                  className="flex-row items-center gap-2 mb-3 p-3 rounded-xl bg-gray-100 dark:bg-neutral-900">
                  <UserAvatar initial={item.first_name[0]} uri={item.avatar_url} size={34} />

                  <Text className="flex-1 dark:text-white font-semibold">
                    {item.first_name} {item.last_name}
                  </Text>

                  {isSelected && <Ionicons name="checkmark-circle" size={22} color="#22c55e" />}
                </TouchableOpacity>
              );
            }}
          />

          {/* Submit */}
          <TouchableOpacity
            disabled={selected.length === 0 || isSubmitting}
            onPress={onSubmit}
            className="bg-black dark:bg-white py-4 rounded-full mt-4 mb-6">
            {isSubmitting ? (
              <LoadingSpinner size="small" />
            ) : (
              <Text className="text-white dark:text-black text-center font-semibold">
                Invite {selected.length} Friends
              </Text>
            )}
          </TouchableOpacity>
        </>
      ) : (
        <View className="flex-1 items-center justify-center">
          <Text className="dark:text-white">No Friends Found</Text>

          <TouchableOpacity
            onPress={onAddFriend}
            className="bg-black dark:bg-white py-4 rounded-full px-4 mt-4">
            <Text className="text-white dark:text-black font-semibold">Add Friends</Text>
          </TouchableOpacity>
        </View>
      )}
    </View>
  );
}
