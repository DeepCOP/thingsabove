import { formatBibleVersionSize } from '@/src/lib/bibleVersionService';
import { useBible } from '@/src/state/BibleContext';
import Ionicons from '@expo/vector-icons/Ionicons';
import BottomSheet, { BottomSheetBackdrop, BottomSheetView } from '@gorhom/bottom-sheet';
import { forwardRef, useMemo } from 'react';
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

type Props = Record<never, never>;
type BibleVersionListEntry = ReturnType<typeof useBible>['versions'][number];

const BibleVersionsMenu = forwardRef<BottomSheet, Props>((_, ref) => {
  const colorScheme = useColorScheme();
  const insets = useSafeAreaInsets();
  const snapPoints = useMemo(() => ['55%', '75%'], []);
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

  const closeSheet = () => {
    if (ref && typeof ref !== 'function') {
      ref.current?.close();
    }
  };

  const handleInstallVersion = async (versionId: (typeof versions)[number]['id']) => {
    try {
      await installVersion(versionId);
    } catch {
      // Errors are already surfaced in the version state inside the menu.
    }
  };

  const handleSelectVersion = async (versionId: (typeof versions)[number]['id']) => {
    try {
      await setVersion(versionId);
      closeSheet();
    } catch {
      // Keep the sheet open so the user can see the current state.
    }
  };

  return (
    <BottomSheet
      ref={ref}
      index={-1}
      snapPoints={snapPoints}
      enablePanDownToClose
      bottomInset={insets.bottom + 56}
      backgroundStyle={{ backgroundColor: colorScheme === 'dark' ? '#171717' : '#fff' }}
      backdropComponent={(props) => (
        <BottomSheetBackdrop
          {...props}
          opacity={0.7}
          pressBehavior="close"
          disappearsOnIndex={-1}
          appearsOnIndex={0}
        />
      )}>
      <BottomSheetView className="w-full h-full px-4">
        <View className="border-b border-gray-200 px-4 py-3 dark:border-neutral-800">
          <Text className="text-sm font-semibold text-primary dark:text-gray-100">
            Bible Versions
          </Text>
          <View className="mt-1 flex-row items-center">
            <Text className="text-xs text-gray-500 dark:text-gray-400">Current:</Text>
            {loadingVersionId ? (
              <ActivityIndicator size="small" className="ml-2" />
            ) : (
              <Text className="ml-2 text-xs text-gray-500 dark:text-gray-400">{version}</Text>
            )}
          </View>
        </View>

        <FlatList<BibleVersionListEntry>
          data={versions}
          keyExtractor={(entry: BibleVersionListEntry) => entry.id}
          contentContainerStyle={{
            paddingHorizontal: 12,
            paddingTop: 12,
            paddingBottom: insets.bottom + 16,
          }}
          showsVerticalScrollIndicator={false}
          keyboardShouldPersistTaps="handled"
          nestedScrollEnabled
          ListHeaderComponent={
            versionsCatalogLoading || versionsCatalogError ? (
              <View className="mb-3 px-2">
                {versionsCatalogLoading ? (
                  <Text className="text-xs text-gray-500 dark:text-gray-400">
                    Checking available downloads...
                  </Text>
                ) : null}

                {versionsCatalogError ? (
                  <Text className="mt-2 text-xs text-amber-600 dark:text-amber-400">
                    Unable to refresh the version catalog. Built-in versions are still available.
                  </Text>
                ) : null}
              </View>
            ) : null
          }
          renderItem={({ item: entry }: { item: BibleVersionListEntry }) => (
            <TouchableOpacity
              onPress={() => void handleSelectVersion(entry.id)}
              disabled={!entry.isInstalled || entry.isActive || loadingVersionId === entry.id}
              activeOpacity={0.8}
              className={`mb-2 rounded-2xl border px-3 py-3 ${
                entry.isActive
                  ? 'border-blue-200 bg-blue-50 dark:border-blue-900/60 dark:bg-blue-950/20'
                  : 'border-gray-200 dark:border-neutral-800 dark:bg-black/20'
              }`}>
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
                  <Text className="mt-1 text-xs text-gray-900 dark:text-gray-300">
                    {entry.label}
                  </Text>
                  <Text className="mt-1 text-[11px] text-gray-500 dark:text-gray-400">
                    {formatBibleVersionSize(entry.sizeBytes)}
                  </Text>
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
                      onPress={() => void handleInstallVersion(entry.id)}
                      disabled={entry.isDownloading}
                      className={`items-center justify-center rounded-full p-2.5 ${
                        entry.isDownloading ? 'bg-gray-300 dark:bg-neutral-700' : 'bg-blue-600'
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
                      onPress={() => {
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
          )}
        />
      </BottomSheetView>
    </BottomSheet>
  );
});

BibleVersionsMenu.displayName = 'BibleVersionsMenu';

export default BibleVersionsMenu;
