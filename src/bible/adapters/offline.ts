import { findBookInBible, normalizeBibleJson } from '../books';
import type { BibleJSON, BibleVersionId, RawBibleJSON } from '../types';
import type { BibleBookMetadata, BibleReadingAdapter } from './types';

/** Keeps file access outside the reader and loads a translation only when needed. */
export const createOfflineBibleAdapter = (
  versionId: BibleVersionId,
  loadBible: () => Promise<RawBibleJSON>,
): BibleReadingAdapter => {
  let biblePromise: Promise<BibleJSON> | undefined;
  let books: BibleBookMetadata[] | undefined;

  const getBible = () => {
    if (!biblePromise) {
      biblePromise = Promise.resolve()
        .then(loadBible)
        .then(normalizeBibleJson)
        .catch((error: unknown) => {
          // A failed file read must be retryable, rather than cached forever.
          biblePromise = undefined;
          throw error;
        });
    }

    return biblePromise;
  };

  return {
    sourceId: 'offline',
    versionId,
    async getBooks() {
      const bible = await getBible();
      books ??= bible.books.map((book) => ({
        id: book.id,
        name: book.name,
        chapters: book.chapters.map((chapter) => chapter.chapter),
      }));
      return books;
    },
    async getChapter(bookId, chapterNumber) {
      const bible = await getBible();
      return (
        findBookInBible(bible, bookId)?.chapters.find(
          (chapter) => chapter.chapter === chapterNumber,
        ) ?? null
      );
    },
  };
};
