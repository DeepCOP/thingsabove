import { useSignInUserWithPassword } from '@/src/hooks/useProfile';
import { Input } from '@rneui/themed';
import { useState } from 'react';
import { Text, TouchableOpacity, useColorScheme, View } from 'react-native';

export default function SignIn() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const colorScheme = useColorScheme();
  const signInWithPassword = useSignInUserWithPassword();
  async function signIn() {
    signInWithPassword.mutate({ email, password });
  }

  return (
    <View className="flex-1 justify-center px-6">
      <Input
        label="Email"
        value={email}
        onChangeText={setEmail}
        style={{ color: colorScheme === 'dark' ? '#F5F5F5' : '#424242' }}
        placeholderTextColor={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
      />
      <Input label="Password" secureTextEntry value={password} onChangeText={setPassword} />

      <TouchableOpacity
        className="bg-black dark:bg-white p-3 rounded-lg mt-4"
        onPress={signIn}
        disabled={signInWithPassword.isPending}>
        <Text
          className="text-white dark:text-black text-center font-bold"
          style={{ opacity: signInWithPassword.isPending ? 0.6 : 1 }}>
          Sign In
        </Text>
      </TouchableOpacity>
    </View>
  );
}
