import { useAppStore } from '@/store/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import { Stack, useRouter } from 'expo-router';
import { useState } from 'react';
import { ScrollView, Text, TouchableOpacity, View, useColorScheme } from 'react-native';
import { useBible } from '../../../context/BibleContext';

export default function BibleBooksChapters() {
  const colorScheme = useColorScheme();
  const router = useRouter();
  const { bible } = useBible();
  const setSelectedBook = useAppStore((s) => s.setSelectedBook);

  const [expandedBook, setExpandedBook] = useState<string | null>(null);

  const toggleBook = (bookName: string) => {
    if (expandedBook === bookName) {
      setExpandedBook(null); // collapse
    } else {
      setExpandedBook(bookName); // expand
    }
  };

  return (
    <>
      <Stack.Screen
        options={{
          title: 'References',
          headerShadowVisible: false,
          headerRight: () => (
            <View className="flex-row items-center">
              {/* Search */}
              <TouchableOpacity onPress={() => console.log('Search')} className="mr-4">
                <Ionicons name="search-outline"  color={colorScheme === 'dark' ? "white": "dark"} size={22} />
              </TouchableOpacity>
            </View>
          ),
        }}
      />
      <ScrollView className="flex-1 bg-white dark:bg-black px-4 py-4">
        {Object.entries(bible).map(([bookName, chapters], index) => {
          const chapterCount = Object.keys(chapters as string).length;
          const isOpen = expandedBook === bookName;

          return (
            <View key={bookName} className="mb-3">
              {/* BOOK HEADER */}
              <TouchableOpacity
                onPress={() => toggleBook(bookName)}
                className="flex-row justify-between items-center bg-gray-100 dark:bg-black px-4 py-3 rounded-lg">
                <Text className="text-lg font-semibold text-gray-900 dark:text-gray-200">{bookName}</Text>

                <Ionicons name={isOpen ? 'chevron-up' : 'chevron-down'} size={22} color="#333" />
              </TouchableOpacity>

              {/* CHAPTER LIST */}
              {isOpen && (
                <View className="flex-row flex-wrap px-3 py-3">
                  {Array.from({ length: chapterCount }, (_, i) => i + 1).map((ch) => (
                    <TouchableOpacity
                      key={ch}
                      onPress={() => {
                        setSelectedBook({ name: bookName, chapters: ch });
                        router.push(`/Bible`);
                      }}
                      className="bg-gray-200 dark:bg-gray-500 w-16 h-16 justify-center items-center text-center rounded-lg m-1">
                      <Text className="text-gray-700 dark:text-gray-100 font-semibold">{ch}</Text>
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
