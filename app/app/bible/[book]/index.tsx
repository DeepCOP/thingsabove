import { useAppStore } from '@/src/state/useAppStore';
import Ionicons from '@expo/vector-icons/Ionicons';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect, useState } from 'react';
import { ActivityIndicator, ScrollView, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useBible } from '@/src/state/BibleContext';

export default function BibleBooksChapters() {
  const router = useRouter();
  const params = useLocalSearchParams<{
    book?: string | string[];
  }>();
  const routeBookId = Array.isArray(params.book) ? params.book[0] : params.book;
  const { books, loadingVersionId, readerError, retryReader } = useBible();
  const setSelectedBook = useAppStore((s) => s.setSelectedBook);
  const selectedBookId = useAppStore((s) => s.selectedBook.bookId);

  const [expandedBook, setExpandedBook] = useState<string | null>(routeBookId ?? selectedBookId);
  const insets = useSafeAreaInsets();

  useEffect(() => {
    setExpandedBook(routeBookId ?? selectedBookId);
  }, [routeBookId, selectedBookId]);

  const toggleBook = (bookId: string) => {
    setExpandedBook((prev) => (prev === bookId ? null : bookId));
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
        {books.length === 0 && loadingVersionId ? (
          <ActivityIndicator accessibilityLabel="Loading books" className="my-6" />
        ) : readerError ? (
          <View className="items-center gap-3 py-6">
            <Text className="text-center text-gray-500 dark:text-gray-400">{readerError}</Text>
            <TouchableOpacity onPress={retryReader}>
              <Text className="font-semibold text-blue-600 dark:text-blue-400">Try again</Text>
            </TouchableOpacity>
          </View>
        ) : null}
        {books.map((book) => {
          const isOpen = expandedBook === book.id;

          return (
            <View key={book.id} className="mb-3">
              {/* BOOK HEADER */}
              <TouchableOpacity
                onPress={() => toggleBook(book.id)}
                className="flex-row justify-between items-center bg-gray-100 dark:bg-neutral-900 px-4 py-3 rounded-lg">
                <Text className="text-lg font-semibold text-gray-900 dark:text-gray-200">
                  {book.name}
                </Text>

                <Ionicons name={isOpen ? 'chevron-up' : 'chevron-down'} size={22} color="#6b7280" />
              </TouchableOpacity>

              {/* CHAPTER LIST */}
              {isOpen && (
                <View className="flex-row flex-wrap px-3 py-3">
                  {book.chapters.map((ch) => (
                    <TouchableOpacity
                      key={ch}
                      onPress={() => {
                        const nextSelectedBook = { bookId: book.id, chapter: ch };

                        setSelectedBook(nextSelectedBook);
                        router.back();
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
