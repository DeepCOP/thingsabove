/* eslint-disable react-hooks/exhaustive-deps */
import { RealtimeChannel } from '@supabase/supabase-js';
import { useEffect } from 'react';
import { notificationsRealTime } from '../api/realTimeQueries';
import { supabase } from '../lib/supabaseClient';

export function useRealtimeNotifications(userId: string | undefined, onNew: () => void) {
  useEffect(() => {
    if (!userId) return;

    let cancelled = false;
    let channel: RealtimeChannel | null = null;

    const setup = async () => {
      const ch = await notificationsRealTime(userId, onNew);

      if (cancelled) {
        supabase.removeChannel(ch);
      } else {
        channel = ch;
      }
    };

    setup();

    return () => {
      cancelled = true;

      if (channel) {
        supabase.removeChannel(channel);
      }
    };
  }, [userId, onNew]);
}
