import { useCallback, useEffect, useState } from 'react';
import { AppState } from 'react-native';
import NetInfo from '@react-native-community/netinfo';
import { supabase } from '../lib/supabaseClient';
import {
  EMPTY_BIBLE_PREFERENCES,
  type BiblePreferences,
  type changeBiblePreferences,
} from '../lib/biblePreferences';
import { useBiblePreferencesStore } from '../state/useBiblePreferencesStore';
import { useAppStore } from '../state/useAppStore';

// Provider remounts and manual retries must not let an older write overtake a
// newer one. This queue also spans logout/login transitions in this process.
let preferenceSyncQueue: Promise<unknown> = Promise.resolve();
function serializePreferenceSync(operation: () => Promise<void>) {
  const result = preferenceSyncQueue.then(operation);
  preferenceSyncQueue = result.catch(() => undefined);
  return result;
}

export function useBiblePreferences(userId: string | null) {
  const account = userId ?? 'guest';
  const preferences = useBiblePreferencesStore(
    (state) => state.accounts[account] ?? EMPTY_BIBLE_PREFERENCES,
  );
  const initialized = useBiblePreferencesStore((state) => state.initialized);
  const legacy = useBiblePreferencesStore((state) => state.legacy);
  const [hydrated, setHydrated] = useState(false);
  const [syncError, setSyncError] = useState(false);
  const [syncedAccount, setSyncedAccount] = useState<string | null>(null);
  const [attempt, setAttempt] = useState(0);
  const retrySync = useCallback(() => setAttempt((value) => value + 1), []);

  useEffect(() => {
    const finish = () => {
      if (!useAppStore.persist.hasHydrated() || !useBiblePreferencesStore.persist.hasHydrated())
        return;
      const old = useAppStore.getState();
      useBiblePreferencesStore.getState().initialize({
        preferredVersionId: old.version,
        savedVersionIds: [
          ...new Set([
            ...Object.keys(old.savedBibleVersions),
            ...Object.entries(old.bibleVersionStates)
              .filter(([, state]) => state?.status === 'downloaded')
              .map(([id]) => id),
            ...(old.version !== 'KJV' ? [old.version] : []),
          ]),
        ],
      });
      setHydrated(true);
    };
    const stopApp = useAppStore.persist.onFinishHydration(finish);
    const stopPreferences = useBiblePreferencesStore.persist.onFinishHydration(finish);
    finish();
    return () => {
      stopApp();
      stopPreferences();
    };
  }, []);

  useEffect(() => {
    if (!userId || !hydrated || !initialized) return;
    let stopped = false;
    let running = false;
    let again = false;
    let timer: ReturnType<typeof setTimeout>;
    const sync = async () => {
      if (stopped) return;
      if (running) {
        again = true;
        return;
      }
      running = true;
      try {
        await serializePreferenceSync(async () => {
          if (stopped) return;
          const sent = (
            useBiblePreferencesStore.getState().accounts[userId] ?? EMPTY_BIBLE_PREFERENCES
          ).pending;
          const controller = new AbortController();
          const deadline = setTimeout(() => controller.abort(), 15_000);
          const request = supabase
            .rpc('sync_bible_preferences', {
              p_user_id: userId,
              p_preferred_version_id: sent.selection?.value,
              p_added_version_ids: Object.entries(sent.versions)
                .filter(([, edit]) => edit.added)
                .map(([id]) => id),
              p_removed_version_ids: Object.entries(sent.versions)
                .filter(([, edit]) => !edit.added)
                .map(([id]) => id),
            })
            .abortSignal(controller.signal);
          const { data, error } = await Promise.resolve(request).finally(() =>
            clearTimeout(deadline),
          );
          if (error) throw error;
          if (stopped) return;
          const remote = data as unknown as BiblePreferences;
          if (
            !remote ||
            !Array.isArray(remote.savedVersionIds) ||
            !remote.savedVersionIds.every((id) => typeof id === 'string') ||
            !(remote.preferredVersionId === null || typeof remote.preferredVersionId === 'string')
          ) {
            throw new Error('Invalid Bible preferences response');
          }
          useBiblePreferencesStore.getState().reconcile(userId, remote, sent);
          setSyncedAccount(userId);
          setSyncError(false);
        });
      } catch {
        if (!stopped) setSyncError(true); // The persisted edits remain queued for retry.
      } finally {
        running = false;
        if (again && !stopped) {
          again = false;
          void sync();
        }
      }
    };
    const schedule = () => {
      clearTimeout(timer);
      timer = setTimeout(() => void sync(), 300);
    };
    const unsubscribe = useBiblePreferencesStore.subscribe((next, previous) => {
      if (next.accounts[userId]?.revision !== previous.accounts[userId]?.revision) schedule();
    });
    const stopNetwork = NetInfo.addEventListener((state) => {
      if (state.isConnected && state.isInternetReachable !== false) schedule();
    });
    const appSubscription = AppState.addEventListener('change', (state) => {
      if (state === 'active') schedule();
    });
    const interval = setInterval(() => {
      if (AppState.currentState === 'active') schedule();
    }, 60_000);
    void sync();
    return () => {
      stopped = true;
      clearTimeout(timer);
      clearInterval(interval);
      unsubscribe();
      stopNetwork();
      appSubscription.remove();
    };
  }, [userId, hydrated, initialized, attempt]);

  // After the first successful sync for a signed-in account, merge the versions
  // previously saved on this device into it. importLegacy marks the account as
  // imported (importDismissed), so this runs at most once per account.
  const shouldImport = Boolean(
    userId &&
    syncedAccount === userId &&
    hydrated &&
    legacy &&
    !preferences.importDismissed &&
    (legacy.savedVersionIds.length ||
      (legacy.preferredVersionId && legacy.preferredVersionId !== 'KJV')),
  );
  useEffect(() => {
    if (shouldImport) useBiblePreferencesStore.getState().importLegacy(account);
  }, [shouldImport, account]);

  const change = useCallback(
    (edit: Parameters<typeof changeBiblePreferences>[1]) => {
      if (!hydrated) throw new Error('Bible preferences are still loading. Please try again.');
      useBiblePreferencesStore.getState().change(account, edit);
    },
    [account, hydrated],
  );
  return {
    preferences,
    ready: hydrated && initialized,
    change,
    syncError,
    retrySync,
  };
}
