import { DevotionalDays } from '@/src/types/types';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { create } from 'zustand';
import { createJSONStorage, persist } from 'zustand/middleware';

export type BibleBook = {
  name: string;
  chapter: number;
  verseStart?: number;
  verseEnd?: number;
};

type AppState = {
  missedDays: DevotionalDays[] | null;
  setMissedDays: (days: DevotionalDays[]) => void;
  version: 'KJV' | 'ASV';
  setVersion: (v: 'KJV' | 'ASV') => void;

  isGrid: boolean;
  setIsGrid: (isGrid: boolean) => void;

  sort: 'Recent' | 'Trending';
  setSort: (s: 'Recent' | 'Trending') => void;

  // USER
  user: any;
  setUser: (u: any) => void;

  itemId: string;
  setItemId: (id: string) => void;

  // BIBLE
  selectedBook: BibleBook;
  setSelectedBook: (book: BibleBook) => void;

  selectedChapter: number | null;
  setSelectedChapter: (chapter: number | null) => void;

  // PLAN
  currentPlan: any;
  setCurrentPlan: (plan: any) => void;

  // THEME
  theme: 'light' | 'dark';
  setTheme: (t: 'light' | 'dark') => void;
};

export const useAppStore = create<AppState>()(
  persist(
    (set) => ({
      missedDays: null,
      setMissedDays: (days) => set({ missedDays: days }),
      sort: 'Recent',
      setSort: (s) => set({ sort: s }),
      // USER
      user: null,
      setUser: (user) => set({ user }),
      isGrid: false,
      setIsGrid: (isGrid) => set({ isGrid }),

      // ITEM
      itemId: '',
      setItemId: (id) => set({ itemId: id }),

      // BIBLE
      selectedBook: {
        name: 'John',
        chapter: 1,
      },
      setSelectedBook: (book) => set({ selectedBook: book }),

      selectedChapter: null,
      setSelectedChapter: (chapter) => set({ selectedChapter: chapter }),

      // PLAN
      currentPlan: null,
      setCurrentPlan: (plan) => set({ currentPlan: plan }),

      // THEME
      theme: 'light',
      setTheme: (theme) => set({ theme }),
      // BIBLE VERSION
      version: 'KJV',
      setVersion: (v) => set({ version: v }),
    }),
    {
      name: 'app-storage', // 🔑 storage key
      storage: createJSONStorage(() => AsyncStorage),

      // ✅ Persist only what matters
      partialize: (state) => ({
        user: state.user,
        isGrid: state.isGrid,
        sort: state.sort,
        version: state.version,
        itemId: state.itemId,
        selectedBook: state.selectedBook,
        selectedChapter: state.selectedChapter,
        currentPlan: state.currentPlan,
        theme: state.theme,
      }),
    },
  ),
);
