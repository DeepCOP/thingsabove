import { useAppStore } from '@/src/state/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import * as Clipboard from 'expo-clipboard';
import { useRouter } from 'expo-router';
import { useMemo, useState } from 'react';
import {
  Animated,
  Modal,
  Pressable,
  Share,
  Text,
  TouchableOpacity,
  useColorScheme,
  useWindowDimensions,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import ScriptureNotesModal from '../components/ScriptureNotesModal';
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
  const [showScriptureNotes, setShowScriptureNotes] = useState(false);
  const [notesVerse, setNotesVerse] = useState<{ number: number; text: string } | null>(null);

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

  const getPrimarySelectedVerse = () => {
    if (selectedVerse.length === 0) return null;
    return [...selectedVerse].sort((a, b) => a.number - b.number)[0];
  };
  const chapters = bible.books.find((book) => book.name === selectedBook.name)?.chapters;
  const chapterCount = chapters?.length || 0;

  const chapterNumber = Number(selectedBook.chapter);
  const verses = bible.books.find((book) => book.name === selectedBook.name)?.chapters[
    chapterNumber - 1
  ]?.verses;

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

        {/* BOTTOM CHAPTER NAVIGATION */}
        <Animated.View
          className="items-center pb-4 bg-transparent"
          style={{
            transform: [{ translateY: headerTranslateY }],
            position: 'absolute',
            bottom: 56 + insets.bottom,
            left: 0,
            right: 0,
            zIndex: 10,
          }}>
          <View className="flex-row bg-black px-6 py-3 rounded-full items-center">
            {/* PREVIOUS CHAPTER */}
            <TouchableOpacity
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

            {/* LABEL */}
            <TouchableOpacity onPress={() => router.push(`/bible/${selectedBook.name}`)}>
              <Text className="text-white font-semibold mx-4">
                {selectedBook.name} {selectedBook.chapter}
              </Text>
            </TouchableOpacity>

            {/* NEXT CHAPTER */}
            <TouchableOpacity
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
          </View>
        </Animated.View>
        <ScriptureNotesModal
          visible={showScriptureNotes}
          onClose={() => {
            setShowScriptureNotes(false);
            setNotesVerse(null);
            setSelectedVerse([]);
          }}
          verse={notesVerse}
          book={selectedBook.name}
          chapter={chapterNumber}
          verseCount={verses?.length ?? 0}
          version={version}
        />
        <Modal
          visible={showMenu}
          transparent
          animationType="fade"
          onRequestClose={() => {
            setSelectedVerse([]);
            setShowMenu(false);
          }}>
          <Pressable className="flex-1 bg-black/25" onPress={() => setShowMenu(false)}>
            <TouchableOpacity
              activeOpacity={1}
              onPress={() => {}}
              style={[{ position: 'absolute' }, contextMenuStyle]}>
              <View
                className="rounded-2xl border border-neutral-700/20 dark:border-neutral-700 bg-white dark:bg-neutral-900 overflow-hidden"
                onLayout={(event) => setMenuHeight(event.nativeEvent.layout.height)}>
                <Text className="px-4 pt-3 pb-2 text-sm font-semibold text-primary dark:text-gray-100">
                  {selectedVerse.length > 0 ? formatSelectedVerseTitle().header : ''}
                </Text>

                <TouchableOpacity
                  className="px-4 py-3 flex-row items-center"
                  disabled={selectedVerse.length === 0}
                  onPress={() => {
                    const target = getPrimarySelectedVerse();
                    if (!target) return;
                    setSelectedVerse([target]);
                    setNotesVerse(target);
                    setShowMenu(false);
                    setShowScriptureNotes(true);
                  }}>
                  <Ionicons
                    name="chatbubble-ellipses-outline"
                    size={22}
                    color={colorScheme === 'dark' ? 'white' : 'black'}
                  />
                  <Text className="ml-3 text-primary dark:text-gray-200 text-base">
                    Scripture Notes
                  </Text>
                </TouchableOpacity>

                <TouchableOpacity
                  className="px-4 py-3 flex-row items-center"
                  onPress={async () => {
                    await Clipboard.setStringAsync(
                      selectedVerse.length > 0 ? formatVerseText(selectedVerse) : '',
                    );
                    setShowMenu(false);
                  }}>
                  <Ionicons
                    name="copy"
                    size={22}
                    color={colorScheme === 'dark' ? 'white' : 'black'}
                  />
                  <Text className="ml-3 text-primary dark:text-gray-200 text-base">Copy</Text>
                </TouchableOpacity>

                <TouchableOpacity
                  className="px-4 py-3 flex-row items-center"
                  onPress={async () => {
                    const content = formatVerseText(selectedVerse);
                    await Share.share({ message: content });

                    setShowMenu(false);
                  }}>
                  <Ionicons
                    name="share-outline"
                    size={22}
                    color={colorScheme === 'dark' ? 'white' : 'black'}
                  />
                  <Text className="ml-3 text-primary dark:text-gray-200 text-base">Share</Text>
                </TouchableOpacity>

                <View className="border-t border-gray-200 dark:border-neutral-700" />

                <TouchableOpacity
                  className="px-4 py-3 flex-row items-center"
                  onPress={() => setShowMenu(false)}>
                  <Ionicons name="close-outline" size={22} color="#ef4444" />
                  <Text className="ml-3 text-red-600 text-base">Cancel</Text>
                </TouchableOpacity>
              </View>
            </TouchableOpacity>
          </Pressable>
        </Modal>
      </View>
    </>
  );
}
