import { addPlanDayComment } from '@/src/api/mutations';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { fetchPlanDayComments } from '../api/groupQueries';

export function useComments(planId: string, dayId: string, group_id?: string) {
  const queryClient = useQueryClient();
  const fetchComments = useQuery({
    queryKey: ['day-comments', planId, dayId, group_id],
    enabled: !!planId && !!dayId,
    staleTime: 0,
    queryFn: async () => await fetchPlanDayComments({ planId, dayId, group_id }),
  });

  const addComment = useMutation({
    mutationFn: async (content: string) =>
      await addPlanDayComment({ planId, dayId, content, group_id }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['day-comments', planId, dayId, group_id] });
    },
  });

  return {
    commentsQuery: fetchComments,
    addComment,
  };
}
