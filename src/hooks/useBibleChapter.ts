import type { BibleReadingAdapter } from '@/src/bible/adapters/types';
import type { BibleChapter } from '@/src/bible/types';
import { useBible } from '@/src/state/BibleContext';
import { trackApiBibleView } from '@/src/lib/apiBibleViewTracking';
import { useCallback, useEffect, useState } from 'react';

type ChapterResult = {
  adapter: BibleReadingAdapter;
  bookId: string;
  chapterNumber: number;
  attempt: number;
  chapter: BibleChapter | null;
  error: string | null;
};

export const useBibleChapter = (
  bookId: string | undefined,
  chapterNumber: number | undefined,
  options?: { enabled?: boolean; adapter?: BibleReadingAdapter },
) => {
  const { adapter: currentAdapter } = useBible();
  const adapter = options?.adapter ?? currentAdapter;
  const enabled =
    options?.enabled !== false &&
    Boolean(bookId) &&
    chapterNumber != null &&
    Number.isInteger(chapterNumber) &&
    chapterNumber > 0;
  const [attempt, setAttempt] = useState(0);
  const [result, setResult] = useState<ChapterResult | null>(null);
  const retry = useCallback(() => setAttempt((previous) => previous + 1), []);

  useEffect(() => {
    if (!enabled || !bookId || chapterNumber == null) return;
    let cancelled = false;

    // A source may throw before returning its promise. Handle both failure modes.
    void Promise.resolve()
      .then(() => adapter.getChapter(bookId, chapterNumber))
      .then(
        (chapter) => {
          if (!cancelled) {
            setResult({ adapter, bookId, chapterNumber, attempt, chapter, error: null });
          }
        },
        (error: unknown) => {
          if (!cancelled) {
            setResult({
              adapter,
              bookId,
              chapterNumber,
              attempt,
              chapter: null,
              error: error instanceof Error ? error.message : 'Unable to load this chapter.',
            });
          }
        },
      );

    return () => {
      cancelled = true;
    };
  }, [adapter, attempt, bookId, chapterNumber, enabled]);

  // Do not expose the previous passage even during the render before effect cleanup.
  const currentResult =
    enabled &&
    result?.adapter === adapter &&
    result.bookId === bookId &&
    result.chapterNumber === chapterNumber &&
    result.attempt === attempt
      ? result
      : null;

  useEffect(() => {
    trackApiBibleView(currentResult?.chapter?.fumsToken);
  }, [currentResult?.chapter?.fumsToken]);

  return {
    chapter: currentResult?.chapter ?? null,
    loading: enabled && !currentResult,
    error: currentResult?.error ?? null,
    retry,
  };
};
