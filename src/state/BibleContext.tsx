import { normalizeBibleJson } from '@/src/bible/books';
import {
  DEFAULT_BIBLE_VERSION_ID,
  fetchBibleVersionCatalog,
  mergeBibleVersionCatalog,
} from '@/src/bible/manifest';
import type {
  BibleJSON,
  BibleVersionId,
  BibleVersionInstallState,
  BibleVersionManifestEntry,
  RawBibleJSON,
} from '@/src/bible/types';
import {
  installBibleVersion,
  isBibleVersionInstalled,
  loadBibleVersion,
  removeBibleVersion,
} from '@/src/lib/bibleVersionService';
import { useAppStore } from '@/src/state/useAppStore';
import {
  createContext,
  type ReactNode,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from 'react';
import kjv from '../../assets/versions/KJV.json';

type BibleVersionListItem = BibleVersionManifestEntry & {
  installState?: BibleVersionInstallState;
  isInstalled: boolean;
  isActive: boolean;
  isDownloading: boolean;
  canDelete: boolean;
};

type BibleContextType = {
  bible: BibleJSON;
  version: BibleVersionId;
  setVersion: (versionId: BibleVersionId) => Promise<void>;
  installVersion: (versionId: BibleVersionId) => Promise<void>;
  removeVersion: (versionId: BibleVersionId) => Promise<void>;
  installedVersionIds: BibleVersionId[];
  versions: BibleVersionListItem[];
  isVersionInstalled: (versionId: BibleVersionId) => boolean;
  selectNextInstalledVersion: () => Promise<void>;
  loadingVersionId: BibleVersionId | null;
  versionsCatalogLoading: boolean;
  versionsCatalogError: string | null;
  bookNames: string[];
};

const BibleContext = createContext<BibleContextType | null>(null);
const defaultBible = normalizeBibleJson(kjv as RawBibleJSON);

export function BibleProvider({ children }: { children: ReactNode }) {
  const persistedVersion = useAppStore((state) => state.version);
  const setPersistedVersion = useAppStore((state) => state.setVersion);
  const bibleVersionStates = useAppStore((state) => state.bibleVersionStates);
  const setBibleVersionState = useAppStore((state) => state.setBibleVersionState);
  const clearBibleVersionState = useAppStore((state) => state.clearBibleVersionState);
  const [bible, setBible] = useState<BibleJSON>(defaultBible);
  const [version, setVersionState] = useState<BibleVersionId>(DEFAULT_BIBLE_VERSION_ID);
  const [loadingVersionId, setLoadingVersionId] = useState<BibleVersionId | null>(null);
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
    setVersionsCatalogLoading(true);

    try {
      const remoteVersions = await fetchBibleVersionCatalog();
      setCatalogVersions(remoteVersions);
      setVersionsCatalogError(null);
    } catch (error) {
      setVersionsCatalogError(
        error instanceof Error
          ? error.message
          : 'Unable to refresh the Bible version catalog right now.',
      );
    } finally {
      setVersionsCatalogLoading(false);
    }
  }, []);

  useEffect(() => {
    void refreshVersionsCatalog();
  }, [refreshVersionsCatalog]);

  const isVersionInstalled = useCallback(
    (versionId: BibleVersionId) =>
      isBibleVersionInstalled(versionMap[versionId], bibleVersionStates[versionId]),
    [bibleVersionStates, versionMap],
  );

  const hydrateVersion = useCallback(
    async (versionId: BibleVersionId) => {
      const selectedVersion = versionMap[versionId];

      if (!selectedVersion) {
        if (versionId !== DEFAULT_BIBLE_VERSION_ID) {
          setBibleVersionState(versionId, {
            status: 'not_downloaded',
            localUri: undefined,
            installedAt: undefined,
            sizeBytes: undefined,
            checksum: undefined,
            error: 'This Bible version is no longer available.',
          });
          setPersistedVersion(DEFAULT_BIBLE_VERSION_ID);
        }

        setBible(defaultBible);
        setVersionState(DEFAULT_BIBLE_VERSION_ID);
        setLoadingVersionId(null);
        return;
      }

      if (selectedVersion.isBundled) {
        setBible(defaultBible);
        setVersionState(selectedVersion.id);
        setLoadingVersionId(null);
        return;
      }

      setLoadingVersionId(versionId);

      try {
        const nextBible = await loadBibleVersion(selectedVersion, bibleVersionStates[versionId]);
        setBible(nextBible);
        setVersionState(selectedVersion.id);
      } catch (error) {
        const message =
          error instanceof Error ? error.message : 'Unable to load this Bible version.';

        setBibleVersionState(versionId, {
          status: 'not_downloaded',
          localUri: undefined,
          installedAt: undefined,
          sizeBytes: undefined,
          checksum: undefined,
          error: `${message} Please download it again.`,
        });
        setPersistedVersion(DEFAULT_BIBLE_VERSION_ID);
        setBible(defaultBible);
        setVersionState(DEFAULT_BIBLE_VERSION_ID);
      } finally {
        setLoadingVersionId(null);
      }
    },
    [bibleVersionStates, setBibleVersionState, setPersistedVersion, versionMap],
  );

  useEffect(() => {
    if (versionsCatalogLoading) {
      return;
    }

    const nextVersion = isVersionInstalled(persistedVersion)
      ? persistedVersion
      : DEFAULT_BIBLE_VERSION_ID;

    if (nextVersion !== persistedVersion) {
      setPersistedVersion(DEFAULT_BIBLE_VERSION_ID);
    }

    void hydrateVersion(nextVersion);
  }, [
    hydrateVersion,
    isVersionInstalled,
    persistedVersion,
    setPersistedVersion,
    versionsCatalogLoading,
  ]);

  const setVersion = useCallback(
    async (versionId: BibleVersionId) => {
      if (!versionMap[versionId]) {
        throw new Error(`${versionId} is not available right now.`);
      }

      if (!isVersionInstalled(versionId)) {
        throw new Error(`${versionId} is not installed yet.`);
      }

      if (versionId === persistedVersion && versionId === version) {
        return;
      }

      setPersistedVersion(versionId);
    },
    [isVersionInstalled, persistedVersion, setPersistedVersion, version, versionMap],
  );

  const installVersion = useCallback(
    async (versionId: BibleVersionId) => {
      const selectedVersion = versionMap[versionId];
      if (!selectedVersion) {
        throw new Error(`${versionId} is not available right now.`);
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

  const installedVersionIds = useMemo(
    () =>
      availableVersions.filter((entry) => isVersionInstalled(entry.id)).map((entry) => entry.id),
    [availableVersions, isVersionInstalled],
  );

  const selectNextInstalledVersion = useCallback(async () => {
    if (installedVersionIds.length <= 1) {
      return;
    }

    const currentIndex = installedVersionIds.indexOf(version);
    const nextVersion =
      installedVersionIds[(currentIndex + 1) % installedVersionIds.length] ??
      installedVersionIds[0];

    if (nextVersion && nextVersion !== version) {
      await setVersion(nextVersion);
    }
  }, [installedVersionIds, setVersion, version]);

  const versions = useMemo(
    () =>
      availableVersions.map((entry) => {
        const installState = bibleVersionStates[entry.id];
        const installed = isVersionInstalled(entry.id);

        return {
          ...entry,
          installState,
          isInstalled: installed,
          isActive: entry.id === version,
          isDownloading: installState?.status === 'downloading',
          canDelete: installed && !entry.isBundled,
        };
      }),
    [availableVersions, bibleVersionStates, isVersionInstalled, version],
  );

  const bookNames = useMemo(() => bible.books.map((book) => book.name), [bible.books]);

  return (
    <BibleContext.Provider
      value={{
        bible,
        version,
        setVersion,
        installVersion,
        removeVersion,
        installedVersionIds,
        versions,
        isVersionInstalled,
        selectNextInstalledVersion,
        loadingVersionId,
        versionsCatalogLoading,
        versionsCatalogError,
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
