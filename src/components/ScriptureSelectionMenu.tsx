import { Ionicons } from '@expo/vector-icons';
import {
  LayoutChangeEvent,
  Modal,
  Pressable,
  StyleProp,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
  ViewStyle,
} from 'react-native';

type ScriptureSelectionMenuProps = {
  visible: boolean;
  title: string;
  menuStyle: StyleProp<ViewStyle>;
  notesDisabled?: boolean;
  onClose: () => void;
  onRequestClose?: () => void;
  onMenuLayout: (event: LayoutChangeEvent) => void;
  onOpenNotes: () => void;
  onCopy: () => void | Promise<void>;
  onShare: () => void | Promise<void>;
};

export default function ScriptureSelectionMenu({
  visible,
  title,
  menuStyle,
  notesDisabled = false,
  onClose,
  onRequestClose,
  onMenuLayout,
  onOpenNotes,
  onCopy,
  onShare,
}: ScriptureSelectionMenuProps) {
  const colorScheme = useColorScheme();

  return (
    <Modal
      visible={visible}
      transparent
      animationType="fade"
      onRequestClose={onRequestClose ?? onClose}>
      <Pressable className="flex-1 bg-black/25" onPress={onClose}>
        <TouchableOpacity
          activeOpacity={1}
          onPress={() => {}}
          style={[{ position: 'absolute' }, menuStyle]}>
          <View
            className="rounded-2xl border border-neutral-700/20 dark:border-neutral-700 bg-white dark:bg-neutral-900 overflow-hidden"
            onLayout={onMenuLayout}>
            <Text className="px-4 pt-3 pb-2 text-sm font-semibold text-primary dark:text-gray-100">
              {title || ' '}
            </Text>

            <TouchableOpacity
              className={`px-4 py-3 flex-row items-center ${
                notesDisabled ? 'opacity-50' : 'opacity-100'
              }`}
              disabled={notesDisabled}
              onPress={onOpenNotes}>
              <Ionicons
                name="chatbubble-ellipses-outline"
                size={22}
                color={
                  notesDisabled
                    ? colorScheme === 'dark'
                      ? '#737373'
                      : '#9ca3af'
                    : colorScheme === 'dark'
                      ? 'white'
                      : 'black'
                }
              />
              <Text
                className={`ml-3 text-base ${
                  notesDisabled
                    ? 'text-gray-400 dark:text-neutral-500'
                    : 'text-primary dark:text-gray-200'
                }`}>
                Scripture Notes
              </Text>
            </TouchableOpacity>

            <TouchableOpacity className="px-4 py-3 flex-row items-center" onPress={onCopy}>
              <Ionicons name="copy" size={22} color={colorScheme === 'dark' ? 'white' : 'black'} />
              <Text className="ml-3 text-primary dark:text-gray-200 text-base">Copy</Text>
            </TouchableOpacity>

            <TouchableOpacity className="px-4 py-3 flex-row items-center" onPress={onShare}>
              <Ionicons
                name="share-outline"
                size={22}
                color={colorScheme === 'dark' ? 'white' : 'black'}
              />
              <Text className="ml-3 text-primary dark:text-gray-200 text-base">Share</Text>
            </TouchableOpacity>

            <View className="border-t border-gray-200 dark:border-neutral-700" />

            <TouchableOpacity className="px-4 py-3 flex-row items-center" onPress={onClose}>
              <Ionicons name="close-outline" size={22} color="#ef4444" />
              <Text className="ml-3 text-red-600 text-base">Cancel</Text>
            </TouchableOpacity>
          </View>
        </TouchableOpacity>
      </Pressable>
    </Modal>
  );
}
