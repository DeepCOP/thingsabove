import { icons } from '@/constants/icons';
import { Tabs } from 'expo-router';
import React from 'react';
import { Image, Text, View } from 'react-native';

const TabIcon = ({ focused, icon, title }: { focused: boolean; icon: any; title: string }) => {
  if (focused) {
    return (
      <View className="flex f w-full flex-1 min-w-[85px] min-h-16 mt-4 justify-center items-center overflow-hidden">
        <Image source={icon} className="size-6" tintColor={'#1FB1F9FF'} />
        <Text className="text-icon-tint text-xs font-[400] font-open-sans-regular">{title}</Text>
      </View>
    );
  }
  return (
    <View className="flex w-full flex-1 min-w-[80px] min-h-16 mt-4 justify-center items-center overflow-hidden">
      <Image source={icon} className="size-6" tintColor={'black'} />
      <Text className="black text-xs font-[400] text-[#383838FF] font-open-sans-regular">
        {title}
      </Text>
    </View>
  );
};

export default function TabLayout() {
  return (
    <Tabs
      screenOptions={{
        tabBarShowLabel: false,
        tabBarLabelStyle: {
          fontWeight: 'bold',
          color: 'black',
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
          title: 'Bible',
          headerShown: false,
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
