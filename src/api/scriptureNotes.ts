import { supabase } from '../lib/supabaseClient';
import { ScriptureNote, ScriptureNoteContext } from '../types/types';

export const SCRIPTURE_NOTES_PAGE_SIZE = 40;

export const getScriptureNotes = async ({
  noteType,
  scopeKey,
  offset = 0,
  limit = SCRIPTURE_NOTES_PAGE_SIZE,
}: Pick<ScriptureNoteContext, 'noteType' | 'scopeKey'> & {
  offset?: number;
  limit?: number;
}): Promise<{ items: ScriptureNote[]; nextOffset: number | null }> => {
  const { data, error } = await supabase.rpc('get_scripture_notes', {
    p_note_type: noteType,
    p_scope_key: scopeKey,
    p_limit: limit,
    p_offset: offset,
  });

  if (error) throw error;

  const items = (data ?? []) as ScriptureNote[];
  const nextOffset = items.length < limit ? null : offset + items.length;

  return { items, nextOffset };
};

export const addScriptureNote = async ({
  noteType,
  scopeKey,
  book,
  chapter,
  verseStart,
  verseEnd,
  content,
  parentNoteId,
}: ScriptureNoteContext & { content: string; parentNoteId?: string | null }): Promise<string> => {
  const { data, error } = await (supabase as any).rpc('add_scripture_note', {
    p_note_type: noteType,
    p_scope_key: scopeKey,
    p_book: book,
    p_chapter: chapter,
    p_verse_start: verseStart,
    p_verse_end: verseEnd,
    p_content: content,
    p_parent_note_id: parentNoteId ?? null,
  });

  if (error) throw error;
  return data as string;
};

export const toggleScriptureNoteHelpful = async (
  noteId: string,
): Promise<{ is_helpful: boolean; helpful_count: number }> => {
  const { data, error } = await (supabase as any)
    .rpc('toggle_scripture_note_helpful', { p_note_id: noteId })
    .single();

  if (error) throw error;
  return data as { is_helpful: boolean; helpful_count: number };
};
