import { ChurchTopPlan } from '@/src/types/types';
import { Ionicons } from '@expo/vector-icons';
import { Text, TouchableOpacity, View } from 'react-native';

type Props = {
  plans: ChurchTopPlan[];
  onPlanPress?: (planId: string) => void;
};

export default function ChurchTopPlansList({ plans, onPlanPress }: Props) {
  return (
    <View className="rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
      <Text className="text-lg font-semibold text-gray-900 dark:text-white">Top Devotionals</Text>

      {plans.length === 0 ? (
        <Text className="mt-3 text-sm text-gray-500 dark:text-gray-400">
          No devotional activity yet for this church.
        </Text>
      ) : (
        <View className="mt-3 gap-3">
          {plans.map((plan, index) => (
            <TouchableOpacity
              key={plan.id}
              className="flex-row items-center justify-between rounded-2xl bg-gray-50 px-4 py-3 dark:bg-neutral-900"
              onPress={() => onPlanPress?.(plan.id)}>
              <View className="flex-row items-center gap-3">
                <View className="h-8 w-8 items-center justify-center rounded-full bg-black dark:bg-white">
                  <Text className="text-sm font-bold text-white dark:text-black">{index + 1}</Text>
                </View>
                <View className="flex-1">
                  <Text className="font-medium text-gray-900 dark:text-white">{plan.title}</Text>
                  <Text className="text-sm text-gray-500 dark:text-gray-400">
                    {plan.starters} started - {plan.completions} completed
                  </Text>
                </View>
              </View>
              <Ionicons name="chevron-forward" size={18} color="#9ca3af" />
            </TouchableOpacity>
          ))}
        </View>
      )}
    </View>
  );
}
