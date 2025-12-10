import {
  Merriweather_300Light,
  Merriweather_400Regular,
  Merriweather_700Bold,
  Merriweather_900Black,
} from '@expo-google-fonts/merriweather';
import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';

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

import { supabase } from '@/api/supabase';
import { AuthProvider } from '@/context/AuthContext';
import { mutationQueue } from '@/lib/mutationQueue';
import { QueryProviderWrapper } from '@/lib/queryClient';
import * as SplashScreen from 'expo-splash-screen';
import { useEffect } from 'react';
import { useColorScheme } from 'react-native';
import '../global.css';

SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const colorScheme = useColorScheme();

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
    if (loaded) SplashScreen.hideAsync();
  }, [loaded]);

  if (!loaded) return null;
  return (
    <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
      <AuthProvider>
        <QueryProviderWrapper>
          <BibleProvider>
            <StatusBar style="auto" />
            <Stack>
              <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
              <Stack.Screen name="bible/[book]/index" />
              <Stack.Screen
                name="search/devotionals/index"
                options={{ title: 'search devotionals' }}
              />
            </Stack>
          </BibleProvider>
        </QueryProviderWrapper>
      </AuthProvider>
    </ThemeProvider>
  );
}
