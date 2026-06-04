import { Ionicons } from '@expo/vector-icons';
import { Tabs } from 'expo-router';
import React from 'react';
import { useColorScheme } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

export default function TabLayout() {
  const insets = useSafeAreaInsets();
  const colorScheme = useColorScheme();

  return (
    <>
      <Tabs
        screenOptions={{
          tabBarShowLabel: true,
          tabBarLabelStyle: {
            fontWeight: 'bold',
          },
          tabBarActiveTintColor: colorScheme === 'dark' ? '#fff' : '#0F0D23',
          tabBarItemStyle: {
            flex: 1,
            height: '100%',
            justifyContent: 'center',
            alignItems: 'center',
          },
          tabBarStyle: {
            overflow: 'hidden',
            borderWidth: 1,
            borderColor: '#0F0D23',
            height: 56 + insets.bottom,
          },
        }}>
        <Tabs.Screen
          name="PlansTab"
          options={{
            title: 'Devotionals',
            headerShown: false,

            tabBarIcon: ({ focused, color, size }) => {
              return (
                <Ionicons name={`${focused ? 'home' : 'home-outline'}`} size={size} color={color} />
              );
            },
          }}
        />
        <Tabs.Screen
          name="BibleTab"
          options={{
            title: 'Bible',

            headerShown: false,

            tabBarIcon: ({ focused, color, size }) => {
              return (
                <Ionicons name={`${focused ? 'book' : 'book-outline'}`} size={size} color={color} />
              );
            },
          }}
        />
        <Tabs.Screen
          name="CommunityTab"
          options={{
            title: 'Community',
            headerShown: false,
            tabBarIcon: ({ focused, color, size }) => {
              return (
                <Ionicons
                  name={`${focused ? 'people' : 'people-outline'}`}
                  size={size}
                  color={color}
                />
              );
            },
          }}
        />
        <Tabs.Screen
          name="ProfileTab"
          options={{
            title: 'Profile',
            headerShown: false,
            tabBarIcon: ({ focused, color, size }) => {
              return (
                <Ionicons
                  name={`${focused ? 'person' : 'person-outline'}`}
                  size={size}
                  color={color}
                />
              );
            },
          }}
        />
      </Tabs>
    </>
  );
}
