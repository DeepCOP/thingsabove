import { Ionicons } from '@expo/vector-icons';
import { Tabs } from 'expo-router';
import { useColorScheme } from 'react-native';

export default function AuthLayout() {
  const colorScheme = useColorScheme();

  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarStyle: {
          backgroundColor: colorScheme === 'dark' ? '#000' : '#fff',
        },
        tabBarActiveTintColor: colorScheme === 'dark' ? '#fff' : '#0F0D23',
      }}>
      <Tabs.Screen
        name="signin"
        options={{
          title: 'Sign In',
          tabBarIcon: ({ focused, color, size }) => {
            return (
              <Ionicons
                name={focused ? 'person' : 'person-outline'}
                size={size}
                color={color}
                focused={focused}
              />
            );
          },
        }}
      />
      <Tabs.Screen
        name="signup"
        options={{
          title: 'Sign Up',
          tabBarIcon: ({ focused, color }) => {
            return (
              <Ionicons
                name={focused ? 'person-add' : 'person-add-outline'}
                size={24}
                color={color}
                focused={focused}
              />
            );
          },
        }}
      />
    </Tabs>
  );
}
