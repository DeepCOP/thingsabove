import { ParsedVerse } from '@/types/types';

export function parseVerseRef(ref: string): ParsedVerse | null {
  try {
    // Example: Song_of_Solomon 2:1-4
    const match = ref.match(/^([\w_]+)\s+(\d+):(\d+)(?:-(\d+))?$/);

    if (!match) return null;

    const [, rawBook, chapter, verseStart, verseEnd] = match;
    return {
      book: rawBook.replace(/_/g, ' '), 
      chapter: Number(chapter),
      verseStart: Number(verseStart),
      verseEnd: verseEnd ? Number(verseEnd) : undefined,
    };
  } catch (e) {
    console.log(e);
  }
}
