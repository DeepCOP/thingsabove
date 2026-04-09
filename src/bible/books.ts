import canonicalBookNames from '../../assets/versions/bookNames.json';
import type { BibleBook, BibleChapter, BibleJSON, RawBibleJSON } from './types';

export const CANONICAL_BOOK_IDS = [
  'GEN',
  'EXO',
  'LEV',
  'NUM',
  'DEU',
  'JOS',
  'JDG',
  'RUT',
  '1SA',
  '2SA',
  '1KI',
  '2KI',
  '1CH',
  '2CH',
  'EZR',
  'NEH',
  'EST',
  'JOB',
  'PSA',
  'PRO',
  'ECC',
  'SOL',
  'ISA',
  'JER',
  'LAM',
  'EZE',
  'DAN',
  'HOS',
  'JOE',
  'AMO',
  'OBA',
  'JON',
  'MIC',
  'NAH',
  'HAB',
  'ZEP',
  'HAG',
  'ZEC',
  'MAL',
  'MAT',
  'MAR',
  'LUK',
  'JOH',
  'ACT',
  'ROM',
  '1CO',
  '2CO',
  'GAL',
  'EPH',
  'PHI',
  'COL',
  '1TH',
  '2TH',
  '1TI',
  '2TI',
  'TIT',
  'PHM',
  'HEB',
  'JAM',
  '1PE',
  '2PE',
  '1JO',
  '2JO',
  '3JO',
  'JUD',
  'REV',
] as const;

export const DEFAULT_BOOK_ID = 'JOH';

const canonicalBookNameById = new Map<string, string>(
  CANONICAL_BOOK_IDS.map((id, index) => [id, canonicalBookNames[index] ?? id]),
);

const normalizeBookLookup = (value: string) => {
  const normalized = value
    .normalize('NFKC')
    .toLowerCase()
    .replace(/[\u2018\u2019]/g, "'")
    .replace(/[\u201c\u201d]/g, '"')
    .replace(/\s+/g, ' ')
    .trim();

  const latinFriendly = normalized
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, ' ')
    .trim();

  return latinFriendly || normalized;
};

const canonicalBookIdByAlias = new Map<string, string>();

for (const [index, bookId] of CANONICAL_BOOK_IDS.entries()) {
  const canonicalName = canonicalBookNames[index] ?? bookId;
  canonicalBookIdByAlias.set(normalizeBookLookup(bookId), bookId);
  canonicalBookIdByAlias.set(normalizeBookLookup(canonicalName), bookId);
}

const normalizeChapters = (chapters: BibleChapter[]) =>
  chapters.map((chapter) => ({
    chapter: chapter.chapter,
    verses: chapter.verses.map((verse) => ({
      verse: verse.verse,
      text: verse.text,
    })),
  }));

export const getCanonicalBookName = (bookId?: string | null) => {
  if (!bookId) return '';
  return canonicalBookNameById.get(bookId.toUpperCase()) ?? bookId;
};

export const getCanonicalBookIdByName = (value?: string | null) => {
  if (!value) return null;

  const trimmed = value.trim();
  if (!trimmed) return null;

  const normalizedId = trimmed.toUpperCase();
  if (canonicalBookNameById.has(normalizedId)) {
    return normalizedId;
  }

  return canonicalBookIdByAlias.get(normalizeBookLookup(trimmed)) ?? null;
};

const getBibleBooks = (input: BibleJSON | BibleBook[]) =>
  Array.isArray(input) ? input : input.books;

export const findBookInBible = (input: BibleJSON | BibleBook[], value?: string | null) => {
  if (!value) return undefined;

  const books = getBibleBooks(input);
  const normalizedValue = normalizeBookLookup(value);
  const canonicalBookId = getCanonicalBookIdByName(value);

  return books.find((book) => {
    if (book.id === value || book.id === value.toUpperCase()) {
      return true;
    }

    if (canonicalBookId && book.id === canonicalBookId) {
      return true;
    }

    return (
      normalizeBookLookup(book.name) === normalizedValue ||
      normalizeBookLookup(getCanonicalBookName(book.id)) === normalizedValue
    );
  });
};

export const getBookNameForId = (input: BibleJSON | BibleBook[], bookId?: string | null) => {
  if (!bookId) return '';
  return findBookInBible(input, bookId)?.name ?? getCanonicalBookName(bookId);
};

export const getBibleDotComBookCode = (bookId?: string | null) =>
  (bookId ?? '').trim().toLowerCase();

export const normalizeBibleJson = (bible: RawBibleJSON | BibleJSON): BibleJSON => ({
  translation: bible.translation,
  books: bible.books.map((book, index) => {
    const fallbackBookId = CANONICAL_BOOK_IDS[index] ?? `BOOK_${index + 1}`;
    const normalizedBookId =
      getCanonicalBookIdByName(book.id) ??
      (typeof book.id === 'string' && book.id.trim()
        ? book.id.trim().toUpperCase()
        : fallbackBookId);
    const fallbackBookName = getCanonicalBookName(normalizedBookId);
    const normalizedBookName =
      typeof book.name === 'string' && book.name.trim() ? book.name.trim() : fallbackBookName;

    return {
      id: normalizedBookId,
      name: normalizedBookName,
      chapters: normalizeChapters(book.chapters),
    };
  }),
});
