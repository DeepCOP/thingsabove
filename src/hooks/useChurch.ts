import { useQuery } from '@tanstack/react-query';
import { fetchChurch } from '../api/churchQueries';

export const useChurch = (churchId: string | undefined) => {
  return useQuery({
    queryKey: ['church', churchId],
    enabled: Boolean(churchId),
    queryFn: () => fetchChurch(churchId!),
  });
};
