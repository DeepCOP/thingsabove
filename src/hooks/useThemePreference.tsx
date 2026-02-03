import { useColorScheme } from 'nativewind';
import { useEffect } from 'react';
import { useColorScheme as systemScheme } from 'react-native';
import { useAppStore } from '../state/useAppStore';

type ThemeMode = 'light' | 'dark' | 'system';

export function useThemePreference() {
  const colorScheme = useColorScheme();
  const systemColorScheme = systemScheme();
  const { theme, setTheme } = useAppStore();

  const updateMode = async (next: ThemeMode) => {
    setTheme(next);
  };

  const resolvedTheme: 'light' | 'dark' =
    theme === 'system' ? (systemColorScheme === 'dark' ? 'dark' : 'light') : theme;
  useEffect(() => {
    colorScheme.setColorScheme(theme);
  }, [theme]);

  return {
    resolvedTheme,
    setMode: updateMode,
  };
}
