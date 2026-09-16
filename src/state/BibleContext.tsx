import type { BibleBookMetadata, BibleReadingAdapter } from '@/src/bible/adapters/types';
import {
  BIBLE_VERSION_MANIFEST,
  DEFAULT_BIBLE_VERSION_ID,
  fetchBibleVersionCatalog,
  mergeBibleVersionCatalog,
} from '@/src/bible/manifest';
import type {
  BibleVersionId,
  BibleVersionInstallState,
  BibleVersionManifestEntry,
} from '@/src/bible/types';
import { createBibleReadingAdapter } from '@/src/lib/bibleReadingService';
import { fetchYouVersionCatalog, requestYouVersion } from '@/src/lib/youVersionClient';
import { fetchEsvCatalog, requestEsv } from '@/src/lib/esvClient';
import { isOnlineBibleVersion } from '@/src/bible/sources';
import {
  installBibleVersion,
  isBibleVersionInstalled,
  removeBibleVersion,
} from '@/src/lib/bibleVersionService';
import { useAppStore } from '@/src/state/useAppStore';
import { useAuth } from '@/src/state/AuthContext';
import {
  createContext,
  type ReactNode,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';

type BibleVersionListItem = BibleVersionManifestEntry & {
  installState?: BibleVersionInstallState;
  isInstalled: boolean;
  isOnline: boolean;
  isActive: boolean;
  isDownloading: boolean;
  canDelete: boolean;
};

type BibleContextType = {
  adapter: BibleReadingAdapter;
  books: BibleBookMetadata[];
  readerError: string | null;
  retryReader: () => void;
  version: BibleVersionId;
  versionLabel: string;
  setVersion: (versionId: BibleVersionId) => Promise<void>;
  installVersion: (versionId: BibleVersionId) => Promise<void>;
  removeVersion: (versionId: BibleVersionId) => Promise<void>;
  versions: BibleVersionListItem[];
  isVersionInstalled: (versionId: BibleVersionId) => boolean;
  loadingVersionId: BibleVersionId | null;
  versionsCatalogLoading: boolean;
  versionsCatalogError: string | null;
  refreshVersionsCatalog: () => Promise<void>;
  bookNames: string[];
};

const BibleContext = createContext<BibleContextType | null>(null);
const defaultVersion = BIBLE_VERSION_MANIFEST[DEFAULT_BIBLE_VERSION_ID];
const defaultAdapter = createBibleReadingAdapter(defaultVersion);
const catalogSources = ['offline', 'youversion', 'esv'] as const;

export function BibleProvider({ children }: { children: ReactNode }) {
  const { session, loading: authLoading } = useAuth();
  const userId = session?.user.id;
  const catalogRequestId = useRef(0);
  const persistedVersion = useAppStore((state) => state.version);
  const setPersistedVersion = useAppStore((state) => state.setVersion);
  const bibleVersionStates = useAppStore((state) => state.bibleVersionStates);
  const setBibleVersionState = useAppStore((state) => state.setBibleVersionState);
  const clearBibleVersionState = useAppStore((state) => state.clearBibleVersionState);
  const [{ adapter, books }, setReader] = useState<{
    adapter: BibleReadingAdapter;
    books: BibleBookMetadata[];
  }>({ adapter: defaultAdapter, books: [] });
  const version = adapter.versionId;
  const [loadingVersionId, setLoadingVersionId] = useState<BibleVersionId | null>(
    DEFAULT_BIBLE_VERSION_ID,
  );
  const [readerError, setReaderError] = useState<string | null>(null);
  const [readerAttempt, setReaderAttempt] = useState(0);
  const retryReader = useCallback(() => setReaderAttempt((previous) => previous + 1), []);
  const [catalogVersions, setCatalogVersions] = useState<BibleVersionManifestEntry[]>([]);
  const [versionsCatalogLoading, setVersionsCatalogLoading] = useState(true);
  const [versionsCatalogError, setVersionsCatalogError] = useState<string | null>(null);

  const availableVersions = useMemo(
    () => mergeBibleVersionCatalog(catalogVersions),
    [catalogVersions],
  );

  const versionMap = useMemo(
    () =>
      availableVersions.reduce<Record<BibleVersionId, BibleVersionManifestEntry>>((acc, entry) => {
        acc[entry.id] = entry;
        return acc;
      }, {}),
    [availableVersions],
  );

  const refreshVersionsCatalog = useCallback(async () => {
    const requestId = ++catalogRequestId.current;
    setVersionsCatalogLoading(true);

    const results = await Promise.allSettled([
      fetchBibleVersionCatalog(),
      userId ? fetchYouVersionCatalog() : Promise.resolve([]),
      userId ? fetchEsvCatalog() : Promise.resolve([]),
    ]);
    if (requestId !== catalogRequestId.current) return;
    setCatalogVersions((previous) =>
      results.flatMap((result, index) =>
        result.status === 'fulfilled'
          ? result.value
          : previous.filter((entry) => (entry.source ?? 'offline') === catalogSources[index]),
      ),
    );
    const errors = results.flatMap((result) =>
      result.status === 'rejected'
        ? [
            result.reason instanceof Error
              ? result.reason.message
              : 'Unable to refresh the version catalog.',
          ]
        : [],
    );
    setVersionsCatalogError(errors.join(' ') || null);
    setVersionsCatalogLoading(false);
  }, [userId]);

  useEffect(() => {
    if (!authLoading) void refreshVersionsCatalog();
    return () => {
      catalogRequestId.current += 1;
    };
  }, [authLoading, refreshVersionsCatalog]);

  const isVersionInstalled = useCallback(
    (versionId: BibleVersionId) =>
      isBibleVersionInstalled(versionMap[versionId], bibleVersionStates[versionId]),
    [bibleVersionStates, versionMap],
  );

  // The bundled reader can open while the remote download catalog is refreshing.
  const versionToLoad =
    isVersionInstalled(persistedVersion) ||
    (userId && isOnlineBibleVersion(versionMap[persistedVersion]))
      ? versionMap[persistedVersion]
      : defaultVersion;
  const installStateToLoad = bibleVersionStates[versionToLoad.id];

  useEffect(() => {
    if (!versionsCatalogLoading && !versionsCatalogError && versionToLoad.id !== persistedVersion) {
      setPersistedVersion(DEFAULT_BIBLE_VERSION_ID);
    }
  }, [
    persistedVersion,
    setPersistedVersion,
    versionToLoad.id,
    versionsCatalogLoading,
    versionsCatalogError,
  ]);

  useEffect(() => {
    let cancelled = false;
    const nextAdapter =
      versionToLoad.id === DEFAULT_BIBLE_VERSION_ID
        ? defaultAdapter
        : createBibleReadingAdapter(versionToLoad, installStateToLoad, {
            youVersion: requestYouVersion,
            esv: requestEsv,
          });

    setLoadingVersionId(versionToLoad.id);
    setReaderError(null);

    const loadReader = async () => {
      try {
        const nextBooks = await nextAdapter.getBooks();
        if (!cancelled) {
          // Publish metadata and source together so labels cannot get ahead of text.
          setReader({ adapter: nextAdapter, books: nextBooks });
        }
      } catch (error) {
        if (cancelled) return;
        const message =
          error instanceof Error ? error.message : 'Unable to load this Bible version.';

        if (versionToLoad.id === DEFAULT_BIBLE_VERSION_ID || isOnlineBibleVersion(versionToLoad)) {
          if (isOnlineBibleVersion(versionToLoad)) {
            // Keep the requested translation and error together; a network failure
            // must not relabel old text or mark an online version as uninstalled.
            setReader({ adapter: nextAdapter, books: [] });
          }
          setReaderError(message);
          return;
        }

        setBibleVersionState(versionToLoad.id, {
          status: 'not_downloaded',
          localUri: undefined,
          installedAt: undefined,
          sizeBytes: undefined,
          checksum: undefined,
          error: `${message} Please download it again.`,
        });
        setPersistedVersion(DEFAULT_BIBLE_VERSION_ID);
      } finally {
        if (!cancelled) setLoadingVersionId(null);
      }
    };

    void loadReader();
    return () => {
      cancelled = true;
    };
  }, [installStateToLoad, readerAttempt, setBibleVersionState, setPersistedVersion, versionToLoad]);

  const setVersion = useCallback(
    async (versionId: BibleVersionId) => {
      if (!versionMap[versionId]) {
        throw new Error(`${versionId} is not available right now.`);
      }

      if (isOnlineBibleVersion(versionMap[versionId]) && !userId) {
        throw new Error('Sign in to read online translations.');
      }
      if (!isOnlineBibleVersion(versionMap[versionId]) && !isVersionInstalled(versionId)) {
        throw new Error(`${versionId} is not installed yet.`);
      }

      if (versionId === persistedVersion && versionId === version) {
        if (readerError) retryReader();
        return;
      }

      setPersistedVersion(versionId);
    },
    [
      isVersionInstalled,
      persistedVersion,
      setPersistedVersion,
      version,
      versionMap,
      readerError,
      retryReader,
      userId,
    ],
  );

  const installVersion = useCallback(
    async (versionId: BibleVersionId) => {
      const selectedVersion = versionMap[versionId];
      if (!selectedVersion) {
        throw new Error(`${versionId} is not available right now.`);
      }
      if (isOnlineBibleVersion(selectedVersion)) {
        throw new Error('This translation is available for online reading only.');
      }

      if (isVersionInstalled(versionId)) {
        return;
      }

      setBibleVersionState(versionId, {
        status: 'downloading',
        error: null,
      });

      try {
        const installed = await installBibleVersion(selectedVersion);
        setBibleVersionState(versionId, {
          status: 'downloaded',
          localUri: installed.localUri,
          installedAt: new Date().toISOString(),
          sizeBytes: installed.sizeBytes ?? selectedVersion.sizeBytes,
          checksum: installed.checksum ?? selectedVersion.checksum ?? null,
          error: null,
        });
      } catch (error) {
        setBibleVersionState(versionId, {
          status: 'error',
          error: error instanceof Error ? error.message : 'Unable to download this version.',
        });
        throw error;
      }
    },
    [isVersionInstalled, setBibleVersionState, versionMap],
  );

  const removeVersion = useCallback(
    async (versionId: BibleVersionId) => {
      const selectedVersion = versionMap[versionId];

      if (!selectedVersion || !isVersionInstalled(versionId) || selectedVersion.isBundled) {
        return;
      }

      if (persistedVersion === versionId) {
        setPersistedVersion(DEFAULT_BIBLE_VERSION_ID);
      }

      await removeBibleVersion(selectedVersion);
      clearBibleVersionState(versionId);
    },
    [clearBibleVersionState, isVersionInstalled, persistedVersion, setPersistedVersion, versionMap],
  );

  const versions = useMemo(
    () =>
      availableVersions
        .map((entry) => {
          const installState = bibleVersionStates[entry.id];
          const installed = isVersionInstalled(entry.id);
          const isOnline = isOnlineBibleVersion(entry);

          return {
            ...entry,
            installState,
            isInstalled: installed,
            isOnline,
            isActive: entry.id === version,
            isDownloading: installState?.status === 'downloading',
            canDelete: installed && !entry.isBundled && !isOnline,
          };
        })
        .sort((a, b) => {
          if (a.isActive !== b.isActive) {
            return a.isActive ? -1 : 1;
          }

          const aIsInstalled = a.isInstalled;
          const bIsInstalled = b.isInstalled;

          if (aIsInstalled !== bIsInstalled) {
            return aIsInstalled ? -1 : 1;
          }

          return a.id.localeCompare(b.id);
        }),
    [availableVersions, bibleVersionStates, isVersionInstalled, version],
  );

  const bookNames = useMemo(() => books.map((book) => book.name), [books]);

  return (
    <BibleContext.Provider
      value={{
        adapter,
        books,
        readerError,
        retryReader,
        version,
        versionLabel: versionMap[version]?.shortLabel ?? version,
        setVersion,
        installVersion,
        removeVersion,
        versions,
        isVersionInstalled,
        loadingVersionId,
        versionsCatalogLoading,
        versionsCatalogError,
        refreshVersionsCatalog,
        bookNames,
      }}>
      {children}
    </BibleContext.Provider>
  );
}

export const useBible = () => {
  const context = useContext(BibleContext);

  if (!context) {
    throw new Error('useBible must be used within a BibleProvider.');
  }

  return context;
};
