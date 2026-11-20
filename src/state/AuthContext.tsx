import { readStoredSession, supabase } from '@/src/lib/supabaseClient';
import { isAuthRetryableFetchError, Session } from '@supabase/supabase-js';
import { createContext, useContext, useEffect, useState } from 'react';
import { clearPushNotificationSetup } from '../api/mutations';

type AuthContextType = {
  session: Session | null;
  loading: boolean;
  isGuest: boolean;
  isOfflineSession: boolean;
  signOut: () => Promise<void>;
};

const AuthContext = createContext<AuthContextType>({
  session: null,
  loading: true,
  isGuest: true,
  isOfflineSession: false,
  signOut: () => Promise.resolve(),
});

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [session, setSession] = useState<Session | null>(null);
  const [isOfflineSession, setIsOfflineSession] = useState(false);
  const [loading, setLoading] = useState(true);

  const isGuest = !session;

  const signOut = async () => {
    try {
      if (session?.user?.id) {
        await clearPushNotificationSetup(session.user.id);
      }
    } catch {
    } finally {
      await supabase.auth.signOut();
    }
  };
  useEffect(() => {
    let active = true;
    let receivedAuthEvent = false;

    const loadInitialSession = async () => {
      const { data, error } = await supabase.auth.getSession();
      let nextSession = data.session ?? null;
      let offline = false;

      if (!nextSession && error && isAuthRetryableFetchError(error)) {
        nextSession = await readStoredSession();
        offline = nextSession !== null;
      }

      // An auth event that arrived meanwhile is newer than this result.
      if (!active || receivedAuthEvent) return;
      setSession(nextSession);
      setIsOfflineSession(offline);
    };

    loadInitialSession().finally(() => {
      if (active) setLoading(false);
    });

    const { data: listener } = supabase.auth.onAuthStateChange((event, nextSession) => {
      if (event === 'INITIAL_SESSION') return;
      receivedAuthEvent = true;
      setSession(nextSession);
      setIsOfflineSession(false);
    });

    return () => {
      active = false;
      listener.subscription.unsubscribe();
    };
  }, []);

  return (
    <AuthContext.Provider value={{ session, loading, isGuest, isOfflineSession, signOut }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
