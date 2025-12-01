import { icons } from '@/constants/icons';
import { Tabs } from 'expo-router';
import React from 'react';
import { Image, Text, View } from 'react-native';
import TabIcon from '@/components/TabIcon';



export default function TabLayout() {
  return (
    <Tabs
      screenOptions={{
        tabBarShowLabel: false,
        tabBarLabelStyle: {
          fontWeight: 'bold',
        },

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
          height: 80
        },
      }}>
      <Tabs.Screen
        name="index"
        options={{
          title: 'Feed',
          headerShown: false,

          tabBarIcon: ({ focused, color, size }) => {
            return <TabIcon focused={focused} icon={icons.home} title="Feed" />;
          },
        }}
      />
      <Tabs.Screen
        name="Bible"
        options={{
          headerShown: false,

          title: 'Bible',
          tabBarIcon: ({ focused, color, size }) => {
            return <TabIcon focused={focused} icon={icons.book} title="Bible" />;
          },
        }}
      />
      <Tabs.Screen
        name="Create"
        options={{
          title: 'Create',
          headerShown: false,
          tabBarIcon: ({ focused, color, size }) => {
            return <TabIcon focused={focused} icon={icons.circlePlus} title="Create" />;
          },
        }}
      />
      <Tabs.Screen
        name="Notifications"
        options={{
          title: 'Notifications',
          headerShown: false,
          tabBarIcon: ({ focused, color, size }) => {
            return <TabIcon focused={focused} icon={icons.bell} title="Notifications" />;
          },
        }}
      />
      <Tabs.Screen
        name="Profile"
        options={{
          title: 'Profile',
          headerShown: false,
          tabBarIcon: ({ focused, color, size }) => {
            return <TabIcon focused={focused} icon={icons.person} title="Profile" />;
          },
        }}
      />
    </Tabs>
  );
}
