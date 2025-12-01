import { useAppStore } from '@/store/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import * as Clipboard from 'expo-clipboard';
import { useRouter } from 'expo-router';
import { useState } from 'react';


import { Animated, Modal, Share, Text, TouchableOpacity, useColorScheme, View } from 'react-native';
import { useBible } from '../context/BibleContext';
export default function VersesScreen({
  onScroll,
  headerTranslateY,
}: {
  onScroll: (...args: any[]) => void;
  headerTranslateY: Animated.AnimatedInterpolation<string | number>;
}) {
  const colorScheme = useColorScheme();

  const [selectedVerse, setSelectedVerse] = useState<
    {
      number: string;
      text: string;
    }[]
  >([]);

  const [showMenu, setShowMenu] = useState(false);

  const selectedBook = useAppStore((s) => s.selectedBook);
  const setSelectedBook = useAppStore((s) => s.setSelectedBook);

  const router = useRouter();
  const { bible, version } = useBible();

  const formatVerseText = (verses: { number: string; text: string }[]) => {
    if (verses.length === 0) return '';

    const { header, ranges, sorted } = formatSelectedVerseTitle();

    // Each verse on its own line
    let body = '';
    for (let v of ranges) {
      const range = v.split('-');

      for (let i = Number(range[0]); i <= Number(range[range.length - 1]); i++) {
        const verse = sorted.find((v) => v.number === i.toString());
        if (!verse) continue;
        body += `[${verse.number}] ${verse.text}`;
      }
      body += '\n';
    }

    // Official Bible.com link
    const link = `https://bible.com/bible/12/${selectedBook.name
      .toLowerCase()
      .slice(0, 3)}.${selectedBook.chapters}.${ranges.join(',')}.ASV`;

    return `${header}\n${body}\n${link}`;
  };

  const formatSelectedVerseTitle = () => {
    if (selectedVerse.length === 0) return { header: '', ranges: [], sorted: [] };

    // Sort verses numerically
    const sorted = selectedVerse.sort((a, b) => Number(a.number) - Number(b.number));

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
    const header = `${selectedBook.name} ${selectedBook.chapters}:${ranges.join(',')} ${version}`;
    return { header, ranges, sorted };
  };

  const chapterNumber = Number(selectedBook.chapters);
  const verses = bible[selectedBook.name as string][selectedBook?.chapters.toString()];

  // Optional: Section titles (if your KJV JSON includes them)
  const sectionTitle = verses['title']; // Adjust if your JSON uses another key

  return (
    <>
      <View className="flex-1 bg-white dark:bg-black">
        <Animated.ScrollView onScroll={onScroll} className="px-5 mb-20">
          <View className="justify-center items-center pb-16 gap-4">
            <Text className="text-center text-primary dark:text-gray-100 text-lg pt-28 font-MerriWeather300Light">
              {selectedBook.name}
            </Text>

            {/* BIG CHAPTER NUMBER */}
            <Text className="text-center text-7xl  font-MerriWeather900Black text-gray-900 dark:text-gray-100">
              {selectedBook.chapters}
            </Text>
          </View>

          {/* BOOK NAME UNDER CHAPTER NUMBER */}

          {/* SECTION TITLE (IF AVAILABLE) */}
          {sectionTitle && (
            <Text className="text-xl font-bold text-gray-900 dark:text-gray-100 mb-4">
              {sectionTitle}
            </Text>
          )}

          {/* VERSES */}
          {Object.entries(verses)
            .filter(([key]) => key !== 'title') // skip title key
            .map(([num, text]) => (
              <View key={num} className="mb-3">
                <TouchableOpacity
                  onPress={() => {
                    if (!selectedVerse.some((item) => item.text === text)) {
                      setSelectedVerse((prev) => [{ number: num, text: text as string }, ...prev]);
                      // setShowMenu(true);
                    } else {
                      setSelectedVerse((prev) => {
                        const current = prev.filter((item) => item.number !== num);
                        return current;
                      });
                    }
                  }}
                  onLongPress={() => {
                    if (!selectedVerse.some((item) => item.text === text)) {
                      setSelectedVerse((prev) => [{ number: num, text: text as string }, ...prev]);
                    }
                    setShowMenu(true);
                  }}
                  className={`flex-row items-start rounded-md px-1 ${
                    selectedVerse.some((item) => item.text === text)
                      ? 'bg-yellow-200 dark:bg-yellow-700'
                      : ''
                  }`}>
                  <Text className="text-verseNumber font-[400] mr-1 -mt-1 dark:text-gray-400">
                    {num}
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
            bottom: 80,
            left: 0,
            right: 0,
            zIndex: 10,
          }}>
          <View className="flex-row bg-black px-6 py-3 rounded-full items-center">
            {/* PREVIOUS CHAPTER */}
            <TouchableOpacity
              disabled={chapterNumber === 1}
              onPress={() => {
                setSelectedBook({ name: selectedBook.name, chapters: chapterNumber - 1 });
                setSelectedVerse([]);
              }}>
              <Ionicons
                name="chevron-back"
                size={20}
                color="white"
                style={{ opacity: chapterNumber === 1 ? 0.3 : 1 }}
              />
            </TouchableOpacity>

            {/* LABEL */}
            <TouchableOpacity onPress={() => router.push(`/bible/${selectedBook.name}`)}>
              <Text className="text-white font-semibold mx-4">
                {selectedBook.name} {selectedBook.chapters}
              </Text>
            </TouchableOpacity>

            {/* NEXT CHAPTER */}
            <TouchableOpacity
              onPress={() => {
                setSelectedBook({ name: selectedBook.name, chapters: chapterNumber + 1 });
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
