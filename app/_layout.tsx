import {
  Merriweather_300Light,
  Merriweather_400Regular,
  Merriweather_700Bold,
  Merriweather_900Black,
} from '@expo-google-fonts/merriweather';
import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';
import { SafeAreaProvider } from 'react-native-safe-area-context';

import {
  OpenSans_400Regular,
  OpenSans_400Regular_Italic,
  OpenSans_600SemiBold,
  OpenSans_600SemiBold_Italic,
  OpenSans_700Bold,
  OpenSans_700Bold_Italic,
  useFonts,
} from '@expo-google-fonts/open-sans';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { BibleProvider } from '../context/BibleContext';

import { supabase } from '@/api/supabaseClient';
import { AuthProvider, useAuth } from '@/context/AuthContext';
import { mutationQueue } from '@/lib/mutationQueue';
import { QueryProviderWrapper } from '@/lib/queryClient';
import * as SplashScreen from 'expo-splash-screen';
import { useEffect } from 'react';
import { useColorScheme } from 'react-native';
import '../global.css';

SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const colorScheme = useColorScheme();

  return (
    <SafeAreaProvider>
      <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
        <AuthProvider>
          <QueryProviderWrapper>
            <BibleProvider>
              <RootLayoutContent />
            </BibleProvider>
          </QueryProviderWrapper>
        </AuthProvider>
      </ThemeProvider>
    </SafeAreaProvider>
  );
}

function RootLayoutContent() {
  const { session, loading } = useAuth();

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
        const { plan_id, user_id, type } = payload;
        await supabase.rpc('toggle_reaction', {
          p_plan_id: plan_id,
          p_user_id: user_id,
          p_reaction_type: type,
        });
        return;
      }

      throw new Error('Unknown queued mutation key: ' + key);
    });
  }, []);
  useEffect(() => {
    if (loaded && !loading) {
      SplashScreen.hideAsync();
    }
  }, [loaded, loading]);

  if (!loaded || loading) return null;
  return (
    <>
      <StatusBar style="auto" />
      <Stack initialRouteName="(tabs)">
        {/* 🌍 PUBLIC / GUEST ROUTES */}
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
        <Stack.Screen name="bible/[book]/index" />
        <Stack.Screen name="search/devotionals/index" options={{ title: 'search devotionals' }} />
        <Stack.Screen name="devotional_detail/[id]/index" options={{ title: '' }} />
        <Stack.Protected guard={session == null}>
          <Stack.Screen name="login" options={{ presentation: 'modal' }} />
        </Stack.Protected>
        {/* 🔒 AUTH-REQUIRED ROUTES */}
        <Stack.Protected guard={session != null}>
          <Stack.Screen name="plan_progress/[planId]/index" options={{ title: 'plan progress' }} />
          <Stack.Screen
            name="plan_progress/[planId]/plan-complete/index"
            options={{ headerShown: false }}
          />
          <Stack.Screen
            name="devotional_detail/[id]/[dayId]/[itemId]"
            options={{ headerShown: false }}
          />
          <Stack.Screen
            name="plan_progress/[planId]/missedDays/index"
            options={{ title: 'Missed Days' }}
          />
        </Stack.Protected>
      </Stack>
    </>
  );
}
