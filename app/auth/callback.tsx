import LoadingSpinner from '@/src/components/LoadingSpinner';
import { createSessionFromCallbackUrl } from '@/src/lib/authOAuth';
import { clearPendingOAuthReturnTo, consumePendingOAuthReturnTo } from '@/src/lib/oauthReturnTo';
import { supabase } from '@/src/lib/supabaseClient';
import * as Linking from 'expo-linking';
import { Href, useRouter } from 'expo-router';
import { useEffect, useRef } from 'react';

const APP_HOME = '/app/(tabs)/PlansTab' as Href;
const SIGN_IN = '/app/signin' as Href;
const OAUTH_CALLBACK_PARAM_KEYS = [
  'access_token',
  'code',
  'error',
  'error_description',
  'refresh_token',
];

const getCallbackUrl = async (linkingUrl?: string | null) =>
  linkingUrl || Linking.getLinkingURL() || (await Linking.getInitialURL());

const hasOAuthCallbackParams = (url: string) => {
  try {
    const parsedUrl = new URL(url);
    const searchParams = new URLSearchParams(parsedUrl.search);
    const hashParams = new URLSearchParams(parsedUrl.hash.replace(/^#/, ''));

    return OAUTH_CALLBACK_PARAM_KEYS.some((key) => searchParams.has(key) || hashParams.has(key));
  } catch {
    return false;
  }
};

const ensureCallbackSession = async (callbackUrl: string) => {
  const { data: currentSessionData } = await supabase.auth.getSession();

  if (currentSessionData.session) {
    return;
  }

  await createSessionFromCallbackUrl(callbackUrl);
};

export default function AuthCallback() {
  const router = useRouter();
  const linkingUrl = Linking.useLinkingURL();
  const hasHandledCallbackRef = useRef(false);

  useEffect(() => {
    if (hasHandledCallbackRef.current) return;

    hasHandledCallbackRef.current = true;
    let isActive = true;

    const completeCallback = async () => {
      let nextRoute: Href = APP_HOME;

      try {
        const callbackUrl = await getCallbackUrl(linkingUrl);

        if (callbackUrl && hasOAuthCallbackParams(callbackUrl)) {
          await ensureCallbackSession(callbackUrl);

          const pendingReturnTo = await consumePendingOAuthReturnTo();
          nextRoute = pendingReturnTo ? (pendingReturnTo as Href) : APP_HOME;
        } else {
          await clearPendingOAuthReturnTo();
        }
      } catch (error) {
        await clearPendingOAuthReturnTo();
        nextRoute = SIGN_IN;
        console.error('OAuth callback error:', error);
      } finally {
        if (isActive) {
          router.replace(nextRoute);
        }
      }
    };

    completeCallback();

    return () => {
      isActive = false;
    };
  }, [linkingUrl, router]);

  return <LoadingSpinner />;
}
