import { Parser } from 'htmlparser2';
import { findBookInBible, getCanonicalBookIdByName } from '../books';
import type { BibleChapter } from '../types';
import type { BibleBookMetadata, BibleReadingAdapter } from './types';

export type ApiBibleRequest = (
  request:
    | { action: 'books'; bibleId: string }
    | { action: 'chapter'; bibleId: string; chapterId: string },
) => Promise<unknown>;

const legacyBookIds: Record<string, string> = {
  SNG: 'SOL',
  EZK: 'EZE',
  JOL: 'JOE',
  NAM: 'NAH',
  MRK: 'MAR',
  JHN: 'JOH',
  PHP: 'PHI',
  JAS: 'JAM',
  '1JN': '1JO',
  '2JN': '2JO',
  '3JN': '3JO',
};

const record = (value: unknown): Record<string, unknown> => {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    throw new Error('API.Bible returned an invalid response.');
  }
  return value as Record<string, unknown>;
};
const whitespace = (value: string) => value.replace(/\s+/g, ' ').trim();
const isBlock = (tag: string) => /^(?:p|div|br|table|tr|td|th|li)$/.test(tag);
const parseVerseNumber = (value: unknown) => {
  const number = String(value ?? '').trim();
  if (!/^[1-9]\d*$/.test(number) || Number(number) > 1000) {
    throw new Error(
      'This chapter uses combined or partial verse numbers that this reader does not support yet.',
    );
  }
  return Number(number);
};

const isIgnored = (tag: string, classes: string[]) =>
  /^(?:script|style|template|h[1-6])$/.test(tag) ||
  classes.some((name) =>
    /^(?:note|notes|footnote|footnotes|f|fe|ef|x|ex|title|s\d*|ms\d*)$/.test(name),
  );

/** Parses API.Bible's data-number verse markers into the app's stable verse keys. */
export const parseApiBibleChapter = (
  response: unknown,
  bibleId: string,
  providerBookId: string,
  chapterId: string,
  chapterNumber: number,
): BibleChapter => {
  const data = record(record(response).data);
  if (
    data.id !== chapterId ||
    data.bibleId !== bibleId ||
    data.bookId !== providerBookId ||
    data.number !== String(chapterNumber) ||
    typeof data.content !== 'string' ||
    !data.content.trim() ||
    data.content.length > 2_000_000 ||
    typeof data.copyright !== 'string' ||
    !data.copyright.trim()
  ) {
    throw new Error('API.Bible returned unexpected chapter content.');
  }

  type Frame = { ignored: boolean; marker?: number };
  const stack: Frame[] = [];
  const verses = new Map<number, string>();
  let currentVerse: number | null = null;
  let nodeCount = 0;
  const append = (text: string) => {
    if (currentVerse == null) {
      if (text.trim()) throw new Error('API.Bible returned text without a verse reference.');
      return;
    }
    verses.set(currentVerse, (verses.get(currentVerse) ?? '') + text);
  };
  const countNode = () => {
    if (++nodeCount > 50_000 || stack.length > 50) {
      throw new Error('API.Bible returned overly complex content.');
    }
  };
  const parser = new Parser(
    {
      onopentag: (tag, attrs) => {
        countNode();
        const parent = stack[stack.length - 1];
        if (parent?.ignored) {
          stack.push({ ignored: true });
          return;
        }
        const classes = (attrs.class ?? '').split(/\s+/);
        if (isIgnored(tag, classes)) {
          stack.push({ ignored: true });
          return;
        }
        if (classes.includes('v')) {
          const verse = parseVerseNumber(attrs['data-number']);
          if (currentVerse != null && verse <= currentVerse) {
            throw new Error('API.Bible returned duplicate or unordered verse references.');
          }
          currentVerse = verse;
          verses.set(verse, '');
          stack.push({ ignored: true, marker: verse });
          return;
        }
        stack.push({ ignored: false });
        if (isBlock(tag) && currentVerse != null) append(' ');
      },
      ontext: (text) => {
        countNode();
        const frame = stack[stack.length - 1];
        if (frame?.marker != null) {
          if (text.trim() && parseVerseNumber(text) !== frame.marker) {
            throw new Error('API.Bible returned inconsistent verse markers.');
          }
        } else if (!frame?.ignored) {
          append(text);
        }
      },
      onclosetag: (tag) => {
        const frame = stack.pop();
        if (!frame?.ignored && isBlock(tag) && currentVerse != null) append(' ');
      },
    },
    { decodeEntities: true },
  );
  parser.end(data.content);

  const normalized = [...verses]
    .map(([verse, text]) => ({ verse, text: whitespace(text) }))
    .filter((verse) => verse.text);
  if (!normalized.length || normalized[0].verse !== 1) {
    throw new Error('API.Bible returned no complete readable verses for this chapter.');
  }
  return {
    chapter: chapterNumber,
    verses: normalized,
    copyright: whitespace(data.copyright),
    attributionUrl: 'https://docs.api.bible/',
    ...(typeof data.fumsToken === 'string' && data.fumsToken.length <= 2048
      ? { fumsToken: data.fumsToken }
      : {}),
  };
};

export const createApiBibleAdapter = (
  versionId: string,
  bibleId: string,
  request: ApiBibleRequest,
): BibleReadingAdapter => {
  type BookEntry = {
    metadata: BibleBookMetadata;
    chapterIds: Map<number, string>;
    providerId: string;
  };
  let indexPromise: Promise<BookEntry[]> | undefined;
  const pendingChapters = new Map<string, Promise<BibleChapter>>();

  const loadIndex = () => {
    if (!indexPromise) {
      indexPromise = Promise.resolve()
        .then(() => request({ action: 'books', bibleId }))
        .then((response): BookEntry[] => {
          const data = record(record(response).data);
          if (!Array.isArray(data.books) || !data.books.length) {
            throw new Error('API.Bible returned an invalid book list.');
          }
          const seenIds = new Set<string>();
          const books = data.books.flatMap((value): BookEntry[] => {
            const book = record(value);
            const providerId = typeof book.id === 'string' ? book.id : '';
            const canonicalId =
              legacyBookIds[providerId] ??
              getCanonicalBookIdByName(providerId) ??
              getCanonicalBookIdByName(typeof book.name === 'string' ? book.name : null) ??
              getCanonicalBookIdByName(typeof book.nameLong === 'string' ? book.nameLong : null);
            if (!canonicalId) return [];
            if (
              !/^[A-Z0-9]{2,12}$/.test(providerId) ||
              typeof book.name !== 'string' ||
              !book.name.trim() ||
              !Array.isArray(book.chapters) ||
              seenIds.has(canonicalId)
            ) {
              throw new Error('API.Bible returned invalid book metadata.');
            }
            const chapterIds = new Map<number, string>();
            for (const value of book.chapters) {
              const chapter = record(value);
              const number = String(chapter.number ?? '');
              if (number === 'intro' || number === '0') continue;
              if (
                !/^[1-9]\d{0,2}$/.test(number) ||
                typeof chapter.id !== 'string' ||
                chapter.id.length > 100 ||
                chapter.bibleId !== bibleId ||
                chapter.bookId !== providerId ||
                chapterIds.has(Number(number))
              ) {
                throw new Error('API.Bible returned invalid chapter metadata.');
              }
              chapterIds.set(Number(number), chapter.id);
            }
            if (!chapterIds.size) return [];
            seenIds.add(canonicalId);
            return [
              {
                providerId,
                metadata: {
                  id: canonicalId,
                  name: book.name.trim(),
                  chapters: [...chapterIds.keys()].sort((a, b) => a - b),
                },
                chapterIds,
              },
            ];
          });
          if (!books.length) throw new Error('API.Bible returned no supported books.');
          return books;
        })
        .catch((error: unknown) => {
          indexPromise = undefined;
          throw error;
        });
    }
    return indexPromise;
  };

  return {
    sourceId: 'apiBible',
    versionId,
    async getBooks() {
      return (await loadIndex()).map((book) => ({
        ...book.metadata,
        chapters: [...book.metadata.chapters],
      }));
    },
    async getChapter(bookId, chapterNumber) {
      if (!Number.isInteger(chapterNumber) || chapterNumber < 1) return null;
      const index = await loadIndex();
      const book = findBookInBible(
        index.map((entry) => entry.metadata),
        bookId,
      );
      const entry = index.find((candidate) => candidate.metadata === book);
      const chapterId = entry?.chapterIds.get(chapterNumber);
      if (!entry || !chapterId) return null;
      let pending = pendingChapters.get(chapterId);
      if (!pending) {
        pending = Promise.resolve()
          .then(() => request({ action: 'chapter', bibleId, chapterId }))
          .then((response) =>
            parseApiBibleChapter(response, bibleId, entry.providerId, chapterId, chapterNumber),
          )
          .finally(() => {
            pendingChapters.delete(chapterId);
          });
        pendingChapters.set(chapterId, pending);
      }
      return pending;
    },
  };
};
