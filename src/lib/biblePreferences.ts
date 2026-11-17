export type BiblePreferences = {
  preferredVersionId: string | null;
  savedVersionIds: string[];
};
export type PendingBibleChanges = {
  selection?: { value: string; revision: number };
  versions: Record<string, { added: boolean; revision: number }>;
};
export type LocalBiblePreferences = BiblePreferences & {
  revision: number;
  pending: PendingBibleChanges;
  importDismissed: boolean;
};

export const EMPTY_BIBLE_PREFERENCES: LocalBiblePreferences = {
  preferredVersionId: null,
  savedVersionIds: [],
  revision: 0,
  pending: { versions: {} },
  importDismissed: false,
};

export function changeBiblePreferences(
  current: LocalBiblePreferences,
  change: { preferredVersionId?: string; versionId?: string; added?: boolean },
): LocalBiblePreferences {
  const revision = current.revision + 1;
  const saved = new Set(current.savedVersionIds);
  const pending = { ...current.pending, versions: { ...current.pending.versions } };
  if (change.versionId) {
    if (change.added) saved.add(change.versionId);
    else saved.delete(change.versionId);
    pending.versions[change.versionId] = { added: Boolean(change.added), revision };
  }
  if (change.preferredVersionId) {
    pending.selection = { value: change.preferredVersionId, revision };
  }
  return {
    ...current,
    preferredVersionId: change.preferredVersionId ?? current.preferredVersionId,
    savedVersionIds: [...saved],
    revision,
    pending,
  };
}

// A response acknowledges only the exact edits it sent. New edits made while
// offline or while the request was running always win over the returned snapshot.
export function reconcileBiblePreferences(
  current: LocalBiblePreferences,
  remote: BiblePreferences,
  sent: PendingBibleChanges,
): LocalBiblePreferences {
  const selection =
    current.pending.selection?.revision === sent.selection?.revision
      ? undefined
      : current.pending.selection;
  const versions = Object.fromEntries(
    Object.entries(current.pending.versions).filter(
      ([id, edit]) => edit.revision !== sent.versions[id]?.revision,
    ),
  );
  const saved = new Set(remote.savedVersionIds);
  for (const [id, edit] of Object.entries(versions)) {
    if (edit.added) saved.add(id);
    else saved.delete(id);
  }
  return {
    ...current,
    preferredVersionId: selection?.value ?? remote.preferredVersionId,
    savedVersionIds: [...saved],
    pending: { selection, versions },
  };
}
