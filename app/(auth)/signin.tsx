import { useSignInUserWithPassword } from '@/src/hooks/useProfile';
import { Input } from '@rneui/themed';
import { useState } from 'react';
import {
  Keyboard,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  Text,
  TouchableOpacity,
  TouchableWithoutFeedback,
  useColorScheme,
} from 'react-native';

export default function SignIn() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const colorScheme = useColorScheme();
  const signInWithPassword = useSignInUserWithPassword();
  async function signIn() {
    signInWithPassword.mutate({ email, password });
  }
  const isDisabled = !email || !password || signInWithPassword.isPending;

  return (
    <KeyboardAvoidingView
      className="flex-1"
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>
      <TouchableWithoutFeedback onPress={Keyboard.dismiss} accessible={false}>
        <ScrollView
          contentContainerStyle={{
            flexGrow: 1,
            justifyContent: 'center',
            paddingHorizontal: 24,
            paddingVertical: 24,
          }}
          keyboardShouldPersistTaps="handled"
          automaticallyAdjustKeyboardInsets>
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
            disabled={isDisabled}>
            <Text
              className="text-white dark:text-black text-center font-bold"
              style={{ opacity: isDisabled ? 0.6 : 1 }}>
              Sign In
            </Text>
          </TouchableOpacity>
        </ScrollView>
      </TouchableWithoutFeedback>
    </KeyboardAvoidingView>
  );
}
