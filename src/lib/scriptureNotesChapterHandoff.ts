import type { BibleReadingAdapter } from '@/src/bible/adapters/types';
import type { BibleChapter } from '@/src/bible/types';

type ChapterScope = {
  adapter: BibleReadingAdapter;
  bookId: string;
  chapterNumber: number;
};

type PendingChapter = ChapterScope & {
  chapter: BibleChapter;
  stagedAt: number;
};

const MAX_HANDOFF_AGE_MS = 60_000;
let pendingChapter: PendingChapter | null = null;

/**
 * Moves an already-rendered chapter to Scripture Notes without serializing
 * Scripture text into a route URL or persistent storage.
 */
export const stageScriptureNotesChapter = (scope: ChapterScope, chapter: BibleChapter) => {
  pendingChapter = { ...scope, chapter, stagedAt: Date.now() };
};

const matchesScope = (candidate: PendingChapter, scope: ChapterScope) =>
  candidate.adapter === scope.adapter &&
  candidate.bookId === scope.bookId &&
  candidate.chapterNumber === scope.chapterNumber;

/** Returns the matching handoff while the notes route mounts. */
export const getScriptureNotesChapter = (scope: ChapterScope): BibleChapter | null => {
  const candidate = pendingChapter;
  if (
    !candidate ||
    Date.now() - candidate.stagedAt > MAX_HANDOFF_AGE_MS ||
    !matchesScope(candidate, scope)
  ) {
    return null;
  }
  return candidate.chapter;
};

/** Removes the handoff after the destination route has captured it. */
export const clearScriptureNotesChapter = (scope: ChapterScope) => {
  if (pendingChapter && matchesScope(pendingChapter, scope)) pendingChapter = null;
};
