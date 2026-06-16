import AuthProviderButtons from '@/src/components/AuthProviderButtons';
import { useSignInUserWithPassword } from '@/src/hooks/useProfile';
import {
  clearPendingOAuthReturnTo,
  normalizeOAuthReturnTo,
  setPendingOAuthReturnTo,
} from '@/src/lib/oauthReturnTo';
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
  const { redirectPlanId, redirectGroupId, redirectInvitedBy, returnTo } = useLocalSearchParams<{
    redirectPlanId?: string;
    redirectGroupId?: string;
    redirectInvitedBy?: string;
    returnTo?: string;
  }>();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const colorScheme = useColorScheme();
  const signInWithPassword = useSignInUserWithPassword();

  const getPlanInvitationReturnTo = () => {
    if (!redirectPlanId || !redirectGroupId) return null;

    const params = new URLSearchParams({ groupId: redirectGroupId });
    if (redirectInvitedBy) {
      params.set('invitedBy', redirectInvitedBy);
    }

    return `/app/devotional_detail/${encodeURIComponent(redirectPlanId)}/invitation?${params.toString()}`;
  };

  const oauthReturnTo = getPlanInvitationReturnTo() ?? normalizeOAuthReturnTo(returnTo);

  const redirectToInvitation = () => {
    if (!redirectPlanId || !redirectGroupId) return;

    router.replace({
      pathname: '/app/devotional_detail/[planId]/invitation',
      params: {
        planId: redirectPlanId,
        groupId: redirectGroupId,
        ...(redirectInvitedBy ? { invitedBy: redirectInvitedBy } : {}),
      },
    } as Href);
  };

  const redirectAfterSignIn = () => {
    if (redirectPlanId && redirectGroupId) {
      redirectToInvitation();
      return;
    }

    if (oauthReturnTo) {
      router.replace(oauthReturnTo as Href);
    }
  };

  const savePendingReturnTarget = async () => {
    try {
      await setPendingOAuthReturnTo(oauthReturnTo);
    } catch (error) {
      console.error('Unable to save auth return target:', error);
    }
  };

  const clearPendingReturnTarget = async () => {
    try {
      await clearPendingOAuthReturnTo();
    } catch (error) {
      console.error('Unable to clear auth return target:', error);
    }
  };

  async function signIn() {
    await savePendingReturnTarget();

    try {
      await signInWithPassword.mutateAsync({ email, password });
      redirectAfterSignIn();
    } catch {
      await clearPendingReturnTarget();
      // The mutation hook shows the alert.
    }
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

          <AuthProviderButtons
            dividerLabel="or sign in with"
            onSuccess={redirectAfterSignIn}
            returnTo={oauthReturnTo}
          />
        </ScrollView>
      </TouchableWithoutFeedback>
    </KeyboardAvoidingView>
  );
}
