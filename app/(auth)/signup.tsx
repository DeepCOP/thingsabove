import { useSignUpUser } from '@/src/hooks/useProfile';
import { Input } from '@rneui/themed';
import { useState } from 'react';
import {
  Alert,
  Keyboard,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  Text,
  TouchableOpacity,
  TouchableWithoutFeedback,
  useColorScheme,
} from 'react-native';

export default function SignUp() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const colorScheme = useColorScheme();
  const signUpWithEmail = useSignUpUser();
  const MIN_NAME_LENGTH = 2;
  const MAX_NAME_LENGTH = 50;
  const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  const trimmedEmail = email.trim();
  const trimmedFirstName = firstName.trim();
  const trimmedLastName = lastName.trim();
  const isEmailValid = EMAIL_REGEX.test(trimmedEmail);
  const isFirstNameValid =
    trimmedFirstName.length >= MIN_NAME_LENGTH && trimmedFirstName.length <= MAX_NAME_LENGTH;
  const isLastNameValid =
    trimmedLastName.length >= MIN_NAME_LENGTH && trimmedLastName.length <= MAX_NAME_LENGTH;

  const isDisabled =
    !trimmedEmail ||
    !password ||
    !confirmPassword ||
    password !== confirmPassword ||
    !isEmailValid ||
    !isFirstNameValid ||
    !isLastNameValid ||
    signUpWithEmail.isPending;

  async function signUp() {
    if (!trimmedEmail || !password || !confirmPassword || !trimmedFirstName || !trimmedLastName) {
      Alert.alert('Missing fields', 'Please fill in all fields.');
      return;
    }
    if (!isEmailValid) {
      Alert.alert('Invalid email', 'Please enter a valid email address.');
      return;
    }
    if (!isFirstNameValid || !isLastNameValid) {
      Alert.alert(
        'Invalid name',
        `First and last name must be between ${MIN_NAME_LENGTH} and ${MAX_NAME_LENGTH} characters.`,
      );
      return;
    }
    if (password !== confirmPassword) {
      Alert.alert('Password mismatch', 'Passwords do not match.');
      return;
    }
    signUpWithEmail.mutate(
      { email: trimmedEmail, password, firstName: trimmedFirstName, lastName: trimmedLastName },
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
            label="First Name"
            value={firstName}
            onChangeText={setFirstName}
            maxLength={MAX_NAME_LENGTH}
            style={{ color: colorScheme === 'dark' ? '#F5F5F5' : '#424242' }}
            placeholderTextColor={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
          />
          <Input
            label="Last Name"
            value={lastName}
            onChangeText={setLastName}
            maxLength={MAX_NAME_LENGTH}
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
            className={`p-3 rounded-lg mt-4 ${
              isDisabled ? 'bg-gray-300 dark:bg-gray-700' : 'bg-black dark:bg-white'
            }`}
            onPress={signUp}
            disabled={isDisabled}>
            <Text
              className="text-white dark:text-black text-center font-bold"
              style={{ opacity: isDisabled ? 0.6 : 1 }}>
              Sign Up
            </Text>
          </TouchableOpacity>
        </ScrollView>
      </TouchableWithoutFeedback>
    </KeyboardAvoidingView>
  );
}
