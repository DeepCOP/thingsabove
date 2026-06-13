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
import { BottomSheetModalProvider } from '@gorhom/bottom-sheet';
import * as SplashScreen from 'expo-splash-screen';
import * as WebBrowser from 'expo-web-browser';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { useCallback, useEffect, useState } from 'react';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { SafeAreaProvider } from 'react-native-safe-area-context';

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
import { BibleProvider } from '@/src/state/BibleContext';
import { useAppStore } from '@/src/state/useAppStore';
import '../global.css';

SplashScreen.preventAutoHideAsync();
WebBrowser.maybeCompleteAuthSession();

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
  const [hasHydratedAppStore, setHasHydratedAppStore] = useState(() =>
    useAppStore.persist.hasHydrated(),
  );
  const { notificationsQuery, notificationsCountQuery } = useNotifications(session?.user?.id);

  const friendsQuery = useFriends(session?.user.id);
  const pendingFriendsQuery = usePendingFriendRequests(session?.user.id);

  usePushNotifications();
  useUserLocation();
  const handleNotificationsNew = useCallback(() => {
    notificationsQuery.refetch();
    notificationsCountQuery.refetch();
  }, [notificationsQuery, notificationsCountQuery]);

  const handleFriendsNew = useCallback(() => {
    friendsQuery.refetch();
    pendingFriendsQuery.refetch();
  }, [friendsQuery, pendingFriendsQuery]);

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

  return (
    <>
      <StatusBar style="auto" />
      <Stack
        initialRouteName="app"
        screenOptions={{
          headerBackButtonDisplayMode: 'minimal',
        }}>
        <Stack.Screen name="index" options={{ headerShown: false }} />
        <Stack.Screen name="auth/callback" options={{ headerShown: false }} />
        <Stack.Screen name="app" options={{ headerShown: false }} />
      </Stack>
    </>
  );
}
