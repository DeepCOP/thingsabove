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
import {
  fetchYouVersionAttribution,
  fetchYouVersionCatalog,
  requestYouVersion,
  type YouVersionAttribution,
} from '@/src/lib/youVersionClient';
import { fetchEsvCatalog, requestEsv } from '@/src/lib/esvClient';
import { fetchApiBibleCatalog, requestApiBible } from '@/src/lib/apiBibleClient';
import { isOnlineBibleVersion } from '@/src/bible/sources';
import {
  installBibleVersion,
  isBibleVersionInstalled,
  removeBibleVersion,
} from '@/src/lib/bibleVersionService';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
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

export type BibleVersionListItem = BibleVersionManifestEntry & {
  installState?: BibleVersionInstallState;
  isInstalled: boolean;
  isOnline: boolean;
  isAdded: boolean;
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
  addVersion: (versionId: BibleVersionId) => Promise<void>;
  removeVersion: (versionId: BibleVersionId) => Promise<void>;
  versions: BibleVersionListItem[];
  isVersionInstalled: (versionId: BibleVersionId) => boolean;
  loadingVersionId: BibleVersionId | null;
  versionsCatalogLoading: boolean;
  versionsCatalogError: string | null;
  refreshVersionsCatalog: () => Promise<void>;
  loadVersionAttribution: (versionId: BibleVersionId) => Promise<void>;
  bookNames: string[];
};

const BibleContext = createContext<BibleContextType | null>(null);
const defaultVersion = BIBLE_VERSION_MANIFEST[DEFAULT_BIBLE_VERSION_ID];
const defaultAdapter = createBibleReadingAdapter(defaultVersion);
type CatalogSource = 'offline' | 'youversion' | 'esv' | 'apiBible';

export function BibleProvider({ children }: { children: ReactNode }) {
  const { session, loading: authLoading } = useAuth();
  const authenticatedUserId = session?.user.id ?? null;
  const catalogRequestId = useRef(0);
  const persistedVersion = useAppStore((state) => state.version);
  const setPersistedVersion = useAppStore((state) => state.setVersion);
  const bibleVersionStates = useAppStore((state) => state.bibleVersionStates);
  const setBibleVersionState = useAppStore((state) => state.setBibleVersionState);
  const clearBibleVersionState = useAppStore((state) => state.clearBibleVersionState);
  const savedBibleVersions = useAppStore((state) => state.savedBibleVersions);
  const saveBibleVersion = useAppStore((state) => state.saveBibleVersion);
  const forgetBibleVersion = useAppStore((state) => state.forgetBibleVersion);
  const installationRequests = useRef(new Map<BibleVersionId, Promise<void>>());
  const removalRequests = useRef(new Map<BibleVersionId, Promise<void>>());
  const attributionRequests = useRef(new Map<BibleVersionId, Promise<void>>());
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
  const [versionAttributions, setVersionAttributions] = useState<
    Partial<Record<BibleVersionId, YouVersionAttribution>>
  >({});
  const [versionsCatalogLoading, setVersionsCatalogLoading] = useState(true);
  const [versionsCatalogError, setVersionsCatalogError] = useState<string | null>(null);

  const availableVersions = useMemo(() => {
    const saved = Object.values(savedBibleVersions).filter(
      (entry): entry is BibleVersionManifestEntry => Boolean(entry),
    );
    // Older installations saved only the file state. Keep those files accessible
    // when upgrading without a network connection, until their catalog metadata arrives.
    const installedFallbacks = Object.entries(bibleVersionStates).flatMap(([id, state]) =>
      state?.status === 'downloaded' && state.localUri
        ? [
            {
              id,
              source: 'offline' as const,
              shortLabel: id,
              label: id,
              description: 'Downloaded Bible version.',
              sizeBytes: state.sizeBytes ?? 0,
              localFilename: state.localUri.split('/').at(-1) ?? '',
              isBundled: false,
            },
          ]
        : [],
    );
    return mergeBibleVersionCatalog([...catalogVersions, ...saved, ...installedFallbacks])
      .map((entry) => ({ ...entry, ...versionAttributions[entry.id] }))
      .filter((entry) => authenticatedUserId || !isOnlineBibleVersion(entry));
  }, [
    authenticatedUserId,
    bibleVersionStates,
    catalogVersions,
    savedBibleVersions,
    versionAttributions,
  ]);

  const versionMap = useMemo(
    () =>
      availableVersions.reduce<Record<BibleVersionId, BibleVersionManifestEntry>>((acc, entry) => {
        acc[entry.id] = entry;
        return acc;
      }, {}),
    [availableVersions],
  );

  const loadVersionAttribution = useCallback(
    async (versionId: BibleVersionId) => {
      const entry = versionMap[versionId];
      if (!entry || entry.copyright || entry.source !== 'youversion' || !entry.providerBibleId) {
        return;
      }
      const existing = attributionRequests.current.get(versionId);
      if (existing) return existing;
      const pending = fetchYouVersionAttribution(entry.providerBibleId)
        .then((attribution) => {
          setVersionAttributions((previous) => ({ ...previous, [versionId]: attribution }));
          if (useAppStore.getState().savedBibleVersions[versionId]) {
            saveBibleVersion({ ...entry, ...attribution });
          }
        })
        .finally(() => {
          attributionRequests.current.delete(versionId);
        });
      attributionRequests.current.set(versionId, pending);
      return pending;
    },
    [saveBibleVersion, versionMap],
  );

  const refreshVersionsCatalog = useCallback(async () => {
    if (authLoading) return;
    const requestId = ++catalogRequestId.current;
    setVersionsCatalogLoading(true);

    const requests: Promise<BibleVersionManifestEntry[]>[] = [fetchBibleVersionCatalog()];
    const requestSources: CatalogSource[] = ['offline'];
    if (authenticatedUserId) {
      requests.push(fetchYouVersionCatalog(), fetchEsvCatalog(), fetchApiBibleCatalog());
      requestSources.push('youversion', 'esv', 'apiBible');
    }
    const results = await Promise.allSettled(requests);
    if (requestId !== catalogRequestId.current) return;
    setCatalogVersions((previous) =>
      results.flatMap((result, index) =>
        result.status === 'fulfilled'
          ? result.value
          : previous.filter((entry) => (entry.source ?? 'offline') === requestSources[index]),
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
  }, [authLoading, authenticatedUserId]);

  useEffect(() => {
    if (authLoading) return;
    void refreshVersionsCatalog();
    return () => {
      catalogRequestId.current += 1;
    };
  }, [authLoading, refreshVersionsCatalog]);

  const isVersionInstalled = useCallback(
    (versionId: BibleVersionId) =>
      isBibleVersionInstalled(versionMap[versionId], bibleVersionStates[versionId]),
    [bibleVersionStates, versionMap],
  );

  useEffect(() => {
    // Existing downloaded versions and the previously selected online translation
    // join My Versions automatically when upgrading to a saved library.
    for (const entry of catalogVersions) {
      if (
        (!entry.isBundled && isVersionInstalled(entry.id)) ||
        (isOnlineBibleVersion(entry) &&
          (Boolean(savedBibleVersions[entry.id]) || entry.id === persistedVersion))
      ) {
        saveBibleVersion(entry);
      }
    }
  }, [catalogVersions, isVersionInstalled, persistedVersion, saveBibleVersion, savedBibleVersions]);

  // The bundled reader can open while the remote download catalog is refreshing.
  const versionToLoad =
    isVersionInstalled(persistedVersion) || isOnlineBibleVersion(versionMap[persistedVersion])
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
            apiBible: requestApiBible,
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

      if (isOnlineBibleVersion(versionMap[versionId]) && !authenticatedUserId) {
        throw new Error('Sign in to use online Bible versions.');
      }

      if (
        !isOnlineBibleVersion(versionMap[versionId]) &&
        !isBibleVersionInstalled(
          versionMap[versionId],
          useAppStore.getState().bibleVersionStates[versionId],
        )
      ) {
        throw new Error(`${versionId} is not installed yet.`);
      }

      if (removalRequests.current.has(versionId)) {
        throw new Error('This version is being removed. Please try again.');
      }
      if (isOnlineBibleVersion(versionMap[versionId])) saveBibleVersion(versionMap[versionId]);

      if (versionId === persistedVersion && versionId === version) {
        if (readerError) retryReader();
        return;
      }

      setPersistedVersion(versionId);
    },
    [
      persistedVersion,
      setPersistedVersion,
      version,
      versionMap,
      readerError,
      retryReader,
      saveBibleVersion,
      authenticatedUserId,
    ],
  );

  const installVersion = useCallback(
    async (versionId: BibleVersionId) => {
      const existing = installationRequests.current.get(versionId);
      if (existing) return existing;
      if (removalRequests.current.has(versionId)) {
        throw new Error('This version is being removed. Please try again.');
      }
      const selectedVersion = versionMap[versionId];
      if (!selectedVersion) {
        throw new Error(`${versionId} is not available right now.`);
      }
      if (isOnlineBibleVersion(selectedVersion)) {
        throw new Error('This translation is available for online reading only.');
      }

      if (
        isBibleVersionInstalled(
          selectedVersion,
          useAppStore.getState().bibleVersionStates[versionId],
        )
      ) {
        return;
      }
      const pending = Promise.resolve().then(async () => {
        setBibleVersionState(versionId, { status: 'downloading', error: null });
        try {
          const installed = await installBibleVersion(selectedVersion);
          saveBibleVersion(selectedVersion);
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
        } finally {
          installationRequests.current.delete(versionId);
        }
      });
      installationRequests.current.set(versionId, pending);
      return pending;
    },
    [saveBibleVersion, setBibleVersionState, versionMap],
  );

  const addVersion = useCallback(
    async (versionId: BibleVersionId) => {
      const selectedVersion = versionMap[versionId];
      if (!selectedVersion) throw new Error(`${versionId} is not available right now.`);
      if (isOnlineBibleVersion(selectedVersion)) {
        if (!authenticatedUserId) throw new Error('Sign in to use online Bible versions.');
        if (removalRequests.current.has(versionId)) {
          throw new Error('This version is being removed. Please try again.');
        }
        saveBibleVersion(selectedVersion);
        return;
      }
      await installVersion(versionId);
    },
    [authenticatedUserId, installVersion, saveBibleVersion, versionMap],
  );

  const removeVersion = useCallback(
    async (versionId: BibleVersionId) => {
      const existing = removalRequests.current.get(versionId);
      if (existing) return existing;
      if (installationRequests.current.has(versionId)) {
        throw new Error('Wait for this version to finish downloading before removing it.');
      }
      const selectedVersion = versionMap[versionId];

      if (!selectedVersion || selectedVersion.isBundled) {
        return;
      }
      const pending = Promise.resolve().then(async () => {
        try {
          if (!isOnlineBibleVersion(selectedVersion)) await removeBibleVersion(selectedVersion);
          if (useAppStore.getState().version === versionId) {
            setPersistedVersion(DEFAULT_BIBLE_VERSION_ID);
          }
          clearBibleVersionState(versionId);
          forgetBibleVersion(versionId);
        } finally {
          removalRequests.current.delete(versionId);
        }
      });
      removalRequests.current.set(versionId, pending);
      return pending;
    },
    [clearBibleVersionState, forgetBibleVersion, setPersistedVersion, versionMap],
  );

  const versions = useMemo(
    () =>
      availableVersions
        .map((entry) => {
          const installState = bibleVersionStates[entry.id];
          const installed = isVersionInstalled(entry.id);
          const isOnline = isOnlineBibleVersion(entry);
          const isAdded = installed || (isOnline && Boolean(savedBibleVersions[entry.id]));

          return {
            ...entry,
            installState,
            isInstalled: installed,
            isOnline,
            isAdded,
            isActive: entry.id === version,
            isDownloading: installState?.status === 'downloading',
            canDelete: isAdded && !entry.isBundled,
          };
        })
        .sort((a, b) => {
          if (a.isActive !== b.isActive) {
            return a.isActive ? -1 : 1;
          }

          const aIsInstalled = a.isAdded;
          const bIsInstalled = b.isAdded;

          if (aIsInstalled !== bIsInstalled) {
            return aIsInstalled ? -1 : 1;
          }

          return a.id.localeCompare(b.id);
        }),
    [availableVersions, bibleVersionStates, isVersionInstalled, savedBibleVersions, version],
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
        addVersion,
        removeVersion,
        versions,
        isVersionInstalled,
        loadingVersionId,
        versionsCatalogLoading,
        versionsCatalogError,
        refreshVersionsCatalog,
        loadVersionAttribution,
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
