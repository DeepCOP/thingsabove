import { findBookInBible, getCanonicalBookIdByName, getBookNameForId } from '@/src/bible/books';
import ScriptureNotesScreen from '@/src/screens/ScriptureNotesScreen';
import { useBible } from '@/src/state/BibleContext';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { useMemo } from 'react';

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
    selectionStart?: string | string[];
    selectionEnd?: string | string[];
    selectionVerses?: string | string[];
  }>();
  const bible = useBible();

  const book = getParam(params.book) ?? '';
  const bookIdParam = getParam(params.bookId) ?? '';
  const chapter = Number(getParam(params.chapter) ?? 0);
  const verseNumberParam = Number(getParam(params.verseNumber) ?? 0);
  const selectionStartParam = Number(getParam(params.selectionStart) ?? verseNumberParam);
  const selectionEndParam = Number(getParam(params.selectionEnd) ?? selectionStartParam);
  const selectionVersesParam = getParam(params.selectionVerses) ?? '';
  const selectionVerses = selectionVersesParam
    .split(',')
    .map((entry) => Number(entry.trim()))
    .filter(
      (entry, index, arr) => Number.isFinite(entry) && entry > 0 && arr.indexOf(entry) === index,
    )
    .sort((a, b) => a - b);
  const selectionStart = selectionVerses[0] ?? Math.min(selectionStartParam, selectionEndParam);
  const selectionEnd =
    selectionVerses[selectionVerses.length - 1] ?? Math.max(selectionStartParam, selectionEndParam);
  const verseText = getParam(params.verseText) ?? '';
  const verseCount = Number(getParam(params.verseCount) ?? 0);
  const version = getParam(params.version) ?? 'KJV';
  const verseNumber = selectionVerses[0] || selectionStart || verseNumberParam;
  const resolvedBook = useMemo(
    () => findBookInBible(bible.bible, bookIdParam || book),
    [bible.bible, book, bookIdParam],
  );
  const bookId = resolvedBook?.id ?? getCanonicalBookIdByName(bookIdParam || book) ?? '';
  const bookName = (resolvedBook?.name ?? getBookNameForId(bible.bible, bookId)) || book;

  const selectedText = useMemo(() => {
    if (!bible || !chapter || selectionStart <= 0 || !bookId) return verseText;
    const verses =
      bible.bible.books.find((entry) => entry.id === bookId)?.chapters[chapter - 1]?.verses ?? [];

    if (verses.length === 0) return verseText;

    const inRange = verses
      .filter((entry) =>
        selectionVerses.length > 0
          ? selectionVerses.includes(entry.verse)
          : entry.verse >= selectionStart && entry.verse <= selectionEnd,
      )
      .map((entry) => `[${entry.verse}] ${entry.text}`);

    return inRange.length > 0 ? inRange.join(' ') : verseText;
  }, [bible, bookId, chapter, selectionEnd, selectionStart, selectionVerses, verseText]);

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
      <ScriptureNotesScreen
        onClose={() => router.back()}
        verse={verse}
        bookId={bookId}
        book={bookName}
        chapter={chapter}
        selectionStart={selectionStart}
        selectionEnd={selectionEnd}
        selectionVerses={selectionVerses}
        verseCount={verseCount}
        version={version}
      />
    </>
  );
}
