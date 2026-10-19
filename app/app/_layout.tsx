import { useTranslation } from 'react-i18next';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import { consumePendingOAuthReturnTo } from '@/src/lib/oauthReturnTo';
import { useTheme } from '@react-navigation/native';
import { Href, Redirect, Stack, usePathname, useRouter } from 'expo-router';
import { useEffect, useState } from 'react';
import { StyleSheet } from 'react-native';

import { useAuth } from '@/src/state/AuthContext';
import { usePushNotifications } from '@/src/hooks/usePushNotifications';
import { useAppStore } from '@/src/state/useAppStore';

const APP_HOME = '/app/(tabs)/PlansTab' as Href;
const APP_ONBOARDING = '/app/onboarding' as Href;

const getRoutePathname = (href: string) => href.split('?')[0] ?? href;

export default function AppLayout() {
  const { t } = useTranslation('app');
  const { session } = useAuth();
  const { colors } = useTheme();
  const pathname = usePathname();
  const router = useRouter();
  const hasCompletedOnboarding = useAppStore((state) => state.hasCompletedOnboarding);
  const userId = session?.user?.id ?? null;
  const [checkedPendingAuthRedirectUserId, setCheckedPendingAuthRedirectUserId] = useState<
    string | null
  >(null);
  const [pendingAuthRedirectPathname, setPendingAuthRedirectPathname] = useState<string | null>(
    null,
  );
  const isCheckingPendingAuthRedirect =
    Boolean(userId && hasCompletedOnboarding && checkedPendingAuthRedirectUserId !== userId) ||
    Boolean(pendingAuthRedirectPathname && pendingAuthRedirectPathname !== pathname);
  const onboardingRedirect = !hasCompletedOnboarding
    ? pathname !== '/app' && pathname !== '/app/onboarding'
      ? APP_ONBOARDING
      : null
    : pathname === '/app/onboarding' && !isCheckingPendingAuthRedirect
      ? APP_HOME
      : null;
  const isNotificationNavigationReady =
    hasCompletedOnboarding &&
    !isCheckingPendingAuthRedirect &&
    !onboardingRedirect &&
    pathname !== '/app' &&
    pathname !== '/app/onboarding';

  usePushNotifications(isNotificationNavigationReady);

  useEffect(() => {
    if (!userId) {
      setCheckedPendingAuthRedirectUserId(null);
      setPendingAuthRedirectPathname(null);
      return;
    }

    if (!hasCompletedOnboarding || checkedPendingAuthRedirectUserId === userId) return;

    let isActive = true;

    const redirectToPendingReturnTarget = async () => {
      try {
        const returnTo = await consumePendingOAuthReturnTo();

        if (!isActive) return;

        const returnToPathname = returnTo ? getRoutePathname(returnTo) : null;

        if (returnTo && returnToPathname) {
          setPendingAuthRedirectPathname(returnToPathname);
          router.replace(returnTo as Href);
          return;
        }

        setPendingAuthRedirectPathname(null);
      } catch (error) {
        if (isActive) {
          setPendingAuthRedirectPathname(null);
        }

        console.error('Unable to complete auth return redirect:', error);
      } finally {
        if (isActive) {
          setCheckedPendingAuthRedirectUserId(userId);
        }
      }
    };

    redirectToPendingReturnTarget();

    return () => {
      isActive = false;
    };
  }, [checkedPendingAuthRedirectUserId, hasCompletedOnboarding, router, userId]);

  useEffect(() => {
    if (!pendingAuthRedirectPathname || pendingAuthRedirectPathname !== pathname) return;

    setPendingAuthRedirectPathname(null);
  }, [pendingAuthRedirectPathname, pathname]);

  return (
    <>
      <Stack
        initialRouteName="(tabs)"
        screenOptions={{
          headerBackButtonDisplayMode: 'minimal',
        }}>
        <Stack.Screen name="index" options={{ headerShown: false }} />
        <Stack.Screen name="onboarding" options={{ headerShown: false }} />
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
        <Stack.Screen name="about-details" options={{ headerShown: false }} />
        <Stack.Screen name="bible/[book]/index" />
        <Stack.Screen name="scripture_notes/index" options={{ headerShown: false }} />
        <Stack.Screen name="search/devotionals/index" options={{ title: t('searchDevotionals') }} />
        <Stack.Screen name="devotional_detail/[planId]/index" options={{ title: '' }} />
        <Stack.Screen
          name="devotional_detail/[planId]/invite"
          options={{ title: t('invitation') }}
        />
        <Stack.Screen
          name="church/[churchId]/invitation"
          options={{ title: t('churchInvitation') }}
        />
        <Stack.Screen name="invite/[code]" options={{ title: t('invitation') }} />
        <Stack.Protected guard={session == null}>
          <Stack.Screen name="(auth)" options={{ presentation: 'modal', headerShown: false }} />
          <Stack.Screen name="confirm-email" options={{ title: t('confirmEmail') }} />
        </Stack.Protected>
        <Stack.Protected guard={session != null}>
          <Stack.Screen
            name="plan_progress/[progressId]/index"
            options={{ title: t('planProgress') }}
          />
          <Stack.Screen
            name="plan_progress/[progressId]/plan-complete/index"
            options={{ headerShown: false }}
          />
          <Stack.Screen
            name="devotional_detail/[planId]/[dayId]/[itemId]"
            options={{ headerShown: false }}
          />
          <Stack.Screen
            name="devotional_detail/[planId]/start-date"
            options={{ title: t('planInfo') }}
          />
          <Stack.Screen
            name="devotional_detail/[planId]/invite-friends"
            options={{ title: t('selectFriends') }}
          />
          <Stack.Screen
            name="devotional_detail/[planId]/participants"
            options={{ title: t('participants') }}
          />
          <Stack.Screen name="church/[churchId]/index" options={{ title: t('myChurch') }} />
          <Stack.Screen name="church/[churchId]/members" options={{ title: t('members') }} />
          <Stack.Screen
            name="devotional_detail/[planId]/invitation"
            options={{ title: t('invitation') }}
          />
          <Stack.Screen
            name="plan_progress/[progressId]/missedDays/index"
            options={{ title: t('missedDays') }}
          />
          <Stack.Screen name="profile/[userId]" options={{ title: t('profile') }} />
          <Stack.Screen name="add_friend/index" options={{ title: t('addFriend') }} />
          <Stack.Screen name="accept_friend/index" options={{ title: t('friendRequests') }} />
          <Stack.Screen name="prayer/new" options={{ title: t('newPrayerRequest') }} />
          <Stack.Screen name="prayer/[requestId]" options={{ title: t('prayerRequest') }} />
          <Stack.Screen name="settings/index" options={{ title: t('settings') }} />
          <Stack.Screen name="notifications/index" options={{ title: t('notifications') }} />
        </Stack.Protected>
      </Stack>
      {onboardingRedirect ? <Redirect href={onboardingRedirect} /> : null}
      {isCheckingPendingAuthRedirect || onboardingRedirect ? (
        <LoadingSpinner
          ViewStyles={[StyleSheet.absoluteFillObject, { backgroundColor: colors.background }]}
        />
      ) : null}
    </>
  );
}
