import canonicalBookNames from '../../assets/versions/bookNames.json';
import type { BibleBook, BibleChapter, BibleJSON, RawBibleJSON } from './types';

const LEGACY_CANONICAL_BOOK_IDS = [
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

const OT_BOOK_COUNT = 39;

const DEUTEROCANONICAL_BOOK_DEFINITIONS = [
  { id: 'TOB', name: 'Tobit', aliases: ['Book of Tobit', 'Tobias'] },
  { id: 'JDT', name: 'Judith', aliases: ['Book of Judith'] },
  {
    id: 'ESG',
    name: 'Greek Esther',
    aliases: ['Esther (Greek)', 'Additions to Esther', 'Esther Greek'],
  },
  {
    id: 'WIS',
    name: 'Wisdom of Solomon',
    aliases: ['Wisdom', 'Book of Wisdom', 'Wisdom of Sol'],
  },
  {
    id: 'SIR',
    name: 'Sirach',
    aliases: ['Ecclesiasticus', 'Wisdom of Sirach', 'Book of Sirach'],
  },
  { id: 'BAR', name: 'Baruch', aliases: ['Book of Baruch'] },
  { id: '1MA', name: '1 Maccabees', aliases: ['First Maccabees'] },
  { id: '2MA', name: '2 Maccabees', aliases: ['Second Maccabees'] },
  { id: '1ES', name: '1 Esdras', aliases: ['First Esdras'] },
  {
    id: 'MAN',
    name: 'Prayer of Manasseh',
    aliases: ['Manasseh', 'Prayer of Manasses'],
  },
  { id: 'PS2', name: 'Psalm 151', aliases: ['Psalms 151'] },
  { id: '3MA', name: '3 Maccabees', aliases: ['Third Maccabees'] },
  { id: '2ES', name: '2 Esdras', aliases: ['Second Esdras'] },
  { id: '4MA', name: '4 Maccabees', aliases: ['Fourth Maccabees'] },
  {
    id: 'DAG',
    name: 'Greek Daniel',
    aliases: ['Daniel (Greek)', 'Additions to Daniel', 'Daniel with Additions'],
  },
] as const;

export const CANONICAL_BOOK_IDS = [
  ...LEGACY_CANONICAL_BOOK_IDS.slice(0, OT_BOOK_COUNT),
  ...DEUTEROCANONICAL_BOOK_DEFINITIONS.map((book) => book.id),
  ...LEGACY_CANONICAL_BOOK_IDS.slice(OT_BOOK_COUNT),
] as const;

export const DEFAULT_BOOK_ID = 'JOH';

const knownBookDefinitions = [
  ...LEGACY_CANONICAL_BOOK_IDS.slice(0, OT_BOOK_COUNT).map((id, index) => ({
    id,
    name: canonicalBookNames[index] ?? id,
    aliases: [],
  })),
  ...DEUTEROCANONICAL_BOOK_DEFINITIONS,
  ...LEGACY_CANONICAL_BOOK_IDS.slice(OT_BOOK_COUNT).map((id, index) => ({
    id,
    name: canonicalBookNames[OT_BOOK_COUNT + index] ?? id,
    aliases: [],
  })),
];

const canonicalBookNameById = new Map<string, string>(
  knownBookDefinitions.map((book) => [book.id, book.name]),
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

for (const { id, name, aliases } of knownBookDefinitions) {
  canonicalBookIdByAlias.set(normalizeBookLookup(id), id);
  canonicalBookIdByAlias.set(normalizeBookLookup(name), id);

  for (const alias of aliases) {
    canonicalBookIdByAlias.set(normalizeBookLookup(alias), id);
  }
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

const BIBLE_DOT_COM_BOOK_IDS = new Set<string>(LEGACY_CANONICAL_BOOK_IDS);

export const getBibleDotComBookCode = (bookId?: string | null) => {
  const normalizedId = (bookId ?? '').trim().toUpperCase();
  if (!BIBLE_DOT_COM_BOOK_IDS.has(normalizedId)) {
    return '';
  }

  return normalizedId.toLowerCase();
};

const getFallbackBookIds = (books: RawBibleJSON['books']) => {
  const baseOrder =
    books.length > LEGACY_CANONICAL_BOOK_IDS.length
      ? CANONICAL_BOOK_IDS
      : LEGACY_CANONICAL_BOOK_IDS;
  const firstBook = books[0];
  const firstBookHint =
    (typeof firstBook?.id === 'string' && firstBook.id.trim()) ||
    (typeof firstBook?.name === 'string' && firstBook.name.trim()) ||
    '';
  const firstBookId = getCanonicalBookIdByName(firstBookHint);
  const startIndex = firstBookId
    ? baseOrder.indexOf(firstBookId as (typeof baseOrder)[number])
    : -1;

  return startIndex >= 0 ? baseOrder.slice(startIndex) : baseOrder;
};

export const normalizeBibleJson = (bible: RawBibleJSON | BibleJSON): BibleJSON => ({
  ...bible,
  books: (() => {
    const fallbackBookIds = getFallbackBookIds(bible.books);

    return bible.books.map((book, index) => {
      const fallbackBookId = fallbackBookIds[index] ?? `BOOK_${index + 1}`;
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
    });
  })(),
});
