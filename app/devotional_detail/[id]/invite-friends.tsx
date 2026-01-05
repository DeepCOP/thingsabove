import LoadingSpinner from '@/components/LoadingSpinner';
import { useAuth } from '@/context/AuthContext';
import { useCreatePlanGroup } from '@/hooks/useCreatePlanGroup';
import { useFriends } from '@/hooks/useFriends';
import { useInviteFriends } from '@/hooks/useInviteFriends';
import { Ionicons } from '@expo/vector-icons';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useState } from 'react';
import { FlatList, Image, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

export default function InviteFriendsScreen() {
  const { session } = useAuth();
  const { id, startDate } = useLocalSearchParams();
  const router = useRouter();

  const friendsQuery = useFriends(session!.user.id);
  const inviteMutation = useInviteFriends(id as string);

  const [selected, setSelected] = useState<string[]>([]);
  const insets = useSafeAreaInsets();
  const createPlanGroupMutation = useCreatePlanGroup();
  if (friendsQuery.isLoading) {
    return (
      <LoadingSpinner style={{ marginTop: 30 }} ViewStyles={{ paddingBottom: insets.bottom }} />
    );
  }

  const toggle = (id: string) => {
    setSelected((prev) => (prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]));
  };

  return (
    <View className="flex-1 bg-white dark:bg-black px-4" style={{ paddingBottom: insets.bottom }}>
      {(friendsQuery.data ?? []).length > 0 ? (
        <>
          <View className="flex-row justify-start items-center mt-6 mb-4 gap-5 border-b border-gray-300 dark:border-gray-700">
            <TouchableOpacity
              onPress={() => {
                if (!friendsQuery.data) return;

                setSelected(friendsQuery.data.map((friend) => friend.id));
              }}
              className="py-3  mb-4">
              <Text className="capitalize text-gray-700 dark:text-gray-200">Select All</Text>
            </TouchableOpacity>
            {selected.length > 0 && (
              <TouchableOpacity
                onPress={() => {
                  setSelected([]);
                }}
                className="py-3  mb-4">
                <Text className="capitalize text-gray-700 dark:text-gray-200">Select None</Text>
              </TouchableOpacity>
            )}
          </View>
          <FlatList
            data={friendsQuery.data}
            keyExtractor={(item) => item.id}
            renderItem={({ item }) => {
              const isSelected = selected.includes(item.id);
              return (
                <TouchableOpacity
                  onPress={() => toggle(item.id)}
                  className="flex-row items-center mb-3 p-3 rounded-xl bg-gray-100 dark:bg-neutral-900">
                  {item.avatar_url ? (
                    <Image
                      source={{ uri: item.avatar_url }}
                      className="w-10 h-10 rounded-full mr-3"
                    />
                  ) : (
                    <View className="w-10 h-10 rounded-full bg-gray-300 dark:bg-gray-700 mr-3" />
                  )}
                  <Text className="flex-1 dark:text-white font-semibold">
                    {item.first_name} {item.last_name}
                  </Text>

                  {isSelected && <Ionicons name="checkmark-circle" size={22} color="#22c55e" />}
                </TouchableOpacity>
              );
            }}
          />
          <TouchableOpacity
            disabled={selected.length === 0 || inviteMutation.isPending}
            onPress={() => {
              createPlanGroupMutation.mutate(
                {
                  plan_id: id as string,
                  invited_user_ids: selected,
                  user_id: session?.user?.id as string,
                  start_date: startDate as string,
                },
                {
                  onSuccess: (groupId) => {
                    router.replace({
                      pathname: `/plan_progress/[planId]`,
                      params: { groupId: groupId, planId: id as string },
                    });
                  },
                  onError: (e) => {
                    console.error(e);
                  },
                },
              );
            }}
            className="bg-black dark:bg-white py-4 rounded-full mt-4 mb-6">
            <Text className="text-white dark:text-black text-center font-semibold">
              Invite {selected.length} Friends
            </Text>
          </TouchableOpacity>
        </>
      ) : (
        <View className="flex-1 items-center justify-center">
          <Text className="text-black dark:text-white">No Friends Found</Text>
          <TouchableOpacity
            onPress={() => router.push('/add_friend')}
            className="bg-black dark:bg-white py-4 rounded-full px-4 mt-4">
            <Text className="text-white dark:text-black text-center font-semibold">
              Add Friends
            </Text>
          </TouchableOpacity>
        </View>
      )}
    </View>
  );
}
