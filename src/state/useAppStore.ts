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

type BibleVersion = 'KJV' | 'ASV';
type SortOption = 'Recent' | 'Trending';
type ThemeMode = 'light' | 'dark' | 'system';

type AppState = {
  missedDays: DevotionalDays[] | null;
  setMissedDays: (days: DevotionalDays[]) => void;
  version: BibleVersion;
  setVersion: (v: BibleVersion) => void;

  isGrid: boolean;
  setIsGrid: (isGrid: boolean) => void;

  sort: SortOption;
  setSort: (s: SortOption) => void;

  user: any;
  setUser: (u: any) => void;

  selectedBook: BibleBook;
  setSelectedBook: (book: BibleBook) => void;

  selectedChapter: number | null;
  setSelectedChapter: (chapter: number | null) => void;

  currentPlan: any;
  setCurrentPlan: (plan: any) => void;

  theme: ThemeMode;
  setTheme: (t: ThemeMode) => void;
};

type PersistedAppState = Pick<
  AppState,
  | 'user'
  | 'isGrid'
  | 'sort'
  | 'version'
  | 'selectedBook'
  | 'selectedChapter'
  | 'currentPlan'
  | 'theme'
>;

const DEFAULT_SELECTED_BOOK: BibleBook = {
  name: 'John',
  chapter: 1,
};

const DEFAULT_PERSISTED_STATE: PersistedAppState = {
  user: null,
  isGrid: false,
  sort: 'Recent',
  version: 'KJV',
  selectedBook: DEFAULT_SELECTED_BOOK,
  selectedChapter: null,
  currentPlan: null,
  theme: 'system',
};

const isRecord = (value: unknown): value is Record<string, unknown> =>
  typeof value === 'object' && value !== null;

const isBibleVersion = (value: unknown): value is BibleVersion =>
  value === 'KJV' || value === 'ASV';

const isSortOption = (value: unknown): value is SortOption =>
  value === 'Recent' || value === 'Trending';

const isThemeMode = (value: unknown): value is ThemeMode =>
  value === 'light' || value === 'dark' || value === 'system';

const isBibleBook = (value: unknown): value is BibleBook => {
  if (!isRecord(value)) {
    return false;
  }

  const { name, chapter, verseStart, verseEnd } = value;

  return (
    typeof name === 'string' &&
    typeof chapter === 'number' &&
    (verseStart === undefined || typeof verseStart === 'number') &&
    (verseEnd === undefined || typeof verseEnd === 'number')
  );
};

const hasOwn = (value: Record<string, unknown>, key: string) =>
  Object.prototype.hasOwnProperty.call(value, key);

const partializeAppState = (state: AppState): PersistedAppState => ({
  user: state.user,
  isGrid: state.isGrid,
  sort: state.sort,
  version: state.version,
  selectedBook: state.selectedBook,
  selectedChapter: state.selectedChapter,
  currentPlan: state.currentPlan,
  theme: state.theme,
});

const migrateAppState = (persistedState: unknown): PersistedAppState => {
  if (!isRecord(persistedState)) {
    return DEFAULT_PERSISTED_STATE;
  }

  return {
    user: hasOwn(persistedState, 'user') ? persistedState.user : DEFAULT_PERSISTED_STATE.user,
    isGrid:
      typeof persistedState.isGrid === 'boolean'
        ? persistedState.isGrid
        : DEFAULT_PERSISTED_STATE.isGrid,
    sort: isSortOption(persistedState.sort) ? persistedState.sort : DEFAULT_PERSISTED_STATE.sort,
    version: isBibleVersion(persistedState.version)
      ? persistedState.version
      : DEFAULT_PERSISTED_STATE.version,
    selectedBook: isBibleBook(persistedState.selectedBook)
      ? persistedState.selectedBook
      : DEFAULT_PERSISTED_STATE.selectedBook,
    selectedChapter:
      typeof persistedState.selectedChapter === 'number' || persistedState.selectedChapter === null
        ? persistedState.selectedChapter
        : DEFAULT_PERSISTED_STATE.selectedChapter,
    currentPlan: hasOwn(persistedState, 'currentPlan')
      ? persistedState.currentPlan
      : DEFAULT_PERSISTED_STATE.currentPlan,
    theme: isThemeMode(persistedState.theme) ? persistedState.theme : DEFAULT_PERSISTED_STATE.theme,
  };
};

export const useAppStore = create<AppState>()(
  persist(
    (set) => ({
      missedDays: null,
      setMissedDays: (days) => set({ missedDays: days }),
      sort: DEFAULT_PERSISTED_STATE.sort,
      setSort: (sort) => set({ sort }),
      user: null,
      setUser: (user) => set({ user }),
      isGrid: DEFAULT_PERSISTED_STATE.isGrid,
      setIsGrid: (isGrid) => set({ isGrid }),

      selectedBook: DEFAULT_SELECTED_BOOK,
      setSelectedBook: (selectedBook) => set({ selectedBook }),

      selectedChapter: DEFAULT_PERSISTED_STATE.selectedChapter,
      setSelectedChapter: (selectedChapter) => set({ selectedChapter }),

      currentPlan: DEFAULT_PERSISTED_STATE.currentPlan,
      setCurrentPlan: (currentPlan) => set({ currentPlan }),

      theme: DEFAULT_PERSISTED_STATE.theme,
      setTheme: (theme) => set({ theme }),
      version: DEFAULT_PERSISTED_STATE.version,
      setVersion: (version) => set({ version }),
    }),
    {
      name: 'app-storage',
      storage: createJSONStorage(() => AsyncStorage),
      version: 1,
      // Older installs already have this key in AsyncStorage, so normalize
      // the saved payload before merging it into the current store shape.
      migrate: (persistedState) => migrateAppState(persistedState),
      merge: (persistedState, currentState) => ({
        ...currentState,
        ...migrateAppState(persistedState),
      }),
      partialize: partializeAppState,
    },
  ),
);
