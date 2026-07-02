import Ionicons from '@expo/vector-icons/Ionicons';
import * as Clipboard from 'expo-clipboard';
import { useRouter } from 'expo-router';
import { useEffect, useMemo, useRef, useState } from 'react';

import { findBookInBible, getBibleDotComBookCode, getBookNameForId } from '@/src/bible/books';
import PlanCoverImage from '@/src/components/PlanCoverImage';
import ReaderBottomBar from '@/src/components/ReaderBottomBar';
import ScriptureSelectionMenu from '@/src/components/ScriptureSelectionMenu';
import { useFetchDevotionalPlanById } from '@/src/hooks/useDevotionalPlans';
import { useAppStore, type SelectedBibleBook } from '@/src/state/useAppStore';
import { UseMutationResult } from '@tanstack/react-query';
import {
  ActivityIndicator,
  Animated,
  ScrollView,
  Linking,
  Share,
  Text,
  TouchableOpacity,
  useColorScheme,
  useWindowDimensions,
  View,
} from 'react-native';
import { WebView } from 'react-native-webview';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useBible } from '../state/BibleContext';
import { DayItemsProgress, DayItemType } from '../types/types';
import { parseVerseRef } from '../utils';

const escapeHtml = (value: string) =>
  value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');

export default function DevotionalPlanReader({
  headerTranslateY,
  item,
  HandleNext,
  first,
  last,
  HandlePrevious,
  toggleItem,
  onReflectAndShare,
}: {
  first: boolean;
  last: boolean;
  headerTranslateY?: Animated.AnimatedInterpolation<string | number>;
  item: DayItemsProgress;
  HandleNext: (itemId: string) => void;
  HandlePrevious: (itemId: string) => void;
  onReflectAndShare?: () => void;
  toggleItem: UseMutationResult<
    void,
    Error,
    {
      item_id: string;
      item_type: DayItemType;
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
  const selectedBook = useAppStore((s) => s.selectedBook);
  const setSelectedBook = useAppStore((s) => s.setSelectedBook);
  const { bible, loadingVersionId, version } = useBible();
  const versePositions = useRef<Record<number, number>>({});
  const scrollRef = useRef<ScrollView | null>(null);
  const didScrollRef = useRef(false);

  const devotionalTitle =
    item?.title?.trim() || (item?.day_number ? `Day ${item.day_number}` : 'Devotional');
  const devotionalHtml = item?.devotional_content ?? '';
  const devotionalDocument = useMemo(() => {
    const isDark = colorScheme === 'dark';

    return `<!doctype html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <style>
      :root {
        color-scheme: ${isDark ? 'dark' : 'light'};
      }

      html,
      body {
        margin: 0;
        padding: 0;
        background: ${isDark ? '#000000' : '#ffffff'};
        color: ${isDark ? '#F3F4F6' : '#111827'};
        font-family: MerriWeather400Regular, Georgia, serif;
        font-size: 19px;
        line-height: 34px;
        -webkit-touch-callout: default;
        -webkit-user-select: text;
        user-select: text;
      }

      body {
        box-sizing: border-box;
        min-height: 100vh;
        padding: 112px 20px ${insets.bottom + 110}px;
      }

      * {
        box-sizing: border-box;
        -webkit-user-select: text;
        user-select: text;
      }

      .devotional-title {
        margin: 0 0 24px;
        text-align: center;
        color: ${isDark ? '#9CA3AF' : '#6B7280'};
        font-family: OpenSansSemiBold, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        font-size: 20px;
        font-weight: 600;
        line-height: 30px;
      }

      p { margin: 0 0 12px; }
      a {
        color: ${isDark ? '#93C5FD' : '#2563EB'};
        text-decoration: underline;
      }
      strong, b {
        font-family: MerriWeather700Bold, Georgia, serif;
        font-weight: 700;
      }
      em, i { font-style: italic; }
      u { text-decoration: underline; }
      s, del { text-decoration: line-through; }
      blockquote {
        border-left: 3px solid ${isDark ? '#334155' : '#E5E7EB'};
        margin: 10px 0;
        padding-left: 12px;
        color: ${isDark ? '#CBD5F5' : '#4B5563'};
      }
      mark {
        background: ${isDark ? '#374151' : '#FDE68A'};
        border-radius: 4px;
        padding: 0 4px;
      }
      ul, ol {
        margin: 0 0 10px;
        padding-left: 18px;
      }
      li { margin-bottom: 6px; }
      h1, h2, h3, h4, h5, h6 {
        font-family: MerriWeather700Bold, Georgia, serif;
        font-weight: 900;
      }
      h1 {
        font-size: 32px;
        line-height: 36px;
        margin: 0 0 12px;
      }
      h2 {
        font-size: 28px;
        line-height: 30px;
        margin: 0 0 10px;
      }
      h3 {
        font-size: 24px;
        line-height: 30px;
        margin: 0 0 10px;
      }
      h4 {
        font-size: 20px;
        line-height: 30px;
        margin: 0 0 10px;
      }
      h5 {
        font-size: 16px;
        line-height: 30px;
        margin: 0 0 10px;
      }
      h6 {
        font-size: 12px;
        line-height: 30px;
        margin: 0 0 10px;
      }
      pre {
        background: ${isDark ? '#0F172A' : '#F8FAFC'};
        border-radius: 8px;
        margin: 0 0 12px;
        padding: 12px;
        white-space: pre-wrap;
      }
      code {
        background: ${isDark ? '#0F172A' : '#F8FAFC'};
        border-radius: 6px;
        font-family: Courier, monospace;
        font-size: 16px;
        padding: 2px 6px;
      }

      .text-left,
      .align-left { text-align: left; }
      .text-center,
      .align-center { text-align: center; }
      .text-right,
      .align-right { text-align: right; }
      .text-justify,
      .align-justify { text-align: justify; }
    </style>
  </head>
  <body>
    <h1 class="devotional-title">${escapeHtml(devotionalTitle)}</h1>
    ${devotionalHtml}
  </body>
</html>`;
  }, [colorScheme, devotionalHtml, devotionalTitle, insets.bottom]);
  const isDevotionalItem = item?.item_type === 'devotional' && item?.item_key === 'main';
  const parsedReference = useMemo(() => {
    if (item?.item_type !== 'scripture' || !item?.item_key) {
      return null;
    }

    return parseVerseRef(item.item_key);
  }, [item?.item_key, item?.item_type]);

  const itemSelectedBook = useMemo<SelectedBibleBook | null>(() => {
    if (!parsedReference) {
      return null;
    }

    const matchedBook = findBookInBible(bible, parsedReference.book);
    if (!matchedBook) {
      return null;
    }

    const chapter = parsedReference.chapter ?? 1;
    if (parsedReference.scope === 'chapter') {
      const chapterVerses =
        matchedBook.chapters.find((entry) => entry.chapter === chapter)?.verses ?? [];
      const firstVerse = chapterVerses[0]?.verse;
      const lastVerse = chapterVerses[chapterVerses.length - 1]?.verse;

      return {
        bookId: matchedBook.id,
        chapter,
        verseStart: firstVerse,
        verseEnd: lastVerse,
      };
    }

    return {
      bookId: matchedBook.id,
      chapter,
      verseStart: parsedReference.verseStart,
      verseEnd: parsedReference.verseEnd,
    };
  }, [bible, parsedReference]);

  const hasUnavailableScriptureReference = item?.item_type === 'scripture' && !itemSelectedBook;

  const currentBook = useMemo(
    () => findBookInBible(bible, selectedBook.bookId) ?? bible.books[0],
    [bible, selectedBook.bookId],
  );
  const currentBookId = currentBook?.id ?? selectedBook.bookId;
  const currentBookName = currentBook?.name ?? getBookNameForId(bible, currentBookId);
  const isWholeBookReference = parsedReference?.scope === 'book';

  useEffect(() => {
    if (item?.item_type !== 'scripture') return;
    if (!itemSelectedBook) return;
    setSelectedBook(itemSelectedBook);
  }, [item?.id, item?.item_type, itemSelectedBook, setSelectedBook]);

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
  }, [selectedBook.bookId, selectedBook.chapter, selectedBook.verseStart, item.id]);

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
    const bookCode = getBibleDotComBookCode(currentBookId);
    const link = bookCode
      ? `${process.env.EXPO_PUBLIC_BASE_URL}/app/bible/12/${bookCode}.${selectedBook.chapter}.${range}.${version}`
      : '';

    return link ? `${header}\n${body}\n${link}` : `${header}\n${body}`;
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
  const chapterCount = currentBook?.chapters.length ?? 0;
  const verses = currentBook?.chapters.find((chapter) => chapter.chapter === chapterNumber)?.verses;
  const scriptureVerses = verses ?? [];
  const selectedVerseRange = getSelectedVerseRange();
  const showScriptureUnavailableFallback =
    item?.item_type === 'scripture' && (hasUnavailableScriptureReference || !verses);
  const canGoToPreviousBookChapter = isWholeBookReference && chapterNumber > 1;
  const canGoToNextBookChapter = isWholeBookReference && chapterNumber < chapterCount;
  const canGoBack = canGoToPreviousBookChapter || !first;

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

          {!isDevotionalItem && (
            <TouchableOpacity
              onPress={() => router.push('/app/bible/versions')}
              disabled={Boolean(loadingVersionId)}
              style={{ opacity: loadingVersionId ? 0.7 : 1 }}
              className="flex-row items-center bg-blue-100 px-3 py-1.5 rounded-full mr-1">
              <Ionicons name="globe-outline" size={16} />
              {loadingVersionId ? (
                <ActivityIndicator size="small" className="ml-2" />
              ) : (
                <>
                  <Text className="ml-2 font-semibold">{version}</Text>
                  <Ionicons
                    name="chevron-forward"
                    size={14}
                    color="#1f2937"
                    style={{ marginLeft: 4 }}
                  />
                </>
              )}
            </TouchableOpacity>
          )}
        </View>
      </View>

      <View className="flex-1 bg-white dark:bg-black" style={{ paddingBottom: insets.bottom }}>
        {isDevotionalItem ? (
          <WebView
            originWhitelist={['*']}
            source={{ html: devotionalDocument }}
            style={{ flex: 1, backgroundColor: colorScheme === 'dark' ? '#000' : '#fff' }}
            textZoom={100}
            setSupportMultipleWindows={false}
            onShouldStartLoadWithRequest={(request) => {
              const url = request.url;
              const isInlineDocument = !url || url === 'about:blank' || url.startsWith('about:');

              if (isInlineDocument) {
                return true;
              }

              Linking.openURL(url).catch(() => undefined);
              return false;
            }}
          />
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
          <Animated.ScrollView scrollEventThrottle={16} ref={scrollRef} className="px-5 mb-20">
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

                    <Text
                      selectable
                      className="flex-1 text-[17px] leading-7 text-primary dark:text-gray-100 indent-5">
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
          leftAction={{
            icon: 'chevron-back',
            disabled: !canGoBack,
            onPress: () => {
              if (!canGoBack) return;

              if (canGoToPreviousBookChapter) {
                setSelectedBook({
                  bookId: currentBookId,
                  chapter: chapterNumber - 1,
                });
                return;
              }

              HandlePrevious(item.id);
            },
          }}
          centerAction={
            isDevotionalItem
              ? {
                  label: 'Devotional',
                }
              : showScriptureUnavailableFallback
                ? {
                    label: 'Scripture unavailable',
                    muted: true,
                  }
                : {
                    label: `${currentBookName} ${selectedBook.chapter}`,
                    onPress: () =>
                      router.push({
                        pathname: '/app/bible/[book]',
                        params: {
                          book: currentBookId,
                        },
                      }),
                  }
          }
          rightAction={
            canGoToNextBookChapter
              ? {
                  icon: 'chevron-forward',
                  onPress: () => {
                    setSelectedBook({
                      bookId: currentBookId,
                      chapter: chapterNumber + 1,
                    });
                  },
                }
              : last
                ? {
                    icon: onReflectAndShare ? 'chevron-forward' : 'checkmark',
                    variant: onReflectAndShare ? 'default' : 'complete',
                    onPress: () => {
                      toggleItem.mutate({
                        item_id: item?.id || '',
                        item_type: item?.item_type as DayItemType,
                        item_key: item?.item_key || '',
                        completed: true,
                      });
                      if (onReflectAndShare) {
                        onReflectAndShare();
                        return;
                      }

                      router.back();
                    },
                  }
                : {
                    icon: 'chevron-forward',
                    onPress: () => {
                      toggleItem.mutate({
                        item_id: item?.id || '',
                        item_type: item?.item_type as DayItemType,
                        item_key: item?.item_key || '',
                        completed: true,
                      });
                      HandleNext(item.id);
                    },
                  }
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
              pathname: '/app/scripture_notes',
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
