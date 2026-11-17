import AsyncStorage from '@react-native-async-storage/async-storage';
import { create } from 'zustand';
import { createJSONStorage, persist } from 'zustand/middleware';
import {
  changeBiblePreferences,
  reconcileBiblePreferences,
  EMPTY_BIBLE_PREFERENCES,
  type BiblePreferences,
  type LocalBiblePreferences,
  type PendingBibleChanges,
} from '../lib/biblePreferences';

type State = {
  accounts: Record<string, LocalBiblePreferences>;
  legacy: BiblePreferences | null;
  initialized: boolean;
  initialize: (legacy: BiblePreferences) => void;
  change: (account: string, change: Parameters<typeof changeBiblePreferences>[1]) => void;
  reconcile: (account: string, remote: BiblePreferences, sent: PendingBibleChanges) => void;
  importLegacy: (account: string) => void;
  dismissImport: (account: string) => void;
};

export const useBiblePreferencesStore = create<State>()(
  persist(
    (set) => ({
      accounts: {},
      legacy: null,
      initialized: false,
      initialize: (legacy) =>
        set((state) =>
          state.initialized
            ? state
            : {
                initialized: true,
                legacy,
                accounts: { ...state.accounts, guest: { ...EMPTY_BIBLE_PREFERENCES, ...legacy } },
              },
        ),
      change: (account, change) =>
        set((state) => ({
          accounts: {
            ...state.accounts,
            [account]: changeBiblePreferences(
              state.accounts[account] ?? EMPTY_BIBLE_PREFERENCES,
              change,
            ),
          },
        })),
      reconcile: (account, remote, sent) =>
        set((state) => ({
          accounts: {
            ...state.accounts,
            [account]: reconcileBiblePreferences(
              state.accounts[account] ?? EMPTY_BIBLE_PREFERENCES,
              remote,
              sent,
            ),
          },
        })),
      importLegacy: (account) =>
        set((state) => {
          let next = state.accounts[account] ?? EMPTY_BIBLE_PREFERENCES;
          for (const id of state.legacy?.savedVersionIds ?? []) {
            next = changeBiblePreferences(next, { versionId: id, added: true });
          }
          // Do not replace an already established account preference.
          if (!next.preferredVersionId && state.legacy?.preferredVersionId) {
            next = changeBiblePreferences(next, {
              preferredVersionId: state.legacy.preferredVersionId,
            });
          }
          return { accounts: { ...state.accounts, [account]: { ...next, importDismissed: true } } };
        }),
      dismissImport: (account) =>
        set((state) => ({
          accounts: {
            ...state.accounts,
            [account]: {
              ...(state.accounts[account] ?? EMPTY_BIBLE_PREFERENCES),
              importDismissed: true,
            },
          },
        })),
    }),
    {
      name: 'bible-account-preferences',
      storage: createJSONStorage(() => AsyncStorage),
      partialize: ({ accounts, legacy, initialized }) => ({ accounts, legacy, initialized }),
    },
  ),
);
