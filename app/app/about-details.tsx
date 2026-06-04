import AboutDetailsForm from '@/src/components/AboutDetailsForm';
import { useSaveSignupAboutDetails, useUpdateProfile } from '@/src/hooks/useProfile';
import {
  hasProfileDetailsErrors,
  ProfileDetailsFormErrors,
  toSignUpAboutDetailsInput,
  toUpdateProfileInput,
  validateProfileDetailsForm,
} from '@/src/profileDetails';
import { useAuth } from '@/src/state/AuthContext';
import { useSignUpDetailsStore } from '@/src/state/useSignUpDetailsStore';
import { useLocalSearchParams, useRouter } from 'expo-router';
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
  View,
} from 'react-native';

export default function AboutDetails() {
  const router = useRouter();
  const { email, userId, firstName, lastName } = useLocalSearchParams<{
    email?: string;
    userId?: string;
    firstName?: string;
    lastName?: string;
  }>();
  const colorScheme = useColorScheme();
  const { details, setDetails, resetDetails } = useSignUpDetailsStore();
  const { session } = useAuth();
  const updateProfile = useUpdateProfile(session?.user?.id);
  const saveSignupAboutDetails = useSaveSignupAboutDetails();
  const signupFirstName = typeof firstName === 'string' ? firstName.trim() : '';
  const signupLastName = typeof lastName === 'string' ? lastName.trim() : '';
  const [form, setForm] = useState(() => ({
    ...details,
    firstName: details.firstName || signupFirstName,
    lastName: details.lastName || signupLastName,
  }));
  const [errors, setErrors] = useState<ProfileDetailsFormErrors>({});
  const hasSession = Boolean(session?.user?.id);
  const isSaving = updateProfile.isPending || saveSignupAboutDetails.isPending;
  const signupEmail = typeof email === 'string' ? email.trim() : '';
  const signupUserId = typeof userId === 'string' ? userId : '';

  const finishFlow = () => {
    resetDetails();
    if (hasSession) {
      router.replace('/app');
      return;
    }
    router.replace({
      pathname: '/app/confirm-email',
      params: { email: signupEmail },
    });
  };

  const onSkip = () => {
    finishFlow();
  };

  const onSave = () => {
    const nextErrors = validateProfileDetailsForm(form);
    setErrors(nextErrors);
    if (hasProfileDetailsErrors(nextErrors)) {
      return;
    }

    if (!hasSession) {
      if (!signupEmail || !signupUserId) {
        finishFlow();
        return;
      }

      setDetails(form);
      saveSignupAboutDetails.mutate(
        { user_id: signupUserId, email: signupEmail, ...toSignUpAboutDetailsInput(form) },
        {
          onSuccess: () => {
            finishFlow();
          },
        },
      );
      return;
    }

    setDetails(form);
    updateProfile.mutate(toUpdateProfileInput(form), {
      onSuccess: () => {
        finishFlow();
      },
    });
  };

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
          <View className="mb-6 flex-row items-center justify-between">
            <Text className="text-2xl font-semibold text-gray-900 dark:text-white">About</Text>
            <TouchableOpacity onPress={onSkip} disabled={isSaving}>
              <Text className="text-sm font-medium text-gray-500 dark:text-gray-400">
                Skip for now
              </Text>
            </TouchableOpacity>
          </View>

          <AboutDetailsForm
            values={form}
            errors={errors}
            showNameFields={false}
            onChange={(patch) => {
              setForm((current) => ({ ...current, ...patch }));
              setErrors((current) => {
                const next = { ...current };
                for (const key of Object.keys(patch) as (keyof ProfileDetailsFormErrors)[]) {
                  delete next[key];
                }
                return next;
              });
            }}
          />

          <TouchableOpacity
            className={`mt-4 rounded-lg p-3 ${colorScheme === 'dark' ? 'bg-white' : 'bg-black'}`}
            onPress={onSave}
            disabled={isSaving}>
            <Text
              className={`text-center font-bold ${
                colorScheme === 'dark' ? 'text-black' : 'text-white'
              }`}>
              Save
            </Text>
          </TouchableOpacity>
        </ScrollView>
      </TouchableWithoutFeedback>
    </KeyboardAvoidingView>
  );
}
