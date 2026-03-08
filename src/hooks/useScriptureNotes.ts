import {
  addScriptureNote,
  getScriptureNotes,
  SCRIPTURE_NOTES_PAGE_SIZE,
  toggleScriptureNoteHelpful,
} from '@/src/api/scriptureNotes';
import { useInfiniteQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useMemo } from 'react';
import { ScriptureNoteContext } from '../types/types';

export function useScriptureNotes(context: ScriptureNoteContext | null) {
  const qc = useQueryClient();

  const notesQuery = useInfiniteQuery({
    queryKey: ['scripture_notes', context?.noteType, context?.scopeKey],
    enabled: !!context,
    staleTime: 0,
    queryFn: async ({ pageParam }: { pageParam: number }) => {
      if (!context) return { items: [], nextOffset: null };
      return getScriptureNotes({
        noteType: context.noteType,
        scopeKey: context.scopeKey,
        offset: pageParam,
        limit: SCRIPTURE_NOTES_PAGE_SIZE,
      });
    },
    initialPageParam: 0,
    getNextPageParam: (lastPage) => lastPage.nextOffset ?? undefined,
  });

  const notes = useMemo(
    () => notesQuery.data?.pages.flatMap((page) => page.items) ?? [],
    [notesQuery.data],
  );

  const addNote = useMutation({
    mutationFn: async ({
      content,
      parentNoteId,
    }: {
      content: string;
      parentNoteId?: string | null;
    }) => {
      if (!context) throw new Error('Scripture notes context is missing');
      return addScriptureNote({
        ...context,
        content,
        parentNoteId,
      });
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['scripture_notes'] });
    },
  });

  const toggleHelpful = useMutation({
    mutationFn: async (noteId: string) => toggleScriptureNoteHelpful(noteId),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['scripture_notes'] });
    },
  });

  return {
    notesQuery,
    notes,
    addNote,
    toggleHelpful,
  };
}
