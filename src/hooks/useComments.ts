import { addPlanDayComment, deletePlanDayComment, updatePlanDayComment } from '@/src/api/mutations';
import { PlanDayComment } from '@/src/types/types';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { fetchPlanDayComments } from '../api/groupQueries';

export function useComments(planId: string, dayId: string, progressId: string, group_id?: string) {
  const queryClient = useQueryClient();
  const queryKey = ['day_comments', planId, dayId, progressId, group_id] as const;

  const fetchComments = useQuery({
    queryKey,
    enabled: !!planId && !!dayId && !!progressId,
    staleTime: 0,
    queryFn: async () =>
      (await fetchPlanDayComments({ planId, dayId, progressId, group_id })) as PlanDayComment[],
  });

  const addComment = useMutation({
    mutationFn: async (content: string) =>
      await addPlanDayComment({ planId, dayId, progressId, content, group_id }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey });
    },
  });

  const updateComment = useMutation({
    mutationFn: async ({ commentId, content }: { commentId: string; content: string }) =>
      await updatePlanDayComment({ commentId, content }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey });
    },
  });

  const deleteComment = useMutation({
    mutationFn: async ({ commentId }: { commentId: string }) =>
      await deletePlanDayComment({ commentId }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey });
    },
  });

  return {
    commentsQuery: fetchComments,
    addComment,
    updateComment,
    deleteComment,
  };
}
