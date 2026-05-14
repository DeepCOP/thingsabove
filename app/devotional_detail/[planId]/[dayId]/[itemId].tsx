import DevotionalPlanReader from '@/src/components/DevotionPlanReader';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useDayItemsProgress } from '@/src/hooks/useDayItemsProgress';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import { sortDayItems } from '@/src/utils';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect, useMemo, useState } from 'react';
import { Text, View } from 'react-native';

export default function DevotionalDayScreen() {
  const { dayId, planId, progressId, groupId, itemId: routeItemId } = useLocalSearchParams();
  const dayIdParam = Array.isArray(dayId) ? dayId[0] : dayId;
  const progressIdParam = Array.isArray(progressId) ? progressId[0] : progressId;
  const { session } = useAuth();
  const router = useRouter();
  const setReflectAndShareRequest = useAppStore((state) => state.setReflectAndShareRequest);
  const [activeItemId, setActiveItemId] = useState((routeItemId as string) || '');

  const { dayItemsProgressQuery, toggleMutation } = useDayItemsProgress({
    progress_id: progressIdParam as string,
    plan_id: planId as string,
    day_id: dayIdParam as string,
    user_id: session?.user?.id!,
    group_id: groupId as string,
  });

  const dayItemsProgress = useMemo(() => {
    if (!dayItemsProgressQuery?.data) return null;
    const data = dayItemsProgressQuery?.data.filter((item) => item.item_type !== 'comment');

    return {
      items: [...data].sort(sortDayItems),
    };
  }, [dayItemsProgressQuery?.data]);

  useEffect(() => {
    setActiveItemId((routeItemId as string) || '');
  }, [routeItemId]);

  const HandleNext = (currentItemId: string) => {
    const items = dayItemsProgress?.items;
    if (!items) return;

    const currentItemIdx = items.findIndex((item) => item.id === currentItemId);
    if (currentItemIdx < 0 || currentItemIdx >= items.length - 1) return;

    const nextItem = items[currentItemIdx + 1];
    setActiveItemId(nextItem?.id || '');
  };
  const HandlePrevious = (currentItemId: string) => {
    const items = dayItemsProgress?.items;
    if (!items) return;

    const currentItem = items.find((item) => item.id === currentItemId);
    if (currentItem?.item_type === 'devotional') {
      return;
    }

    const currentItemIdx = items.findIndex((item) => item.id === currentItemId);
    if (currentItemIdx <= 0) return;

    const prevItem = items[currentItemIdx - 1];
    setActiveItemId(prevItem?.id || '');
  };
  const items = dayItemsProgress?.items ?? [];
  const item = items.find((entry) => entry.id === activeItemId) ?? items[0];
  const first = !!item && items.length > 0 && items[0]?.id === item.id;
  const last = !!item && items.length > 0 && items[items.length - 1]?.id === item.id;
  if (dayItemsProgressQuery.isLoading) {
    return <LoadingSpinner />;
  }

  if (items.length === 0) {
    return (
      <View className="flex-1 justify-center items-center">
        <Text>Item Not Found</Text>
      </View>
    );
  }
  return (
    <>
      {item && (
        <DevotionalPlanReader
          item={item}
          HandleNext={HandleNext}
          HandlePrevious={HandlePrevious}
          first={first}
          last={last}
          toggleItem={toggleMutation}
          onReflectAndShare={() => {
            setReflectAndShareRequest({
              progressId: progressIdParam as string,
              dayId: dayIdParam as string,
              token: String(Date.now()),
            });
            router.back();
          }}
        />
      )}
    </>
  );
}
