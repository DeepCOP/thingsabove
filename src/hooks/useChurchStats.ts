import { useQuery } from '@tanstack/react-query';
import { fetchChurchAnalytics } from '../api/churchQueries';
import { useAuth } from '../state/AuthContext';

export const useChurchStats = (churchId: string | undefined) => {
  const { session } = useAuth();
  const userId = session?.user?.id ?? null;

  return useQuery({
    queryKey: ['church-analytics', userId, churchId],
    enabled: Boolean(churchId),
    queryFn: () => fetchChurchAnalytics(churchId!),
    select: (data) => data.stats,
  });
};
