import TabIconComponent from '@/components/TabIcon';
import { icons } from '@/constants/icons';
import { Tabs } from 'expo-router';
import React from 'react';

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
          height: 80,
        },
      }}>
      <Tabs.Screen
        name="PlansTab"
        options={{
          title: 'Devotionals',
          headerShown: false,

          tabBarIcon: ({ focused, color, size }) => {
            return <TabIconComponent focused={focused} icon={icons.home} title="Devotionals" />;
          },
        }}
      />
      <Tabs.Screen
        name="BibleTab"
        options={{
          headerShown: false,

          title: 'Bible',
          tabBarIcon: ({ focused, color, size }) => {
            return <TabIconComponent focused={focused} icon={icons.book} title="Bible" />;
          },
        }}
      />
      <Tabs.Screen
        name="CreateTab"
        options={{
          title: 'Create',
          headerShown: false,
          tabBarIcon: ({ focused, color, size }) => {
            return <TabIconComponent focused={focused} icon={icons.circlePlus} title="Create" />;
          },
        }}
      />
      <Tabs.Screen
        name="NotificationsTab"
        options={{
          title: 'Notifications',
          headerShown: false,
          tabBarIcon: ({ focused, color, size }) => {
            return <TabIconComponent focused={focused} icon={icons.bell} title="Notifications" />;
          },
        }}
      />
      <Tabs.Screen
        name="ProfileTab"
        options={{
          title: 'Profile',
          headerShown: false,
          tabBarIcon: ({ focused, color, size }) => {
            return <TabIconComponent focused={focused} icon={icons.person} title="Profile" />;
          },
        }}
      />
    </Tabs>
  );
}
