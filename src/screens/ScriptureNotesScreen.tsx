import { useTranslation } from 'react-i18next';
import { getCanonicalBookName } from '@/src/bible/books';
import BibleAttribution from '@/src/components/BibleAttribution';
import { useRealtimeScriptureNotes } from '@/src/hooks/useRealtimeScriptureNotes';
import { useScriptureNotes } from '@/src/hooks/useScriptureNotes';
import dayjs from '@/src/lib/dayjs';
import { useAuth } from '@/src/state/AuthContext';
import Ionicons from '@expo/vector-icons/Ionicons';
import { useEffect, useMemo, useState } from 'react';
import {
  Keyboard,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  Text,
  TextInput,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import LoadingSpinner from '../components/LoadingSpinner';
import ProfileIdentityRow from '../components/ProfileIdentityRow';
import { ScriptureNote, ScriptureNoteContext, ScriptureNoteType } from '../types/types';
import { getVerseNumbersFromRange, getVerseRangeLabels } from '../utils';

type VerseTarget = {
  number: number;
  text: string;
};

type ScopeDescriptor = {
  tabLabel: string;
  helper: string;
  heading: string;
  reference: string;
  context: ScriptureNoteContext;
};

type Props = {
  onClose: () => void;
  verse: VerseTarget | null;
  bookId: string;
  book: string;
  chapter: number;
  selectionStart: number;
  selectionEnd: number;
  selectionVerses: number[];
  verseCount: number;
  version: string;
  copyright?: string;
  attributionUrl?: string;
};

const NOTE_TYPES: ScriptureNoteType[] = ['verse', 'section', 'chapter', 'book'];

const formatScopeKeyBook = (book: string) =>
  book
    .toLowerCase()
    .trim()
    .replace(/\s+/g, '_')
    .replace(/[^a-z0-9_]/g, '');

export default function ScriptureNotesScreen({
  onClose,
  verse,
  bookId,
  book,
  chapter,
  selectionStart,
  selectionEnd,
  selectionVerses,
  verseCount,
  version,
  copyright,
  attributionUrl,
}: Props) {
  const { t, i18n } = useTranslation('community');
  const insets = useSafeAreaInsets();
  const colorScheme = useColorScheme();
  const { session } = useAuth();

  const [activeType, setActiveType] = useState<ScriptureNoteType>('verse');
  const [draft, setDraft] = useState('');
  const [submitError, setSubmitError] = useState('');
  const [replyTo, setReplyTo] = useState<ScriptureNote | null>(null);
  const [keyboardHeight, setKeyboardHeight] = useState(0);

  const normalizedSelectionVerses = useMemo(() => {
    if (selectionVerses.length > 0) return selectionVerses;
    if (selectionStart > 0) return getVerseNumbersFromRange(selectionStart, selectionEnd);
    if (verse?.number) return [verse.number];
    return [];
  }, [selectionEnd, selectionStart, verse?.number, selectionVerses]);

  const selectedVerseRangeLabel = useMemo(() => {
    const labels = getVerseRangeLabels(normalizedSelectionVerses);
    if (labels.length > 0) return labels.join(',');
    return verse?.number ? `${verse.number}` : '';
  }, [normalizedSelectionVerses, verse?.number]);

  const selectedVerseReference = useMemo(() => {
    if (!verse) return '';
    return `${book} ${chapter}:${selectedVerseRangeLabel || verse.number}`;
  }, [book, chapter, selectedVerseRangeLabel, verse]);

  useEffect(() => {
    setActiveType('verse');
    setDraft('');
    setSubmitError('');
    setReplyTo(null);
  }, [verse?.number, book, bookId, chapter]);

  useEffect(() => {
    const show = Keyboard.addListener('keyboardDidShow', (e) => {
      setKeyboardHeight(e.endCoordinates.height);
    });

    const hide = Keyboard.addListener('keyboardDidHide', () => {
      setKeyboardHeight(0);
    });

    return () => {
      show.remove();
      hide.remove();
    };
  }, []);

  const scopes = useMemo<Record<ScriptureNoteType, ScopeDescriptor> | null>(() => {
    if (!verse) return null;

    const safeVerseCount = Math.max(verseCount, verse.number);
    const sectionStart = Math.max(1, verse.number - 4);
    const sectionEnd = Math.min(safeVerseCount, verse.number + 4);
    const bookKey = formatScopeKeyBook(getCanonicalBookName(bookId) || book);
    const chapterKey = `${bookKey}:${chapter}`;

    return {
      verse: {
        tabLabel: t('verse'),
        helper: t('discussionReference', { reference: `${book} ${chapter}:${verse.number}` }),
        heading: t('verseNotes'),
        reference: `${book} ${chapter}:${verse.number}`,
        context: {
          noteType: 'verse',
          scopeKey: `${chapterKey}:${verse.number}`,
          bookId,
          book,
          chapter,
          verseStart: verse.number,
          verseEnd: verse.number,
        },
      },
      section: {
        tabLabel: t('section'),
        helper: t('discussionReference', {
          reference: `${book} ${chapter}:${sectionStart}-${sectionEnd}`,
        }),
        heading: t('sectionNotes'),
        reference: `${book} ${chapter}:${sectionStart}-${sectionEnd}`,
        context: {
          noteType: 'section',
          scopeKey: `${chapterKey}:${sectionStart}-${sectionEnd}`,
          bookId,
          book,
          chapter,
          verseStart: sectionStart,
          verseEnd: sectionEnd,
        },
      },
      chapter: {
        tabLabel: t('chapter'),
        helper: t('discussionReference', { reference: `${book} ${chapter}` }),
        heading: t('chapterNotes'),
        reference: `${book} ${chapter}`,
        context: {
          noteType: 'chapter',
          scopeKey: chapterKey,
          bookId,
          book,
          chapter,
          verseStart: null,
          verseEnd: null,
        },
      },
      book: {
        tabLabel: t('book'),
        helper: t('discussionReference', { reference: book }),
        heading: t('bookNotes'),
        reference: `${book}`,
        context: {
          noteType: 'book',
          scopeKey: bookKey,
          bookId,
          book,
          chapter: null,
          verseStart: null,
          verseEnd: null,
        },
      },
    };
  }, [book, bookId, chapter, verse, verseCount, t]);

  const activeScope = scopes?.[activeType] ?? null;
  const { notesQuery, notes, addNote, toggleHelpful } = useScriptureNotes(
    activeScope?.context ?? null,
  );
  useRealtimeScriptureNotes({
    scopeKey: activeScope?.context.scopeKey,
    enabled: !!activeScope,
    onNew: notesQuery.refetch,
  });

  const canPost = !!session && !!draft.trim() && !addNote.isPending;
  const topLevelNotes = useMemo(() => notes.filter((note) => !note.parent_note_id), [notes]);

  const repliesByParent = useMemo(() => {
    const grouped: Record<string, ScriptureNote[]> = {};
    notes
      .filter((note) => !!note.parent_note_id)
      .forEach((note) => {
        const parentId = note.parent_note_id!;
        if (!grouped[parentId]) grouped[parentId] = [];
        grouped[parentId].push(note);
      });

    Object.keys(grouped).forEach((parentId) => {
      grouped[parentId].sort(
        (a, b) => dayjs(a.created_at).valueOf() - dayjs(b.created_at).valueOf(),
      );
    });

    return grouped;
  }, [notes]);

  return (
    <KeyboardAvoidingView
      className="flex-1 bg-white dark:bg-black"
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>
      <View className="flex-1 bg-white dark:bg-black" style={{ paddingTop: insets.top + 4 }}>
        <View className="flex-row items-center justify-between px-4 pb-3 border-b border-gray-200 dark:border-neutral-800">
          <TouchableOpacity accessibilityLabel={t('back')} onPress={onClose} className="p-1 -ml-1">
            <Ionicons
              name="chevron-back"
              size={26}
              color={colorScheme === 'dark' ? '#fff' : '#000'}
            />
          </TouchableOpacity>

          <Text className="text-xl font-bold text-primary dark:text-white">
            {t('scriptureNotes')}
          </Text>

          <View className="w-6" />
        </View>

        {verse ? (
          <>
            <ScrollView
              className="flex-1 mt-2"
              keyboardShouldPersistTaps="handled"
              automaticallyAdjustKeyboardInsets
              showsVerticalScrollIndicator={false}>
              <View className="px-4">
                <View className="mt-1 p-4 rounded-2xl border border-gray-200 dark:border-neutral-800 bg-gray-50 dark:bg-neutral-900">
                  <Text className="text-[17px] leading-7 text-primary dark:text-gray-100 italic">
                    &quot;{verse.text}&quot;
                  </Text>
                  <Text className="text-right mt-2 text-sm text-gray-500 dark:text-gray-300">
                    {selectedVerseReference} {version}
                  </Text>
                  <BibleAttribution copyright={copyright} attributionUrl={attributionUrl} />
                </View>

                <View className="mt-4">
                  <View className="flex-row rounded-xl border border-gray-200 dark:border-neutral-700 overflow-hidden">
                    {NOTE_TYPES.map((type) => {
                      const isActive = activeType === type;
                      const label = scopes?.[type]?.tabLabel ?? type;

                      return (
                        <TouchableOpacity
                          key={type}
                          onPress={() => {
                            setActiveType(type);
                            setReplyTo(null);
                            setSubmitError('');
                          }}
                          className={`flex-1 py-2.5 items-center ${isActive ? 'bg-blue-600' : 'bg-white dark:bg-black'}`}>
                          <Text
                            className={`text-sm font-semibold ${
                              isActive ? 'text-white' : 'text-gray-700 dark:text-gray-200'
                            }`}>
                            {label}
                          </Text>
                        </TouchableOpacity>
                      );
                    })}
                  </View>
                </View>

                <Text className="mt-3 text-sm text-gray-600 dark:text-gray-300">
                  {activeScope?.helper ?? t('notesDescription')}
                </Text>

                <View className="mt-2 mb-3 p-3 rounded-xl border border-gray-200 dark:border-neutral-700 bg-gray-50 dark:bg-neutral-900">
                  <Text className="text-base font-semibold text-primary dark:text-white">
                    {activeScope?.heading} - {activeScope?.reference}
                  </Text>
                </View>

                {notesQuery.isLoading ? (
                  <View className="pt-8 items-center">
                    <LoadingSpinner />
                  </View>
                ) : topLevelNotes.length === 0 ? (
                  <View className="pt-8 items-center">
                    <Text className="text-gray-500 dark:text-gray-300">{t('noNotes')}</Text>
                    <Text className="text-gray-500 dark:text-gray-300 text-xs mt-1">
                      {t('firstNote')}
                    </Text>
                  </View>
                ) : (
                  topLevelNotes.map((note) => (
                    <View
                      key={note.id}
                      className="mb-3 p-3 rounded-xl border border-gray-200 dark:border-neutral-700 bg-white dark:bg-neutral-900">
                      <ProfileIdentityRow
                        className="items-start"
                        first_name={note.first_name}
                        last_name={note.last_name}
                        name={`${note.first_name} ${note.last_name?.[0] ? `${note.last_name[0]}.` : ''}`.trim()}
                        size={34}
                        subtitle={new Date(note.created_at).toLocaleDateString(
                          i18n.resolvedLanguage ?? 'en',
                          { month: 'short', day: 'numeric', year: 'numeric' },
                        )}
                        subtitleClassName="text-xs text-gray-500 dark:text-gray-300"
                        titleClassName="font-semibold text-primary dark:text-gray-100"
                        uri={note.avatar_url}
                        userId={note.user_id}
                      />

                      <Text className="mt-3 text-[15px] leading-6 text-primary dark:text-gray-100">
                        {note.content}
                      </Text>

                      <View className="mt-3 flex-row items-center gap-4">
                        <TouchableOpacity
                          onPress={() => toggleHelpful.mutate(note.id)}
                          disabled={toggleHelpful.isPending || !session}
                          className="self-start flex-row items-center">
                          <Ionicons
                            name={note.is_helpful ? 'heart' : 'heart-outline'}
                            size={20}
                            color={
                              note.is_helpful
                                ? '#facc15'
                                : colorScheme === 'dark'
                                  ? '#cbd5e1'
                                  : '#6b7280'
                            }
                          />
                          <Text
                            className={`text-sm font-semibold ${
                              note.is_helpful
                                ? 'text-yellow-600 dark:text-yellow-400'
                                : 'text-gray-500 dark:text-gray-300'
                            }`}>
                            {note.helpful_count}
                          </Text>
                        </TouchableOpacity>

                        <TouchableOpacity
                          onPress={() => {
                            setReplyTo(note);
                            setSubmitError('');
                          }}
                          disabled={!session}
                          className="flex-row items-center">
                          <Ionicons
                            name="return-up-forward-outline"
                            size={16}
                            color={colorScheme === 'dark' ? '#cbd5e1' : '#6b7280'}
                          />
                          <Text className="ml-1 text-sm text-gray-500 dark:text-gray-300">
                            {t('reply')}
                          </Text>
                        </TouchableOpacity>
                      </View>

                      {(repliesByParent[note.id] ?? []).map((reply) => (
                        <View
                          key={reply.id}
                          className="mt-3 ml-5 p-3 rounded-xl border border-gray-200 dark:border-neutral-700 bg-gray-50 dark:bg-neutral-800">
                          <ProfileIdentityRow
                            className="items-start"
                            first_name={reply.first_name}
                            last_name={reply.last_name}
                            name={`${reply.first_name} ${reply.last_name?.[0] ? `${reply.last_name[0]}.` : ''}`.trim()}
                            size={30}
                            subtitle={new Date(reply.created_at).toLocaleDateString(
                              i18n.resolvedLanguage ?? 'en',
                              { month: 'short', day: 'numeric', year: 'numeric' },
                            )}
                            subtitleClassName="text-xs text-gray-500 dark:text-gray-300"
                            titleClassName="font-semibold text-primary dark:text-gray-100"
                            uri={reply.avatar_url}
                            userId={reply.user_id}
                          />

                          <Text className="mt-2 text-[15px] leading-6 text-primary dark:text-gray-100">
                            {reply.content}
                          </Text>

                          <TouchableOpacity
                            onPress={() => toggleHelpful.mutate(reply.id)}
                            disabled={toggleHelpful.isPending || !session}
                            className="mt-2 self-start flex-row items-center">
                            <Ionicons
                              name={reply.is_helpful ? 'heart' : 'heart-outline'}
                              size={18}
                              color={
                                reply.is_helpful
                                  ? '#facc15'
                                  : colorScheme === 'dark'
                                    ? '#cbd5e1'
                                    : '#6b7280'
                              }
                            />
                            <Text
                              className={`ml-1 text-xs ${
                                reply.is_helpful
                                  ? 'text-yellow-600 dark:text-yellow-400'
                                  : 'text-gray-500 dark:text-gray-300'
                              }`}>
                              {reply.helpful_count}
                            </Text>
                          </TouchableOpacity>
                        </View>
                      ))}
                    </View>
                  ))
                )}

                {notesQuery.hasNextPage && (
                  <View className="items-center mt-1 mb-6">
                    <TouchableOpacity
                      onPress={() => notesQuery.fetchNextPage()}
                      disabled={notesQuery.isFetchingNextPage}
                      className="px-4 py-2 rounded-full bg-gray-200 dark:bg-neutral-800">
                      {notesQuery.isFetchingNextPage ? (
                        <LoadingSpinner size="small" />
                      ) : (
                        <Text className="text-sm font-semibold text-gray-700 dark:text-gray-200">
                          {t('loadMoreNotes')}
                        </Text>
                      )}
                    </TouchableOpacity>
                  </View>
                )}
              </View>
            </ScrollView>

            <View
              className="px-4 pt-3 border-t border-gray-200 dark:border-neutral-800 bg-white dark:bg-black"
              style={{
                paddingBottom: insets.bottom + 12,
                marginBottom: Platform.OS === 'android' ? keyboardHeight : 0,
              }}>
              {replyTo && (
                <View className="mb-2 px-3 py-2 rounded-xl bg-blue-50 dark:bg-blue-950/40 flex-row items-center justify-between">
                  <Text className="text-xs text-blue-700 dark:text-blue-200">
                    {t('replyingTo', { name: replyTo.first_name })}
                  </Text>

                  <TouchableOpacity
                    accessibilityLabel={t('cancel')}
                    onPress={() => setReplyTo(null)}>
                    <Ionicons
                      name="close"
                      size={16}
                      color={colorScheme === 'dark' ? '#bfdbfe' : '#1d4ed8'}
                    />
                  </TouchableOpacity>
                </View>
              )}

              <View className="flex-row items-center gap-2">
                <TextInput
                  value={draft}
                  onChangeText={(value) => {
                    setDraft(value);
                    if (submitError) setSubmitError('');
                  }}
                  placeholder={
                    replyTo ? t('replyPlaceholder', { name: replyTo.first_name }) : t('addNote')
                  }
                  placeholderTextColor={colorScheme === 'dark' ? '#9ca3af' : '#6b7280'}
                  multiline
                  maxLength={500}
                  className="flex-1 min-h-[48px] max-h-28 px-4 py-3 rounded-2xl bg-gray-100 dark:bg-neutral-900 dark:text-white"
                />

                <TouchableOpacity
                  onPress={() => {
                    if (!canPost || !activeScope) return;
                    addNote.mutate(
                      {
                        content: draft.trim(),
                        parentNoteId: replyTo?.id ?? null,
                      },
                      {
                        onSuccess: () => {
                          setDraft('');
                          setSubmitError('');
                          setReplyTo(null);
                        },
                        onError: (error) => {
                          console.error('Unable to post note:', error);
                          setSubmitError(t('postNoteError'));
                        },
                      },
                    );
                  }}
                  disabled={!canPost}
                  className={`px-4 py-3 rounded-xl ${canPost ? 'bg-blue-600' : 'bg-gray-400 dark:bg-neutral-700'}`}>
                  {addNote.isPending ? (
                    <LoadingSpinner size="small" />
                  ) : (
                    <Text className="text-white font-semibold">{t('post')}</Text>
                  )}
                </TouchableOpacity>
              </View>

              {!session && (
                <Text className="text-xs text-amber-600 dark:text-amber-400 mt-2">
                  {t('signInForNotes')}
                </Text>
              )}

              {!!submitError && (
                <Text className="text-xs text-red-500 mt-2" numberOfLines={2}>
                  {submitError}
                </Text>
              )}
            </View>
          </>
        ) : (
          <View className="flex-1 items-center justify-center px-8">
            <Text className="text-gray-600 dark:text-gray-300 text-center">
              {t('selectVerseForNotes')}
            </Text>
          </View>
        )}
      </View>
    </KeyboardAvoidingView>
  );
}
