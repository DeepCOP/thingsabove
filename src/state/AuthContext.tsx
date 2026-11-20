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

    // An auth event that arrived meanwhile is newer than anything loaded here.
    const isStale = () => !active || receivedAuthEvent;

    const loadInitialSession = async () => {
      const storedSession = await readStoredSession();
      if (isStale()) return;
      if (storedSession) {
        setSession(storedSession);
        setLoading(false);
      }

      const { data, error } = await supabase.auth.getSession();
      if (isStale()) return;

      if (!data.session && error && isAuthRetryableFetchError(error)) {
        // Offline with an expired token: keep the stored session.
        setIsOfflineSession(storedSession !== null);
        return;
      }

      setSession(data.session ?? null);
      setIsOfflineSession(false);
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
