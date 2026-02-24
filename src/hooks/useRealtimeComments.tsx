import { RealtimeChannel } from '@supabase/supabase-js';
import { useEffect } from 'react';
import { commentsRealTimeChannel } from '../api/realTimeQueries';
import { supabase } from '../lib/supabaseClient';

export function useRealtimeComments(group_id: string, onNew: () => void) {
  useEffect(() => {
    if (!group_id) return;

    let cancelled = false;
    let channel: RealtimeChannel | null = null;

    const setupChannel = async () => {
      const ch = await commentsRealTimeChannel(group_id, onNew);

      if (cancelled) {
        supabase.removeChannel(ch);
      } else {
        channel = ch;
      }
    };

    setupChannel();

    return () => {
      cancelled = true;

      if (channel) {
        supabase.removeChannel(channel);
      }
    };
  }, [group_id, onNew]);
}
