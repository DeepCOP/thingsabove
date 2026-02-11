import { useSignUpUser } from '@/src/hooks/useProfile';
import { Input } from '@rneui/themed';
import { useState } from 'react';
import { Alert, Text, TouchableOpacity, useColorScheme, View } from 'react-native';

export default function SignUp() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const colorScheme = useColorScheme();
  const signUpWithEmail = useSignUpUser();

  const isDisabled =
    !email ||
    !password ||
    !confirmPassword ||
    password !== confirmPassword ||
    signUpWithEmail.isPending;

  async function signUp() {
    if (!email || !password || !confirmPassword || !firstName || !lastName) {
      alert('Please fill in all fields');
      return;
    }
    if (password !== confirmPassword) {
      alert('Passwords do not match');
      return;
    }
    signUpWithEmail.mutate(
      { email, password, firstName, lastName },
      {
        onSuccess: () => {
          Alert.alert(
            'Confirm your email',
            'We sent a confirmation link to your email. Please verify to continue.',
          );
        },
      },
    );
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
      <Input
        label="Confirm Password"
        secureTextEntry
        value={confirmPassword}
        onChangeText={setConfirmPassword}
        style={{ color: colorScheme === 'dark' ? '#F5F5F5' : '#424242' }}
        placeholderTextColor={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
      />

      <TouchableOpacity
        className="bg-black dark:bg-white p-3 rounded-lg mt-4"
        onPress={signUp}
        disabled={isDisabled}>
        <Text className="text-white dark:text-black text-center font-bold">Sign Up</Text>
      </TouchableOpacity>
    </View>
  );
}
