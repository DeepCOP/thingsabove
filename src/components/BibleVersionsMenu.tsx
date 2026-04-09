import { formatBibleVersionSize } from '@/src/lib/bibleVersionService';
import { useBible } from '@/src/state/BibleContext';
import Ionicons from '@expo/vector-icons/Ionicons';
import {
  Alert,
  Modal,
  Pressable,
  ScrollView,
  StyleProp,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
  ViewStyle,
} from 'react-native';

type Props = {
  visible: boolean;
  menuStyle: StyleProp<ViewStyle>;
  onClose: () => void;
};

export default function BibleVersionsMenu({ visible, menuStyle, onClose }: Props) {
  const colorScheme = useColorScheme();
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
      onClose();
    } catch {
      // Keep the menu open so the user can see the current state.
    }
  };

  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
      <Pressable className="flex-1 bg-black/25" onPress={onClose}>
        <TouchableOpacity
          activeOpacity={1}
          onPress={() => {}}
          style={[{ position: 'absolute' }, menuStyle]}>
          <View className="overflow-hidden rounded-3xl border border-neutral-700/15 bg-white dark:border-neutral-700 dark:bg-neutral-900">
            <View className="border-b border-gray-200 px-4 py-3 dark:border-neutral-800">
              <Text className="text-sm font-semibold text-primary dark:text-gray-100">
                Bible Versions
              </Text>
              <Text className="mt-1 text-xs text-gray-500 dark:text-gray-400">
                Current: {loadingVersionId ? `${version}...` : version}
              </Text>
            </View>

            <ScrollView
              showsVerticalScrollIndicator={false}
              contentContainerStyle={{ paddingHorizontal: 12, paddingVertical: 12 }}>
              {versionsCatalogLoading ? (
                <Text className="mb-3 px-2 text-xs text-gray-500 dark:text-gray-400">
                  Checking available downloads...
                </Text>
              ) : null}

              {versionsCatalogError ? (
                <Text className="mb-3 px-2 text-xs text-amber-600 dark:text-amber-400">
                  Unable to refresh the version catalog. Built-in versions are still available.
                </Text>
              ) : null}

              {versions.map((entry) => (
                <TouchableOpacity
                  key={entry.id}
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
                          <Text className="ml-2 text-[11px] font-semibold text-blue-500">
                            Active
                          </Text>
                        ) : null}
                      </View>
                      <Text className="mt-1 text-xs text-gray-900 dark:text-gray-300">
                        {entry.label}
                      </Text>
                      <Text className="mt-1 text-[11px] text-gray-500 dark:text-gray-400">
                        {formatBibleVersionSize(entry.sizeBytes)}
                      </Text>
                      {!entry.isBundled && entry.isDownloading && (
                        <Text className="mt-1 text-[11px] text-gray-500 dark:text-gray-400">
                          {'Downloading...'}
                        </Text>
                      )}
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
                            entry.isActive
                              ? '#3b82f6'
                              : colorScheme === 'dark'
                                ? '#9ca3af'
                                : '#6b7280'
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
              ))}
            </ScrollView>
          </View>
        </TouchableOpacity>
      </Pressable>
    </Modal>
  );
}
