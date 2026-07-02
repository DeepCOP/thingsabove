import { useComments } from '@/src/hooks/useComments';
import { formatRelativeTime } from '@/src/lib/relativeTime';
import { useAuth } from '@/src/state/AuthContext';
import { PlanDayComment } from '@/src/types/types';
import { Ionicons } from '@expo/vector-icons';
import BottomSheet, {
  BottomSheetBackdrop,
  BottomSheetFlatList,
  BottomSheetFooter,
  BottomSheetFooterProps,
  BottomSheetTextInput,
} from '@gorhom/bottom-sheet';
import { createContext, forwardRef, memo, useCallback, useContext, useMemo, useState } from 'react';
import { Alert, Text, TouchableOpacity, useColorScheme, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useRealtimeComments } from '../hooks/useRealtimeComments';
import LoadingSpinner from './LoadingSpinner';
import ProfileIdentityRow from './ProfileIdentityRow';

type Props = {
  progressId: string;
  planId: string;
  dayId: string;
  group_id?: string;
  isDoneLoading?: boolean;
  title?: string;
  entryLabel?: string;
  inputPlaceholder?: string;
  emptyMessage?: string;
  doneAccessibilityLabel?: string;
  onDone?: () => void;
  onEntryCreated?: () => void;
};

type DayCommentsFooterContextValue = {
  colorScheme: ReturnType<typeof useColorScheme>;
  editingCommentId: string | null;
  insetsBottom: number;
  isSubmitting: boolean;
  onCancel: () => void;
  onSubmit: () => void;
  setText: (value: string) => void;
  text: string;
  inputPlaceholder: string;
  entryLabel: string;
};

const DayCommentsFooterContext = createContext<DayCommentsFooterContextValue | null>(null);

const DayCommentsFooter = memo(function DayCommentsFooter({
  animatedFooterPosition,
}: BottomSheetFooterProps) {
  const context = useContext(DayCommentsFooterContext);

  if (!context) {
    return null;
  }

  const {
    colorScheme,
    editingCommentId,
    insetsBottom,
    isSubmitting,
    onCancel,
    onSubmit,
    setText,
    text,
    inputPlaceholder,
    entryLabel,
  } = context;

  return (
    <BottomSheetFooter
      animatedFooterPosition={animatedFooterPosition}
      style={{
        paddingBottom: insetsBottom,
        backgroundColor: colorScheme === 'dark' ? '#000' : '#fff',
      }}>
      <View className="border-t border-gray-200 px-4 pt-2 dark:border-neutral-800 dark:bg-black">
        {editingCommentId && (
          <View className="mb-3 flex-row items-center justify-between">
            <Text className="text-sm text-gray-600 dark:text-gray-300">Editing {entryLabel}</Text>

            <TouchableOpacity onPress={onCancel}>
              <Text className="text-sm font-medium text-gray-800 dark:text-gray-200">Cancel</Text>
            </TouchableOpacity>
          </View>
        )}

        <View className="flex-row items-center gap-2 pb-2">
          <BottomSheetTextInput
            value={text}
            onChangeText={setText}
            placeholder={inputPlaceholder}
            placeholderTextColor="#999"
            className="flex-1 rounded-full bg-gray-200 px-4 py-3 dark:bg-neutral-800 dark:text-white"
          />

          <TouchableOpacity
            disabled={!text.trim() || isSubmitting}
            onPress={onSubmit}
            className="rounded-full bg-black px-4 py-3 dark:bg-white">
            {isSubmitting ? (
              <LoadingSpinner size="small" />
            ) : (
              <Text className="text-white dark:text-black">
                {editingCommentId ? 'Save' : 'Send'}
              </Text>
            )}
          </TouchableOpacity>
        </View>
      </View>
    </BottomSheetFooter>
  );
});

const DayCommentsBottomSheet = forwardRef<BottomSheet, Props>(
  (
    {
      progressId,
      planId,
      dayId,
      group_id,
      isDoneLoading = false,
      title = 'Reflect & Share',
      entryLabel = 'comment',
      inputPlaceholder = 'Share your thoughts...',
      emptyMessage = "Share your thoughts based on today's reading.",
      doneAccessibilityLabel,
      onDone,
      onEntryCreated,
    },
    ref,
  ) => {
    const snapPoints = useMemo(() => ['80%'], []);
    const EditingComposerInset = 160;
    const DefaultComposerInset = 116;
    const colorScheme = useColorScheme();
    const [text, setText] = useState('');
    const [editingCommentId, setEditingCommentId] = useState<string | null>(null);
    const { session } = useAuth();
    const currentUserId = session?.user?.id;

    const { commentsQuery, addComment, updateComment, deleteComment } = useComments(
      planId,
      dayId,
      progressId,
      group_id,
    );
    const comments = commentsQuery.data || [];
    const isSubmitting = addComment.isPending || updateComment.isPending;
    const deletingCommentId = deleteComment.isPending ? deleteComment.variables?.commentId : null;
    const insets = useSafeAreaInsets();
    const composerInset = editingCommentId ? EditingComposerInset : DefaultComposerInset;
    useRealtimeComments(group_id as string, commentsQuery.refetch);

    const resetComposer = useCallback(() => {
      setText('');
      setEditingCommentId(null);
    }, []);

    const canMarkDone = !!onDone;

    const handleSubmit = useCallback(() => {
      const trimmedText = text.trim();
      if (!trimmedText || isSubmitting) return;

      if (editingCommentId) {
        updateComment.mutate(
          { commentId: editingCommentId, content: trimmedText },
          { onSuccess: resetComposer },
        );
        return;
      }

      addComment.mutate(trimmedText, {
        onSuccess: () => {
          resetComposer();
          onEntryCreated?.();
        },
      });
    }, [
      addComment,
      editingCommentId,
      isSubmitting,
      onEntryCreated,
      resetComposer,
      text,
      updateComment,
    ]);

    const handleDelete = (comment: PlanDayComment) => {
      Alert.alert(`Delete ${entryLabel}?`, `This will permanently remove your ${entryLabel}.`, [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: () => {
            if (editingCommentId === comment.id) {
              resetComposer();
            }

            deleteComment.mutate({ commentId: comment.id });
          },
        },
      ]);
    };

    const handleDone = () => {
      if (!canMarkDone || isDoneLoading || isSubmitting) return;

      onDone?.();
    };

    const footerContextValue = useMemo(
      () => ({
        colorScheme,
        editingCommentId,
        insetsBottom: insets.bottom,
        isSubmitting,
        onCancel: resetComposer,
        onSubmit: handleSubmit,
        setText,
        text,
        inputPlaceholder,
        entryLabel,
      }),
      [
        colorScheme,
        editingCommentId,
        entryLabel,
        handleSubmit,
        inputPlaceholder,
        insets.bottom,
        isSubmitting,
        resetComposer,
        text,
      ],
    );

    return (
      <DayCommentsFooterContext.Provider value={footerContextValue}>
        <BottomSheet
          ref={ref}
          index={-1}
          snapPoints={snapPoints}
          enableDynamicSizing={false}
          enablePanDownToClose
          containerStyle={{ paddingBottom: insets.bottom }}
          backgroundStyle={{ backgroundColor: colorScheme === 'dark' ? '#171717' : '#fff' }}
          keyboardBehavior="extend"
          keyboardBlurBehavior="restore"
          footerComponent={DayCommentsFooter}
          backdropComponent={(props) => (
            <BottomSheetBackdrop
              {...props}
              opacity={0.7}
              pressBehavior="close"
              disappearsOnIndex={-1}
              appearsOnIndex={0}
            />
          )}>
          <BottomSheetFlatList
            style={{ flex: 1 }}
            data={comments}
            keyboardDismissMode="interactive"
            keyboardShouldPersistTaps="handled"
            keyExtractor={(item: PlanDayComment) => item.id}
            contentContainerStyle={{
              flexGrow: 1,
              paddingBottom: composerInset + insets.bottom,
            }}
            showsVerticalScrollIndicator={false}
            ListHeaderComponent={
              <View className="mb-3 flex-row items-center justify-between px-4">
                <View className="w-16" />

                <Text className="flex-1 text-center text-xl font-bold text-gray-800 dark:text-gray-200">
                  {title}
                </Text>

                <TouchableOpacity
                  accessibilityRole="button"
                  accessibilityLabel={doneAccessibilityLabel ?? `Mark ${title} complete`}
                  disabled={!canMarkDone || isDoneLoading || isSubmitting}
                  onPress={handleDone}
                  className={`min-w-16 rounded-full px-3 py-2 ${
                    canMarkDone && !isDoneLoading && !isSubmitting
                      ? 'bg-black dark:bg-white'
                      : 'bg-gray-200 dark:bg-neutral-800'
                  }`}>
                  <Text
                    className={`text-center text-sm font-semibold ${
                      canMarkDone && !isDoneLoading && !isSubmitting
                        ? 'text-white dark:text-black'
                        : 'text-gray-400 dark:text-gray-500'
                    }`}>
                    Done
                  </Text>
                </TouchableOpacity>
              </View>
            }
            ListEmptyComponent={
              <View className="flex-1 items-center justify-center px-6">
                <Ionicons name="book" size={60} color="#808080" />
                <Text className="text-gray-800 dark:text-gray-200">{emptyMessage}</Text>
              </View>
            }
            renderItem={({ item }: { item: PlanDayComment }) => {
              const isOwner = item.user_id === currentUserId;
              const isEditing = editingCommentId === item.id;
              const isDeleting = deletingCommentId === item.id;

              return (
                <View className="mb-4 px-4">
                  <ProfileIdentityRow
                    className="items-start"
                    first_name={item.first_name}
                    last_name={item.last_name}
                    size={40}
                    titleAside={
                      <Text className="mt-1 text-xs text-gray-500 dark:text-gray-400">
                        {formatRelativeTime(item.created_at)}
                      </Text>
                    }
                    titleClassName="text-sm font-semibold text-gray-200 dark:text-gray-200"
                    uri={item.avatar_url}
                    userId={item.user_id}
                  />

                  <View className="rounded-xl bg-neutral-600 px-3 py-2" style={{ marginLeft: 52 }}>
                    <Text className="mt-1 text-sm text-white dark:text-white">{item.content}</Text>

                    <View className="mt-2 flex-row items-center justify-end">
                      {isOwner && (
                        <View className="flex-row items-center gap-3">
                          {isEditing && (
                            <Text className="text-xs text-blue-200 dark:text-blue-200">
                              Editing
                            </Text>
                          )}

                          {!isEditing && (
                            <TouchableOpacity
                              disabled={isSubmitting || isDeleting}
                              onPress={() => {
                                setEditingCommentId(item.id);
                                setText(item.content);
                              }}>
                              <Ionicons
                                name="create-outline"
                                size={16}
                                color={colorScheme === 'dark' ? '#e5e7eb' : '#e5e7eb'}
                              />
                            </TouchableOpacity>
                          )}

                          <TouchableOpacity
                            disabled={isDeleting}
                            onPress={() => handleDelete(item)}>
                            <Ionicons
                              name={isDeleting ? 'hourglass-outline' : 'trash-outline'}
                              size={16}
                              color={colorScheme === 'dark' ? '#fecaca' : '#fecaca'}
                            />
                          </TouchableOpacity>
                        </View>
                      )}
                    </View>
                  </View>
                </View>
              );
            }}
          />
        </BottomSheet>
      </DayCommentsFooterContext.Provider>
    );
  },
);

DayCommentsBottomSheet.displayName = 'DayCommentsBottomSheet';

export default DayCommentsBottomSheet;
