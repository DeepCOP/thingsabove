import { findBookInBible, getBibleDotComBookCode, getBookNameForId } from '@/src/bible/books';
import ReaderBottomBar from '@/src/components/ReaderBottomBar';
import BibleAttribution from '@/src/components/BibleAttribution';
import ScriptureSelectionMenu from '@/src/components/ScriptureSelectionMenu';
import { useBibleChapter } from '@/src/hooks/useBibleChapter';
import { getBibleVerseHighlightKey, useAppStore } from '@/src/state/useAppStore';
import * as Clipboard from 'expo-clipboard';
import { useRouter } from 'expo-router';
import { type SetStateAction, useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  ActivityIndicator,
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

type SelectedVerse = { number: number; text: string };

export default function BibleReaderView({ onScroll }: { onScroll: (...args: any[]) => void }) {
  const SCROLLvIEWBOTTOMPADDING = 80;
  const insets = useSafeAreaInsets();
  const [showMenu, setShowMenu] = useState(false);
  const [menuAnchor, setMenuAnchor] = useState({ x: 0, y: 0 });
  const [menuHeight, setMenuHeight] = useState(0);
  const scrollRef = useRef<ScrollView | null>(null);
  const versePositions = useRef<Record<number, number>>({});
  const didScrollRef = useRef(false);

  const selectedBook = useAppStore((s) => s.selectedBook);
  const setSelectedBook = useAppStore((s) => s.setSelectedBook);
  const bibleVerseHighlights = useAppStore((s) => s.bibleVerseHighlights);
  const toggleBibleVerseHighlights = useAppStore((s) => s.toggleBibleVerseHighlights);
  const { width: screenWidth, height: screenHeight } = useWindowDimensions();

  const router = useRouter();
  const { adapter, books, version, versionLabel, loadingVersionId, readerError, retryReader } =
    useBible();
  const contextMenuStyle = useMemo(() => {
    const menuWidth = 220;
    const horizontalMargin = 10;
    const verticalSpacing = 12;
    const estimatedHeight = menuHeight || 260;
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
    () => findBookInBible(books, selectedBook.bookId) ?? books[0],
    [books, selectedBook.bookId],
  );
  const currentBookId = currentBook?.id ?? selectedBook.bookId;
  const currentBookName = currentBook?.name ?? getBookNameForId(books, currentBookId);
  const currentBookIndex = currentBook ? books.findIndex((book) => book.id === currentBook.id) : -1;
  const chapterNumber = Number(selectedBook.chapter);
  const {
    chapter,
    loading: chapterLoading,
    error: chapterError,
    retry: retryChapter,
  } = useBibleChapter(currentBook?.id, chapterNumber);
  const selectionScope = useMemo(
    () => ({ adapter, bookId: currentBookId, chapterNumber }),
    [adapter, chapterNumber, currentBookId],
  );
  const [selection, setSelection] = useState<{
    scope: typeof selectionScope;
    verses: SelectedVerse[];
  }>({ scope: selectionScope, verses: [] });
  const selectedVerse = useMemo(
    () => (selection.scope === selectionScope ? selection.verses : []),
    [selection, selectionScope],
  );
  const setSelectedVerse = useCallback(
    (next: SetStateAction<SelectedVerse[]>) => {
      setSelection((previous) => {
        const previousVerses = previous.scope === selectionScope ? previous.verses : [];
        return {
          scope: selectionScope,
          verses: typeof next === 'function' ? next(previousVerses) : next,
        };
      });
    },
    [selectionScope],
  );

  useEffect(() => {
    setShowMenu(false);
    didScrollRef.current = false;
    versePositions.current = {};
    scrollRef.current?.scrollTo({ y: 0, animated: false });
  }, [selectionScope]);

  useEffect(() => {
    setShowMenu(false);
    didScrollRef.current = false;
  }, [selectedBook.verseEnd, selectedBook.verseStart]);

  useEffect(() => {
    if (!chapter || selectedBook.verseStart == null) {
      setSelectedVerse([]);
      return;
    }

    const endVerse = selectedBook.verseEnd ?? selectedBook.verseStart;
    const nextSelectedVerse = chapter.verses
      .filter((entry) => entry.verse >= selectedBook.verseStart! && entry.verse <= endVerse)
      .map((entry) => ({ number: entry.verse, text: entry.text }));

    setSelectedVerse(nextSelectedVerse);
  }, [chapter, selectedBook.verseEnd, selectedBook.verseStart, setSelectedVerse]);

  useEffect(() => {
    if (!chapter || selectedBook.verseStart == null) {
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
  }, [chapter, selectionScope, selectedBook.verseEnd, selectedBook.verseStart]);

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
    const link =
      bookCode && adapter.sourceId === 'offline'
        ? `${process.env.EXPO_PUBLIC_BASE_URL}/app/bible/12/${bookCode}.${selectedBook.chapter}.${ranges.join(',')}.${version}`
        : '';

    return [header, body, chapter?.copyright, chapter?.attributionUrl, link]
      .filter(Boolean)
      .join('\n');
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
    const header = `${currentBookName} ${selectedBook.chapter}:${ranges.join(',')} ${versionLabel}`;
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

  const selectedVerseReferences = useMemo(
    () =>
      selectedVerse.map(({ number }) => ({
        bookId: currentBookId,
        chapter: chapterNumber,
        verse: number,
      })),
    [chapterNumber, currentBookId, selectedVerse],
  );

  const areSelectedVersesHighlighted =
    selectedVerseReferences.length > 0 &&
    selectedVerseReferences.every(
      (reference) => bibleVerseHighlights[getBibleVerseHighlightKey(reference)],
    );

  const isVerseSelected = (verse: number) => selectedVerse.some((item) => item.number === verse);

  const isVerseHighlighted = (verse: number) =>
    Boolean(
      bibleVerseHighlights[
        getBibleVerseHighlightKey({
          bookId: currentBookId,
          chapter: chapterNumber,
          verse,
        })
      ],
    );

  const chapterIndex = currentBook?.chapters.indexOf(chapterNumber) ?? -1;
  const previousBook = books
    .slice(0, currentBookIndex)
    .reverse()
    .find((book) => book.chapters.length);
  const nextBook = books.slice(currentBookIndex + 1).find((book) => book.chapters.length);
  const previousChapter =
    currentBook && chapterIndex > 0
      ? { bookId: currentBook.id, chapter: currentBook.chapters[chapterIndex - 1] }
      : previousBook
        ? {
            bookId: previousBook.id,
            chapter: previousBook.chapters[previousBook.chapters.length - 1],
          }
        : null;
  const nextChapter =
    currentBook && chapterIndex >= 0 && chapterIndex < currentBook.chapters.length - 1
      ? { bookId: currentBook.id, chapter: currentBook.chapters[chapterIndex + 1] }
      : nextBook
        ? { bookId: nextBook.id, chapter: nextBook.chapters[0] }
        : null;
  const verses = chapter?.verses;
  const selectedVerseRange = getSelectedVerseRange();
  const hasBibleChapter = currentBookIndex >= 0 && chapterIndex >= 0;
  const loading = chapterLoading || (books.length === 0 && Boolean(loadingVersionId));
  const readingError = chapterError ?? readerError;

  return (
    <>
      <View className="flex-1 bg-white dark:bg-black">
        <Animated.ScrollView
          ref={scrollRef}
          scrollEventThrottle={16}
          onScroll={onScroll}
          className="px-5"
          contentContainerStyle={{ paddingBottom: insets.bottom + SCROLLvIEWBOTTOMPADDING }}>
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
          {loading ? (
            <ActivityIndicator accessibilityLabel="Loading chapter" className="my-6" />
          ) : readingError ? (
            <View className="items-center gap-3 py-6">
              <Text className="text-center text-gray-500 dark:text-gray-400">{readingError}</Text>
              <TouchableOpacity onPress={readerError ? retryReader : retryChapter}>
                <Text className="font-semibold text-blue-600 dark:text-blue-400">Try again</Text>
              </TouchableOpacity>
            </View>
          ) : !verses?.length ? (
            <Text className="py-6 text-center text-gray-500 dark:text-gray-400">
              This chapter is unavailable in this translation.
            </Text>
          ) : null}
          {verses?.map(({ verse, text }) => {
            const verseNumber = Number(verse);
            const selected = isVerseSelected(verseNumber);
            const highlighted = isVerseHighlighted(verseNumber);

            return (
              <View
                key={verse}
                className="mb-3"
                onLayout={(event) => {
                  versePositions.current[verseNumber] = event.nativeEvent.layout.y;
                }}>
                <TouchableOpacity
                  onPress={() => {
                    if (!selected) {
                      setSelectedVerse((prev) => [
                        { number: verseNumber, text: text as string },
                        ...prev,
                      ]);
                    } else {
                      setSelectedVerse((prev) =>
                        prev.filter((item) => item.number !== verseNumber),
                      );
                    }
                  }}
                  onLongPress={(event) => {
                    const pageX = event?.nativeEvent?.pageX ?? screenWidth / 2;
                    const pageY = event?.nativeEvent?.pageY ?? screenHeight / 2;
                    if (!selected) {
                      setSelectedVerse((prev) => [
                        { number: verseNumber, text: text as string },
                        ...prev,
                      ]);
                    }
                    setMenuAnchor({ x: pageX, y: pageY });
                    setShowMenu(true);
                  }}
                  className={`flex-row items-start rounded-md px-1 ${
                    selected
                      ? 'bg-yellow-200 dark:bg-yellow-700'
                      : highlighted
                        ? 'bg-yellow-100 dark:bg-yellow-800/40'
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
            );
          })}
          <BibleAttribution
            copyright={chapter?.copyright}
            attributionUrl={chapter?.attributionUrl}
          />
        </Animated.ScrollView>

        <ReaderBottomBar
          leftAction={{
            icon: 'chevron-back',
            disabled: !hasBibleChapter || !previousChapter,
            onPress: () => {
              if (!hasBibleChapter || !previousChapter) return;
              setSelectedBook(previousChapter);
              setSelectedVerse([]);
            },
          }}
          centerAction={{
            label: `${currentBookName} ${selectedBook.chapter}`,
            onPress: () => router.push(`/app/bible/${currentBookId}`),
          }}
          rightAction={{
            icon: 'chevron-forward',
            disabled: !hasBibleChapter || !nextChapter,
            onPress: () => {
              if (!hasBibleChapter || !nextChapter) return;
              setSelectedBook(nextChapter);
              setSelectedVerse([]);
            },
          }}
        />
        <ScriptureSelectionMenu
          visible={showMenu && selectedVerse.length > 0}
          title={selectedVerse.length > 0 ? formatSelectedVerseTitle().header : ''}
          menuStyle={contextMenuStyle}
          notesDisabled={!selectedVerseRange}
          highlightLabel={areSelectedVersesHighlighted ? 'Remove Highlight' : 'Highlight'}
          highlightDisabled={selectedVerseReferences.length === 0}
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
              pathname: '/app/scripture_notes',
              params: {
                bookId: currentBookId,
                book: currentBookName,
                chapter: String(chapterNumber),
                verseNumber: String(selectedVerseRange.start.number),
                verseText: [...selectedVerse]
                  .sort((a, b) => a.number - b.number)
                  .map((entry) => `[${entry.number}] ${entry.text}`)
                  .join(' '),
                selectionStart: String(selectedVerseRange.start.number),
                selectionEnd: String(selectedVerseRange.end.number),
                selectionVerses: [...selectedVerse]
                  .sort((a, b) => a.number - b.number)
                  .map((entry) => entry.number)
                  .join(','),
                verseCount: String(
                  adapter.sourceId !== 'offline'
                    ? Math.max(0, ...(verses ?? []).map((entry) => entry.verse))
                    : (verses?.length ?? 0),
                ),
                version,
                versionLabel,
                copyright: chapter?.copyright ?? '',
                attributionUrl: chapter?.attributionUrl ?? '',
              },
            } as never);
          }}
          onToggleHighlight={() => {
            toggleBibleVerseHighlights(selectedVerseReferences);
            setSelectedVerse([]);
            setShowMenu(false);
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
