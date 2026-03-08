import { ParsedVerse } from '@/src/types/types';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import { useEffect, useState } from 'react';

export const utcdayjs = dayjs.extend(utc);

export function parseVerseRef(ref: string): ParsedVerse | null {
  try {
    // Matches:
    // "Song of Solomon 2:1-4"
    // "1 Peter 1:3"
    // "Song_of_Solomon 2:1"
    const match = ref.match(/^(.+?)\s+(\d+):(\d+)(?:-(\d+))?$/);

    if (!match) return null;

    const [, rawBook, chapter, verseStart, verseEnd] = match;

    return {
      book: rawBook.replace(/_/g, ' ').trim(),
      chapter: Number(chapter),
      verseStart: Number(verseStart),
      verseEnd: verseEnd ? Number(verseEnd) : undefined,
    };
  } catch {
    return null;
  }
}

export const getNumericPrefix = (key?: string | null) => {
  if (!key) return 0;
  const match = key.match(/^(\d+)/);
  return match ? Number(match[0]) : 0;
};

export const sortByItemKey = (a?: string | null, b?: string | null) => {
  const A = (a ?? '').toLowerCase();
  const B = (b ?? '').toLowerCase();

  // 'main' always comes first
  if (A === 'main' && B !== 'main') return -1;
  if (B === 'main' && A !== 'main') return 1;

  const na = getNumericPrefix(a);
  const nb = getNumericPrefix(b);

  if (na === nb) {
    return A.localeCompare(B);
  }

  return na - nb;
};

export function useDebounce<T>(value: T, delay = 500) {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const handler = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(handler);
  }, [value, delay]);

  return debouncedValue;
}

export function isValidEmail(email: string) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

export function incrementPlanCompletions(item: unknown, planId: string) {
  if (!item || typeof item !== 'object') return item;

  const planItem = item as {
    id?: string | null;
    completions?: number | null;
  };

  if (planItem.id !== planId) return item;

  return {
    ...planItem,
    completions: Math.max(0, (planItem.completions ?? 0) + 1),
  };
}

export function incrementPlanCompletionsInInfiniteData(data: unknown, planId: string) {
  if (!data || typeof data !== 'object') return data;

  const typed = data as { pages?: unknown[]; pageParams?: unknown[] };
  if (!Array.isArray(typed.pages)) return data;

  return {
    ...typed,
    pages: typed.pages.map((page) => {
      if (!page || typeof page !== 'object') return page;

      const typedPage = page as { items?: unknown[] };
      if (!Array.isArray(typedPage.items)) return page;

      return {
        ...typedPage,
        items: typedPage.items.map((item) => incrementPlanCompletions(item, planId)),
      };
    }),
  };
}
