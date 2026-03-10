import { BibleBook, useAppStore } from '@/src/state/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import * as Clipboard from 'expo-clipboard';
import { useRouter } from 'expo-router';
import { useEffect, useMemo, useRef, useState } from 'react';

import PlanCoverImage from '@/src/components/PlanCoverImage';
import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { UseMutationResult } from '@tanstack/react-query';
import {
  Animated,
  Modal,
  Pressable,
  ScrollView,
  Share,
  Text,
  TouchableOpacity,
  useColorScheme,
  useWindowDimensions,
  View,
} from 'react-native';
import RenderHTML from 'react-native-render-html';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useBible } from '../state/BibleContext';
import { DayItemsProgress } from '../types/types';
import { parseVerseRef } from '../utils';

export default function DevotionalPlanReader({
  onScroll,
  headerTranslateY,
  item,
  HandleNext,
  last,
  HandlePrevious,
  toggleItem,
}: {
  onScroll?: (...args: any[]) => void;
  last: boolean;
  headerTranslateY?: Animated.AnimatedInterpolation<string | number>;
  item: DayItemsProgress;
  HandleNext: (itemId: string) => void;
  HandlePrevious: (itemId: string) => void;
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
  const { width, height } = useWindowDimensions();
  const { data: plan } = useFetchDevotionalPlanById(item?.plan_id!);
  const [showMenu, setShowMenu] = useState(false);
  const [menuAnchor, setMenuAnchor] = useState({ x: 0, y: 0 });
  const [menuHeight, setMenuHeight] = useState(0);

  const storedSelectedBook = useAppStore((s) => s.selectedBook);
  const setSelectedBook = useAppStore((s) => s.setSelectedBook);

  const router = useRouter();
  const { bible, version, setVersion } = useBible();
  const versePositions = useRef<Record<number, number>>({});
  const scrollRef = useRef<ScrollView | null>(null);
  const didScrollRef = useRef(false);
  const syncedItemIdRef = useRef<string | null>(null);

  const devotionalTitle =
    item?.title?.trim() || (item?.day_number ? `Day ${item.day_number}` : 'Devotional');
  const devotionalHtml = item?.devotional_content ?? '';
  const isDevotionalItem = item?.item_type === 'devotional' && item?.item_key === 'main';

  const itemSelectedBook = useMemo<BibleBook | null>(() => {
    if (item?.item_type !== 'scripture' || !item?.item_key) {
      return null;
    }

    const parsed = parseVerseRef(item.item_key);
    if (!parsed) {
      return null;
    }

    return {
      name: parsed.book,
      chapter: parsed.chapter,
      verseStart: parsed.verseStart,
      verseEnd: parsed.verseEnd,
    };
  }, [item?.item_key, item?.item_type]);

  const selectedBook =
    itemSelectedBook && syncedItemIdRef.current !== item.id ? itemSelectedBook : storedSelectedBook;
  const hasUnavailableScriptureReference = item?.item_type === 'scripture' && !itemSelectedBook;

  useEffect(() => {
    if (item?.item_type !== 'scripture' || !itemSelectedBook) {
      syncedItemIdRef.current = item?.id ?? null;
      return;
    }

    syncedItemIdRef.current = item.id;
    setSelectedBook(itemSelectedBook);
  }, [item?.id, item?.item_type, itemSelectedBook, setSelectedBook]);

  useEffect(() => {
    didScrollRef.current = false;
    versePositions.current = {};
  }, [selectedBook.name, selectedBook.chapter]);

  useEffect(() => {
    didScrollRef.current = false;
  }, [item.id]);

  useEffect(() => {
    if (!selectedBook?.verseStart) return;
    if (!scrollRef.current) return;
    if (didScrollRef.current) return;

    let cancelled = false;
    let attempts = 0;
    const maxAttempts = 12;
    const tryScroll = () => {
      if (cancelled || didScrollRef.current) return;
      const y = versePositions.current[selectedBook.verseStart!];
      if (y != null) {
        didScrollRef.current = true;
        scrollRef.current?.scrollTo({
          y: Math.max(y - 140, 0), // header offset
          animated: true,
        });
        return;
      }
      if (attempts < maxAttempts) {
        attempts += 1;
        setTimeout(tryScroll, 50);
      }
    };

    // wait for layout pass
    setTimeout(tryScroll, 50);

    return () => {
      cancelled = true;
    };
  }, [selectedBook.name, selectedBook.chapter, selectedBook.verseStart]);

  const getSelectedRange = () => {
    if (!selectedBook?.verseStart) return '';
    const start = Number(selectedBook.verseStart);
    const end = Number(selectedBook.verseEnd ?? selectedBook.verseStart);
    return start === end ? `${start}` : `${start}-${end}`;
  };

  const getSelectedVerses = () => {
    if (!selectedBook?.verseStart) return [];
    const start = Number(selectedBook.verseStart);
    const end = Number(selectedBook.verseEnd ?? selectedBook.verseStart);
    return (
      verses?.filter(({ verse }) => {
        const num = Number(verse);
        return num >= start && num <= end;
      }) ?? []
    ).map(({ verse, text }) => ({ number: `${verse}`, text: text as string }));
  };

  const formatVerseText = () => {
    const selected = getSelectedVerses();
    if (selected.length === 0) return '';

    const range = getSelectedRange();
    const header = `${selectedBook.name} ${selectedBook.chapter}:${range} ${version}`;
    const body = selected.map((v) => `[${v.number}] ${v.text}`).join('\n');

    // Official Bible.com link
    const link = `${process.env.EXPO_PUBLIC_BASE_URL} ${selectedBook.name
      .toLowerCase()
      .slice(0, 3)}.${selectedBook.chapter}.${range}.${version}`;

    return `${header}\n${body}\n${link}`;
  };

  const formatSelectedVerseTitle = () => {
    const range = getSelectedRange();
    if (!range) return { header: '', range: '' };
    const header = `${selectedBook.name} ${selectedBook.chapter}:${range} ${version}`;
    return { header, range };
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
  const scriptureVerses = verses ?? [];
  const showScriptureUnavailableFallback =
    item?.item_type === 'scripture' && (hasUnavailableScriptureReference || !verses);

  const contextMenuStyle = useMemo(() => {
    const menuWidth = 220;
    const horizontalMargin = 10;
    const verticalSpacing = 12;
    const estimatedHeight = menuHeight || 170;
    const maxLeft = Math.max(horizontalMargin, width - menuWidth - horizontalMargin);
    const left = Math.min(Math.max(horizontalMargin, menuAnchor.x - menuWidth / 2), maxLeft);

    const preferBelow = menuAnchor.y + verticalSpacing + estimatedHeight <= height - insets.bottom;
    const top = preferBelow
      ? menuAnchor.y + verticalSpacing
      : Math.max(insets.top + 8, menuAnchor.y - estimatedHeight - verticalSpacing);

    return {
      top,
      left,
      width: menuWidth,
    };
  }, [height, insets.bottom, insets.top, menuAnchor.x, menuAnchor.y, menuHeight, width]);

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
            <PlanCoverImage
              uri={plan?.cover_image}
              className="w-12 h-12 ml-2 rounded-lg"
              placeholderClassName="w-10 h-10 ml-2 rounded-lg bg-gray-400 dark:bg-gray-700"
            />
          </View>

          {isDevotionalItem ? (
            <TouchableOpacity
              onPress={async () => {
                const content = `${plan?.title}: Day ${item?.day_number} · Devotional \n\n ${process.env.EXPO_PUBLIC_BASE_URL}/devotional_detail/${plan?.id}/${item?.day_id}/${item.id}`;
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

      <View className="flex-1 bg-white dark:bg-black" style={{ paddingBottom: insets.bottom }}>
        {isDevotionalItem ? (
          <Animated.ScrollView className="px-5 pt-28 pb-32">
            <View className="items-center mb-6">
              <Text className="text-center text-gray-500 dark:text-gray-400 text-xl font-OpenSansSemiBold">
                {devotionalTitle}
              </Text>
            </View>
            <RenderHTML
              contentWidth={Math.max(width - 40, 0)}
              source={{ html: devotionalHtml }}
              systemFonts={[
                'MerriWeather400Regular',
                'MerriWeather700Bold',
                'MerriWeather900Black',
                'OpenSansSemiBold',
              ]}
              enableCSSInlineProcessing
              classesStyles={{
                'text-left': { textAlign: 'left' },
                'text-center': { textAlign: 'center' },
                'text-right': { textAlign: 'right' },
                'text-justify': { textAlign: 'justify' },
                'align-left': { textAlign: 'left' },
                'align-center': { textAlign: 'center' },
                'align-right': { textAlign: 'right' },
                'align-justify': { textAlign: 'justify' },
              }}
              baseStyle={{
                color: colorScheme === 'dark' ? '#F3F4F6' : '#111827',
                fontSize: 19,
                lineHeight: 34,
                fontFamily: 'MerriWeather400Regular',
                paddingBottom: insets.bottom + 90,
              }}
              tagsStyles={{
                p: { marginBottom: 12 },
                a: {
                  color: colorScheme === 'dark' ? '#93C5FD' : '#2563EB',
                  textDecorationLine: 'underline',
                },
                strong: { fontFamily: 'MerriWeather700Bold', fontWeight: '700' },
                b: { fontFamily: 'MerriWeather700Bold', fontWeight: '700' },
                em: { fontStyle: 'italic' },
                i: { fontStyle: 'italic' },
                u: { textDecorationLine: 'underline' },
                s: { textDecorationLine: 'line-through' },
                del: { textDecorationLine: 'line-through' },
                blockquote: {
                  borderLeftWidth: 3,
                  borderLeftColor: colorScheme === 'dark' ? '#334155' : '#E5E7EB',
                  paddingLeft: 12,
                  marginVertical: 10,
                  color: colorScheme === 'dark' ? '#CBD5F5' : '#4B5563',
                },
                mark: {
                  backgroundColor: colorScheme === 'dark' ? '#374151' : '#FDE68A',
                  paddingHorizontal: 4,
                  borderRadius: 4,
                },
                ul: { paddingLeft: 18, marginBottom: 10 },
                ol: { paddingLeft: 18, marginBottom: 10 },
                h1: {
                  fontSize: 32,
                  lineHeight: 36,
                  marginBottom: 12,
                  fontFamily: 'MerriWeather900Black',
                  fontWeight: '900',
                },
                h2: {
                  fontSize: 28,
                  lineHeight: 30,
                  marginBottom: 10,
                  fontFamily: 'MerriWeather700Bold',
                },
                h3: {
                  fontSize: 24,
                  lineHeight: 30,
                  marginBottom: 10,
                  fontFamily: 'MerriWeather700Bold',
                  fontWeight: '900',
                },
                h4: {
                  fontSize: 20,
                  lineHeight: 30,
                  marginBottom: 10,
                  fontFamily: 'MerriWeather700Bold',
                  fontWeight: '900',
                },
                h5: {
                  fontSize: 16,
                  lineHeight: 30,
                  marginBottom: 10,
                  fontFamily: 'MerriWeather700Bold',
                  fontWeight: '900',
                },
                h6: {
                  fontSize: 12,
                  lineHeight: 30,
                  marginBottom: 10,
                  fontFamily: 'MerriWeather700Bold',
                  fontWeight: '900',
                },
                pre: {
                  backgroundColor: colorScheme === 'dark' ? '#0F172A' : '#F8FAFC',
                  padding: 12,
                  borderRadius: 8,
                  marginBottom: 12,
                },
                code: {
                  backgroundColor: colorScheme === 'dark' ? '#0F172A' : '#F8FAFC',
                  paddingHorizontal: 6,
                  paddingVertical: 2,
                  borderRadius: 6,
                  fontFamily: 'Courier',
                  fontSize: 16,
                },
                li: { marginBottom: 6 },
              }}
            />
          </Animated.ScrollView>
        ) : showScriptureUnavailableFallback ? (
          <View className="flex-1 items-center justify-center px-6">
            <Text className="text-center text-xl font-semibold text-gray-900 dark:text-white">
              Scripture reference unavailable
            </Text>
            <Text className="mt-3 text-center text-base text-gray-500 dark:text-gray-400">
              This reading item does not have a valid scripture reference.
            </Text>
          </View>
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

            {scriptureVerses.map(({ verse, text }) => {
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
                    onLongPress={(event) => {
                      const start = selectedBook.verseStart;
                      const end = selectedBook.verseEnd ?? selectedBook.verseStart;
                      const hasRange = start != null && end != null && end !== start;
                      const inRange =
                        start != null && end != null
                          ? verseNumber >= start && verseNumber <= end
                          : verseNumber === start;

                      if (!hasRange || !inRange) {
                        setSelectedBook({
                          name: selectedBook.name,
                          chapter: selectedBook.chapter,
                          verseStart: verseNumber,
                          verseEnd: verseNumber,
                        });
                      }
                      const pageX = event?.nativeEvent?.pageX ?? width / 2;
                      const pageY = event?.nativeEvent?.pageY ?? height / 2;
                      setMenuAnchor({ x: pageX, y: pageY });
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
            right: 0,
            paddingBottom: insets.bottom,
            zIndex: 10,
          }}>
          <View className="flex-row bg-black px-4 py-3 rounded-full items-center">
            <TouchableOpacity
              className="py-2 mr-8"
              onPress={() => {
                HandlePrevious(item.id);
              }}>
              <Ionicons name="chevron-back" size={20} color="white" />
            </TouchableOpacity>

            {isDevotionalItem ? (
              <TouchableOpacity className="px-2 py-1">
                <Text className="text-white font-semibold mx-4">Devotional</Text>
              </TouchableOpacity>
            ) : showScriptureUnavailableFallback ? (
              <TouchableOpacity disabled>
                <Text className="mx-4 font-semibold text-white/70">Scripture unavailable</Text>
              </TouchableOpacity>
            ) : (
              <TouchableOpacity
                className="px-2 py-1"
                onPress={() => router.push(`/bible/${selectedBook.name}`)}>
                <Text className="text-white font-semibold mx-4">
                  {`${selectedBook.name} ${selectedBook.chapter}`}
                </Text>
              </TouchableOpacity>
            )}

            {last ? (
              <View className="ml-8">
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
                          router.back();
                        },
                      },
                    )
                  }
                  className={`rounded-full p-2 border border-white ${'bg-green-500'}`}>
                  <Ionicons name="checkmark" size={12} color="white" />
                </TouchableOpacity>
              </View>
            ) : (
              <TouchableOpacity
                className="py-2 ml-8"
                onPress={() => {
                  toggleItem.mutate(
                    {
                      item_type: item?.item_type as 'devotional' | 'scripture',
                      item_key: item?.item_key || '',
                      completed: true,
                    },
                    {
                      onSuccess: () => {
                        HandleNext(item.id);
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
                  {formatSelectedVerseTitle().header || ' '}
                </Text>

                <TouchableOpacity
                  className="px-4 py-3 flex-row items-center"
                  onPress={async () => {
                    await Clipboard.setStringAsync(formatVerseText());
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
                    const content = formatVerseText();
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
