import { useSignInUserWithPassword } from '@/src/hooks/useProfile';
import { openExternalUrl } from '@/src/utils';
import { Ionicons } from '@expo/vector-icons';
import { Input } from '@rneui/themed';
import { Href, useLocalSearchParams, useRouter } from 'expo-router';
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
  const router = useRouter();
  const { redirectPlanId, redirectGroupId, redirectInvitedBy } = useLocalSearchParams<{
    redirectPlanId?: string;
    redirectGroupId?: string;
    redirectInvitedBy?: string;
  }>();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const colorScheme = useColorScheme();
  const signInWithPassword = useSignInUserWithPassword();

  const redirectToInvitation = () => {
    if (!redirectPlanId || !redirectGroupId) return;

    router.push({
      pathname: '/devotional_detail/[planId]/invitation',
      params: {
        planId: redirectPlanId,
        groupId: redirectGroupId,
        ...(redirectInvitedBy ? { invitedBy: redirectInvitedBy } : {}),
      },
    } as Href);
  };

  async function signIn() {
    signInWithPassword.mutate(
      { email, password },
      {
        onSuccess: () => {
          redirectToInvitation();
        },
      },
    );
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
          <Input
            style={{ color: colorScheme === 'dark' ? '#F5F5F5' : '#424242' }}
            label="Password"
            secureTextEntry={!showPassword}
            value={password}
            onChangeText={setPassword}
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
          <TouchableOpacity
            className="self-end mt-1"
            onPress={() =>
              openExternalUrl(`${process.env.EXPO_PUBLIC_WEB_INTERFACE_URL}/auth/forgot-password`)
            }>
            <Text className="text-blue-600 dark:text-blue-400 font-semibold">
              Forget your password?
            </Text>
          </TouchableOpacity>

          <TouchableOpacity
            className={` p-3 rounded-lg mt-4 ${
              isDisabled ? 'bg-gray-300 dark:bg-gray-700' : 'bg-black dark:bg-white'
            }`}
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
