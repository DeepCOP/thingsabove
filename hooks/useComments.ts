import { addPlanDayComment } from '@/api/mutations';
import { commentsRealTimeChannel, fetchPlanDayComments } from '@/api/queries';
import { supabase } from '@/api/supabaseClient';
import { RealtimeChannel } from '@supabase/supabase-js';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useEffect } from 'react';

export function useComments(planId: string, dayId: string, group_id?: string) {
  const queryClient = useQueryClient();
  const fetchComments = useQuery({
    queryKey: ['day-comments', planId, dayId],
    enabled: !!planId && !!dayId,
    staleTime: 0,
    queryFn: async () => await fetchPlanDayComments({ planId, dayId, group_id }),
  });

  const addComment = useMutation({
    mutationFn: async (content: string) =>
      await addPlanDayComment({ planId, dayId, content, group_id }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['day-comments', planId, dayId] });
    },
  });

  return {
    commentsQuery: fetchComments,
    addComment,
  };
}

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
