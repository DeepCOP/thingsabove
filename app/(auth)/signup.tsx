import ProfileDetailsForm from '@/src/components/ProfileDetailsForm';
import {
  ProfileDetailsFormErrors,
  buildProfileDetailsFormValues,
  hasProfileDetailsErrors,
  toSignUpProfileInput,
  validateProfileDetailsForm,
} from '@/src/profileDetails';
import { useSignUpUser } from '@/src/hooks/useProfile';
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
  const [detailsForm, setDetailsForm] = useState(() => buildProfileDetailsFormValues());
  const [detailsErrors, setDetailsErrors] = useState<ProfileDetailsFormErrors>({});
  const colorScheme = useColorScheme();
  const signUpWithEmail = useSignUpUser();
  const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  const trimmedEmail = email.trim();
  const isEmailValid = EMAIL_REGEX.test(trimmedEmail);
  const profileErrors = validateProfileDetailsForm(detailsForm, {
    requireName: true,
    requireChoices: true,
  });

  const isDisabled =
    !trimmedEmail ||
    !password ||
    !confirmPassword ||
    password !== confirmPassword ||
    !isEmailValid ||
    hasProfileDetailsErrors(profileErrors) ||
    signUpWithEmail.isPending;

  async function signUp() {
    if (!trimmedEmail || !password || !confirmPassword) {
      Alert.alert('Missing fields', 'Please fill in all required fields.');
      return;
    }

    if (!isEmailValid) {
      Alert.alert('Invalid email', 'Please enter a valid email address.');
      return;
    }

    if (password !== confirmPassword) {
      Alert.alert('Password mismatch', 'Passwords do not match.');
      return;
    }

    const nextErrors = validateProfileDetailsForm(detailsForm, {
      requireName: true,
      requireChoices: true,
    });
    setDetailsErrors(nextErrors);

    if (hasProfileDetailsErrors(nextErrors)) {
      Alert.alert('Complete your profile', 'Please finish the faith and church details.');
      return;
    }

    signUpWithEmail.mutate(toSignUpProfileInput(trimmedEmail, password, detailsForm), {
      onSuccess: () => {
        router.replace(`../confirm-email?email=${encodeURIComponent(trimmedEmail)}`);
      },
    });
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

          <ProfileDetailsForm
            values={detailsForm}
            errors={detailsErrors}
            onChange={(patch) => {
              setDetailsForm((current) => ({ ...current, ...patch }));
              setDetailsErrors((current) => {
                const next = { ...current };
                for (const key of Object.keys(patch) as Array<keyof ProfileDetailsFormErrors>) {
                  delete next[key];
                }
                return next;
              });
            }}
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

          <TouchableOpacity
            className={`mt-4 rounded-lg p-3 ${
              isDisabled ? 'bg-gray-300 dark:bg-gray-700' : 'bg-black dark:bg-white'
            }`}
            onPress={signUp}
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
