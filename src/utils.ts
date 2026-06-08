import type { DayItemsProgress, ParsedVerse } from '@/src/types/types';
import * as Notifications from 'expo-notifications';
import { useEffect, useState } from 'react';
import { Linking } from 'react-native';
import { NOTIFICATION_TYPES } from './types/notifications';

const normalizeScriptureBook = (value: string) =>
  value.replace(/_/g, ' ').replace(/\s+/g, ' ').trim();

export function parseVerseRef(ref: string): ParsedVerse | null {
  try {
    const normalizedRef = ref.trim();
    if (!normalizedRef) return null;

    // Matches:
    // "Song of Solomon 2:1-4"
    // "1 Peter 1:3"
    // "Song_of_Solomon 2:1"
    const verseMatch = normalizedRef.match(/^(.+?)\s+(\d+):(\d+)(?:-(\d+))?$/);
    if (verseMatch) {
      const [, rawBook, chapter, verseStart, verseEnd] = verseMatch;

      return {
        book: normalizeScriptureBook(rawBook),
        scope: 'verse',
        chapter: Number(chapter),
        verseStart: Number(verseStart),
        verseEnd: verseEnd ? Number(verseEnd) : undefined,
      };
    }

    // Matches:
    // "John 3"
    // "1 Peter 2"
    const chapterMatch = normalizedRef.match(/^(.+?)\s+(\d+)$/);
    if (chapterMatch) {
      const [, rawBook, chapter] = chapterMatch;

      return {
        book: normalizeScriptureBook(rawBook),
        scope: 'chapter',
        chapter: Number(chapter),
      };
    }

    // Matches:
    // "John"
    // "Song_of_Solomon"
    return {
      book: normalizeScriptureBook(normalizedRef),
      scope: 'book',
    };
  } catch {
    return null;
  }
}

export function getVerseNumbersFromRange(start?: number | null, end?: number | null) {
  if (!Number.isFinite(start) || (start ?? 0) <= 0) return [];

  const safeStart = Math.max(1, Math.floor(start as number));
  const safeEnd = Number.isFinite(end) ? Math.max(safeStart, Math.floor(end as number)) : safeStart;

  return Array.from({ length: safeEnd - safeStart + 1 }, (_, index) => safeStart + index);
}

export function getVerseRangeLabels(verseNumbers: number[]) {
  const normalized = [...new Set(verseNumbers)]
    .filter((value) => Number.isFinite(value) && value > 0)
    .sort((a, b) => a - b);

  if (normalized.length === 0) return [];

  const ranges: string[] = [];
  let start = normalized[0];
  let end = normalized[0];

  for (let index = 1; index < normalized.length; index += 1) {
    const current = normalized[index];
    if (current === end + 1) {
      end = current;
      continue;
    }

    ranges.push(start === end ? `${start}` : `${start}-${end}`);
    start = current;
    end = current;
  }

  ranges.push(start === end ? `${start}` : `${start}-${end}`);
  return ranges;
}

export const getNumericPrefix = (key?: string | null) => {
  if (!key) return 0;
  const match = key.match(/^(\d+)/);
  return match ? Number(match[0]) : 0;
};

export const sortByItemKey = (a?: string | null, b?: string | null) => {
  const A = (a ?? '').toLowerCase();
  const B = (b ?? '').toLowerCase();

  // 'main' always comes first
  if (A === 'main' && B !== 'main') return -1;
  if (B === 'main' && A !== 'main') return 1;

  const na = getNumericPrefix(a);
  const nb = getNumericPrefix(b);

  if (na === nb) {
    return A.localeCompare(B);
  }

  return na - nb;
};

const DAY_ITEM_TYPE_ORDER: Record<string, number> = {
  devotional: 0,
  scripture: 1,
  comment: 2,
};

export const sortDayItems = (
  a: Pick<DayItemsProgress, 'item_key' | 'item_type'>,
  b: Pick<DayItemsProgress, 'item_key' | 'item_type'>,
) => {
  const typeOrder =
    (DAY_ITEM_TYPE_ORDER[a.item_type ?? ''] ?? Number.MAX_SAFE_INTEGER) -
    (DAY_ITEM_TYPE_ORDER[b.item_type ?? ''] ?? Number.MAX_SAFE_INTEGER);

  if (typeOrder !== 0) {
    return typeOrder;
  }

  return sortByItemKey(a.item_key, b.item_key);
};

export function useDebounce<T>(value: T, delay = 500) {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const handler = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(handler);
  }, [value, delay]);

  return debouncedValue;
}

export function isValidEmail(email: string) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

export function incrementPlanCompletions(item: unknown, planId: string) {
  if (!item || typeof item !== 'object') return item;

  const planItem = item as {
    id?: string | null;
    completions?: number | null;
  };

  if (planItem.id !== planId) return item;

  return {
    ...planItem,
    completions: Math.max(0, (planItem.completions ?? 0) + 1),
  };
}

export function incrementPlanCompletionsInInfiniteData(data: unknown, planId: string) {
  if (!data || typeof data !== 'object') return data;

  const typed = data as { pages?: unknown[]; pageParams?: unknown[] };
  if (!Array.isArray(typed.pages)) return data;

  return {
    ...typed,
    pages: typed.pages.map((page) => {
      if (!page || typeof page !== 'object') return page;

      const typedPage = page as { items?: unknown[] };
      if (!Array.isArray(typedPage.items)) return page;

      return {
        ...typedPage,
        items: typedPage.items.map((item) => incrementPlanCompletions(item, planId)),
      };
    }),
  };
}

export function getAvatarInitials(first_name?: string | null, last_name?: string | null) {
  const firstInitial = first_name?.trim()?.[0] ?? '';
  const lastInitial = last_name?.trim()?.[0] ?? '';

  if (firstInitial && lastInitial) {
    return `${firstInitial}${lastInitial}`.toUpperCase();
  }

  if (firstInitial) {
    return firstInitial.toUpperCase();
  }

  if (lastInitial) {
    return lastInitial.toUpperCase();
  }

  return 'U';
}

type DisplayNameOptions = {
  isAnonymous?: boolean;
  firstName?: string | null;
  lastName?: string | null;
  anonymousLabel?: string;
  fallbackLabel?: string;
};

export function getDisplayName({
  isAnonymous = false,
  firstName,
  lastName,
  anonymousLabel = 'Anonymous',
  fallbackLabel = 'Member',
}: DisplayNameOptions) {
  if (isAnonymous) {
    return anonymousLabel;
  }

  const name = [firstName, lastName].filter(Boolean).join(' ').trim();
  return name || fallbackLabel;
}

export function getAvatarNameParts({
  isAnonymous = false,
  firstName,
  lastName,
  anonymousLabel = 'Anonymous',
  fallbackLabel = 'Member',
}: DisplayNameOptions) {
  if (isAnonymous) {
    return { firstName: anonymousLabel, lastName: undefined };
  }

  if (firstName) {
    return { firstName, lastName: lastName ?? undefined };
  }

  if (lastName) {
    return { firstName: lastName, lastName: undefined };
  }

  return { firstName: fallbackLabel, lastName: undefined };
}

export async function openExternalUrl(url?: string | null) {
  if (!url) return false;

  const canOpen = await Linking.canOpenURL(url);
  if (!canOpen) return false;

  await Linking.openURL(url);
  return true;
}

type NotificationRoute =
  | string
  | {
      pathname: string;
      params: Record<string, string>;
    };

const APP_ROUTE_PREFIX = '/app';
const DEFAULT_NOTIFICATION_ROUTE = `${APP_ROUTE_PREFIX}/notifications`;
const LEGACY_APP_ROUTE_PREFIXES = [
  '/(auth)',
  '/(tabs)',
  '/about-details',
  '/accept_friend',
  '/add_friend',
  '/bible',
  '/church',
  '/confirm-email',
  '/devotional_detail',
  '/friends',
  '/invite',
  '/notifications',
  '/onboarding',
  '/plan_progress',
  '/PlansTab',
  '/prayer',
  '/profile',
  '/scripture_notes',
  '/search',
  '/settings',
  '/signin',
  '/signup',
];

function normalizeAppRoute(route: string) {
  if (route === APP_ROUTE_PREFIX || route.startsWith(`${APP_ROUTE_PREFIX}/`)) {
    return route;
  }

  if (route === '/') {
    return APP_ROUTE_PREFIX;
  }

  const isLegacyAppRoute = LEGACY_APP_ROUTE_PREFIXES.some(
    (prefix) => route === prefix || route.startsWith(`${prefix}/`),
  );

  return isLegacyAppRoute ? `${APP_ROUTE_PREFIX}${route}` : DEFAULT_NOTIFICATION_ROUTE;
}

function getNotificationDataString(data: Record<string, unknown>, key: string) {
  const value = data[key];
  if (typeof value !== 'string') return null;

  const trimmedValue = value.trim();
  return trimmedValue.length > 0 ? trimmedValue : null;
}

function getNotificationDataNumberParam(data: Record<string, unknown>, key: string) {
  const value = data[key];

  if (typeof value === 'number') {
    return Number.isFinite(value) && value > 0 ? String(value) : null;
  }

  if (typeof value === 'string') {
    const trimmedValue = value.trim();
    const parsedValue = Number(trimmedValue);
    return Number.isFinite(parsedValue) && parsedValue > 0 ? trimmedValue : null;
  }

  return null;
}

function getGroupDayCompletedRoute(data: Record<string, unknown>): NotificationRoute {
  const progressId = getNotificationDataString(data, 'progress_id');
  if (!progressId) return DEFAULT_NOTIFICATION_ROUTE;

  const groupId = getNotificationDataString(data, 'group_id');
  const planId = getNotificationDataString(data, 'plan_id');
  const dayId = getNotificationDataString(data, 'day_id');
  const dayNumber = getNotificationDataNumberParam(data, 'day_number');

  return {
    pathname: '/app/plan_progress/[progressId]',
    params: {
      progressId,
      ...(groupId ? { groupId } : {}),
      ...(planId ? { planId } : {}),
      ...(dayId ? { dayId } : {}),
      ...(dayNumber ? { dayNumber } : {}),
    },
  };
}

export function getRouteFromNotificationResponse(
  response: Notifications.NotificationResponse,
): NotificationRoute {
  const data = response.notification.request.content.data;
  const type = getNotificationDataString(data, 'type');

  if (type === NOTIFICATION_TYPES.GROUP_DAY_COMPLETED) {
    return getGroupDayCompletedRoute(data);
  }

  const route = getNotificationDataString(data, 'route');

  if (!route) {
    return DEFAULT_NOTIFICATION_ROUTE;
  }

  if (!route.startsWith('/') || route.startsWith('//')) {
    return DEFAULT_NOTIFICATION_ROUTE;
  }

  return normalizeAppRoute(route);
}
