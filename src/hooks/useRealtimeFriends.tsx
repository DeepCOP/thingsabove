import { RealtimeChannel } from '@supabase/supabase-js';
import { useEffect } from 'react';
import { FriendRequestRealTime, FriendRequestRealTimeReceiver } from '../api/realTimeQueries';
import { supabase } from '../lib/supabaseClient';

export function useRealtimeFriends(userId: string | undefined, onNew: () => void) {
  useEffect(() => {
    if (!userId) return;

    let requesterChannel: RealtimeChannel;

    const getRequesterChannel = async () => {
      requesterChannel = await FriendRequestRealTime({ userId, onNew });
    };

    let receiverChannel: RealtimeChannel;

    const getReceiverChannel = async () => {
      receiverChannel = await FriendRequestRealTimeReceiver({ userId, onNew });
    };

    getRequesterChannel();
    getReceiverChannel();

    return () => {
      if (receiverChannel) {
        supabase.removeChannel(receiverChannel);
      }
      if (requesterChannel) {
        supabase.removeChannel(requesterChannel);
      }
    };
  }, [userId, onNew]);
}
