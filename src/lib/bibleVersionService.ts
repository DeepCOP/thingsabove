import { normalizeBibleJson } from '@/src/bible/books';
import type {
  BibleJSON,
  BibleVersionInstallState,
  BibleVersionManifestEntry,
  RawBibleJSON,
} from '@/src/bible/types';
import { Directory, File, Paths } from 'expo-file-system';

const versionsDirectory = new Directory(Paths.document, 'bible-versions');

const ensureVersionsDirectory = () => {
  versionsDirectory.create({ idempotent: true, intermediates: true });
};

const getVersionFile = (version: BibleVersionManifestEntry) =>
  new File(versionsDirectory, version.localFilename);

export const isBibleVersionInstalled = (
  version?: BibleVersionManifestEntry | null,
  state?: BibleVersionInstallState,
) =>
  version
    ? version.isBundled || (state?.status === 'downloaded' && Boolean(state.localUri))
    : false;

export const installBibleVersion = async (version: BibleVersionManifestEntry) => {
  if (version.isBundled) {
    return {
      localUri: undefined,
      sizeBytes: version.sizeBytes,
      checksum: version.checksum ?? null,
    };
  }

  ensureVersionsDirectory();
  const targetFile = getVersionFile(version);

  if (!version.downloadUrl) {
    throw new Error(`No download URL configured for ${version.id}.`);
  }

  const downloadedFile = await File.downloadFileAsync(version.downloadUrl, targetFile, {
    idempotent: true,
  });

  return {
    localUri: downloadedFile.uri,
    sizeBytes: downloadedFile.size,
    checksum: downloadedFile.md5,
  };
};

export const loadBibleVersion = async (
  version: BibleVersionManifestEntry,
  state?: BibleVersionInstallState,
): Promise<BibleJSON> => {
  if (version.isBundled) {
    if (!version.loadBundledJson) {
      throw new Error(`No bundled loader configured for ${version.id}.`);
    }

    return normalizeBibleJson(await version.loadBundledJson());
  }

  if (!state?.localUri) {
    throw new Error(`${version.id} is not installed yet.`);
  }

  const file = new File(state.localUri);
  if (!file.exists) {
    throw new Error(`${version.id} is missing from device storage.`);
  }

  return normalizeBibleJson(JSON.parse(await file.text()) as RawBibleJSON);
};

export const removeBibleVersion = async (version: BibleVersionManifestEntry) => {
  if (version.isBundled) {
    return;
  }

  const file = getVersionFile(version);
  if (file.exists) {
    file.delete();
  }
};

export const formatBibleVersionSize = (sizeBytes: number) => {
  if (sizeBytes < 1024) return `${sizeBytes} B`;
  if (sizeBytes < 1024 * 1024) return `${(sizeBytes / 1024).toFixed(1)} KB`;
  return `${(sizeBytes / (1024 * 1024)).toFixed(1)} MB`;
};
