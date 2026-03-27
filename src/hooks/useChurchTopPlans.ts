import { useQuery } from '@tanstack/react-query';
import { fetchChurchAnalytics } from '../api/churchQueries';

export const useChurchTopPlans = (churchId: string | undefined) => {
  return useQuery({
    queryKey: ['church-analytics', churchId],
    enabled: Boolean(churchId),
    queryFn: () => fetchChurchAnalytics(churchId!),
    select: (data) => data.topPlans,
  });
};
