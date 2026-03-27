import { useSignUpUser } from '@/src/hooks/useProfile';
import { Ionicons } from '@expo/vector-icons';
import { Input } from '@rneui/themed';
import * as Linking from 'expo-linking';
import { useRouter } from 'expo-router';
import { useState } from 'react';
import {
  Alert,
  Keyboard,
  Platform,
  Text,
  TouchableOpacity,
  TouchableWithoutFeedback,
  View,
  useColorScheme,
} from 'react-native';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

export default function SignUp() {
  const router = useRouter();
  const insets = useSafeAreaInsets();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [acceptedPolicies, setAcceptedPolicies] = useState(false);
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

    if (!acceptedPolicies) {
      Alert.alert(
        'Agreement required',
        'You must accept the Terms of Service and Statement of Faith before creating an account.',
      );
      return;
    }

    signUpWithEmail.mutate(
      { email: trimmedEmail, password, firstName: trimmedFirstName, lastName: trimmedLastName },
      {
        onSuccess: (data) => {
          const params: Record<string, string> = {
            email: trimmedEmail,
            firstName: trimmedFirstName,
            lastName: trimmedLastName,
          };
          if (data?.user?.id) {
            params.userId = data.user.id;
          }
          router.push({ pathname: '/about-details', params });
        },
      },
    );
  }

  return (
    <TouchableWithoutFeedback onPress={Keyboard.dismiss} accessible={false}>
      <View className="flex-1 bg-white dark:bg-black">
        <KeyboardAwareScrollView
          style={{ flex: 1 }}
          contentContainerStyle={{ flexGrow: 1 }}
          enableOnAndroid
          enableAutomaticScroll
          extraScrollHeight={Platform.OS === 'ios' ? 96 : 72}
          keyboardOpeningTime={0}
          keyboardShouldPersistTaps="handled"
          showsVerticalScrollIndicator={false}>
          <View className="flex-1 justify-between">
            <View
              style={{
                paddingHorizontal: 24,
                paddingTop: 24,
                paddingBottom: 32,
              }}>
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
            </View>

          <View className="mb-2 rounded-lg border border-gray-300 p-4 dark:border-gray-700">
            <View className="flex-row items-start gap-3">
              <TouchableOpacity
                accessibilityRole="checkbox"
                accessibilityState={{ checked: acceptedPolicies }}
                onPress={() => setAcceptedPolicies((prev) => !prev)}
                className="mt-0.5">
                <Ionicons
                  name={acceptedPolicies ? 'checkbox-outline' : 'square-outline'}
                  size={22}
                  color={colorScheme === 'dark' ? '#F5F5F5' : '#424242'}
                />
              </TouchableOpacity>

              <Text className="flex-1 text-sm leading-6 text-gray-700 dark:text-gray-300">
                I agree to the{' '}
                <Text
                  className="underline"
                  onPress={() =>
                    Linking.openURL(`${process.env.EXPO_PUBLIC_WEB_INTERFACE_URL}/terms`)
                  }>
                  Terms of Service
                </Text>{' '}
                and{' '}
                <Text
                  className="underline"
                  onPress={() =>
                    Linking.openURL(
                      `${process.env.EXPO_PUBLIC_WEB_INTERFACE_URL}/statement-of-faith`,
                    )
                  }>
                  Statement of Faith
                </Text>
                .
              </Text>
            </View>
          </View>

            <View
              className="border-t border-gray-200 bg-white px-6 pt-4 dark:border-neutral-800 dark:bg-black"
              style={{
                paddingBottom: Math.max(insets.bottom, 16),
              }}>
              <TouchableOpacity
                className={`rounded-lg p-3 ${
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
            </View>
          </View>
        </KeyboardAwareScrollView>
      </View>
    </TouchableWithoutFeedback>
  );
}
