/* eslint-disable react-hooks/exhaustive-deps */
import { useAppStore } from '@/store/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import * as Clipboard from 'expo-clipboard';
import { useRouter } from 'expo-router';
import { useEffect, useRef, useState } from 'react';

import { useAuth } from '@/context/AuthContext';
import { useFetchDevotionalPlan } from '@/hooks/usePlans';
import { PlanProgress } from '@/types/types';
import { UseMutationResult, useQueryClient } from '@tanstack/react-query';
import {
  Animated,
  Image,
  Modal,
  ScrollView,
  Share,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useBible } from '../context/BibleContext';

export default function DevotionalPlanReader({
  onScroll,
  headerTranslateY,
  item,
  dayData,
  HandleNext,
  last,
  HandlePrevious,
  toggleItem,
}: {
  onScroll?: (...args: any[]) => void;
  last: boolean;
  headerTranslateY?: Animated.AnimatedInterpolation<string | number>;
  item: {
    completed: boolean | null;
    created_at: string | null;
    day_id: string | null;
    id: string;
    item_key: string | null;
    item_type: string | null;
    plan_id: string | null;
    updated_at: string | null;
    user_id: string | null;
  };
  dayData?:
    | {
        day_id: string | null;
        day_number: number | null;
        devotional_content: string | null;
        plan_id: string | null;
        scripture_refs: string[] | null;
      }
    | undefined;
  HandleNext: () => void;
  HandlePrevious: () => void;
  toggleItem: UseMutationResult<
    void,
    Error,
    {
      item_type: 'devotional' | 'scripture';
      item_key: string;
      completed: boolean;
    },
    unknown
  >;
}) {
  const insets = useSafeAreaInsets();
  const colorScheme = useColorScheme();
  const { data: plan } = useFetchDevotionalPlan(item?.plan_id!);
  const queryClient = useQueryClient();
  const { session } = useAuth();
  const [selectedVerse, setSelectedVerse] = useState<
    {
      number: string;
      text: string;
    }[]
  >([]);

  console.log(last);

  const [showMenu, setShowMenu] = useState(false);

  const selectedBook = useAppStore((s) => s.selectedBook);
  const setSelectedBook = useAppStore((s) => s.setSelectedBook);

  const router = useRouter();
  const { bible, version, setVersion } = useBible();
  const versePositions = useRef<Record<number, number>>({});
  const scrollRef = useRef<ScrollView | null>(null);
  const didScrollRef = useRef(false);

  useEffect(() => {
    console.log('selectedBook changed:', selectedBook);
    if (!selectedBook?.verseStart) return;
    if (!scrollRef.current) return;
    if (didScrollRef.current) return;

    const y = versePositions.current[selectedBook.verseStart];
    console.log('Verse position y:', y);
    if (y != null) {
      console.log('Scrolling to verse:', y);

      didScrollRef.current = true;

      // wait for layout pass
      setTimeout(() => {
        scrollRef.current?.scrollTo({
          y: Math.max(y - 140, 0), // header offset
          animated: true,
        });
      }, 50);
    }
  }, [selectedBook.verseStart, versePositions.current]);
  console.log('selectedBook:', selectedBook);
  useEffect(() => {
    didScrollRef.current = false;
    versePositions.current = {};
  }, [selectedBook.name, selectedBook.chapter]);

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
  const isVerseInRange = (verseNum: number) => {
    const { verseStart, verseEnd } = selectedBook;

    if (verseStart == null) return false;

    if (verseEnd == null) {
      return verseNum === verseStart;
    }

    return verseNum >= verseStart && verseNum <= verseEnd;
  };

  const chapterNumber = Number(selectedBook.chapter);
  const verses = bible.books
    .find((book) => book.name === selectedBook.name)
    ?.chapters.find((chapter) => chapter.chapter === chapterNumber)?.verses;

  if (!verses) return null;

  return (
    <>
      <View className="absolute top-0 left-0 right-0 z-20 px-4 pt-14 pb-3 bg-white dark:bg-black">
        <View className="flex-row items-center justify-between">
          <View className="flex-row items-center">
            <TouchableOpacity onPress={() => router.back()}>
              <Ionicons
                name="arrow-back"
                size={24}
                color={colorScheme === 'dark' ? '#fff' : '#000'}
              />
            </TouchableOpacity>
            {plan?.cover_image ? (
              <Image source={{ uri: plan?.cover_image }} className="w-12 h-12 ml-2 rounded-lg " />
            ) : (
              <View className="w-10 h-10 ml-2 rounded-full bg-gray-400 dark:bg-gray-700" />
            )}
          </View>

          {item?.item_type === 'devotional' && item?.item_key === 'main' ? (
            <TouchableOpacity
              onPress={async () => {
                const content = `${plan?.title}: Day ${dayData?.day_number} · Devotional \n\n ${process.env.EXPO_BASE_URL}/devotional_detail/${plan?.id}/${dayData?.day_id}/${item.id}`;
                await Share.share({ message: content });
              }}>
              <Ionicons
                name="share-social-outline"
                size={24}
                color={colorScheme === 'dark' ? '#fff' : '#111'}
              />
            </TouchableOpacity>
          ) : (
            <TouchableOpacity
              onPress={() => setVersion(version === 'KJV' ? 'ASV' : 'KJV')}
              className="flex-row items-center bg-blue-100 px-3 py-1.5 rounded-full mr-1">
              <Ionicons name="globe-outline" size={16} />
              <Text className="ml-2 font-semibold">{version}</Text>
            </TouchableOpacity>
          )}
        </View>
      </View>

      <View className="flex-1 bg-white dark:bg-black">
        {item?.item_type === 'devotional' && item?.item_key === 'main' ? (
          <Animated.ScrollView className="px-5 pt-28 pb-32">
            <Text className="text-[19px] leading-[34px] text-gray-900 dark:text-gray-100 font-MerriWeather400Regular">
              {dayData?.devotional_content}
            </Text>
          </Animated.ScrollView>
        ) : (
          <Animated.ScrollView
            scrollEventThrottle={16}
            onScroll={onScroll}
            ref={scrollRef}
            className="px-5 mb-20">
            <View className="justify-center items-center pb-16 gap-4">
              <Text className="text-center text-primary dark:text-gray-100 text-lg pt-28 font-MerriWeather300Light">
                {selectedBook.name}
              </Text>

              <Text className="text-center text-7xl  font-MerriWeather900Black text-gray-900 dark:text-gray-100">
                {selectedBook.chapter}
              </Text>
            </View>

            {verses.map(({ verse, text }) => {
              const verseNumber = Number(verse);
              const highlighted = isVerseInRange(verseNumber);

              return (
                <View
                  key={verse}
                  className="mb-3"
                  onLayout={(e) => {
                    versePositions.current[Number(verse)] = e.nativeEvent.layout.y;
                  }}>
                  <TouchableOpacity
                    onPress={() => {
                      setSelectedBook({
                        name: selectedBook.name,
                        chapter: selectedBook.chapter,
                        verseStart: verseNumber,
                        verseEnd: verseNumber,
                      });
                    }}
                    onLongPress={() => {
                      setShowMenu(true);
                    }}
                    className={`flex-row items-start rounded-md px-1 ${
                      highlighted ? 'bg-yellow-100 dark:bg-yellow-800/40' : ''
                    }`}>
                    <Text className="text-verseNumber mr-1 -mt-1 dark:text-gray-400">{verse}</Text>

                    <Text className="flex-1 text-[17px] leading-7 text-primary dark:text-gray-100 indent-5">
                      {text as string}
                    </Text>
                  </TouchableOpacity>
                </View>
              );
            })}
          </Animated.ScrollView>
        )}

        <Animated.View
          className="items-center pb-4 bg-transparent"
          style={{
            transform: [{ translateY: headerTranslateY || 0 }],
            position: 'absolute',
            bottom: 0,
            left: 0,
            paddingBottom: insets.bottom,
            right: 0,
            zIndex: 10,
          }}>
          <View className="flex-row bg-black px-6 py-3 rounded-full items-center">
            <TouchableOpacity
              disabled={chapterNumber === 1}
              onPress={() => {
                HandlePrevious();
                setSelectedVerse([]);
              }}>
              <Ionicons
                name="chevron-back"
                size={20}
                color="white"
                style={{ opacity: chapterNumber === 1 ? 0.3 : 1 }}
              />
            </TouchableOpacity>

            {item?.item_type === 'devotional' && item?.item_key === 'main' ? (
              <TouchableOpacity>
                <Text className="text-white font-semibold mx-4">Devotional</Text>
              </TouchableOpacity>
            ) : (
              <TouchableOpacity onPress={() => router.push(`/bible/${selectedBook.name}`)}>
                <Text className="text-white font-semibold mx-4">
                  {`${selectedBook.name} ${selectedBook.chapter}`}
                </Text>
              </TouchableOpacity>
            )}

            {last ? (
              <TouchableOpacity
                onPress={() =>
                  toggleItem.mutate(
                    {
                      item_type: item?.item_type as 'devotional' | 'scripture',
                      item_key: item?.item_key || '',
                      completed: true,
                    },
                    {
                      onSuccess: async () => {
                        setSelectedVerse([]);
                        const updated: PlanProgress = await queryClient.fetchQuery({
                          queryKey: ['plan_progress', plan?.id, session.user.id],
                        });
                        if (updated.completed_days?.length === plan?.total_days) {
                          router.replace(`/plan_progress/${plan?.id}/plan-complete`);
                          return;
                        }
                        router.back();
                      },
                    },
                  )
                }
                className={`rounded-full p-1 border mr-3 border-white ${'bg-green-500'}`}>
                <Ionicons name="checkmark" size={12} color="white" />
              </TouchableOpacity>
            ) : (
              <TouchableOpacity
                onPress={() => {
                  toggleItem.mutate(
                    {
                      item_type: item?.item_type as 'devotional' | 'scripture',
                      item_key: item?.item_key || '',
                      completed: true,
                    },
                    {
                      onSuccess: () => {
                        setSelectedVerse([]);
                        HandleNext();
                      },
                    },
                  );
                }}>
                <Ionicons name="chevron-forward" size={20} color="white" />
              </TouchableOpacity>
            )}
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
                {selectedVerse.length > 0 ? formatSelectedVerseTitle().header : ' '}
              </Text>

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
