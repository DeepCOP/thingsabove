import { normalizeBibleJson } from './books';
import { supabase } from '@/src/lib/supabaseClient';
import type { BibleJSON, BibleVersionId, BibleVersionManifestEntry, RawBibleJSON } from './types';

const BIBLE_VERSION_BUCKET = 'bible_versions';

const loadKjvBible = async () => {
  const module = await import('../../assets/versions/KJV.json');
  return normalizeBibleJson((module.default ?? module) as RawBibleJSON) as BibleJSON;
};

export const BIBLE_VERSION_MANIFEST: Record<BibleVersionId, BibleVersionManifestEntry> = {
  KJV: {
    id: 'KJV',
    shortLabel: 'KJV',
    label: 'King James Version',
    description: 'Included with the app.',
    sizeBytes: 6852878,
    localFilename: 'kjv.json',
    isBundled: true,
    sortOrder: 0,
    loadBundledJson: loadKjvBible,
  },
};

export const DEFAULT_BIBLE_VERSION_ID = 'KJV';

export const BUILT_IN_BIBLE_VERSIONS = Object.values(BIBLE_VERSION_MANIFEST);

export const getBuiltInBibleVersion = (versionId: BibleVersionId) =>
  BIBLE_VERSION_MANIFEST[versionId];

const resolvePublicUrl = (storagePath: string) =>
  supabase.storage.from(BIBLE_VERSION_BUCKET).getPublicUrl(storagePath).data.publicUrl;

type BibleVersionCatalogRow = {
  id: string;
  short_label: string;
  label: string;
  description: string;
  language: string | null;
  size_bytes: number;
  local_filename: string;
  storage_path: string | null;
  public_url: string | null;
  is_bundled: boolean;
  checksum: string | null;
  updated_at: string;
  sort_order: number;
};

const mapBibleVersionRow = (row: BibleVersionCatalogRow): BibleVersionManifestEntry => {
  const builtInVersion = getBuiltInBibleVersion(row.id);

  return {
    id: row.id,
    shortLabel: row.short_label,
    label: row.label,
    description: row.description,
    language: row.language,
    sizeBytes: row.size_bytes,
    localFilename: row.local_filename,
    isBundled: builtInVersion?.isBundled ?? false,
    storagePath: row.storage_path,
    downloadUrl: row.storage_path ? resolvePublicUrl(row.storage_path) : row.public_url,
    checksum: row.checksum,
    updatedAt: row.updated_at,
    sortOrder: row.sort_order,
    loadBundledJson: builtInVersion?.loadBundledJson,
  };
};

export const fetchBibleVersionCatalog = async (): Promise<BibleVersionManifestEntry[]> => {
  const { data, error } = await supabase
    .from('bible_versions')
    .select(
      'id, short_label, label, description, language, size_bytes, local_filename, storage_path, public_url, is_bundled, checksum, updated_at, sort_order',
    )
    .eq('is_enabled', true)
    .order('sort_order', { ascending: true })
    .order('label', { ascending: true });

  if (error) {
    throw error;
  }

  return (data ?? []).map(mapBibleVersionRow);
};

export const mergeBibleVersionCatalog = (remoteVersions: BibleVersionManifestEntry[]) => {
  const merged = new Map<BibleVersionId, BibleVersionManifestEntry>();

  for (const entry of BUILT_IN_BIBLE_VERSIONS) {
    merged.set(entry.id, entry);
  }

  for (const entry of remoteVersions) {
    if (!merged.has(entry.id)) {
      merged.set(entry.id, entry);
    }
  }

  return [...merged.values()].sort((a, b) => {
    const sortOrderDiff =
      (a.sortOrder ?? Number.MAX_SAFE_INTEGER) - (b.sortOrder ?? Number.MAX_SAFE_INTEGER);
    if (sortOrderDiff !== 0) {
      return sortOrderDiff;
    }

    return a.label.localeCompare(b.label);
  });
};
