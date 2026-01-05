import LoadingSpinner from '@/components/LoadingSpinner';
import { ProgressBar } from '@/components/ProgressBar';
import { usePlanGroupMembers } from '@/hooks/usePlanGroup';
import { usePlanProgress } from '@/hooks/usePlanProgress';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { FlatList, Image, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

export default function InviteFriendsScreen() {
  const { id, groupId } = useLocalSearchParams<{
    id: string;
    groupId: string;
    totalDays: string;
  }>();
  const router = useRouter();

  const planGroupMembersQuery = usePlanGroupMembers(groupId as string);

  const insets = useSafeAreaInsets();
  if (planGroupMembersQuery.isLoading) {
    return (
      <LoadingSpinner style={{ marginTop: 30 }} ViewStyles={{ paddingBottom: insets.bottom }} />
    );
  }

  return (
    <View className="flex-1 bg-white dark:bg-black px-4" style={{ paddingBottom: insets.bottom }}>
      <FlatList
        data={planGroupMembersQuery.data}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => {
          return <MemberCard item={item} />;
        }}
      />

      <TouchableOpacity
        onPress={() => {
          router.push({
            pathname: `/devotional_detail/[id]/invite-friends`,
            params: {
              startDate: groupId,
              id: id as string,
            },
          });
        }}
        className="bg-black dark:bg-white py-4 rounded-full mt-4 mb-6">
        <Text className="text-white dark:text-black text-center font-semibold">Invite others</Text>
      </TouchableOpacity>
    </View>
  );
}

function MemberCard({
  item,
}: {
  item: {
    id: string;
    status: string | null;
    joined_at: string | null;
    user_id: string;
    profiles: {
      id: string;
      first_name: string;
      last_name: string;
      avatar_url: string | null;
    };
  };
}) {
  const { id, groupId, totalDays } = useLocalSearchParams<{
    id: string;
    groupId: string;
    totalDays: string;
  }>();
  const { planProgressQuery } = usePlanProgress(id as string, item.profiles.id, groupId as string);
  const planProgress = planProgressQuery.data;

  const percentageCompletion =
    ((planProgress?.completed_days?.length || 0) / Number(totalDays || 1)) * 100;

  if (planProgressQuery.isLoading) {
    return <LoadingSpinner size={'small'} />;
  }

  return (
    <View className="mb-3 p-3 rounded-xl bg-gray-100 dark:bg-neutral-900">
      <View className="flex-row items-center mb-2">
        {item.profiles.avatar_url ? (
          <Image
            source={{ uri: item.profiles.avatar_url }}
            className="w-10 h-10 rounded-full mr-3"
          />
        ) : (
          <View className="w-10 h-10 rounded-full bg-gray-300 dark:bg-gray-700 mr-3" />
        )}

        <View className="flex-1">
          <Text className="dark:text-white font-semibold">
            {item.profiles.first_name} {item.profiles.last_name}
          </Text>

          <Text className="text-xs text-gray-700 dark:text-neutral-200  mt-0.5">
            {planProgress?.completed_days?.length || 0} / {totalDays} days completed
          </Text>
        </View>

        <Text className="font-semibold text-green-600">{percentageCompletion.toFixed(2)}%</Text>
      </View>
      {planProgress && <ProgressBar percentage={percentageCompletion} />}
    </View>
  );
}
