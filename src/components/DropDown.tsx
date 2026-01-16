import { Ionicons } from '@expo/vector-icons';
import { useState } from 'react';
import { Modal, TouchableOpacity, View, Text } from 'react-native';

export default function Dropdown({
  value,
  onChange,
  options,
}: {
  value: string;
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
        <Text className="text-gray-800 dark:text-gray-200 mr-2">{value}</Text>
        <Ionicons name="chevron-down" size={16} color="#555" />
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
