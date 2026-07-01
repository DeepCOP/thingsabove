import LoadingSpinner from '@/src/components/LoadingSpinner';
import { consumePendingOAuthReturnTo } from '@/src/lib/oauthReturnTo';
import { useTheme } from '@react-navigation/native';
import { Href, Redirect, Stack, usePathname, useRouter } from 'expo-router';
import { useEffect, useState } from 'react';
import { StyleSheet } from 'react-native';

import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';

const APP_HOME = '/app/(tabs)/PlansTab' as Href;
const APP_ONBOARDING = '/app/onboarding' as Href;

const getRoutePathname = (href: string) => href.split('?')[0] ?? href;

export default function AppLayout() {
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

  if (!hasCompletedOnboarding && pathname !== '/app/onboarding') {
    return <Redirect href={APP_ONBOARDING} />;
  }

  if (hasCompletedOnboarding && pathname === '/app/onboarding') {
    return <Redirect href={APP_HOME} />;
  }

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
        <Stack.Screen name="search/devotionals/index" options={{ title: 'search devotionals' }} />
        <Stack.Screen name="devotional_detail/[planId]/index" options={{ title: '' }} />
        <Stack.Screen name="devotional_detail/[planId]/invite" options={{ title: 'Invitation' }} />
        <Stack.Screen
          name="church/[churchId]/invitation"
          options={{ title: 'Church Invitation' }}
        />
        <Stack.Screen name="invite/[code]" options={{ title: 'Invitation' }} />
        <Stack.Protected guard={session == null}>
          <Stack.Screen name="(auth)" options={{ presentation: 'modal', headerShown: false }} />
          <Stack.Screen name="confirm-email" options={{ title: 'Confirm Email' }} />
        </Stack.Protected>
        <Stack.Protected guard={session != null}>
          <Stack.Screen
            name="plan_progress/[progressId]/index"
            options={{ title: 'plan progress' }}
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
            options={{ title: 'plan info' }}
          />
          <Stack.Screen
            name="devotional_detail/[planId]/invite-friends"
            options={{ title: 'Select Friends To Invite' }}
          />
          <Stack.Screen
            name="devotional_detail/[planId]/participants"
            options={{ title: 'Participants' }}
          />
          <Stack.Screen name="church/[churchId]/index" options={{ title: 'My Church' }} />
          <Stack.Screen name="church/[churchId]/members" options={{ title: 'Members' }} />
          <Stack.Screen
            name="devotional_detail/[planId]/invitation"
            options={{ title: 'Invitation' }}
          />
          <Stack.Screen
            name="plan_progress/[progressId]/missedDays/index"
            options={{ title: 'Missed Days' }}
          />
          <Stack.Screen name="profile/[userId]" options={{ title: 'Profile' }} />
          <Stack.Screen name="add_friend/index" options={{ title: 'Add Friend' }} />
          <Stack.Screen name="accept_friend/index" options={{ title: 'Friend Requests' }} />
          <Stack.Screen name="prayer/new" options={{ title: 'New Prayer Request' }} />
          <Stack.Screen name="prayer/[requestId]" options={{ title: 'Prayer Request' }} />
          <Stack.Screen name="settings/index" options={{ title: 'Settings' }} />
          <Stack.Screen name="notifications/index" options={{ title: 'Notifications' }} />
        </Stack.Protected>
      </Stack>
      {isCheckingPendingAuthRedirect ? (
        <LoadingSpinner
          ViewStyles={[StyleSheet.absoluteFillObject, { backgroundColor: colors.background }]}
        />
      ) : null}
    </>
  );
}
