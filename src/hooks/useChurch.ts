import { useQuery } from '@tanstack/react-query';
import { fetchChurch } from '../api/churchQueries';
import { useAuth } from '../state/AuthContext';

export const useChurch = (churchId: string | undefined) => {
  const { session } = useAuth();
  const userId = session?.user?.id ?? null;

  return useQuery({
    queryKey: ['church', userId, churchId],
    enabled: Boolean(churchId),
    queryFn: () => fetchChurch(churchId!),
  });
};
