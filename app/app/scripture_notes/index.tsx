import { findBookInBible, getCanonicalBookIdByName, getBookNameForId } from '@/src/bible/books';
import ScriptureNotesScreen from '@/src/screens/ScriptureNotesScreen';
import { useBibleChapter } from '@/src/hooks/useBibleChapter';
import {
  clearScriptureNotesChapter,
  getScriptureNotesChapter,
} from '@/src/lib/scriptureNotesChapterHandoff';
import { useBible } from '@/src/state/BibleContext';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect, useMemo, useState } from 'react';
import { ActivityIndicator, Text, TouchableOpacity, View } from 'react-native';

const getParam = (value: string | string[] | undefined) =>
  Array.isArray(value) ? value[0] : value;

export default function ScriptureNotes() {
  const router = useRouter();
  const params = useLocalSearchParams<{
    bookId?: string | string[];
    book?: string | string[];
    chapter?: string | string[];
    verseNumber?: string | string[];
    verseText?: string | string[];
    verseCount?: string | string[];
    version?: string | string[];
    versionLabel?: string | string[];
    copyright?: string | string[];
    attributionUrl?: string | string[];
    selectionStart?: string | string[];
    selectionEnd?: string | string[];
    selectionVerses?: string | string[];
  }>();
  const currentReader = useBible();
  // A note preview belongs to the source used when it was opened, even if the
  // active translation changes while this route remains mounted.
  const [reader] = useState(() => ({
    adapter: currentReader.adapter,
    books: currentReader.books,
    versionLabel: currentReader.versionLabel,
  }));

  const book = getParam(params.book) ?? '';
  const bookIdParam = getParam(params.bookId) ?? '';
  const chapter = Number(getParam(params.chapter) ?? 0);
  const verseNumberParam = Number(getParam(params.verseNumber) ?? 0);
  const selectionStartParam = Number(getParam(params.selectionStart) ?? verseNumberParam);
  const selectionEndParam = Number(getParam(params.selectionEnd) ?? selectionStartParam);
  const selectionVersesParam = getParam(params.selectionVerses) ?? '';
  const selectionVerses = useMemo(
    () =>
      selectionVersesParam
        .split(',')
        .map((entry) => Number(entry.trim()))
        .filter(
          (entry, index, arr) =>
            Number.isFinite(entry) && entry > 0 && arr.indexOf(entry) === index,
        )
        .sort((a, b) => a - b),
    [selectionVersesParam],
  );
  const selectionStart = selectionVerses[0] ?? Math.min(selectionStartParam, selectionEndParam);
  const selectionEnd =
    selectionVerses[selectionVerses.length - 1] ?? Math.max(selectionStartParam, selectionEndParam);
  const verseText = getParam(params.verseText) ?? '';
  const verseCount = Number(getParam(params.verseCount) ?? 0);
  const version = getParam(params.version) ?? reader.adapter.versionId;
  const verseNumber = selectionVerses[0] || selectionStart || verseNumberParam;
  const resolvedBook = useMemo(
    () => findBookInBible(reader.books, bookIdParam || book),
    [reader.books, book, bookIdParam],
  );
  const bookId = resolvedBook?.id ?? getCanonicalBookIdByName(bookIdParam || book) ?? '';
  const bookName = (resolvedBook?.name ?? getBookNameForId(reader.books, bookId)) || book;
  const handoffScope = useMemo(
    () => ({ adapter: reader.adapter, bookId, chapterNumber: chapter }),
    [bookId, chapter, reader.adapter],
  );
  const [handoffChapter] = useState(() => getScriptureNotesChapter(handoffScope));
  useEffect(() => {
    if (handoffChapter) clearScriptureNotesChapter(handoffScope);
  }, [handoffChapter, handoffScope]);
  const {
    chapter: fetchedChapter,
    loading: fetchLoading,
    error: fetchError,
    retry,
  } = useBibleChapter(bookId, chapter, {
    adapter: handoffScope.adapter,
    enabled: !handoffChapter && version === reader.adapter.versionId && selectionStart > 0,
  });
  const chapterData = handoffChapter ?? fetchedChapter;
  const loading = !handoffChapter && fetchLoading;
  const error = handoffChapter ? null : fetchError;

  const selectedText = useMemo(() => {
    if (!chapter || selectionStart <= 0 || !bookId) return verseText;
    const verses = chapterData?.verses ?? [];

    if (verses.length === 0) return verseText;

    const inRange = verses
      .filter((entry) =>
        selectionVerses.length > 0
          ? selectionVerses.includes(entry.verse)
          : entry.verse >= selectionStart && entry.verse <= selectionEnd,
      )
      .map((entry) => `[${entry.verse}] ${entry.text}`);

    return inRange.length > 0 ? inRange.join(' ') : verseText;
  }, [chapterData, bookId, chapter, selectionEnd, selectionStart, selectionVerses, verseText]);

  const verse =
    verseNumber > 0 && selectedText
      ? {
          number: verseNumber,
          text: selectedText,
        }
      : null;

  return (
    <>
      <Stack.Screen options={{ headerShown: false }} />
      {!selectedText && loading ? (
        <ActivityIndicator accessibilityLabel="Loading scripture" className="mt-16" />
      ) : !selectedText && error ? (
        <View className="items-center gap-3 px-6 pt-16">
          <Text className="text-center text-gray-500 dark:text-gray-400">{error}</Text>
          <TouchableOpacity onPress={retry}>
            <Text className="font-semibold text-blue-600 dark:text-blue-400">Try again</Text>
          </TouchableOpacity>
        </View>
      ) : null}
      <ScriptureNotesScreen
        onClose={() => router.back()}
        verse={verse}
        bookId={bookId}
        book={bookName}
        chapter={chapter}
        selectionStart={selectionStart}
        selectionEnd={selectionEnd}
        selectionVerses={selectionVerses}
        verseCount={verseCount || chapterData?.verses.length || 0}
        version={
          getParam(params.versionLabel) ??
          (reader.adapter.versionId === version ? reader.versionLabel : version)
        }
        copyright={chapterData?.copyright || getParam(params.copyright)}
        attributionUrl={chapterData?.attributionUrl || getParam(params.attributionUrl)}
      />
    </>
  );
}
