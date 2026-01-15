import { supabase } from '@/src/lib/supabaseClient';
import { Input } from '@rneui/themed';
import { useState } from 'react';
import { Alert, Text, TouchableOpacity, useColorScheme, View } from 'react-native';

export default function SignUp() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [loading, setLoading] = useState(false);
  const colorScheme = useColorScheme();

  async function signUp() {
    setLoading(true);
    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          first_name: firstName,
          last_name: lastName,
        },
      },
    });
    if (error) Alert.alert(error.message);
    setLoading(false);
  }

  return (
    <View className="flex-1 justify-center px-6">
      <Input
        label="First Name"
        value={firstName}
        onChangeText={setFirstName}
        style={{ color: colorScheme === 'dark' ? '#F5F5F5' : '#424242' }}
        placeholderTextColor={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
      />
      <Input
        label="Last Name"
        value={lastName}
        onChangeText={setLastName}
        style={{ color: colorScheme === 'dark' ? '#F5F5F5' : '#424242' }}
        placeholderTextColor={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
      />
      <Input
        label="Email"
        value={email}
        onChangeText={setEmail}
        style={{ color: colorScheme === 'dark' ? '#F5F5F5' : '#424242' }}
        placeholderTextColor={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
      />
      <Input
        label="Password"
        secureTextEntry
        value={password}
        onChangeText={setPassword}
        style={{ color: colorScheme === 'dark' ? '#F5F5F5' : '#424242' }}
        placeholderTextColor={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
      />

      <TouchableOpacity
        className="bg-indigo-700 p-3 rounded-lg mt-4"
        onPress={signUp}
        disabled={loading}>
        <Text className="text-white text-center font-bold">Sign Up</Text>
      </TouchableOpacity>
    </View>
  );
}
