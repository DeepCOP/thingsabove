import { ProgressBar } from '@/src/components/ProgressBar';
import { PlanProgress } from '@/src/types/types';
import { FlatList, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import UserAvatar from '../components/UserAvatar';

type Member = {
  id: string;
  user_id: string;
  profiles: {
    first_name: string;
    last_name: string;
    avatar_url: string | null;
  };
};

type Props = {
  members: Member[];
  totalDays: number;
  progresses: PlanProgress[];
  refreshing: boolean;
  onRefresh: () => void;
  onInvite: () => void;
};

export default function ParticipantsScreen({
  members,
  totalDays,
  progresses,
  refreshing,
  onRefresh,
  onInvite,
}: Props) {
  const insets = useSafeAreaInsets();

  return (
    <View className="flex-1 bg-white dark:bg-black px-4" style={{ paddingBottom: insets.bottom }}>
      <FlatList
        data={members}
        refreshing={refreshing}
        onRefresh={onRefresh}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => {
          const progress = progresses.find((p) => p.user_id === item.user_id);

          const completed = progress?.completed_days?.length || 0;
          const percentage = (completed / Math.max(totalDays, 1)) * 100;

          return (
            <View className="mb-3 p-3 rounded-xl bg-gray-100 dark:bg-neutral-900">
              <View className="flex-row items-center mb-2">
                <UserAvatar
                  uri={item.profiles.avatar_url}
                  first_name={item.profiles.first_name}
                  last_name={item.profiles.last_name}
                  size={40}
                />

                <View className="flex-1 ml-2">
                  <Text className="dark:text-white font-semibold">
                    {item.profiles.first_name} {item.profiles.last_name}
                  </Text>

                  <Text className="text-xs text-gray-700 dark:text-neutral-200 mt-0.5">
                    {completed} / {totalDays} days completed
                  </Text>
                </View>

                <Text className="font-semibold text-green-600">{percentage.toFixed(2)}%</Text>
              </View>

              {progress && <ProgressBar percentage={percentage} />}
            </View>
          );
        }}
      />

      <TouchableOpacity
        onPress={onInvite}
        className="bg-black dark:bg-white py-4 rounded-full mt-4 mb-6">
        <Text className="text-white dark:text-black text-center font-semibold">Invite others</Text>
      </TouchableOpacity>
    </View>
  );
}
