import Ionicons from '@expo/vector-icons/Ionicons';
import * as Clipboard from 'expo-clipboard';
import { useRouter } from 'expo-router';
import { useEffect, useMemo, useRef, useState } from 'react';

import {
  DEFAULT_BOOK_ID,
  findBookInBible,
  getBibleDotComBookCode,
  getBookNameForId,
} from '@/src/bible/books';
import PlanCoverImage from '@/src/components/PlanCoverImage';
import ReaderBottomBar from '@/src/components/ReaderBottomBar';
import ScriptureSelectionMenu from '@/src/components/ScriptureSelectionMenu';
import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import type { SelectedBibleBook } from '@/src/state/useAppStore';
import { UseMutationResult } from '@tanstack/react-query';
import {
  Animated,
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
      item_id: string;
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

  const router = useRouter();
  const { bible, installedVersionIds, loadingVersionId, selectNextInstalledVersion, version } =
    useBible();
  const versePositions = useRef<Record<number, number>>({});
  const scrollRef = useRef<ScrollView | null>(null);
  const didScrollRef = useRef(false);

  const devotionalTitle =
    item?.title?.trim() || (item?.day_number ? `Day ${item.day_number}` : 'Devotional');
  const devotionalHtml = item?.devotional_content ?? '';
  const isDevotionalItem = item?.item_type === 'devotional' && item?.item_key === 'main';

  const itemSelectedBook = useMemo<SelectedBibleBook | null>(() => {
    if (item?.item_type !== 'scripture' || !item?.item_key) {
      return null;
    }

    const parsed = parseVerseRef(item.item_key);
    if (!parsed) {
      return null;
    }

    const matchingBook = findBookInBible(bible, parsed.book);
    if (!matchingBook) {
      return null;
    }

    return {
      bookId: matchingBook.id,
      chapter: parsed.chapter,
      verseStart: parsed.verseStart,
      verseEnd: parsed.verseEnd,
    };
  }, [bible, item?.item_key, item?.item_type]);

  const [selectedBook, setSelectedBook] = useState<SelectedBibleBook>(
    itemSelectedBook ?? { bookId: DEFAULT_BOOK_ID, chapter: 1 },
  );
  const hasUnavailableScriptureReference = item?.item_type === 'scripture' && !itemSelectedBook;

  const currentBook = useMemo(
    () => findBookInBible(bible, selectedBook.bookId) ?? bible.books[0],
    [bible, selectedBook.bookId],
  );
  const currentBookId = currentBook?.id ?? selectedBook.bookId;
  const currentBookName = currentBook?.name ?? getBookNameForId(bible, currentBookId);

  useEffect(() => {
    if (item?.item_type !== 'scripture') return;
    if (!itemSelectedBook) return;
    setSelectedBook(itemSelectedBook);
  }, [item?.id, item?.item_type, itemSelectedBook]);

  useEffect(() => {
    didScrollRef.current = false;
    versePositions.current = {};
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
  }, [selectedBook.bookId, selectedBook.chapter, selectedBook.verseStart]);

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
    ).map(({ verse, text }) => ({ number: Number(verse), text: text as string }));
  };

  const getSelectedVerseRange = () => {
    const selected = getSelectedVerses();
    if (selected.length === 0) return null;

    return {
      start: selected[0],
      end: selected[selected.length - 1],
    };
  };

  const formatVerseText = () => {
    const selected = getSelectedVerses();
    if (selected.length === 0) return '';

    const range = getSelectedRange();
    const header = `${currentBookName} ${selectedBook.chapter}:${range} ${version}`;
    const body = selected.map((v) => `[${v.number}] ${v.text}`).join('\n');

    // Official Bible.com link
    const link = `${process.env.EXPO_PUBLIC_BASE_URL}/bible/12/${getBibleDotComBookCode(
      currentBookId,
    )}.${selectedBook.chapter}.${range}.${version}`;

    return `${header}\n${body}\n${link}`;
  };

  const formatSelectedVerseTitle = () => {
    const range = getSelectedRange();
    if (!range) return { header: '', range: '' };
    const header = `${currentBookName} ${selectedBook.chapter}:${range} ${version}`;
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
  const verses = currentBook?.chapters.find((chapter) => chapter.chapter === chapterNumber)?.verses;
  const scriptureVerses = verses ?? [];
  const selectedVerseRange = getSelectedVerseRange();
  const showScriptureUnavailableFallback =
    item?.item_type === 'scripture' && (hasUnavailableScriptureReference || !verses);

  const contextMenuStyle = useMemo(() => {
    const menuWidth = 220;
    const horizontalMargin = 10;
    const verticalSpacing = 12;
    const estimatedHeight = menuHeight || 210;
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
              onPress={() => {
                if (installedVersionIds.length <= 1) {
                  router.push('/settings');
                  return;
                }

                void selectNextInstalledVersion();
              }}
              className="flex-row items-center bg-blue-100 px-3 py-1.5 rounded-full mr-1">
              <Ionicons name="globe-outline" size={16} />
              <Text className="ml-2 font-semibold">
                {loadingVersionId ? `${version}...` : version}
              </Text>
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
                {currentBookName}
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
                        bookId: currentBookId,
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
                          bookId: currentBookId,
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

        <ReaderBottomBar
          translateY={headerTranslateY || 0}
          bottom={0}
          paddingBottom={insets.bottom}
          barPaddingHorizontal={16}
          left={
            <TouchableOpacity
              className="py-1 mr-8"
              onPress={() => {
                HandlePrevious(item.id);
              }}>
              <Ionicons name="chevron-back" size={20} color="white" />
            </TouchableOpacity>
          }
          center={
            isDevotionalItem ? (
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
                onPress={() => router.push(`/bible/${currentBookId}`)}>
                <Text className="text-white font-semibold mx-4">
                  {`${currentBookName} ${selectedBook.chapter}`}
                </Text>
              </TouchableOpacity>
            )
          }
          right={
            last ? (
              <View className="ml-8">
                <TouchableOpacity
                  onPress={() =>
                    toggleItem.mutate(
                      {
                        item_id: item?.id || '',
                        item_type: item?.item_type as 'devotional' | 'scripture',
                        item_key: item?.item_key || '',
                        completed: true,
                      },
                      {
                        onSettled: async () => {
                          router.back();
                        },
                      },
                    )
                  }
                  className="rounded-full p-2 border border-white bg-green-500">
                  <Ionicons name="checkmark" size={12} color="white" />
                </TouchableOpacity>
              </View>
            ) : (
              <TouchableOpacity
                className="py-1 ml-8"
                onPress={() => {
                  toggleItem.mutate(
                    {
                      item_id: item?.id || '',
                      item_type: item?.item_type as 'devotional' | 'scripture',
                      item_key: item?.item_key || '',
                      completed: true,
                    },
                    {
                      onSettled: () => {
                        HandleNext(item.id);
                      },
                    },
                  );
                }}>
                <Ionicons name="chevron-forward" size={20} color="white" />
              </TouchableOpacity>
            )
          }
        />
        <ScriptureSelectionMenu
          visible={showMenu}
          title={formatSelectedVerseTitle().header || ' '}
          menuStyle={contextMenuStyle}
          notesDisabled={!selectedVerseRange}
          onClose={() => setShowMenu(false)}
          onMenuLayout={(event) => setMenuHeight(event.nativeEvent.layout.height)}
          onOpenNotes={() => {
            if (!selectedVerseRange) return;

            setShowMenu(false);
            router.push({
              pathname: '/scripture_notes',
              params: {
                bookId: currentBookId,
                book: currentBookName,
                chapter: String(chapterNumber),
                verseNumber: String(selectedVerseRange.start.number),
                verseText: selectedVerseRange.start.text,
                selectionStart: String(selectedVerseRange.start.number),
                selectionEnd: String(selectedVerseRange.end.number),
                selectionVerses: getSelectedVerses()
                  .map((entry) => entry.number)
                  .join(','),
                verseCount: String(verses?.length ?? 0),
                version,
              },
            } as never);
          }}
          onCopy={async () => {
            await Clipboard.setStringAsync(formatVerseText());
            setShowMenu(false);
          }}
          onShare={async () => {
            const content = formatVerseText();
            await Share.share({ message: content });
            setShowMenu(false);
          }}
        />
      </View>
    </>
  );
}
