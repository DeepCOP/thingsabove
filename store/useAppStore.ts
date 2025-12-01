import { create } from 'zustand';

type BibleBook = {
  name: string;
  chapters: number;
};

type AppState = {
  // USER
  user: any;
  setUser: (u: any) => void;

  // BIBLE DATA
  bibleBooks: BibleBook[];
  setBibleBooks: (books: BibleBook[]) => void;

  selectedBook: BibleBook;
  setSelectedBook: (book: BibleBook) => void;

  selectedChapter: number | null;
  setSelectedChapter: (chapter: number | null) => void;

  // DEVOTIONAL PLAN
  currentPlan: any;
  setCurrentPlan: (plan: any) => void;

  // THEME
  theme: 'light' | 'dark';
  setTheme: (t: 'light' | 'dark') => void;
};

export const useAppStore = create<AppState>((set) => ({
  // USER
  user: null,
  setUser: (user) => set({ user }),

  // BIBLE
  bibleBooks: [],
  setBibleBooks: (books) => set({ bibleBooks: books }),

  selectedBook: {
    name: 'John',
    chapters: 1,
  },
  setSelectedBook: (book) => set({ selectedBook: book }),

  selectedChapter: null,
  setSelectedChapter: (chapter) => set({ selectedChapter: chapter }),

  // DEVOTIONAL PLAN
  currentPlan: null,
  setCurrentPlan: (plan) => set({ currentPlan: plan }),

  // APP THEME
  theme: 'light',
  setTheme: (theme) => set({ theme }),
}));
