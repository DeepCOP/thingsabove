export type BibleVersionId = string;

export type BibleVerse = {
  verse: number;
  text: string;
};

export type BibleChapter = {
  chapter: number;
  verses: BibleVerse[];
};

export type BibleBook = {
  id: string;
  name: string;
  chapters: BibleChapter[];
};

export type BibleJSON = {
  translation: string;
  books: BibleBook[];
};

export type RawBibleJSON = {
  translation: string;
  books: {
    id?: string;
    name?: string;
    chapters: BibleChapter[];
  }[];
};

export type BibleVersionInstallStatus = 'not_downloaded' | 'downloading' | 'downloaded' | 'error';

export type BibleVersionInstallState = {
  status: BibleVersionInstallStatus;
  localUri?: string;
  installedAt?: string;
  sizeBytes?: number;
  checksum?: string | null;
  error?: string | null;
};

export type BibleVersionManifestEntry = {
  id: BibleVersionId;
  shortLabel: string;
  label: string;
  description: string;
  language?: string | null;
  sizeBytes: number;
  localFilename: string;
  isBundled: boolean;
  storagePath?: string | null;
  downloadUrl?: string | null;
  checksum?: string | null;
  updatedAt?: string | null;
  loadBundledJson?: () => Promise<BibleJSON>;
};
