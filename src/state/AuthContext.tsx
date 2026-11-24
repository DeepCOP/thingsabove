import { clearStoredSession, readStoredSession, supabase } from '@/src/lib/supabaseClient';
import { isAuthRetryableFetchError, Session } from '@supabase/supabase-js';
import { createContext, useContext, useEffect, useState } from 'react';
import { clearPushNotificationSetup } from '../api/mutations';

type AuthContextType = {
  session: Session | null;
  loading: boolean;
  isGuest: boolean;
  signOut: () => Promise<void>;
};

const AuthContext = createContext<AuthContextType>({
  session: null,
  loading: true,
  isGuest: true,
  signOut: () => Promise.resolve(),
});

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [session, setSession] = useState<Session | null>(null);
  const [loading, setLoading] = useState(true);

  const isGuest = !session;

  const signOut = async () => {
    try {
      if (session?.user?.id) {
        await clearPushNotificationSetup(session.user.id);
      }
    } catch {
    } finally {
      const { error } = await supabase.auth.signOut();

      if (error && isAuthRetryableFetchError(error)) {
        await clearStoredSession();
        setSession(null);
      }
    }
  };

  useEffect(() => {
    let active = true;
    let receivedAuthEvent = false;

    const loadInitialSession = async () => {
      const isStale = () => !active || receivedAuthEvent;

      const storedSession = await readStoredSession();
      if (isStale()) return;
      if (storedSession) {
        setSession(storedSession);
        setLoading(false);
      }

      const { data, error } = await supabase.auth.getSession();
      if (isStale()) return;

      if (!data.session && error && isAuthRetryableFetchError(error)) return;

      setSession(data.session ?? null);
    };

    loadInitialSession().finally(() => {
      if (active) setLoading(false);
    });

    const { data: listener } = supabase.auth.onAuthStateChange((event, nextSession) => {
      if (event === 'INITIAL_SESSION') return;
      receivedAuthEvent = true;
      setSession(nextSession);
    });

    return () => {
      active = false;
      listener.subscription.unsubscribe();
    };
  }, []);

  return (
    <AuthContext.Provider value={{ session, loading, isGuest, signOut }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
