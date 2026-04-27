import { useComments } from '@/src/hooks/useComments';
import { formatRelativeTime } from '@/src/lib/relativeTime';
import { useAuth } from '@/src/state/AuthContext';
import { PlanDayComment } from '@/src/types/types';
import dayjs from '@/src/lib/dayjs';
import { Ionicons } from '@expo/vector-icons';
import BottomSheet, {
  BottomSheetBackdrop,
  BottomSheetFlatList,
  BottomSheetTextInput,
  BottomSheetView,
} from '@gorhom/bottom-sheet';
import { forwardRef, useMemo, useState } from 'react';
import { Alert, Text, TouchableOpacity, useColorScheme, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useRealtimeComments } from '../hooks/useRealtimeComments';
import LoadingSpinner from './LoadingSpinner';
import ProfileIdentityRow from './ProfileIdentityRow';

type Props = {
  planId: string;
  dayId: string;
  group_id?: string;
};

const DayCommentsBottomSheet = forwardRef<BottomSheet, Props>(
  ({ planId, dayId, group_id }, ref) => {
    const snapPoints = useMemo(() => ['50%', '85%'], []);
    const colorScheme = useColorScheme();
    const [text, setText] = useState('');
    const [editingCommentId, setEditingCommentId] = useState<string | null>(null);
    const { session } = useAuth();
    const currentUserId = session?.user?.id;

    const { commentsQuery, addComment, updateComment, deleteComment } = useComments(
      planId,
      dayId,
      group_id,
    );
    const comments = commentsQuery.data || [];
    const isSubmitting = addComment.isPending || updateComment.isPending;
    const deletingCommentId = deleteComment.isPending ? deleteComment.variables?.commentId : null;
    const insets = useSafeAreaInsets();
    useRealtimeComments(group_id as string, commentsQuery.refetch);

    const resetComposer = () => {
      setText('');
      setEditingCommentId(null);
    };

    const handleSubmit = () => {
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
        onSuccess: resetComposer,
      });
    };

    const handleDelete = (comment: PlanDayComment) => {
      Alert.alert('Delete comment?', 'This will permanently remove your comment.', [
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

    return (
      <BottomSheet
        ref={ref}
        index={-1}
        snapPoints={snapPoints}
        enablePanDownToClose
        bottomInset={insets.bottom + 8}
        backgroundStyle={{ backgroundColor: colorScheme === 'dark' ? '#171717' : '#fff' }}
        keyboardBehavior="interactive"
        keyboardBlurBehavior="restore"
        backdropComponent={(props) => (
          <BottomSheetBackdrop
            {...props}
            opacity={0.7}
            pressBehavior="close"
            disappearsOnIndex={-1}
            appearsOnIndex={0}
          />
        )}>
        <BottomSheetView className="w-full h-full">
          <Text className="text-xl font-bold text-gray-800 dark:text-gray-200 mb-3 text-center">
            Share your thoughts…
          </Text>
          {comments.length === 0 ? (
            <View className="flex-1 items-center justify-center">
              <Ionicons name="book" size={60} color={'#808080'} />
              <Text className="text-gray-800 dark:text-gray-200">
                Share your thoughts based on todays reading.
              </Text>
            </View>
          ) : (
            <BottomSheetFlatList
              data={comments}
              keyboardDismissMode="interactive"
              keyboardShouldPersistTaps="handled"
              keyExtractor={(item: PlanDayComment) => item.id}
              contentContainerStyle={{ paddingBottom: 120 }}
              showsVerticalScrollIndicator={false}
              renderItem={({ item }: { item: PlanDayComment }) => {
                const isOwner = item.user_id === currentUserId;
                const isEditing = editingCommentId === item.id;
                const isDeleting = deletingCommentId === item.id;

                return (
                  <ProfileIdentityRow
                    className="mb-4 px-4 items-start"
                    contentClassName="rounded-xl bg-neutral-600 px-3 py-2"
                    first_name={item.first_name}
                    last_name={item.last_name}
                    size={40}
                    titleClassName="text-sm font-semibold text-gray-200 dark:text-gray-200"
                    uri={item.avatar_url}
                    userId={item.user_id}>
                    <>
                      <Text className="mt-1 text-sm dark:text-white text-white">
                        {item.content}
                      </Text>

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
                    </>
                  </ProfileIdentityRow>
                );
              }}
            />
          )}
          <View
            style={{
              paddingHorizontal: 16,
              paddingVertical: 8,
              backgroundColor: colorScheme === 'dark' ? '#000' : '#fff',
            }}>
            {editingCommentId && (
              <View className="mb-3 flex-row items-center justify-between">
                <Text className="text-sm text-gray-600 dark:text-gray-300">Editing comment</Text>

                <TouchableOpacity onPress={resetComposer}>
                  <Text className="text-sm font-medium text-gray-800 dark:text-gray-200">
                    Cancel
                  </Text>
                </TouchableOpacity>
              </View>
            )}

            <View className="flex-row items-center gap-2">
              <BottomSheetTextInput
                value={text}
                onChangeText={setText}
                placeholder="Share your thoughts…"
                placeholderTextColor="#999"
                className="flex-1 px-4 py-3 rounded-full bg-gray-200 dark:bg-neutral-800 dark:text-white"
              />

              <TouchableOpacity
                disabled={!text.trim() || isSubmitting}
                onPress={handleSubmit}
                className="px-4 py-3 rounded-full bg-black dark:bg-white">
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
        </BottomSheetView>
      </BottomSheet>
    );
  },
);

DayCommentsBottomSheet.displayName = 'DayCommentsBottomSheet';

export default DayCommentsBottomSheet;
