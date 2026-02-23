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

    let channel: RealtimeChannel;

    const setupChannel = async () => {
      channel = await scriptureNotesRealTimeChannel({
        scopeKey,
        onNew,
      });
    };

    setupChannel();

    return () => {
      if (channel) {
        supabase.removeChannel(channel);
      }
    };
  }, [scopeKey, enabled, onNew]);
}
