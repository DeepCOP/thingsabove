import { Parser } from 'htmlparser2';
import { findBookInBible, getCanonicalBookIdByName } from '../books';
import type { BibleChapter } from '../types';
import type { BibleBookMetadata, BibleReadingAdapter } from './types';

export type YouVersionRequest = (
  request:
    | { action: 'metadata'; bibleId: string }
    | { action: 'books'; bibleId: string }
    | { action: 'chapter'; bibleId: string; chapterId: string },
) => Promise<unknown>;

// Preserve the book identifiers already used by local highlights and notes.
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
    throw new Error('YouVersion returned an invalid response.');
  }
  return value as Record<string, unknown>;
};

const normalizeWhitespace = (value: string) => value.replace(/\s+/g, ' ').trim();

export const parseYouVersionCopyright = (value: string) => {
  let result = '';
  const parser = new Parser(
    {
      ontext: (text) => {
        result += text;
      },
      onclosetag: (tag) => {
        if (tag === 'div' || tag === 'p' || tag === 'br') result += ' ';
      },
    },
    { decodeEntities: true },
  );
  parser.end(value);
  return normalizeWhitespace(result);
};

const parseVerseNumber = (value: unknown) => {
  const number = String(value ?? '').trim();
  if (!/^[1-9]\d*$/.test(number) || Number(number) > 1000) {
    throw new Error(
      'This chapter uses combined or partial verse numbers that this reader does not support yet.',
    );
  }
  return Number(number);
};

/** Parse the Platform's YVDOM verse milestones, never split unmarked plain text. */
export const parseYouVersionChapter = (
  response: unknown,
  bibleId: string,
  chapterId: string,
  chapterNumber: number,
  copyright: string,
): BibleChapter => {
  const data = record(record(response).data);
  if (
    data.id !== chapterId ||
    data.bibleId !== bibleId ||
    typeof data.content !== 'string' ||
    data.content.length > 2_000_000 ||
    chapterId.split('.')[1] !== String(chapterNumber)
  ) {
    throw new Error('YouVersion returned unexpected chapter content.');
  }
  if (!copyright.trim()) {
    throw new Error('YouVersion did not return the copyright notice for this Bible.');
  }

  type Label = { text: string; verse: number };
  type Frame = { ignored: boolean; label?: Label; labelRoot?: boolean; marker?: number };
  const stack: Frame[] = [];
  const verses = new Map<number, string>();
  let currentVerse: number | null = null;
  let nodeCount = 0;
  const append = (text: string) => {
    if (currentVerse == null) {
      if (text.trim()) throw new Error('YouVersion returned text without a verse reference.');
      return;
    }
    verses.set(currentVerse, (verses.get(currentVerse) ?? '') + text);
  };
  const isBlock = (tag: string) => /^(?:div|p|br|table|tr|td|th|li)$/.test(tag);
  const countNode = () => {
    if (++nodeCount > 50000 || stack.length > 50) {
      throw new Error('YouVersion returned overly complex content.');
    }
  };
  const parser = new Parser(
    {
      onopentag: (tag, attrs) => {
        countNode();
        const parent = stack[stack.length - 1];
        const classes = (attrs.class ?? '').split(/\s+/);
        if (parent?.ignored) {
          stack.push({ ignored: true, label: parent.label, marker: parent.marker });
          return;
        }
        const ignored =
          /^(?:script|style|template|h[1-6])$/.test(tag) ||
          classes.some((name) =>
            /^(?:yv-h|yv-n|yv-clbl|s\d*|ms\d*|mt\d*|mte\d*|r|d|sp|cl|cd|c|f|fe|ef|x|ex)$/.test(
              name,
            ),
          );
        if (ignored) {
          stack.push({ ignored: true });
          return;
        }
        if (classes.includes('yv-v')) {
          const verse = parseVerseNumber(attrs.v);
          if (currentVerse != null && verse < currentVerse) {
            throw new Error('YouVersion returned verses out of order.');
          }
          currentVerse = verse;
          stack.push({ ignored: true, marker: verse });
          return;
        }
        if (classes.includes('yv-vlbl')) {
          if (currentVerse == null) {
            throw new Error('YouVersion returned a verse label without a verse reference.');
          }
          stack.push({ ignored: true, label: { text: '', verse: currentVerse }, labelRoot: true });
          return;
        }
        stack.push({ ignored: false });
        if (isBlock(tag) && currentVerse != null) append(' ');
      },
      ontext: (text) => {
        countNode();
        const frame = stack[stack.length - 1];
        if (frame?.label) {
          frame.label.text += text;
        } else if (frame?.marker != null) {
          if (text.trim() && parseVerseNumber(text) !== frame.marker) {
            throw new Error('YouVersion returned inconsistent verse markers.');
          }
        } else if (!frame?.ignored) {
          append(text);
        }
      },
      onclosetag: (tag) => {
        const frame = stack.pop();
        if (frame?.labelRoot && frame.label) {
          if (parseVerseNumber(frame.label.text) !== frame.label.verse) {
            throw new Error(
              'This chapter uses verse labels that this reader does not support yet.',
            );
          }
        }
        if (!frame?.ignored && isBlock(tag) && currentVerse != null) append(' ');
      },
    },
    { decodeEntities: true },
  );
  parser.end(data.content);
  const normalized = [...verses]
    .map(([verse, text]) => ({ verse, text: normalizeWhitespace(text) }))
    .filter((verse) => verse.text);
  if (!normalized.length) {
    throw new Error('YouVersion returned no readable verses for this chapter.');
  }
  return { chapter: chapterNumber, verses: normalized, copyright };
};

export const createYouVersionAdapter = (
  versionId: string,
  bibleId: string,
  request: YouVersionRequest,
): BibleReadingAdapter => {
  type BookEntry = { metadata: BibleBookMetadata; chapterIds: Map<number, string> };
  type Index = { books: BookEntry[]; copyright: string };
  let indexPromise: Promise<Index> | undefined;
  const pendingChapters = new Map<string, Promise<BibleChapter>>();

  const loadIndex = () => {
    if (!indexPromise) {
      indexPromise = Promise.resolve()
        .then(() => request({ action: 'books', bibleId }))
        .then((response): Index => {
          const data = record(record(response).data);
          if (data.bibleId !== bibleId || !Array.isArray(data.books) || !data.books.length) {
            throw new Error('YouVersion returned an invalid book list.');
          }
          const copyright =
            typeof data.copyright === 'string' ? parseYouVersionCopyright(data.copyright) : '';
          if (!copyright) {
            throw new Error('YouVersion did not return the copyright notice for this Bible.');
          }
          const seenIds = new Set<string>();
          const books = data.books.map((value): BookEntry => {
            const book = record(value);
            if (
              typeof book.id !== 'string' ||
              !/^[A-Z0-9]{3}$/.test(book.id) ||
              typeof book.title !== 'string' ||
              !book.title.trim() ||
              !Array.isArray(book.chapters)
            ) {
              throw new Error('YouVersion returned invalid book metadata.');
            }
            const id = legacyBookIds[book.id] ?? getCanonicalBookIdByName(book.id) ?? book.id;
            if (seenIds.has(id)) throw new Error('YouVersion returned duplicate book identifiers.');
            seenIds.add(id);
            const chapterIds = new Map<number, string>();
            for (const value of book.chapters) {
              const chapter = record(value);
              if (chapter.id === 'INTRO' || String(chapter.id) === '0') continue;
              const number = String(chapter.id);
              if (
                !/^[1-9]\d{0,2}$/.test(number) ||
                chapter.passage_id !== `${book.id}.${number}` ||
                chapterIds.has(Number(number))
              ) {
                throw new Error('YouVersion returned invalid chapter metadata.');
              }
              chapterIds.set(Number(number), chapter.passage_id as string);
            }
            return {
              metadata: {
                id,
                name: book.title.trim(),
                chapters: [...chapterIds.keys()].sort((a, b) => a - b),
              },
              chapterIds,
            };
          });
          return { books, copyright };
        })
        .catch((error: unknown) => {
          indexPromise = undefined;
          throw error;
        });
    }
    return indexPromise;
  };

  return {
    sourceId: 'youversion',
    versionId,
    async getBooks() {
      return (await loadIndex()).books.map((book) => book.metadata);
    },
    async getChapter(bookId, chapterNumber) {
      if (!Number.isInteger(chapterNumber) || chapterNumber < 1) return null;
      const index = await loadIndex();
      const book = findBookInBible(
        index.books.map((entry) => entry.metadata),
        bookId,
      );
      const chapterId = index.books
        .find((entry) => entry.metadata === book)
        ?.chapterIds.get(chapterNumber);
      if (!chapterId) return null;
      let pending = pendingChapters.get(chapterId);
      if (!pending) {
        pending = Promise.resolve()
          .then(() => request({ action: 'chapter', bibleId, chapterId }))
          .then((response) =>
            parseYouVersionChapter(response, bibleId, chapterId, chapterNumber, index.copyright),
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
