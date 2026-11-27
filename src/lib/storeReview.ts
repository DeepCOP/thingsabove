import AsyncStorage from '@react-native-async-storage/async-storage';
import * as Application from 'expo-application';
import * as StoreReview from 'expo-store-review';
import { Linking, Platform } from 'react-native';

const STORAGE_KEY = 'store_review_v1';
const DAY_MS = 24 * 60 * 60 * 1000;

// Ask only after the user has gotten real value from the app.
const MIN_COMPLETED_DAYS = 3;
const MIN_DAYS_SINCE_FIRST_SEEN = 3;
const MIN_DAYS_BETWEEN_PROMPTS = 120;
// Give the completion feedback a moment before the system sheet appears.
const PROMPT_DELAY_MS = 1500;
// A completion that synced long after the user acted (e.g. offline queue) is not a good moment.
const MAX_COMPLETION_AGE_MS = 60 * 1000;
const MAX_TRACKED_DAY_KEYS = 200;

const IOS_APP_STORE_ID = '6759932294';
const ANDROID_PACKAGE = 'life.thingsabove';

type StoreReviewState = {
  firstSeenAt: number;
  completedDayKeys: string[];
  lastPromptAt?: number;
  lastPromptVersion?: string;
};

let queue: Promise<void> = Promise.resolve();

async function loadState(): Promise<StoreReviewState> {
  try {
    const raw = await AsyncStorage.getItem(STORAGE_KEY);
    if (raw) {
      const parsed = JSON.parse(raw) as Partial<StoreReviewState>;
      return {
        firstSeenAt: typeof parsed.firstSeenAt === 'number' ? parsed.firstSeenAt : Date.now(),
        completedDayKeys: Array.isArray(parsed.completedDayKeys) ? parsed.completedDayKeys : [],
        lastPromptAt: parsed.lastPromptAt,
        lastPromptVersion: parsed.lastPromptVersion,
      };
    }
  } catch {
    // fall through to a fresh state
  }
  return { firstSeenAt: Date.now(), completedDayKeys: [] };
}

async function saveState(state: StoreReviewState) {
  await AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(state));
}

function isEligible(state: StoreReviewState, now: number, version: string) {
  if (state.completedDayKeys.length < MIN_COMPLETED_DAYS) return false;
  if (now - state.firstSeenAt < MIN_DAYS_SINCE_FIRST_SEEN * DAY_MS) return false;
  if (state.lastPromptVersion === version) return false;
  if (state.lastPromptAt && now - state.lastPromptAt < MIN_DAYS_BETWEEN_PROMPTS * DAY_MS) {
    return false;
  }
  return true;
}

async function handleDayCompleted(dayKey: string, completedAt: number) {
  if (Platform.OS === 'web') return;

  const state = await loadState();
  if (!state.completedDayKeys.includes(dayKey)) {
    state.completedDayKeys = [...state.completedDayKeys, dayKey].slice(-MAX_TRACKED_DAY_KEYS);
  }

  const now = Date.now();
  const version = Application.nativeApplicationVersion ?? '';
  const isFreshCompletion = now - completedAt <= MAX_COMPLETION_AGE_MS;

  if (
    isFreshCompletion &&
    isEligible(state, now, version) &&
    (await StoreReview.isAvailableAsync())
  ) {
    state.lastPromptAt = now;
    state.lastPromptVersion = version;
    await saveState(state);
    setTimeout(() => {
      StoreReview.requestReview().catch(() => undefined);
    }, PROMPT_DELAY_MS);
    return;
  }

  await saveState(state);
}

/**
 * Record that the user finished a plan day and, if the timing rules allow it,
 * show the native App Store / Google Play review sheet.
 * The OS may still decide not to show it (Apple/Google enforce their own quotas).
 */
export function onPlanDayCompleted(dayKey: string, completedAt: number = Date.now()) {
  queue = queue
    .then(() => handleDayCompleted(dayKey, completedAt))
    .catch((error) => console.warn('Store review check failed', error));
}

/** Open the store listing so the user can write a review (used by the Settings row). */
export async function openStoreReviewPage() {
  if (Platform.OS === 'ios') {
    await Linking.openURL(
      `itms-apps://apps.apple.com/app/id${IOS_APP_STORE_ID}?action=write-review`,
    ).catch(() =>
      Linking.openURL(`https://apps.apple.com/app/id${IOS_APP_STORE_ID}?action=write-review`),
    );
    return;
  }

  if (Platform.OS === 'android') {
    await Linking.openURL(`market://details?id=${ANDROID_PACKAGE}`).catch(() =>
      Linking.openURL(`https://play.google.com/store/apps/details?id=${ANDROID_PACKAGE}`),
    );
    return;
  }

  throw new Error('Store review is not supported on this platform');
}
