import {
  useSignInUserWithAppleIdToken,
  useSignInUserWithGoogleIdToken,
  useSignInUserWithOAuth,
} from '@/src/hooks/useProfile';
import { clearPendingOAuthReturnTo, setPendingOAuthReturnTo } from '@/src/lib/oauthReturnTo';
import type { OAuthProvider } from '@/src/lib/authOAuth';
import { Ionicons } from '@expo/vector-icons';
import {
  GoogleSignin,
  isErrorWithCode,
  isSuccessResponse,
  statusCodes,
} from '@react-native-google-signin/google-signin';
import * as AppleAuthentication from 'expo-apple-authentication';
import { Image } from 'expo-image';
import { useEffect, useState } from 'react';
import {
  ActivityIndicator,
  Alert,
  Platform,
  Text,
  TouchableOpacity,
  useColorScheme,
  useWindowDimensions,
  View,
} from 'react-native';

type AuthProviderButtonsProps = {
  buttonLabels?: Partial<Record<OAuthProvider, string>>;
  disabled?: boolean;
  dividerLabel?: string;
  nativeAppleButtonType?: 'continue' | 'signIn' | 'signUp';
  onBeforeStart?: () => boolean;
  onSuccess?: () => void;
  returnTo?: string | null;
};

const PROVIDERS: {
  provider: OAuthProvider;
  label: string;
  icon: keyof typeof Ionicons.glyphMap;
}[] = [
  { provider: 'google', label: 'Continue with Google', icon: 'logo-google' },
  { provider: 'apple', label: 'Continue with Apple', icon: 'logo-apple' },
];

const GOOGLE_G_MARK = require('../../assets/images/google-g.svg');
const APPLE_NATIVE_BUTTON_TYPES = {
  continue: AppleAuthentication.AppleAuthenticationButtonType.CONTINUE,
  signIn: AppleAuthentication.AppleAuthenticationButtonType.SIGN_IN,
  signUp: AppleAuthentication.AppleAuthenticationButtonType.SIGN_UP,
};

export default function AuthProviderButtons({
  buttonLabels,
  disabled = false,
  dividerLabel,
  nativeAppleButtonType = 'signIn',
  onBeforeStart,
  onSuccess,
  returnTo,
}: AuthProviderButtonsProps) {
  const colorScheme = useColorScheme();
  const { width: windowWidth } = useWindowDimensions();
  const signInWithOAuth = useSignInUserWithOAuth();
  const signInWithAppleIdToken = useSignInUserWithAppleIdToken();
  const signInWithGoogleIdToken = useSignInUserWithGoogleIdToken();
  const [isAppleAuthenticationAvailable, setIsAppleAuthenticationAvailable] = useState(false);
  const shouldUseNativeApple = Platform.OS === 'ios' && isAppleAuthenticationAvailable;
  const shouldUseNativeGoogle = Platform.OS !== 'web';
  const isBusy =
    signInWithOAuth.isPending ||
    signInWithAppleIdToken.isPending ||
    signInWithGoogleIdToken.isPending;
  const foregroundColor = colorScheme === 'dark' ? '#F5F5F5' : '#111827';
  const googleButtonBackgroundColor = colorScheme === 'dark' ? '#131314' : '#FFFFFF';
  const googleButtonBorderColor = colorScheme === 'dark' ? '#8E918F' : '#747775';
  const googleButtonTextColor = colorScheme === 'dark' ? '#E3E3E3' : '#1F1F1F';
  const googleButtonLabel = buttonLabels?.google ?? 'Continue with Google';
  const appleButtonLabel = buttonLabels?.apple ?? 'Continue with Apple';
  const authProviderButtonWidth = Math.max(192, Math.min(windowWidth - 48, 312));
  const visibleProviders = PROVIDERS.filter(
    ({ provider }) =>
      !(provider === 'apple' && shouldUseNativeApple) &&
      !(provider === 'google' && shouldUseNativeGoogle),
  );

  useEffect(() => {
    if (!shouldUseNativeGoogle) return;

    const webClientId = process.env.EXPO_PUBLIC_GOOGLE_WEB_CLIENT_ID?.trim();
    const iosClientId = process.env.EXPO_PUBLIC_GOOGLE_IOS_CLIENT_ID?.trim();

    if (!webClientId) return;

    if (Platform.OS === 'ios') {
      if (!iosClientId) return;

      GoogleSignin.configure({
        iosClientId,
        webClientId,
      });
      return;
    }

    GoogleSignin.configure({ webClientId });
  }, [shouldUseNativeGoogle]);

  useEffect(() => {
    if (Platform.OS !== 'ios') return;

    AppleAuthentication.isAvailableAsync()
      .then(setIsAppleAuthenticationAvailable)
      .catch(() => setIsAppleAuthenticationAvailable(false));
  }, []);

  const savePendingReturnTarget = async () => {
    try {
      await setPendingOAuthReturnTo(returnTo);
    } catch (error) {
      console.error('Unable to save OAuth return target:', error);
    }
  };

  const clearPendingReturnTarget = async () => {
    try {
      await clearPendingOAuthReturnTo();
    } catch (error) {
      console.error('Unable to clear OAuth return target:', error);
    }
  };

  const handlePress = async (provider: OAuthProvider) => {
    if (disabled || isBusy) return;
    if (onBeforeStart && !onBeforeStart()) return;

    await savePendingReturnTarget();

    try {
      const data = await signInWithOAuth.mutateAsync({ provider });
      if (data?.session) {
        onSuccess?.();
      } else {
        await clearPendingReturnTarget();
      }
    } catch {
      await clearPendingReturnTarget();
      // The mutation hook shows the alert.
    }
  };

  const handleNativeGooglePress = async () => {
    if (disabled || isBusy) return;
    if (onBeforeStart && !onBeforeStart()) return;

    const webClientId = process.env.EXPO_PUBLIC_GOOGLE_WEB_CLIENT_ID?.trim();
    const iosClientId = process.env.EXPO_PUBLIC_GOOGLE_IOS_CLIENT_ID?.trim();
    const iosUrlScheme = process.env.EXPO_PUBLIC_GOOGLE_IOS_URL_SCHEME?.trim();

    if (!webClientId) {
      Alert.alert(
        'Google Sign In Error',
        'Missing EXPO_PUBLIC_GOOGLE_WEB_CLIENT_ID. Add your Google web client ID and rebuild the app.',
      );
      return;
    }

    if (Platform.OS === 'ios' && !iosClientId) {
      Alert.alert(
        'Google Sign In Error',
        'Missing EXPO_PUBLIC_GOOGLE_IOS_CLIENT_ID. Add your Google iOS client ID and rebuild the app.',
      );
      return;
    }

    if (Platform.OS === 'ios' && !iosUrlScheme) {
      Alert.alert(
        'Google Sign In Error',
        'Missing EXPO_PUBLIC_GOOGLE_IOS_URL_SCHEME. Add the reversed iOS client ID URL scheme and rebuild the app.',
      );
      return;
    }

    try {
      await GoogleSignin.hasPlayServices({ showPlayServicesUpdateDialog: true });
      const response = await GoogleSignin.signIn();

      if (!isSuccessResponse(response)) {
        return;
      }

      if (!response.data.idToken) {
        Alert.alert('Google Sign In Error', 'No Google identity token was returned.');
        return;
      }

      await savePendingReturnTarget();

      try {
        const data = await signInWithGoogleIdToken.mutateAsync({
          identityToken: response.data.idToken,
          profile: {
            email: response.data.user.email,
            familyName: response.data.user.familyName,
            fullName: response.data.user.name,
            givenName: response.data.user.givenName,
            photoUrl: response.data.user.photo,
          },
        });

        if (data?.session) {
          onSuccess?.();
        } else {
          await clearPendingReturnTarget();
        }
      } catch {
        await clearPendingReturnTarget();
        // The mutation hook shows the alert.
      }
    } catch (error) {
      if (isErrorWithCode(error)) {
        if (error.code === statusCodes.IN_PROGRESS) {
          return;
        }

        if (error.code === statusCodes.PLAY_SERVICES_NOT_AVAILABLE) {
          Alert.alert(
            'Google Sign In Error',
            'Google Play Services is not available or needs to be updated.',
          );
          return;
        }
      }

      Alert.alert(
        'Google Sign In Error',
        error instanceof Error ? error.message : 'Unable to start Google sign in.',
      );
      console.error('Google Sign In Error:', error);
    }
  };

  const handleNativeApplePress = async () => {
    if (disabled || isBusy) return;
    if (onBeforeStart && !onBeforeStart()) return;

    let credential: AppleAuthentication.AppleAuthenticationCredential;
    try {
      credential = await AppleAuthentication.signInAsync({
        requestedScopes: [
          AppleAuthentication.AppleAuthenticationScope.FULL_NAME,
          AppleAuthentication.AppleAuthenticationScope.EMAIL,
        ],
      });
    } catch (error) {
      if (
        typeof error === 'object' &&
        error !== null &&
        'code' in error &&
        error.code === 'ERR_REQUEST_CANCELED'
      ) {
        return;
      }

      Alert.alert(
        'Apple Sign In Error',
        error instanceof Error ? error.message : 'Unable to start Apple sign in.',
      );
      return;
    }

    if (!credential.identityToken) {
      Alert.alert('Apple Sign In Error', 'No Apple identity token was returned.');
      return;
    }

    await savePendingReturnTarget();

    try {
      const data = await signInWithAppleIdToken.mutateAsync({
        fullName: credential.fullName,
        identityToken: credential.identityToken,
      });

      if (data?.session) {
        onSuccess?.();
      } else {
        await clearPendingReturnTarget();
      }
    } catch {
      await clearPendingReturnTarget();
      // The mutation hook shows the alert.
    }
  };

  return (
    <View>
      {dividerLabel ? (
        <View className="my-5 flex-row items-center">
          <View className="h-px flex-1 bg-gray-200 dark:bg-gray-800" />
          <Text className="mx-3 text-xs font-semibold uppercase text-gray-500 dark:text-gray-400">
            {dividerLabel}
          </Text>
          <View className="h-px flex-1 bg-gray-200 dark:bg-gray-800" />
        </View>
      ) : null}

      <View className="gap-3">
        {shouldUseNativeGoogle ? (
          <TouchableOpacity
            activeOpacity={0.85}
            accessibilityLabel={googleButtonLabel}
            accessibilityRole="button"
            disabled={disabled || isBusy}
            onPress={handleNativeGooglePress}
            style={{
              alignItems: 'center',
              alignSelf: 'center',
              backgroundColor: googleButtonBackgroundColor,
              borderColor: googleButtonBorderColor,
              borderRadius: 999,
              borderWidth: 1,
              height: 48,
              justifyContent: 'center',
              overflow: 'hidden',
              position: 'relative',
              opacity: disabled || isBusy ? 0.6 : 1,
              width: authProviderButtonWidth,
            }}>
            <View
              style={{
                alignItems: 'center',
                flexDirection: 'row',
                height: '100%',
                justifyContent: 'center',
                paddingHorizontal: 16,
                width: '100%',
              }}>
              {signInWithGoogleIdToken.isPending ? (
                <ActivityIndicator color={googleButtonTextColor} />
              ) : (
                <>
                  <View
                    style={{
                      alignItems: 'center',
                      backgroundColor: '#FFFFFF',
                      borderRadius: 10,
                      height: 20,
                      justifyContent: 'center',
                      marginRight: 12,
                      width: 20,
                    }}>
                    <Image
                      accessibilityIgnoresInvertColors
                      alt=""
                      contentFit="contain"
                      source={GOOGLE_G_MARK}
                      style={{ height: 18, width: 18 }}
                    />
                  </View>
                  <Text
                    style={{
                      color: googleButtonTextColor,
                      fontSize: 14,
                      fontWeight: '600',
                      lineHeight: 20,
                    }}>
                    {googleButtonLabel}
                  </Text>
                </>
              )}
            </View>
          </TouchableOpacity>
        ) : null}

        {visibleProviders.map(({ provider, label, icon }) => {
          const isProviderBusy = isBusy && signInWithOAuth.variables?.provider === provider;
          const isDisabled = disabled || isBusy;
          const providerLabel = buttonLabels?.[provider] ?? label;

          return (
            <TouchableOpacity
              key={provider}
              accessibilityLabel={providerLabel}
              accessibilityRole="button"
              className="flex-row items-center justify-center rounded-full border border-gray-300 bg-white p-3 dark:border-gray-700 dark:bg-black"
              disabled={isDisabled}
              onPress={() => handlePress(provider)}
              style={{
                alignSelf: 'center',
                minHeight: 48,
                opacity: isDisabled ? 0.6 : 1,
                width: authProviderButtonWidth,
              }}>
              {isProviderBusy ? (
                <ActivityIndicator color={foregroundColor} />
              ) : (
                <>
                  <Ionicons name={icon} size={20} color={foregroundColor} />
                  <Text className="ml-3 text-center font-semibold text-gray-900 dark:text-white">
                    {providerLabel}
                  </Text>
                </>
              )}
            </TouchableOpacity>
          );
        })}

        {shouldUseNativeApple ? (
          <View
            className="overflow-hidden rounded-full border border-white"
            style={{
              alignSelf: 'center',
              borderRadius: 999,
              width: authProviderButtonWidth,
            }}>
            <AppleAuthentication.AppleAuthenticationButton
              accessibilityLabel={appleButtonLabel}
              buttonType={APPLE_NATIVE_BUTTON_TYPES[nativeAppleButtonType]}
              buttonStyle={AppleAuthentication.AppleAuthenticationButtonStyle.BLACK}
              cornerRadius={24}
              onPress={handleNativeApplePress}
              style={{ height: 48, opacity: disabled || isBusy ? 0.6 : 1, width: '100%' }}
            />
          </View>
        ) : null}
      </View>
    </View>
  );
}
