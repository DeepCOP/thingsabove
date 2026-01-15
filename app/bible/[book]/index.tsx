import { useAppStore } from '@/src/state/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import { Stack, useRouter } from 'expo-router';
import { useState } from 'react';
import { ScrollView, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useBible } from '../../../src/state/BibleContext';

export default function BibleBooksChapters() {
  const router = useRouter();
  const { bible, bookNames } = useBible();
  const setSelectedBook = useAppStore((s) => s.setSelectedBook);

  const [expandedBook, setExpandedBook] = useState<string | null>(null);
  const insets = useSafeAreaInsets();

  const toggleBook = (bookName: string) => {
    setExpandedBook((prev) => (prev === bookName ? null : bookName));
  };

  return (
    <>
      <Stack.Screen
        options={{
          title: 'References',
          headerShadowVisible: false,
        }}
      />

      <ScrollView
        className="flex-1 bg-white dark:bg-black px-4 py-4"
        style={{ marginBottom: insets.bottom + 5 }}>
        {bookNames.map((bookName) => {
          const chapters = bible.books.find((book) => book.name === bookName)?.chapters;
          if (!chapters) return null;

          const chapterCount = chapters.length;
          const isOpen = expandedBook === bookName;

          return (
            <View key={bookName} className="mb-3">
              {/* BOOK HEADER */}
              <TouchableOpacity
                onPress={() => toggleBook(bookName)}
                className="flex-row justify-between items-center bg-gray-100 dark:bg-neutral-900 px-4 py-3 rounded-lg">
                <Text className="text-lg font-semibold text-gray-900 dark:text-gray-200">
                  {bookName}
                </Text>

                <Ionicons name={isOpen ? 'chevron-up' : 'chevron-down'} size={22} color="#6b7280" />
              </TouchableOpacity>

              {/* CHAPTER LIST */}
              {isOpen && (
                <View className="flex-row flex-wrap px-3 py-3">
                  {Array.from({ length: chapterCount }, (_, i) => i + 1).map((ch) => (
                    <TouchableOpacity
                      key={ch}
                      onPress={() => {
                        setSelectedBook({ name: bookName, chapter: ch });
                        router.push('/BibleTab');
                      }}
                      className="bg-gray-200 dark:bg-gray-700 w-16 h-16 justify-center items-center rounded-lg m-1">
                      <Text className="text-gray-800 dark:text-gray-100 font-semibold">{ch}</Text>
                    </TouchableOpacity>
                  ))}
                </View>
              )}
            </View>
          );
        })}
      </ScrollView>
    </>
  );
}
