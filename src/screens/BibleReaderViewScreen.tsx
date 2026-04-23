import { findBookInBible, getBibleDotComBookCode, getBookNameForId } from '@/src/bible/books';
import ReaderBottomBar from '@/src/components/ReaderBottomBar';
import ScriptureSelectionMenu from '@/src/components/ScriptureSelectionMenu';
import { useAppStore } from '@/src/state/useAppStore';
import * as Clipboard from 'expo-clipboard';
import { useRouter } from 'expo-router';
import { useEffect, useMemo, useRef, useState } from 'react';
import {
  Animated,
  ScrollView,
  Share,
  Text,
  TouchableOpacity,
  useWindowDimensions,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useBible } from '../state/BibleContext';

export default function BibleReaderView({ onScroll }: { onScroll: (...args: any[]) => void }) {
  const insets = useSafeAreaInsets();
  const [selectedVerse, setSelectedVerse] = useState<
    {
      number: number;
      text: string;
    }[]
  >([]);

  const [showMenu, setShowMenu] = useState(false);
  const [menuAnchor, setMenuAnchor] = useState({ x: 0, y: 0 });
  const [menuHeight, setMenuHeight] = useState(0);
  const scrollRef = useRef<ScrollView | null>(null);
  const versePositions = useRef<Record<number, number>>({});
  const didScrollRef = useRef(false);

  const selectedBook = useAppStore((s) => s.selectedBook);
  const setSelectedBook = useAppStore((s) => s.setSelectedBook);
  const { width: screenWidth, height: screenHeight } = useWindowDimensions();

  const router = useRouter();
  const { bible, version } = useBible();
  const contextMenuStyle = useMemo(() => {
    const menuWidth = 220;
    const horizontalMargin = 10;
    const verticalSpacing = 12;
    const estimatedHeight = menuHeight || 210;
    const maxLeft = Math.max(horizontalMargin, screenWidth - menuWidth - horizontalMargin);
    const left = Math.min(Math.max(horizontalMargin, menuAnchor.x - menuWidth / 2), maxLeft);

    const preferBelow =
      menuAnchor.y + verticalSpacing + estimatedHeight <= screenHeight - insets.bottom;
    const top = preferBelow
      ? menuAnchor.y + verticalSpacing
      : Math.max(insets.top + 8, menuAnchor.y - estimatedHeight - verticalSpacing);

    return {
      top,
      left,
      width: menuWidth,
    };
  }, [
    insets.bottom,
    insets.top,
    menuAnchor.x,
    menuAnchor.y,
    menuHeight,
    screenHeight,
    screenWidth,
  ]);

  const currentBook = useMemo(
    () => findBookInBible(bible, selectedBook.bookId) ?? bible.books[0],
    [bible, selectedBook.bookId],
  );
  const currentBookId = currentBook?.id ?? selectedBook.bookId;
  const currentBookName = currentBook?.name ?? getBookNameForId(bible, currentBookId);
  const currentBookIndex = currentBook
    ? bible.books.findIndex((book) => book.id === currentBook.id)
    : -1;

  useEffect(() => {
    if (selectedBook.verseStart == null) {
      setSelectedVerse([]);
      didScrollRef.current = false;
      versePositions.current = {};
      return;
    }

    const selectedChapterVerses =
      currentBook?.chapters.find((chapter) => chapter.chapter === selectedBook.chapter)?.verses ??
      [];

    const endVerse = selectedBook.verseEnd ?? selectedBook.verseStart;
    const nextSelectedVerse = selectedChapterVerses
      .filter((entry) => entry.verse >= selectedBook.verseStart! && entry.verse <= endVerse)
      .map((entry) => ({ number: entry.verse, text: entry.text }));

    setSelectedVerse(nextSelectedVerse);
    didScrollRef.current = false;
    versePositions.current = {};
  }, [currentBook, selectedBook.chapter, selectedBook.verseEnd, selectedBook.verseStart]);

  useEffect(() => {
    if (selectedBook.verseStart == null) {
      return;
    }

    let cancelled = false;
    let attempts = 0;
    const maxAttempts = 12;

    const tryScroll = () => {
      if (cancelled || didScrollRef.current) return;

      const y = versePositions.current[selectedBook.verseStart!];
      if (y != null) {
        didScrollRef.current = true;
        scrollRef.current?.scrollTo({
          y: Math.max(y - 140, 0),
          animated: true,
        });
        return;
      }

      if (attempts < maxAttempts) {
        attempts += 1;
        setTimeout(tryScroll, 50);
      }
    };

    setTimeout(tryScroll, 50);

    return () => {
      cancelled = true;
    };
  }, [selectedBook.chapter, selectedBook.bookId, selectedBook.verseStart]);

  const formatVerseText = (verses: { number: number; text: string }[]) => {
    if (verses.length === 0) return '';

    const { header, ranges, sorted } = formatSelectedVerseTitle();

    // Each verse on its own line
    let body = '';
    for (let v of ranges) {
      const range = v.split('-');

      for (let i = Number(range[0]); i <= Number(range[range.length - 1]); i++) {
        const verse = sorted.find((v) => v.number === i);
        if (!verse) continue;
        body += `[${verse.number}] ${verse.text}`;
      }
      body += '\n';
    }

    // Official Bible.com link
    const bookCode = getBibleDotComBookCode(currentBookId);
    const link = bookCode
      ? `${process.env.EXPO_PUBLIC_BASE_URL}/bible/12/${bookCode}.${selectedBook.chapter}.${ranges.join(',')}.${version}`
      : '';

    return link ? `${header}\n${body}\n${link}` : `${header}\n${body}`;
  };

  const formatSelectedVerseTitle = () => {
    if (selectedVerse.length === 0) return { header: '', ranges: [], sorted: [] };

    // Sort verses numerically
    const sorted = [...selectedVerse].sort((a, b) => Number(a.number) - Number(b.number));

    // Build verse range header (1-2, 10-12, 24)
    const verseNumbers = sorted.map((v) => Number(v.number));
    let ranges: string[] = [];
    let start = verseNumbers[0];
    let end = verseNumbers[0];

    for (let i = 1; i < verseNumbers.length; i++) {
      if (verseNumbers[i] === end + 1) {
        end = verseNumbers[i];
      } else {
        ranges.push(start === end ? `${start}` : `${start}-${end}`);
        start = end = verseNumbers[i];
      }
    }

    // Push last range
    ranges.push(start === end ? `${start}` : `${start}-${end}`);
    // Construct header: "Luke 19:1-2,10-12,24 ASV"
    const header = `${currentBookName} ${selectedBook.chapter}:${ranges.join(',')} ${version}`;
    return { header, ranges, sorted };
  };

  const getSelectedVerseRange = () => {
    if (selectedVerse.length === 0) return null;
    const sorted = [...selectedVerse].sort((a, b) => a.number - b.number);
    return {
      start: sorted[0],
      end: sorted[sorted.length - 1],
    };
  };
  const chapters = currentBook?.chapters;
  const chapterCount = chapters?.length || 0;

  const chapterNumber = Number(selectedBook.chapter);
  const verses = currentBook?.chapters.find((chapter) => chapter.chapter === chapterNumber)?.verses;
  const selectedVerseRange = getSelectedVerseRange();
  const hasBibleChapter = currentBookIndex >= 0 && chapterCount > 0;
  const isFirstBibleChapter = !hasBibleChapter || (currentBookIndex === 0 && chapterNumber <= 1);
  const isLastBibleChapter =
    !hasBibleChapter ||
    (currentBookIndex === bible.books.length - 1 && chapterNumber >= chapterCount);

  return (
    <>
      <View className="flex-1 bg-white dark:bg-black">
        <Animated.ScrollView
          ref={scrollRef}
          scrollEventThrottle={16}
          onScroll={onScroll}
          className="px-5"
          contentContainerStyle={{ paddingBottom: insets.bottom + 80 }}>
          <View className="justify-center items-center pb-16 gap-4">
            <Text className="text-center text-primary dark:text-gray-100 text-lg pt-28 font-MerriWeather300Light">
              {currentBookName}
            </Text>

            {/* BIG CHAPTER NUMBER */}
            <Text className="text-center text-7xl  font-MerriWeather900Black text-gray-900 dark:text-gray-100">
              {selectedBook.chapter}
            </Text>
          </View>

          {/* VERSES */}
          {verses?.map(({ verse, text }) => (
            <View
              key={verse}
              className="mb-3"
              onLayout={(event) => {
                versePositions.current[Number(verse)] = event.nativeEvent.layout.y;
              }}>
              <TouchableOpacity
                onPress={() => {
                  if (!selectedVerse.some((item) => item.number === verse)) {
                    setSelectedVerse((prev) => [{ number: verse, text: text as string }, ...prev]);
                  } else {
                    setSelectedVerse((prev) => prev.filter((item) => item.number !== verse));
                  }
                }}
                onLongPress={(event) => {
                  const pageX = event?.nativeEvent?.pageX ?? screenWidth / 2;
                  const pageY = event?.nativeEvent?.pageY ?? screenHeight / 2;
                  if (!selectedVerse.some((item) => item.number === verse)) {
                    setSelectedVerse((prev) => [{ number: verse, text: text as string }, ...prev]);
                  }
                  setMenuAnchor({ x: pageX, y: pageY });
                  setShowMenu(true);
                }}
                className={`flex-row items-start rounded-md px-1 ${
                  selectedVerse.some((item) => item.number === verse)
                    ? 'bg-yellow-200 dark:bg-yellow-700'
                    : ''
                }`}>
                <Text className="text-verseNumber font-[400] mr-1 -mt-1 dark:text-gray-400">
                  {verse}
                </Text>

                <Text className="flex-1 text-[17px] leading-7 text-primary dark:text-gray-100 font-semibold  font-open-sans-regular indent-5">
                  {text as string}
                </Text>
              </TouchableOpacity>
            </View>
          ))}
        </Animated.ScrollView>

        <ReaderBottomBar
          leftAction={{
            icon: 'chevron-back',
            disabled: isFirstBibleChapter,
            onPress: () => {
              if (isFirstBibleChapter) return;

              if (chapterNumber === 1) {
                const previousBook =
                  currentBookIndex > 0 ? bible.books[currentBookIndex - 1] : null;
                if (previousBook) {
                  const lastChapterNumber = previousBook.chapters.length || 1;
                  setSelectedBook({ bookId: previousBook.id, chapter: lastChapterNumber });
                  setSelectedVerse([]);
                }
                return;
              }
              setSelectedBook({ bookId: currentBookId, chapter: chapterNumber - 1 });
              setSelectedVerse([]);
            },
          }}
          centerAction={{
            label: `${currentBookName} ${selectedBook.chapter}`,
            onPress: () => router.push(`/bible/${currentBookId}`),
          }}
          rightAction={{
            icon: 'chevron-forward',
            disabled: isLastBibleChapter,
            onPress: () => {
              if (isLastBibleChapter) return;

              if (chapterNumber === chapterCount) {
                const nextBook =
                  currentBookIndex >= 0 ? bible.books[currentBookIndex + 1] : undefined;
                if (nextBook) {
                  setSelectedBook({ bookId: nextBook.id, chapter: 1 });
                  setSelectedVerse([]);
                }
                return;
              }
              setSelectedBook({ bookId: currentBookId, chapter: chapterNumber + 1 });
              setSelectedVerse([]);
            },
          }}
        />
        <ScriptureSelectionMenu
          visible={showMenu}
          title={selectedVerse.length > 0 ? formatSelectedVerseTitle().header : ''}
          menuStyle={contextMenuStyle}
          notesDisabled={!selectedVerseRange}
          onClose={() => setShowMenu(false)}
          onRequestClose={() => {
            setSelectedVerse([]);
            setShowMenu(false);
          }}
          onMenuLayout={(event) => setMenuHeight(event.nativeEvent.layout.height)}
          onOpenNotes={() => {
            if (!selectedVerseRange) return;

            setShowMenu(false);
            router.push({
              pathname: '/scripture_notes',
              params: {
                bookId: currentBookId,
                book: currentBookName,
                chapter: String(chapterNumber),
                verseNumber: String(selectedVerseRange.start.number),
                verseText: selectedVerseRange.start.text,
                selectionStart: String(selectedVerseRange.start.number),
                selectionEnd: String(selectedVerseRange.end.number),
                selectionVerses: [...selectedVerse]
                  .sort((a, b) => a.number - b.number)
                  .map((entry) => entry.number)
                  .join(','),
                verseCount: String(verses?.length ?? 0),
                version,
              },
            } as never);
          }}
          onCopy={async () => {
            await Clipboard.setStringAsync(
              selectedVerse.length > 0 ? formatVerseText(selectedVerse) : '',
            );
            setShowMenu(false);
          }}
          onShare={async () => {
            const content = formatVerseText(selectedVerse);
            await Share.share({ message: content });
            setShowMenu(false);
          }}
        />
      </View>
    </>
  );
}
