import type { BibleChapter, BibleVersionId } from '../types';

/** Navigation metadata without the text of the entire translation. */
export type BibleBookMetadata = {
  id: string;
  name: string;
  chapters: number[];
};

/**
 * Reading sources return the app's canonical book IDs and verse numbers so
 * saved references, highlights, and note scopes remain independent of storage.
 * Source/version identity must stay fixed for the lifetime of an adapter.
 */
export interface BibleReadingAdapter {
  readonly sourceId: string;
  readonly versionId: BibleVersionId;
  getBooks(): Promise<BibleBookMetadata[]>;
  /** Returns null for a missing reference; rejects when the source cannot be read. */
  getChapter(bookId: string, chapterNumber: number): Promise<BibleChapter | null>;
}
