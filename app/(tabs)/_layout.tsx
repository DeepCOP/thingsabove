import { useNotifications } from '@/src/hooks/useNotifications';
import { useAuth } from '@/src/state/AuthContext';
import { Ionicons } from '@expo/vector-icons';
import { Tabs } from 'expo-router';
import React from 'react';
import { Text, useColorScheme, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

export default function TabLayout() {
  const insets = useSafeAreaInsets();
  const colorScheme = useColorScheme();

  const { session } = useAuth();
  const { notificationsCountQuery } = useNotifications(session?.user?.id);

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
            width: '100%',
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
          name="NotificationsTab"
          options={{
            title: 'Notifications',
            tabBarIcon: ({ focused, color, size }) => {
              const count = notificationsCountQuery.data ?? 0;

              return (
                <View style={{ position: 'relative', width: size, height: size }}>
                  {count > 0 && (
                    <View
                      style={{
                        position: 'absolute',
                        top: -6,
                        right: -10,
                        minWidth: 18,
                        height: 18,
                        borderRadius: 9,
                        backgroundColor: 'red',
                        alignItems: 'center',
                        justifyContent: 'center',
                        paddingHorizontal: 4,
                        zIndex: 10,
                      }}>
                      <Text
                        style={{
                          color: 'white',
                          fontSize: 10,
                          fontWeight: 'bold',
                        }}>
                        {count > 99 ? '99+' : count}
                      </Text>
                    </View>
                  )}

                  <Ionicons
                    name={focused ? 'notifications' : 'notifications-outline'}
                    size={size}
                    color={color}
                  />
                </View>
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
      <View
        pointerEvents="none"
        style={{
          position: 'absolute',
          left: 0,
          right: 0,
          bottom: 0,
          height: insets.bottom,
          zIndex: 0,
        }}
        className="dark:bg-neutral-900 bg-white"
      />
    </>
  );
}
