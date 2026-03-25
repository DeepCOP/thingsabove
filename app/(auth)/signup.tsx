import { useSignUpUser } from '@/src/hooks/useProfile';
import FormRestrictionText from '@/src/components/FormRestrictionText';
import { Ionicons } from '@expo/vector-icons';
import { Input } from '@rneui/themed';
import { useRouter } from 'expo-router';
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
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const colorScheme = useColorScheme();
  const MIN_NAME_LENGTH = 2;
  const MAX_NAME_LENGTH = 50;
  const MIN_PASSWORD_LENGTH = 6;

  const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  const signUpWithEmail = useSignUpUser();

  const trimmedEmail = email.trim();
  const trimmedFirstName = firstName.trim();
  const trimmedLastName = lastName.trim();

  const isEmailValid = EMAIL_REGEX.test(trimmedEmail);
  const isFirstNameValid =
    trimmedFirstName.length >= MIN_NAME_LENGTH && trimmedFirstName.length <= MAX_NAME_LENGTH;
  const isLastNameValid =
    trimmedLastName.length >= MIN_NAME_LENGTH && trimmedLastName.length <= MAX_NAME_LENGTH;
  const isPasswordValid = password.length >= MIN_PASSWORD_LENGTH;
  const nameRestrictionText = `Required. ${MIN_NAME_LENGTH}-${MAX_NAME_LENGTH} characters.`;
  const passwordRestrictionText = `Required. At least ${MIN_PASSWORD_LENGTH} characters.`;

  const isDisabled =
    !trimmedEmail ||
    !password ||
    !confirmPassword ||
    !isPasswordValid ||
    password !== confirmPassword ||
    !isEmailValid ||
    !isFirstNameValid ||
    !isLastNameValid ||
    signUpWithEmail.isPending;

  function handleSignUp() {
    if (!trimmedEmail || !password || !confirmPassword || !trimmedFirstName || !trimmedLastName) {
      Alert.alert('Missing fields', 'Please fill in all required fields.');
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

    if (!isPasswordValid) {
      Alert.alert(
        'Invalid password',
        `Password must be at least ${MIN_PASSWORD_LENGTH} characters.`,
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
        onSuccess: (data) => {
          const params: Record<string, string> = { email: trimmedEmail };
          if (data?.user?.id) {
            params.userId = data.user.id;
          }
          router.push({ pathname: '/about-details', params });
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
            paddingHorizontal: 24,
            paddingVertical: 24,
          }}
          keyboardShouldPersistTaps="handled"
          automaticallyAdjustKeyboardInsets>
          <Text className="mb-6 text-2xl font-semibold text-gray-900 dark:text-white">
            Create Your Account
          </Text>

          <Input
            label="First Name"
            value={firstName}
            onChangeText={setFirstName}
            maxLength={MAX_NAME_LENGTH}
            errorMessage={
              firstName && !isFirstNameValid
                ? `First name must be ${MIN_NAME_LENGTH}-${MAX_NAME_LENGTH} characters.`
                : ''
            }
            style={{ color: colorScheme === 'dark' ? '#F5F5F5' : '#424242' }}
            placeholderTextColor={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
          />
          <FormRestrictionText className="-mt-4 mb-4">{nameRestrictionText}</FormRestrictionText>
          <Input
            label="Last Name"
            value={lastName}
            onChangeText={setLastName}
            maxLength={MAX_NAME_LENGTH}
            errorMessage={
              lastName && !isLastNameValid
                ? `Last name must be ${MIN_NAME_LENGTH}-${MAX_NAME_LENGTH} characters.`
                : ''
            }
            style={{ color: colorScheme === 'dark' ? '#F5F5F5' : '#424242' }}
            placeholderTextColor={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
          />
          <FormRestrictionText className="-mt-4 mb-4">{nameRestrictionText}</FormRestrictionText>

          <Input
            label="Email"
            value={email}
            onChangeText={setEmail}
            autoCapitalize="none"
            autoCorrect={false}
            keyboardType="email-address"
            errorMessage={trimmedEmail && !isEmailValid ? 'Enter a valid email address.' : ''}
            style={{ color: colorScheme === 'dark' ? '#F5F5F5' : '#424242' }}
            placeholderTextColor={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
          />
          <FormRestrictionText className="-mt-4 mb-4">
            Required. Use a valid email address.
          </FormRestrictionText>
          <Input
            label="Password"
            secureTextEntry={!showPassword}
            value={password}
            onChangeText={setPassword}
            autoCapitalize="none"
            autoCorrect={false}
            errorMessage={
              password && !isPasswordValid
                ? `Password must be at least ${MIN_PASSWORD_LENGTH} characters.`
                : ''
            }
            style={{ color: colorScheme === 'dark' ? '#F5F5F5' : '#424242' }}
            placeholderTextColor={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
            rightIcon={
              <TouchableOpacity onPress={() => setShowPassword((prev) => !prev)}>
                <Ionicons
                  name={showPassword ? 'eye-off-outline' : 'eye-outline'}
                  size={20}
                  color={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
                />
              </TouchableOpacity>
            }
          />
          <FormRestrictionText className="-mt-4 mb-4">
            {passwordRestrictionText}
          </FormRestrictionText>
          <Input
            label="Confirm Password"
            secureTextEntry={!showConfirmPassword}
            value={confirmPassword}
            onChangeText={setConfirmPassword}
            autoCapitalize="none"
            autoCorrect={false}
            errorMessage={
              confirmPassword && password !== confirmPassword ? 'Passwords do not match.' : ''
            }
            style={{ color: colorScheme === 'dark' ? '#F5F5F5' : '#424242' }}
            placeholderTextColor={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
            rightIcon={
              <TouchableOpacity onPress={() => setShowConfirmPassword((prev) => !prev)}>
                <Ionicons
                  name={showConfirmPassword ? 'eye-off-outline' : 'eye-outline'}
                  size={20}
                  color={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
                />
              </TouchableOpacity>
            }
          />
          <FormRestrictionText className="-mt-4 mb-4">
            Required. Must match the password above.
          </FormRestrictionText>

          <TouchableOpacity
            className={`mt-4 rounded-lg p-3 ${
              isDisabled ? 'bg-gray-300 dark:bg-gray-700' : 'bg-black dark:bg-white'
            }`}
            onPress={handleSignUp}
            disabled={isDisabled}>
            <Text
              className="text-center font-bold text-white dark:text-black"
              style={{ opacity: isDisabled ? 0.6 : 1 }}>
              Sign Up
            </Text>
          </TouchableOpacity>
        </ScrollView>
      </TouchableWithoutFeedback>
    </KeyboardAvoidingView>
  );
}
