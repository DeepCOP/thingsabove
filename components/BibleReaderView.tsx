import { useAppStore } from '@/store/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import * as Clipboard from 'expo-clipboard';
import { useRouter } from 'expo-router';
import { useState } from 'react';
import { Animated, Modal, Share, Text, TouchableOpacity, useColorScheme, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useBible } from '../context/BibleContext';

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

  const selectedBook = useAppStore((s) => s.selectedBook);
  const setSelectedBook = useAppStore((s) => s.setSelectedBook);

  const router = useRouter();
  const bibleContext = useBible();
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
    const link = `${process.env.EXPO_BASE_URL}/bible/12/${selectedBook.name
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
                  if (!selectedVerse.some((item) => item.text === text)) {
                    setSelectedVerse((prev) => [{ number: verse, text: text as string }, ...prev]);
                  } else {
                    setSelectedVerse((prev) => {
                      const current = prev.filter((item) => item.number !== verse);
                      return current;
                    });
                  }
                }}
                onLongPress={() => {
                  if (!selectedVerse.some((item) => item.number === verse)) {
                    setSelectedVerse((prev) => [{ number: verse, text: text as string }, ...prev]);
                  }
                  setShowMenu(true);
                }}
                className={`flex-row items-start rounded-md px-1 ${
                  selectedVerse.some((item) => item.text === text)
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
        <Modal
          visible={showMenu}
          transparent
          animationType="fade"
          onRequestClose={() => {
            setSelectedVerse([]);
            setShowMenu(false);
          }}
          className="absolute bottom-0 bg-white">
          <View className="bg-transparent absolute bottom-0 left-0 right-0 justify-end">
            <View className="bg-gray-100 dark:bg-neutral-900 p-6 rounded-t-2xl">
              <Text className="mb-4 text-lg font-bold dark:text-white">
                {selectedVerse.length > 0 ? formatSelectedVerseTitle().header : ''}
              </Text>

              {/* COPY */}
              <View className="flex-row gap-2 items-center justify-start p-1">
                <TouchableOpacity
                  className="py-3 flex items-center justify-center"
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
                  <Text className="text-primary dark:text-gray-200 text-lg">Copy</Text>
                </TouchableOpacity>

                {/* SHARE */}
                <TouchableOpacity
                  className="py-3 flex items-center justify-center"
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
                  <Text className="text-primary dark:text-gray-200 text-lg">Share</Text>
                </TouchableOpacity>
              </View>

              {/* CLOSE */}
              <TouchableOpacity className="py-3" onPress={() => setShowMenu(false)}>
                <Text className="text-red-600 text-lg text-center">Cancel</Text>
              </TouchableOpacity>
            </View>
          </View>
        </Modal>
      </View>
    </>
  );
}
