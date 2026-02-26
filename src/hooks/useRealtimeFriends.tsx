import { RealtimeChannel } from '@supabase/supabase-js';
import { useEffect, useRef } from 'react';
import { FriendRequestRealTime, FriendRequestRealTimeReceiver } from '../api/realTimeQueries';
import { supabase } from '../lib/supabaseClient';

export function useRealtimeFriends(userId: string | undefined, onNew: () => void) {
  const requesterRef = useRef<RealtimeChannel | null>(null);
  const receiverRef = useRef<RealtimeChannel | null>(null);

  useEffect(() => {
    if (!userId) return;

    let cancelled = false;

    const setup = async () => {
      const req = await FriendRequestRealTime({ userId, onNew });
      if (cancelled) return supabase.removeChannel(req);
      requesterRef.current = req;

      const rec = await FriendRequestRealTimeReceiver({ userId, onNew });
      if (cancelled) return supabase.removeChannel(rec);
      receiverRef.current = rec;
    };

    setup();

    return () => {
      cancelled = true;

      if (requesterRef.current) {
        supabase.removeChannel(requesterRef.current);
        requesterRef.current = null;
      }

      if (receiverRef.current) {
        supabase.removeChannel(receiverRef.current);
        receiverRef.current = null;
      }
    };
  }, [userId, onNew]);
}
