import DevotionalPlanReader from '@/src/components/DevotionPlanReader';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { useDayItemsProgress } from '@/src/hooks/useDayItemsProgress';
import { useAuth } from '@/src/state/AuthContext';
import { sortByItemKey } from '@/src/utils';
import { useLocalSearchParams } from 'expo-router';
import { useEffect, useMemo, useState } from 'react';
import { Text, View } from 'react-native';

export default function DevotionalDayScreen() {
  const { dayId, id: planId, progressId, groupId, itemId: routeItemId } = useLocalSearchParams();
  const { session } = useAuth();
  const [activeItemId, setActiveItemId] = useState((routeItemId as string) || '');

  const { dayItemsProgressQuery, toggleMutation } = useDayItemsProgress({
    progress_id: progressId as string,
    plan_id: planId as string,
    day_id: dayId as string,
    user_id: session?.user?.id!,
    group_id: groupId as string,
  });

  const dayItemsProgress = useMemo(() => {
    if (!dayItemsProgressQuery?.data) return null;
    const data = dayItemsProgressQuery?.data;

    return {
      items: [...data].sort((a, b) => sortByItemKey(a.item_key, b.item_key)),
    };
  }, [dayItemsProgressQuery?.data]);

  useEffect(() => {
    setActiveItemId((routeItemId as string) || '');
  }, [routeItemId]);

  const HandleNext = (currentItemId: string) => {
    const currentItemIdx = dayItemsProgress?.items?.findIndex((item) => item.id === currentItemId);
    if (currentItemIdx === undefined || !dayItemsProgress?.items) return;
    if (currentItemIdx === -1 || currentItemIdx === dayItemsProgress.items.length - 1) {
      return;
    }
    const nextItem = dayItemsProgress.items[currentItemIdx + 1];
    setActiveItemId(nextItem?.id || '');
  };
  const HandlePrevious = (currentItemId: string) => {
    const currentItem = dayItemsProgress?.items?.find((item) => item.id === currentItemId);
    if (currentItem?.item_type === 'devotional') {
      return;
    }
    const currentItemIdx = dayItemsProgress?.items?.findIndex((item) => item.id === currentItemId);
    if (!currentItemIdx || !dayItemsProgress?.items) return;
    const prevItem = dayItemsProgress.items[currentItemIdx - 1];
    setActiveItemId(prevItem?.id || '');
  };
  const item = dayItemsProgress?.items.find((item) => item.id === activeItemId);
  const last =
    !!item &&
    !!dayItemsProgress?.items?.length &&
    dayItemsProgress.items[dayItemsProgress.items.length - 1]?.id === item.id;
  if (dayItemsProgressQuery.isLoading) {
    return <LoadingSpinner />;
  }

  if (!dayItemsProgressQuery.data?.length) {
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
          last={last}
          toggleItem={toggleMutation}
        />
      )}
    </>
  );
}
