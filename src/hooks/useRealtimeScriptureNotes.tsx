import { RealtimeChannel } from '@supabase/supabase-js';
import { useEffect } from 'react';
import { scriptureNotesRealTimeChannel } from '../api/realTimeQueries';
import { supabase } from '../lib/supabaseClient';

export function useRealtimeScriptureNotes({
  scopeKey,
  enabled,
  onNew,
}: {
  scopeKey?: string | null;
  enabled?: boolean;
  onNew: () => void;
}) {
  useEffect(() => {
    if (!enabled || !scopeKey) return;

    let channel: RealtimeChannel | null = null;
    let isMounted = true;

    const setupChannel = async () => {
      const newChannel = await scriptureNotesRealTimeChannel({
        scopeKey,
        onNew,
      });

      if (isMounted) {
        channel = newChannel;
      } else {
        supabase.removeChannel(newChannel);
      }
    };

    setupChannel();

    return () => {
      isMounted = false;
      if (channel) {
        supabase.removeChannel(channel);
      }
    };
  }, [scopeKey, enabled, onNew]);
}
