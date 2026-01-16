/* eslint-disable react-hooks/exhaustive-deps */
import { RealtimeChannel } from '@supabase/supabase-js';
import { useEffect } from 'react';
import { notificationsRealTime } from '../api/realTimeQueries';
import { supabase } from '../lib/supabaseClient';

export function useRealtimeNotifications(userId: string | null, onNew: () => void) {
  useEffect(() => {
    if (!userId) return;

    let channel: RealtimeChannel;
    const getChannel = async () => {
      channel = await notificationsRealTime(userId, onNew);
    };

    getChannel();

    return () => {
      if (channel) {
        supabase.removeChannel(channel);
      }
    };
  }, [userId]);
}
