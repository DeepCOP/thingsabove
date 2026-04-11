import { DEFAULT_BOOK_ID, getCanonicalBookIdByName } from '@/src/bible/books';
import type {
  BibleVersionId,
  BibleVersionInstallState,
  BibleVersionInstallStatus,
} from '@/src/bible/types';
import { DevotionalDays } from '@/src/types/types';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { create } from 'zustand';
import { createJSONStorage, persist } from 'zustand/middleware';

export type SelectedBibleBook = {
  bookId: string;
  chapter: number;
  verseStart?: number;
  verseEnd?: number;
};

type SortOption = 'Recent' | 'Trending';
type ThemeMode = 'light' | 'dark' | 'system';

type AppState = {
  missedDays: DevotionalDays[] | null;
  setMissedDays: (days: DevotionalDays[]) => void;
  version: BibleVersionId;
  setVersion: (v: BibleVersionId) => void;
  bibleVersionStates: Partial<Record<BibleVersionId, BibleVersionInstallState>>;
  setBibleVersionState: (
    versionId: BibleVersionId,
    patch: Partial<BibleVersionInstallState>,
  ) => void;
  clearBibleVersionState: (versionId: BibleVersionId) => void;

  isGrid: boolean;
  setIsGrid: (isGrid: boolean) => void;

  sort: SortOption;
  setSort: (s: SortOption) => void;

  user: any;
  setUser: (u: any) => void;

  selectedBook: SelectedBibleBook;
  setSelectedBook: (book: SelectedBibleBook) => void;

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
  | 'bibleVersionStates'
  | 'selectedBook'
  | 'currentPlan'
  | 'theme'
>;

const DEFAULT_SELECTED_BOOK: SelectedBibleBook = {
  bookId: DEFAULT_BOOK_ID,
  chapter: 1,
};

const DEFAULT_PERSISTED_STATE: PersistedAppState = {
  user: null,
  isGrid: false,
  sort: 'Recent',
  version: 'KJV',
  bibleVersionStates: {},
  selectedBook: DEFAULT_SELECTED_BOOK,
  currentPlan: null,
  theme: 'system',
};

const isRecord = (value: unknown): value is Record<string, unknown> =>
  typeof value === 'object' && value !== null;

const hasOwn = (value: Record<string, unknown>, key: string) =>
  Object.prototype.hasOwnProperty.call(value, key);

const toPositiveNumber = (value: unknown, fallback?: number) => {
  const parsed = Number(value);
  if (!Number.isFinite(parsed) || parsed <= 0) {
    return fallback;
  }

  return parsed;
};

const normalizeBibleVersionId = (value: unknown): BibleVersionId | null => {
  if (typeof value !== 'string') {
    return null;
  }

  const normalized = value.trim().toUpperCase();
  return normalized ? normalized : null;
};

const isSortOption = (value: unknown): value is SortOption =>
  value === 'Recent' || value === 'Trending';

const isThemeMode = (value: unknown): value is ThemeMode =>
  value === 'light' || value === 'dark' || value === 'system';

const isBibleVersionInstallStatus = (value: unknown): value is BibleVersionInstallStatus =>
  value === 'not_downloaded' ||
  value === 'downloading' ||
  value === 'downloaded' ||
  value === 'error';

const normalizeSelectedBook = (value: unknown): SelectedBibleBook => {
  const selectedBook = value as
    | (Partial<SelectedBibleBook> & {
        name?: string;
      })
    | undefined;

  return {
    bookId:
      getCanonicalBookIdByName(selectedBook?.bookId) ||
      (typeof selectedBook?.bookId === 'string' && selectedBook.bookId.trim().toUpperCase()) ||
      getCanonicalBookIdByName(selectedBook?.name) ||
      DEFAULT_BOOK_ID,
    chapter: toPositiveNumber(selectedBook?.chapter, 1) ?? 1,
    verseStart: toPositiveNumber(selectedBook?.verseStart),
    verseEnd: toPositiveNumber(selectedBook?.verseEnd),
  };
};

const normalizeBibleVersionState = (value: unknown): BibleVersionInstallState | null => {
  if (!isRecord(value) || !isBibleVersionInstallStatus(value.status)) {
    return null;
  }

  return {
    status: value.status,
    localUri: typeof value.localUri === 'string' ? value.localUri : undefined,
    installedAt: typeof value.installedAt === 'string' ? value.installedAt : undefined,
    sizeBytes: toPositiveNumber(value.sizeBytes),
    checksum:
      typeof value.checksum === 'string' || value.checksum === null ? value.checksum : undefined,
    error: typeof value.error === 'string' || value.error === null ? value.error : undefined,
  };
};

const normalizeBibleVersionStates = (
  value: unknown,
): Partial<Record<BibleVersionId, BibleVersionInstallState>> => {
  if (!isRecord(value)) {
    return {};
  }

  const normalizedEntries = Object.entries(value).flatMap(([versionId, state]) => {
    const normalizedVersionId = normalizeBibleVersionId(versionId);
    const normalizedState = normalizeBibleVersionState(state);

    if (!normalizedVersionId || !normalizedState) {
      return [];
    }

    return [[normalizedVersionId, normalizedState] as const];
  });

  return Object.fromEntries(normalizedEntries);
};

const partializeAppState = (state: AppState): PersistedAppState => ({
  user: state.user,
  isGrid: state.isGrid,
  sort: state.sort,
  version: state.version,
  bibleVersionStates: state.bibleVersionStates,
  selectedBook: state.selectedBook,
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
    version: normalizeBibleVersionId(persistedState.version) ?? DEFAULT_PERSISTED_STATE.version,
    bibleVersionStates: normalizeBibleVersionStates(persistedState.bibleVersionStates),
    selectedBook: normalizeSelectedBook(persistedState.selectedBook),
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

      user: DEFAULT_PERSISTED_STATE.user,
      setUser: (user) => set({ user }),
      isGrid: DEFAULT_PERSISTED_STATE.isGrid,
      setIsGrid: (isGrid) => set({ isGrid }),

      selectedBook: DEFAULT_SELECTED_BOOK,
      setSelectedBook: (selectedBook) => set({ selectedBook }),

      currentPlan: DEFAULT_PERSISTED_STATE.currentPlan,
      setCurrentPlan: (currentPlan) => set({ currentPlan }),

      theme: DEFAULT_PERSISTED_STATE.theme,
      setTheme: (theme) => set({ theme }),

      version: DEFAULT_PERSISTED_STATE.version,
      setVersion: (version) => set({ version }),
      bibleVersionStates: DEFAULT_PERSISTED_STATE.bibleVersionStates,
      setBibleVersionState: (versionId, patch) =>
        set((state) => ({
          bibleVersionStates: {
            ...state.bibleVersionStates,
            [versionId]: {
              status: 'not_downloaded',
              ...state.bibleVersionStates[versionId],
              ...patch,
            },
          },
        })),
      clearBibleVersionState: (versionId) =>
        set((state) => {
          const nextStates = { ...state.bibleVersionStates };
          delete nextStates[versionId];
          return { bibleVersionStates: nextStates };
        }),
    }),
    {
      name: 'app-storage',
      version: 2,
      storage: createJSONStorage(() => AsyncStorage),
      migrate: (persistedState) => migrateAppState(persistedState),
      merge: (persistedState, currentState) => ({
        ...currentState,
        ...migrateAppState(persistedState),
      }),
      partialize: partializeAppState,
    },
  ),
);
