import { acceptChurchInvite } from '@/src/api/mutations';
import { useMutation, useQueryClient } from '@tanstack/react-query';

export const useAcceptChurchInvite = (churchId: string | undefined, userId: string | undefined) => {
  const qc = useQueryClient();

  return useMutation({
    mutationFn: async () => {
      await acceptChurchInvite({ churchId: churchId! });
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['profile', userId] });
      qc.invalidateQueries({ queryKey: ['church-members'] });
      qc.invalidateQueries({ queryKey: ['church-analytics'] });
    },
  });
};
