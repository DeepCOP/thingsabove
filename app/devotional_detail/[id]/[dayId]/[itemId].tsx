import DevotionalPlanReader from '@/components/DevotionPlanReader';
import LoadingSpinner from '@/components/LoadingSpinner';
import { useAuth } from '@/context/AuthContext';
import { useDayItemsProgress } from '@/hooks/useDayItemsProgress';
import { usePlanDay } from '@/hooks/usePlanProgress';
import { BibleBook, useAppStore } from '@/store/useAppStore';
import { parseVerseRef, sortByItemKey } from '@/utils/utils';
import { useLocalSearchParams } from 'expo-router';
import { useMemo, useState } from 'react';

export default function DevotionalDayScreen() {
  const { dayId, id: planId, groupId } = useLocalSearchParams();
  const [last, setLast] = useState(false);
  const { session } = useAuth();
  const { itemId, setItemId, setSelectedBook } = useAppStore();

  const { data: dayData, isLoading: dayLoading } = usePlanDay((dayId as string) ?? null);
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
      items: [...data].sort((a, b) => {
        const getNumericPrefix = (key?: string | null) => {
          if (!key) return 0;
          const match = key.match(/^(\d+)/);
          return match ? Number(match[0]) : 0;
        };

        const numericA = getNumericPrefix(a.item_key);
        const numericB = getNumericPrefix(b.item_key);

        if (numericA === numericB) {
          return (a.item_key ?? '').localeCompare(b.item_key ?? '');
        }

        return numericA - numericB;
      }),
      devotional: {
        completed: data.find((i) => i.item_type === 'devotional' && i.item_key === 'main')
          ?.completed,
        id: data.find((i) => i.item_type === 'devotional' && i.item_key === 'main')?.id,
      },
      scriptures: [...(dayData?.scripture_refs || [])]
        .sort((a, b) => sortByItemKey(a, b))
        .map((ref) => ({
          ref,
          completed: data.find((i) => i.item_type === 'scripture' && i.item_key === ref)?.completed,
          id: data.find((i) => i.item_type === 'scripture' && i.item_key === ref)?.id,
        })),
    };
  }, [dayItemsProgressQuery?.data, dayData?.scripture_refs]);
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
    const currentItem = dayItemsProgress?.items?.find((item) => item.id === itemId);
    let nextItemId;
    if (currentItem?.item_type === 'devotional') {
      nextItemId = dayItemsProgress?.scriptures?.[0]?.id;
      if (!nextItemId) {
        setLast(true);
        return;
      }
      setFromVerseRef(dayItemsProgress?.scriptures?.[0]?.ref || '', setSelectedBook);

      setItemId(nextItemId || '');
      return;
    }
    const currentItemIdx = dayItemsProgress?.scriptures?.findIndex((item) => item.id === itemId);
    if (currentItemIdx === undefined || !dayItemsProgress?.scriptures) return;
    if (currentItemIdx === dayItemsProgress?.scriptures?.length - 1) {
      setLast(true);
      return;
    }
    const nextItem = dayItemsProgress?.scriptures?.[currentItemIdx + 1];
    setFromVerseRef(nextItem.ref, setSelectedBook);

    setItemId(nextItem?.id || '');
  };
  const HandlePrevious = () => {
    setLast(false);
    const currentItem = dayItemsProgress?.items?.find((item) => item.id === itemId);
    if (currentItem?.item_type === 'devotional') {
      return;
    }
    const currentItemIdx = dayItemsProgress?.scriptures?.findIndex((item) => item.id === itemId);
    if (currentItemIdx === 0) {
      setItemId(dayItemsProgress?.devotional?.id || '');
      return;
    }
    if (!currentItemIdx || !dayItemsProgress?.scriptures) return;
    const prevItem = dayItemsProgress?.scriptures?.[currentItemIdx - 1];
    setFromVerseRef(prevItem.ref, setSelectedBook);

    setItemId(prevItem?.id || '');
  };
  const item = dayItemsProgress?.items.find((item) => item.id === itemId);
  if (dayLoading || dayItemsProgressQuery.isLoading) {
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
