import { RealtimeChannel } from '@supabase/supabase-js';
import { useEffect } from 'react';
import { commentsRealTimeChannel } from '../api/realTimeQueries';
import { supabase } from '../lib/supabaseClient';

export function useRealtimeComments(group_id: string, onNew: () => void) {
  useEffect(() => {
    if (!group_id) return;

    // 1. Create a variable to hold the channel instance
    let channel: RealtimeChannel;

    const setupChannel = async () => {
      channel = await commentsRealTimeChannel(group_id, onNew);
    };

    setupChannel();

    // 2. Cleanup function
    return () => {
      if (channel) {
        supabase.removeChannel(channel);
      }
    };
  }, [group_id, onNew]); // Added onNew to dependencies for safety
}
