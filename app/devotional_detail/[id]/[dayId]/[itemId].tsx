import DevotionalPlanReader from '@/components/DevotionPlanReader';
import { useAuth } from '@/context/AuthContext';
import { useDayItemsProgress } from '@/hooks/useDayItemsProgress';
import { usePlanDay } from '@/hooks/usePLanProgress';
import { BibleBook, useAppStore } from '@/store/useAppStore';
import { parseVerseRef } from '@/utils/utils';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useState } from 'react';
import { useColorScheme } from 'react-native';

export default function DevotionalDayScreen() {
  const { dayId, id: planId } = useLocalSearchParams();
  const router = useRouter();
  const [last, setLast] = useState(false);
  const { session } = useAuth();
  const { itemId, setItemId, setSelectedBook } = useAppStore();
  const colorScheme = useColorScheme();

  const { data: dayData, isLoading: dayLoading } = usePlanDay((dayId as string) ?? null);
  const { dayItemsProgressQuery, toggleMutation } = useDayItemsProgress({
    plan_id: planId as string,
    day_id: dayId as string,
    user_id: session?.user?.id!,
    scripture_refs: dayData?.scripture_refs || [],
  });
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
      chapters: parsed.chapter,
      verseEnd: parsed.verseEnd,
      verseStart: parsed.verseStart,
    });
  };
  const HandleNext = () => {
    setLast(false);
    const currentItem = dayItemsProgressQuery?.items?.find((item) => item.id === itemId);
    let nextItemId;
    if (currentItem?.item_type === 'devotional') {
      nextItemId = dayItemsProgressQuery?.scriptures?.[0]?.id;
      if (!nextItemId) {
        setLast(true);
        return;
      }
      setFromVerseRef(dayItemsProgressQuery?.scriptures?.[0]?.ref || '', setSelectedBook);

      setItemId(nextItemId || '');
      return;
    }
    const currentItemIdx = dayItemsProgressQuery?.scriptures?.findIndex(
      (item) => item.id === itemId,
    );
    console.log('called', itemId, currentItemIdx, dayItemsProgressQuery?.scriptures?.length);
    if (currentItemIdx === undefined || !dayItemsProgressQuery?.scriptures) return;
    if (currentItemIdx === dayItemsProgressQuery?.scriptures?.length - 1) {
      setLast(true);
      return;
    }
    const nextItem = dayItemsProgressQuery?.scriptures?.[currentItemIdx + 1];
    console.log('next', nextItem);
    setFromVerseRef(nextItem.ref, setSelectedBook);

    setItemId(nextItem?.id || '');
  };
  const HandlePrevious = () => {
    setLast(false);
    const currentItem = dayItemsProgressQuery?.items?.find((item) => item.id === itemId);
    let nextItemId;
    if (currentItem?.item_type === 'devotional') {
      return;
    }
    const currentItemIdx = dayItemsProgressQuery?.scriptures?.findIndex(
      (item) => item.id === itemId,
    );
    let previousIdx;
    if (currentItemIdx === 0) {
      setItemId(dayItemsProgressQuery?.devotional?.id || '');
      return;
    }
    if (!currentItemIdx || !dayItemsProgressQuery?.scriptures) return;
    const prevItem = dayItemsProgressQuery?.scriptures?.[currentItemIdx - 1];
    console.log(prevItem, currentItemIdx);
    setFromVerseRef(prevItem.ref, setSelectedBook);

    setItemId(prevItem?.id || '');
  };
  const item = dayItemsProgressQuery?.items.find((item) => item.id === itemId);
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
