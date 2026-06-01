import { Ionicons } from '@expo/vector-icons';
import { useState } from 'react';
import { Modal, Text, TouchableOpacity, View } from 'react-native';

export default function Dropdown({
  onChange,
  options,
}: {
  onChange: (v: string) => void;
  options: string[];
}) {
  const [open, setOpen] = useState(false);

  return (
    <>
      {/* Trigger */}
      <TouchableOpacity
        onPress={() => setOpen(true)}
        className="flex-row items-center bg-white dark:bg-neutral-900 px-3 py-2 rounded-full shadow">
        <Text className="text-gray-800 dark:text-gray-200 mr-2">Sort</Text>
        <Ionicons name="swap-vertical" size={18} color="#555" />
      </TouchableOpacity>

      {/* Dropdown Menu */}
      <Modal visible={open} transparent animationType="fade">
        <TouchableOpacity
          className="flex-1 bg-black/30"
          activeOpacity={1}
          onPress={() => setOpen(false)}>
          <View className="absolute top-32 left-4 right-4 bg-white dark:bg-neutral-900 rounded-xl shadow p-2">
            {options.map((op) => (
              <TouchableOpacity
                key={op}
                className="px-3 py-3 rounded-lg"
                onPress={() => {
                  onChange(op);
                  setOpen(false);
                }}>
                <Text className="text-gray-900 dark:text-gray-200">{op}</Text>
              </TouchableOpacity>
            ))}
          </View>
        </TouchableOpacity>
      </Modal>
    </>
  );
}
