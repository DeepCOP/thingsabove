import { useQuery } from '@tanstack/react-query';
import { fetchChurchMembers } from '../api/churchQueries';

export const useChurchMembers = (churchId: string | undefined) => {
  return useQuery({
    queryKey: ['church-members', churchId],
    enabled: Boolean(churchId),
    queryFn: () => fetchChurchMembers(churchId!),
  });
};
