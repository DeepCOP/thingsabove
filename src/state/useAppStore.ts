import { DEFAULT_BOOK_ID, getCanonicalBookIdByName } from '@/src/bible/books';
import type {
  BibleVersionId,
  BibleVersionInstallState,
  BibleVersionInstallStatus,
  BibleVersionManifestEntry,
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

export type BibleVerseHighlight = {
  bookId: string;
  chapter: number;
  verse: number;
  createdAt: string;
};

type BibleVerseHighlightReference = Pick<BibleVerseHighlight, 'bookId' | 'chapter' | 'verse'>;

export const getBibleVerseHighlightKey = ({
  bookId,
  chapter,
  verse,
}: BibleVerseHighlightReference) => `${bookId}:${chapter}:${verse}`;

type SortOption = 'Recent' | 'Trending';
type ThemeMode = 'light' | 'dark' | 'system';

type ReflectAndShareRequest = {
  progressId: string;
  dayId: string;
  token: string;
};

type AppState = {
  hasCompletedOnboarding: boolean;
  completeOnboarding: () => void;

  missedDays: DevotionalDays[] | null;
  setMissedDays: (days: DevotionalDays[]) => void;
  reflectAndShareRequest: ReflectAndShareRequest | null;
  setReflectAndShareRequest: (request: ReflectAndShareRequest) => void;
  clearReflectAndShareRequest: () => void;
  version: BibleVersionId;
  setVersion: (v: BibleVersionId) => void;
  bibleVersionStates: Partial<Record<BibleVersionId, BibleVersionInstallState>>;
  setBibleVersionState: (
    versionId: BibleVersionId,
    patch: Partial<BibleVersionInstallState>,
  ) => void;
  clearBibleVersionState: (versionId: BibleVersionId) => void;
  savedBibleVersions: Partial<Record<BibleVersionId, BibleVersionManifestEntry>>;
  saveBibleVersion: (version: BibleVersionManifestEntry) => void;
  forgetBibleVersion: (versionId: BibleVersionId) => void;

  isGrid: boolean;
  setIsGrid: (isGrid: boolean) => void;

  sort: SortOption;
  setSort: (s: SortOption) => void;

  user: any;
  setUser: (u: any) => void;

  selectedBook: SelectedBibleBook;
  setSelectedBook: (book: SelectedBibleBook) => void;
  bibleVerseHighlights: Record<string, BibleVerseHighlight>;
  toggleBibleVerseHighlights: (references: BibleVerseHighlightReference[]) => void;

  currentPlan: any;
  setCurrentPlan: (plan: any) => void;

  theme: ThemeMode;
  setTheme: (t: ThemeMode) => void;
};

type PersistedAppState = Pick<
  AppState,
  | 'user'
  | 'hasCompletedOnboarding'
  | 'isGrid'
  | 'sort'
  | 'version'
  | 'bibleVersionStates'
  | 'savedBibleVersions'
  | 'selectedBook'
  | 'bibleVerseHighlights'
  | 'currentPlan'
  | 'theme'
>;

const DEFAULT_SELECTED_BOOK: SelectedBibleBook = {
  bookId: DEFAULT_BOOK_ID,
  chapter: 1,
};

const DEFAULT_PERSISTED_STATE: PersistedAppState = {
  user: null,
  hasCompletedOnboarding: false,
  isGrid: false,
  sort: 'Recent',
  version: 'KJV',
  bibleVersionStates: {},
  savedBibleVersions: {},
  selectedBook: DEFAULT_SELECTED_BOOK,
  bibleVerseHighlights: {},
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
    status: value.status === 'downloading' ? 'error' : value.status,
    localUri: typeof value.localUri === 'string' ? value.localUri : undefined,
    installedAt: typeof value.installedAt === 'string' ? value.installedAt : undefined,
    sizeBytes: toPositiveNumber(value.sizeBytes),
    checksum:
      typeof value.checksum === 'string' || value.checksum === null ? value.checksum : undefined,
    error:
      value.status === 'downloading'
        ? 'Download interrupted. Please try again.'
        : typeof value.error === 'string' || value.error === null
          ? value.error
          : undefined,
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

// Persist catalog metadata only. Never persist a reader, bundled loader, or scripture content.
const normalizeSavedBibleVersion = (value: unknown): BibleVersionManifestEntry | null => {
  if (!isRecord(value)) return null;
  const id = normalizeBibleVersionId(value.id);
  const source = value.source ?? 'offline';
  if (
    !id ||
    !['offline', 'youversion', 'esv', 'apiBible'].includes(String(source)) ||
    typeof value.shortLabel !== 'string' ||
    !value.shortLabel.trim() ||
    typeof value.label !== 'string' ||
    !value.label.trim() ||
    (source !== 'offline' &&
      (typeof value.providerBibleId !== 'string' || !value.providerBibleId.trim()))
  ) {
    return null;
  }

  return {
    id,
    source: source as BibleVersionManifestEntry['source'],
    providerBibleId: typeof value.providerBibleId === 'string' ? value.providerBibleId : undefined,
    shortLabel: value.shortLabel,
    label: value.label,
    description: typeof value.description === 'string' ? value.description : '',
    copyright:
      typeof value.copyright === 'string' && value.copyright.trim().length <= 20_000
        ? value.copyright.trim()
        : undefined,
    attributionUrl:
      value.attributionUrl === 'https://www.esv.org/' ||
      value.attributionUrl === 'https://docs.api.bible/' ||
      value.attributionUrl === 'https://www.bible.com/'
        ? value.attributionUrl
        : undefined,
    language: typeof value.language === 'string' ? value.language : null,
    sizeBytes: toPositiveNumber(value.sizeBytes, 0) ?? 0,
    localFilename: typeof value.localFilename === 'string' ? value.localFilename : '',
    isBundled: value.isBundled === true,
    storagePath: typeof value.storagePath === 'string' ? value.storagePath : null,
    downloadUrl: typeof value.downloadUrl === 'string' ? value.downloadUrl : null,
    checksum: typeof value.checksum === 'string' ? value.checksum : null,
    updatedAt: typeof value.updatedAt === 'string' ? value.updatedAt : null,
  };
};

const normalizeSavedBibleVersions = (
  value: unknown,
): Partial<Record<BibleVersionId, BibleVersionManifestEntry>> => {
  if (!isRecord(value)) return {};
  return Object.fromEntries(
    Object.values(value).flatMap((entry) => {
      const normalized = normalizeSavedBibleVersion(entry);
      return normalized ? [[normalized.id, normalized]] : [];
    }),
  );
};

const normalizeBibleVerseHighlights = (value: unknown): Record<string, BibleVerseHighlight> => {
  if (!isRecord(value)) {
    return {};
  }

  const normalizedHighlights: Record<string, BibleVerseHighlight> = {};

  Object.values(value).forEach((entry) => {
    if (!isRecord(entry)) {
      return;
    }

    const rawBookId = typeof entry.bookId === 'string' ? entry.bookId : '';
    const bookId =
      getCanonicalBookIdByName(rawBookId) || (rawBookId.trim() && rawBookId.trim().toUpperCase());
    const chapter = toPositiveNumber(entry.chapter);
    const verse = toPositiveNumber(entry.verse);

    if (!bookId || !chapter || !verse) {
      return;
    }

    const highlight: BibleVerseHighlight = {
      bookId,
      chapter,
      verse,
      createdAt: typeof entry.createdAt === 'string' ? entry.createdAt : '1970-01-01T00:00:00.000Z',
    };

    normalizedHighlights[getBibleVerseHighlightKey(highlight)] = highlight;
  });

  return normalizedHighlights;
};

const partializeAppState = (state: AppState): PersistedAppState => ({
  user: state.user,
  hasCompletedOnboarding: state.hasCompletedOnboarding,
  isGrid: state.isGrid,
  sort: state.sort,
  version: state.version,
  bibleVersionStates: state.bibleVersionStates,
  savedBibleVersions: state.savedBibleVersions,
  selectedBook: state.selectedBook,
  bibleVerseHighlights: state.bibleVerseHighlights,
  currentPlan: state.currentPlan,
  theme: state.theme,
});

const migrateAppState = (persistedState: unknown): PersistedAppState => {
  if (!isRecord(persistedState)) {
    return DEFAULT_PERSISTED_STATE;
  }

  return {
    user: hasOwn(persistedState, 'user') ? persistedState.user : DEFAULT_PERSISTED_STATE.user,
    hasCompletedOnboarding:
      typeof persistedState.hasCompletedOnboarding === 'boolean'
        ? persistedState.hasCompletedOnboarding
        : DEFAULT_PERSISTED_STATE.hasCompletedOnboarding,
    isGrid:
      typeof persistedState.isGrid === 'boolean'
        ? persistedState.isGrid
        : DEFAULT_PERSISTED_STATE.isGrid,
    sort: isSortOption(persistedState.sort) ? persistedState.sort : DEFAULT_PERSISTED_STATE.sort,
    version: normalizeBibleVersionId(persistedState.version) ?? DEFAULT_PERSISTED_STATE.version,
    bibleVersionStates: normalizeBibleVersionStates(persistedState.bibleVersionStates),
    savedBibleVersions: normalizeSavedBibleVersions(persistedState.savedBibleVersions),
    selectedBook: normalizeSelectedBook(persistedState.selectedBook),
    bibleVerseHighlights: normalizeBibleVerseHighlights(persistedState.bibleVerseHighlights),
    currentPlan: hasOwn(persistedState, 'currentPlan')
      ? persistedState.currentPlan
      : DEFAULT_PERSISTED_STATE.currentPlan,
    theme: isThemeMode(persistedState.theme) ? persistedState.theme : DEFAULT_PERSISTED_STATE.theme,
  };
};

export const useAppStore = create<AppState>()(
  persist(
    (set, get) => ({
      hasCompletedOnboarding: DEFAULT_PERSISTED_STATE.hasCompletedOnboarding,
      completeOnboarding: () => set({ hasCompletedOnboarding: true }),

      missedDays: null,
      setMissedDays: (days) => set({ missedDays: days }),
      reflectAndShareRequest: null,
      setReflectAndShareRequest: (reflectAndShareRequest) => set({ reflectAndShareRequest }),
      clearReflectAndShareRequest: () => set({ reflectAndShareRequest: null }),
      sort: DEFAULT_PERSISTED_STATE.sort,
      setSort: (sort) => set({ sort }),

      user: DEFAULT_PERSISTED_STATE.user,
      setUser: (user) => set({ user }),
      isGrid: DEFAULT_PERSISTED_STATE.isGrid,
      setIsGrid: (isGrid) => set({ isGrid }),

      selectedBook: DEFAULT_SELECTED_BOOK,
      setSelectedBook: (selectedBook) => set({ selectedBook }),
      bibleVerseHighlights: DEFAULT_PERSISTED_STATE.bibleVerseHighlights,
      toggleBibleVerseHighlights: (references) =>
        set((state) => {
          const normalizedReferences = references.flatMap((reference) => {
            const bookId =
              getCanonicalBookIdByName(reference.bookId) ||
              (typeof reference.bookId === 'string' && reference.bookId.trim().toUpperCase());
            const chapter = toPositiveNumber(reference.chapter);
            const verse = toPositiveNumber(reference.verse);

            if (!bookId || !chapter || !verse) {
              return [];
            }

            return [{ bookId, chapter, verse }];
          });

          if (normalizedReferences.length === 0) {
            return {};
          }

          const shouldRemove = normalizedReferences.every(
            (reference) => state.bibleVerseHighlights[getBibleVerseHighlightKey(reference)],
          );
          const nextHighlights = { ...state.bibleVerseHighlights };

          if (shouldRemove) {
            normalizedReferences.forEach((reference) => {
              delete nextHighlights[getBibleVerseHighlightKey(reference)];
            });
          } else {
            const createdAt = new Date().toISOString();

            normalizedReferences.forEach((reference) => {
              const key = getBibleVerseHighlightKey(reference);

              nextHighlights[key] = {
                ...reference,
                createdAt: nextHighlights[key]?.createdAt ?? createdAt,
              };
            });
          }

          return { bibleVerseHighlights: nextHighlights };
        }),

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
      savedBibleVersions: DEFAULT_PERSISTED_STATE.savedBibleVersions,
      saveBibleVersion: (version) => {
        const metadata = normalizeSavedBibleVersion(version);
        if (!metadata) return;
        if (JSON.stringify(get().savedBibleVersions[metadata.id]) === JSON.stringify(metadata))
          return;
        set((state) => ({
          savedBibleVersions: { ...state.savedBibleVersions, [metadata.id]: metadata },
        }));
      },
      forgetBibleVersion: (versionId) =>
        set((state) => {
          if (!state.savedBibleVersions[versionId]) return state;
          const nextVersions = { ...state.savedBibleVersions };
          delete nextVersions[versionId];
          return { savedBibleVersions: nextVersions };
        }),
    }),
    {
      name: 'app-storage',
      version: 5,
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
