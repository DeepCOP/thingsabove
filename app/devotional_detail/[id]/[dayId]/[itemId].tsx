import DevotionalPlanReader from '@/components/DevotionPlanReader';
import LoadingSpinner from '@/components/LoadingSpinner';
import { useAuth } from '@/context/AuthContext';
import { useDayItemsProgress } from '@/hooks/useDayItemsProgress';
import { usePlanDayView } from '@/hooks/usePlanProgress';
import { parseVerseRef, sortByItemKey } from '@/lib/utils';
import { BibleBook, useAppStore } from '@/store/useAppStore';
import { useLocalSearchParams } from 'expo-router';
import { useMemo, useState } from 'react';

export default function DevotionalDayScreen() {
  const { dayId, id: planId, groupId } = useLocalSearchParams();
  const [last, setLast] = useState(false);
  const { session } = useAuth();
  const { itemId, setItemId, setSelectedBook } = useAppStore();
  const { data: dayData, isLoading: dayLoading } = usePlanDayView(
    (dayId as string) ?? null,
    session?.user?.id as string,
  );
  const { dayItemsProgressQuery, toggleMutation } = useDayItemsProgress({
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

  const setFromVerseRef = (
    ref: string,
    // bibleBooks: BibleBook[],
    setSelectedBook: (b: BibleBook) => void,
  ) => {
    const parsed = parseVerseRef(ref);
    if (!parsed) return;

    // const book = bibleBooks.find((b) => b.name.toLowerCase() === parsed.book.toLowerCase());

    // if (!book) return;

    setSelectedBook({
      name: parsed.book,
      chapter: parsed.chapter,
      verseEnd: parsed.verseEnd,
      verseStart: parsed.verseStart,
    });
  };
  const HandleNext = () => {
    setLast(false);
    const currentItemIdx = dayItemsProgress?.items?.findIndex((item) => item.id === itemId);
    if (currentItemIdx === undefined || !dayItemsProgress?.items) return;
    if (currentItemIdx === dayItemsProgress?.items?.length - 1) {
      setLast(true);
      return;
    }
    const nextItem = dayItemsProgress?.items?.[currentItemIdx + 1];
    setFromVerseRef(nextItem.item_key as string, setSelectedBook);

    setItemId(nextItem?.id || '');
  };
  const HandlePrevious = () => {
    setLast(false);
    const currentItem = dayItemsProgress?.items?.find((item) => item.id === itemId);
    if (currentItem?.item_type === 'devotional') {
      return;
    }
    const currentItemIdx = dayItemsProgress?.items?.findIndex((item) => item.id === itemId);
    if (!currentItemIdx || !dayItemsProgress?.items) return;
    const prevItem = dayItemsProgress?.items?.[currentItemIdx - 1];
    setFromVerseRef(prevItem.item_key as string, setSelectedBook);

    setItemId(prevItem?.id || '');
  };
  const item = dayItemsProgress?.items.find((item) => item.id === itemId);
  if (dayItemsProgressQuery.isLoading || dayLoading) {
    return <LoadingSpinner />;
  }
  return (
    <>
      {item && (
        <DevotionalPlanReader
          item={item}
          dayData={dayData}
          HandleNext={HandleNext}
          HandlePrevious={HandlePrevious}
          last={last}
          toggleItem={toggleMutation}
        />
      )}
    </>
  );
}
