import {
  Merriweather_300Light,
  Merriweather_400Regular,
  Merriweather_700Bold,
  Merriweather_900Black,
} from '@expo-google-fonts/merriweather';
import {
  OpenSans_400Regular,
  OpenSans_400Regular_Italic,
  OpenSans_600SemiBold,
  OpenSans_600SemiBold_Italic,
  OpenSans_700Bold,
  OpenSans_700Bold_Italic,
  useFonts,
} from '@expo-google-fonts/open-sans';
import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';
import { Href, Redirect, Stack, usePathname } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { BibleProvider } from '../src/state/BibleContext';

import { useFriends, usePendingFriendRequests } from '@/src/hooks/useFriends';
import { useLastSeenTracker } from '@/src/hooks/useLastSeen';
import { useNotifications } from '@/src/hooks/useNotifications';
import { usePushNotifications } from '@/src/hooks/usePushNotifications';
import { useRealtimeFriends } from '@/src/hooks/useRealtimeFriends';
import { useRealtimeNotifications } from '@/src/hooks/useRealtimeNotifications';
import { useThemePreference } from '@/src/hooks/useThemePreference';
import { useUserLocation } from '@/src/hooks/useUserLocation';
import { mutationQueue } from '@/src/lib/mutationQueue';
import { QueryProviderWrapper } from '@/src/lib/queryClient';
import { supabase } from '@/src/lib/supabaseClient';
import { AuthProvider, useAuth } from '@/src/state/AuthContext';
import { BottomSheetModalProvider } from '@gorhom/bottom-sheet';
import * as SplashScreen from 'expo-splash-screen';
import { useCallback, useEffect, useState } from 'react';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import '../global.css';
import { useAppStore } from '@/src/state/useAppStore';

SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const { resolvedTheme } = useThemePreference();

  return (
    <SafeAreaProvider>
      <GestureHandlerRootView style={{ flex: 1 }}>
        <ThemeProvider value={resolvedTheme === 'dark' ? DarkTheme : DefaultTheme}>
          <AuthProvider>
            <QueryProviderWrapper>
              <BottomSheetModalProvider>
                <BibleProvider>
                  <RootLayoutContent />
                </BibleProvider>
              </BottomSheetModalProvider>
            </QueryProviderWrapper>
          </AuthProvider>
        </ThemeProvider>
      </GestureHandlerRootView>
    </SafeAreaProvider>
  );
}

function RootLayoutContent() {
  const { session, loading } = useAuth();
  const pathname = usePathname();
  const hasCompletedOnboarding = useAppStore((state) => state.hasCompletedOnboarding);
  const [hasHydratedAppStore, setHasHydratedAppStore] = useState(() =>
    useAppStore.persist.hasHydrated(),
  );
  const { notificationsQuery, notificationsCountQuery } = useNotifications(session?.user?.id);

  const friendsQuery = useFriends(session?.user.id);
  const PandingFriendsQuery = usePendingFriendRequests(session?.user.id);

  usePushNotifications();
  useUserLocation();
  const handleNotificationsNew = useCallback(() => {
    notificationsQuery.refetch();
    notificationsCountQuery.refetch();
  }, [notificationsQuery, notificationsCountQuery]);

  const handleFriendsNew = useCallback(() => {
    friendsQuery.refetch();
    PandingFriendsQuery.refetch();
  }, [friendsQuery, PandingFriendsQuery]);

  useRealtimeNotifications(session?.user?.id, handleNotificationsNew);
  useRealtimeFriends(session?.user?.id, handleFriendsNew);

  useLastSeenTracker();
  const [loaded] = useFonts({
    OpenSansRegular: OpenSans_400Regular,
    OpenSansSemiBold: OpenSans_600SemiBold,
    OpenSansBold: OpenSans_700Bold,
    MerriWeather300Light: Merriweather_300Light,
    MerriWeather400Regular: Merriweather_400Regular,
    MerriWeather700Bold: Merriweather_700Bold,
    MerriWeather900Black: Merriweather_900Black,
    OpenSansRegularItalic: OpenSans_400Regular_Italic,
    OpenSansSemiBoldItalic: OpenSans_600SemiBold_Italic,
    OpenSansBoldItalic: OpenSans_700Bold_Italic,
  });

  useEffect(() => {
    const unsubscribeHydrate = useAppStore.persist.onHydrate(() => {
      setHasHydratedAppStore(false);
    });
    const unsubscribeFinishHydration = useAppStore.persist.onFinishHydration(() => {
      setHasHydratedAppStore(true);
    });

    setHasHydratedAppStore(useAppStore.persist.hasHydrated());

    return () => {
      unsubscribeHydrate();
      unsubscribeFinishHydration();
    };
  }, []);

  useEffect(() => {
    mutationQueue.setExecutor(async (item) => {
      const { key, payload } = item;
      if (key === 'start_plan') {
        const { plan_id, user_id } = payload;
        await supabase.from('plan_progress').insert({
          user_id,
          plan_id,
          current_day: 1,
          completed_days: [],
        });
        return;
      }
      if (key === 'toggle_reaction') {
        const { plan_id } = payload;
        await supabase.rpc('toggle_reaction', {
          p_plan_id: plan_id,
          p_reaction_type: 'helpful',
        });
        return;
      }

      throw new Error('Unknown queued mutation key: ' + key);
    });
  }, []);
  useEffect(() => {
    if (loaded && !loading && hasHydratedAppStore) {
      SplashScreen.hideAsync();
    }
  }, [hasHydratedAppStore, loaded, loading]);

  if (!loaded || loading || !hasHydratedAppStore) return null;

  if (!hasCompletedOnboarding && pathname !== '/onboarding') {
    return <Redirect href={'/onboarding' as Href} />;
  }

  if (hasCompletedOnboarding && pathname === '/onboarding') {
    return <Redirect href="/(tabs)/PlansTab" />;
  }

  return (
    <>
      <StatusBar style="auto" />
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
        {/* 🔒 AUTH-REQUIRED ROUTES */}
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
    </>
  );
}
