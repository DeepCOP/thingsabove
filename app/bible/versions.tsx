import BibleVersionsScreen from '@/src/screens/BibleVersionsScreen';
import Ionicons from '@expo/vector-icons/Ionicons';
import { Stack } from 'expo-router';
import { useState } from 'react';
import { Modal, Pressable, Text, TouchableOpacity, useColorScheme, View } from 'react-native';

export default function BibleVersionsRoute() {
  const colorScheme = useColorScheme();
  const [isInfoVisible, setIsInfoVisible] = useState(false);

  return (
    <>
      <Stack.Screen
        options={{
          title: 'Bible Versions',
          headerShadowVisible: false,
          headerRight: () => (
            <TouchableOpacity
              accessibilityRole="button"
              accessibilityLabel="About Bible versions"
              className="h-10 w-10 items-center justify-center"
              onPress={() => setIsInfoVisible(true)}>
              <Ionicons
                name="information-circle-outline"
                size={22}
                color={colorScheme === 'dark' ? '#f5f5f5' : '#111827'}
              />
            </TouchableOpacity>
          ),
        }}
      />
      <BibleVersionsScreen />

      <Modal
        visible={isInfoVisible}
        transparent
        animationType="fade"
        onRequestClose={() => setIsInfoVisible(false)}>
        <Pressable
          className="flex-1 items-center justify-center bg-black/40 px-6"
          onPress={() => setIsInfoVisible(false)}>
          <Pressable
            className="w-full max-w-sm rounded-3xl border border-gray-200 bg-white p-5 dark:border-neutral-800 dark:bg-neutral-950"
            onPress={(e) => e.stopPropagation()}>
            <View className="flex-row items-start justify-between">
              <Text className="flex-1 pr-4 text-lg font-semibold text-primary dark:text-gray-100">
                About Bible Versions
              </Text>
              <TouchableOpacity
                accessibilityRole="button"
                accessibilityLabel="Close version info"
                className="-mr-1 -mt-1 h-8 w-8 items-center justify-center"
                onPress={() => setIsInfoVisible(false)}>
                <Ionicons
                  name="close"
                  size={20}
                  color={colorScheme === 'dark' ? '#d4d4d8' : '#4b5563'}
                />
              </TouchableOpacity>
            </View>

            <Text className="mt-3 text-sm leading-6 text-gray-600 dark:text-gray-300">
              Different Bible versions present the original text in different ways. Some stay closer
              to the original wording, while others focus more on making the meaning clear and easy
              to read. Feel free to choose the version that helps you understand the text best. If
              you’re unsure which version to use, consider consulting the leaders at your church.
            </Text>
          </Pressable>
        </Pressable>
      </Modal>
    </>
  );
}
