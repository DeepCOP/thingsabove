import { formatBibleVersionSize } from '@/src/lib/bibleVersionService';
import { useBible } from '@/src/state/BibleContext';
import NetInfo from '@react-native-community/netinfo';
import Ionicons from '@expo/vector-icons/Ionicons';
import { useRouter } from 'expo-router';
import { useEffect, useState } from 'react';
import {
  ActivityIndicator,
  Alert,
  FlatList,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type BibleVersionListEntry = ReturnType<typeof useBible>['versions'][number];

export default function BibleVersionsScreen() {
  const colorScheme = useColorScheme();
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const [isOffline, setIsOffline] = useState(false);
  const {
    installVersion,
    loadingVersionId,
    removeVersion,
    setVersion,
    version,
    versions,
    versionsCatalogError,
    versionsCatalogLoading,
  } = useBible();

  useEffect(() => {
    const updateOfflineState = (state: {
      isConnected: boolean | null;
      isInternetReachable: boolean | null;
    }) => {
      setIsOffline(state.isConnected === false || state.isInternetReachable === false);
    };

    void NetInfo.fetch().then(updateOfflineState);

    const unsubscribe = NetInfo.addEventListener((state) => {
      updateOfflineState(state);
    });

    return () => unsubscribe();
  }, []);

  const handleInstallVersion = async (versionId: (typeof versions)[number]['id']) => {
    try {
      await installVersion(versionId);
    } catch {
      // Errors are already surfaced in the version state.
    }
  };

  const handleSelectVersion = async (versionId: (typeof versions)[number]['id']) => {
    try {
      await setVersion(versionId);
      router.back();
    } catch {
      // Keep the user on this screen so the current state remains visible.
    }
  };

  return (
    <View className="flex-1 bg-white dark:bg-black">
      <FlatList<BibleVersionListEntry>
        data={versions}
        keyExtractor={(entry) => entry.id}
        contentContainerStyle={{
          paddingHorizontal: 16,
          paddingTop: 16,
          paddingBottom: insets.bottom + 24,
        }}
        showsVerticalScrollIndicator={false}
        keyboardShouldPersistTaps="handled"
        ListHeaderComponent={
          <View className="mb-4 rounded-3xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
            <Text className="text-lg font-semibold text-primary dark:text-gray-100">
              Choose Your Translation
            </Text>
            <Text className="mt-1 text-sm text-gray-500 dark:text-gray-400">
              Installed versions can be opened right away. Other translations can be downloaded to
              this device first.
            </Text>

            <View className="mt-4 flex-row items-center rounded-2xl bg-blue-50 px-3 py-3 dark:bg-blue-950/30">
              <Ionicons name="book-outline" size={18} color="#2563eb" />
              <View className="ml-3 flex-1">
                <Text className="text-xs font-semibold uppercase tracking-wide text-blue-700 dark:text-blue-300">
                  Current version
                </Text>
                {loadingVersionId ? (
                  <ActivityIndicator size="small" className="mt-2 self-start" />
                ) : (
                  <Text className="mt-1 text-base font-semibold text-gray-900 dark:text-white">
                    {version}
                  </Text>
                )}
              </View>
            </View>

            {versionsCatalogLoading ? (
              <Text className="mt-4 text-xs text-gray-500 dark:text-gray-400">
                Checking available downloads...
              </Text>
            ) : null}

            {versionsCatalogError ? (
              <Text className="mt-2 text-xs text-amber-600 dark:text-amber-400">
                Unable to refresh the version catalog. Built-in versions are still available.
              </Text>
            ) : null}

            {isOffline ? (
              <View className="mt-4 flex-row items-start rounded-2xl bg-amber-50 px-3 py-3 dark:bg-amber-950/30">
                <Ionicons name="cloud-offline-outline" size={18} color="#d97706" />
                <Text className="ml-3 flex-1 text-xs text-amber-700 dark:text-amber-300">
                  You&apos;re offline. Downloaded versions are still available, but new installs are
                  disabled until you reconnect.
                </Text>
              </View>
            ) : null}
          </View>
        }
        renderItem={({ item: entry }) => {
          const isVersionUnavailableOffline = isOffline && !entry.isInstalled;
          const isRowDisabled =
            isVersionUnavailableOffline ||
            !entry.isInstalled ||
            entry.isActive ||
            loadingVersionId === entry.id;
          const isInstallDisabled = isOffline || entry.isDownloading;

          return (
            <TouchableOpacity
              onPress={() => void handleSelectVersion(entry.id)}
              disabled={isRowDisabled}
              activeOpacity={0.8}
              className={`mb-3 rounded-3xl border px-4 py-4 ${
                entry.isActive
                  ? 'border-blue-200 bg-blue-50 dark:border-blue-900/60 dark:bg-blue-950/20'
                  : 'border-gray-200 bg-white dark:border-neutral-800 dark:bg-neutral-950'
              } ${isVersionUnavailableOffline ? 'opacity-60' : ''}`}>
              <View className="flex-row items-start justify-between">
                <View className="flex-1 pr-3">
                  <View className="flex-row items-center">
                    <Text className="font-semibold text-primary dark:text-gray-100">
                      {entry.shortLabel}
                    </Text>
                    {entry.isActive ? (
                      <Text className="ml-2 text-[11px] font-semibold text-blue-500">Active</Text>
                    ) : null}
                  </View>

                  <Text className="mt-1 text-sm text-gray-900 dark:text-gray-300">
                    {entry.label}
                  </Text>
                  <Text className="mt-1 text-[11px] text-gray-500 dark:text-gray-400">
                    {formatBibleVersionSize(entry.sizeBytes)}
                  </Text>

                  {isVersionUnavailableOffline ? (
                    <Text className="mt-1 text-[11px] text-amber-600 dark:text-amber-400">
                      Unavailable offline. Connect to the internet to download this version.
                    </Text>
                  ) : null}

                  {!entry.isBundled && entry.isDownloading ? (
                    <Text className="mt-1 text-[11px] text-gray-500 dark:text-gray-400">
                      Downloading...
                    </Text>
                  ) : null}

                  {entry.installState?.error ? (
                    <Text className="mt-1 text-[11px] text-red-500">
                      {entry.installState.error}
                    </Text>
                  ) : null}
                </View>

                <View className="items-end">
                  {entry.isInstalled ? (
                    <Ionicons
                      name={entry.isActive ? 'checkmark-circle' : 'chevron-forward'}
                      size={18}
                      color={
                        entry.isActive ? '#3b82f6' : colorScheme === 'dark' ? '#9ca3af' : '#6b7280'
                      }
                    />
                  ) : (
                    <TouchableOpacity
                      onPress={(e) => {
                        e.stopPropagation();
                        void handleInstallVersion(entry.id);
                      }}
                      disabled={isInstallDisabled}
                      className={`items-center justify-center rounded-full p-2.5 ${
                        isInstallDisabled ? 'bg-gray-300 dark:bg-neutral-700' : 'bg-blue-600'
                      }`}>
                      <Ionicons
                        name={
                          entry.isDownloading ? 'arrow-down-circle-outline' : 'download-outline'
                        }
                        size={16}
                        color="#ffffff"
                      />
                    </TouchableOpacity>
                  )}

                  {entry.canDelete ? (
                    <TouchableOpacity
                      className="mt-2 flex-row items-center"
                      onPress={(e) => {
                        e.stopPropagation();

                        Alert.alert(
                          'Remove version',
                          entry.isActive
                            ? `Remove ${entry.label}?`
                            : `Remove ${entry.label} from this device?`,
                          [
                            { text: 'Cancel', style: 'cancel' },
                            {
                              text: 'Remove',
                              style: 'destructive',
                              onPress: () => void removeVersion(entry.id),
                            },
                          ],
                        );
                      }}>
                      <Ionicons name="trash-outline" size={14} color="#ef4444" />
                      <Text className="ml-1 text-xs font-medium text-red-500">Remove</Text>
                    </TouchableOpacity>
                  ) : null}
                </View>
              </View>
            </TouchableOpacity>
          );
        }}
      />
    </View>
  );
}
