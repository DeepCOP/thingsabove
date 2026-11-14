import { useFocusEffect } from '@react-navigation/native';
import { useIsRestoring, useQueryClient, type QueryKey } from '@tanstack/react-query';
import { useCallback } from 'react';

// Pass a stable key so query updates do not restart the focus effect.
export function useRefetchStaleQueryOnFocus(queryKey: QueryKey) {
  const client = useQueryClient();
  const isRestoring = useIsRestoring();

  useFocusEffect(
    useCallback(() => {
      if (isRestoring) return;
      void client.refetchQueries(
        { queryKey, exact: true, stale: true, type: 'active' },
        { cancelRefetch: false },
      );
    }, [client, isRestoring, queryKey]),
  );
}
