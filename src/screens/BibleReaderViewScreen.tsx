import ReaderBottomBar from '@/src/components/ReaderBottomBar';
import ScriptureSelectionMenu from '@/src/components/ScriptureSelectionMenu';
import { useAppStore } from '@/src/state/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import * as Clipboard from 'expo-clipboard';
import { useRouter } from 'expo-router';
import { useMemo, useState } from 'react';
import {
  Animated,
  Share,
  Text,
  TouchableOpacity,
  useColorScheme,
  useWindowDimensions,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useBible } from '../state/BibleContext';

export default function BibleReaderView({
  onScroll,
  headerTranslateY,
}: {
  onScroll: (...args: any[]) => void;
  headerTranslateY: Animated.AnimatedInterpolation<string | number>;
}) {
  const colorScheme = useColorScheme();
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

  const selectedBook = useAppStore((s) => s.selectedBook);
  const setSelectedBook = useAppStore((s) => s.setSelectedBook);
  const { width: screenWidth, height: screenHeight } = useWindowDimensions();

  const router = useRouter();
  const bibleContext = useBible();
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

  if (!bibleContext) return null;
  const { bible, version, bookNames } = bibleContext;

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
    const link = `${process.env.EXPO_PUBLIC_BASE_URL}/bible/12/${selectedBook.name
      .toLowerCase()
      .slice(0, 3)}.${selectedBook.chapter}.${ranges.join(',')}.${version}`;

    return `${header}\n${body}\n${link}`;
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
    const header = `${selectedBook.name} ${selectedBook.chapter}:${ranges.join(',')} ${version}`;
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
  const chapters = bible.books.find((book) => book.name === selectedBook.name)?.chapters;
  const chapterCount = chapters?.length || 0;

  const chapterNumber = Number(selectedBook.chapter);
  const verses = bible.books.find((book) => book.name === selectedBook.name)?.chapters[
    chapterNumber - 1
  ]?.verses;
  const selectedVerseRange = getSelectedVerseRange();

  return (
    <>
      <View className="flex-1 bg-white dark:bg-black">
        <Animated.ScrollView
          scrollEventThrottle={16}
          onScroll={onScroll}
          className="px-5"
          style={{ marginBottom: insets.bottom + 80 }}>
          <View className="justify-center items-center pb-16 gap-4">
            <Text className="text-center text-primary dark:text-gray-100 text-lg pt-28 font-MerriWeather300Light">
              {selectedBook.name}
            </Text>

            {/* BIG CHAPTER NUMBER */}
            <Text className="text-center text-7xl  font-MerriWeather900Black text-gray-900 dark:text-gray-100">
              {selectedBook.chapter}
            </Text>
          </View>

          {/* VERSES */}
          {verses?.map(({ verse, text }) => (
            <View key={verse} className="mb-3">
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
          translateY={headerTranslateY}
          bottom={56 + insets.bottom}
          barPaddingHorizontal={24}
          left={
            <TouchableOpacity
              className="py-1 mr-8"
              onPress={() => {
                if (chapterNumber === 1) {
                  bookNames.forEach((bookName) => {
                    if (bookName === selectedBook.name) {
                      const currentBookIndex = bookNames.indexOf(selectedBook.name);
                      if (currentBookIndex === 0) return;
                      const prevBookName = bookNames[currentBookIndex - 1];
                      if (prevBookName) {
                        const prevChapters = bible.books.find(
                          (book) => book.name === prevBookName,
                        )?.chapters;
                        const lastChapterNumber = prevChapters?.length || 1;
                        setSelectedBook({ name: prevBookName, chapter: lastChapterNumber });
                        setSelectedVerse([]);
                      }
                    }
                  });
                  return;
                }
                setSelectedBook({ name: selectedBook.name, chapter: chapterNumber - 1 });
                setSelectedVerse([]);
              }}>
              <Ionicons name="chevron-back" size={20} color="white" />
            </TouchableOpacity>
          }
          center={
            <TouchableOpacity
              className="px-2 py-1"
              onPress={() => router.push(`/bible/${selectedBook.name}`)}>
              <Text className="text-white font-semibold mx-4">
                {selectedBook.name} {selectedBook.chapter}
              </Text>
            </TouchableOpacity>
          }
          right={
            <TouchableOpacity
              className="py-1 ml-8"
              onPress={() => {
                if (chapterNumber === chapterCount) {
                  bookNames.forEach((bookName) => {
                    if (bookName === selectedBook.name) {
                      const currentBookIndex = bookNames.indexOf(selectedBook.name);
                      const nextBookName = bookNames[currentBookIndex + 1];
                      if (nextBookName) {
                        setSelectedBook({ name: nextBookName, chapter: 1 });
                        setSelectedVerse([]);
                      }
                    }
                  });
                  return;
                }
                setSelectedBook({ name: selectedBook.name, chapter: chapterNumber + 1 });
                setSelectedVerse([]);
              }}>
              <Ionicons name="chevron-forward" size={20} color="white" />
            </TouchableOpacity>
          }
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
                book: selectedBook.name,
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
