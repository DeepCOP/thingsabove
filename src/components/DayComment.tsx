import { useComments } from '@/src/hooks/useComments';
import { Ionicons } from '@expo/vector-icons';
import BottomSheet, {
  BottomSheetBackdrop,
  BottomSheetFlatList,
  BottomSheetTextInput,
  BottomSheetView,
} from '@gorhom/bottom-sheet';
import dayjs from 'dayjs';
import { forwardRef, useMemo, useState } from 'react';
import { Text, TouchableOpacity, useColorScheme, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useRealtimeComments } from '../hooks/useRealtimeComments';
import LoadingSpinner from './LoadingSpinner';
import UserAvatar from './UserAvatar';

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

    const { commentsQuery, addComment } = useComments(planId, dayId, group_id);
    const comments = commentsQuery.data || [];
    const isPosting = addComment.isPending;
    const insets = useSafeAreaInsets();
    useRealtimeComments(group_id as string, commentsQuery.refetch);

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
              keyExtractor={(item: {
                content: string;
                created_at: string;
                id: string;
                parent_id: string;
                user_id: string;
              }) => item.id}
              contentContainerStyle={{ paddingBottom: 120 }}
              showsVerticalScrollIndicator={false}
              renderItem={({
                item,
              }: {
                item: {
                  content: string;
                  created_at: string;
                  id: string;
                  parent_id: string;
                  user_id: string;
                  first_name: string;
                  last_name: string;
                  avatar_url: string;
                };
              }) => {
                return (
                  <View className="flex-row items-start gap-3 mb-4 px-4">
                    {/* Avatar */}
                    <UserAvatar
                      uri={item.avatar_url}
                      first_name={item.first_name}
                      last_name={item.last_name}
                      size={40}
                    />

                    <View className={`flex-1 px-3 py-2 rounded-xl bg-neutral-600`}>
                      <Text className="font-semibold text-sm text-gray-200 dark:text-gray-200">
                        {item.first_name} {item.last_name}
                      </Text>

                      <Text className="mt-1 text-sm dark:text-white text-white">
                        {item.content}
                      </Text>

                      {/* Date */}
                      <Text className="mt-1 text-xs text-gray-300 ">
                        {dayjs(item.created_at).format('MMM DD')}
                      </Text>
                    </View>
                  </View>
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
            <View className="flex-row items-center gap-2">
              <BottomSheetTextInput
                value={text}
                onChangeText={setText}
                placeholder="Share your thoughts…"
                placeholderTextColor="#999"
                className="flex-1 px-4 py-3 rounded-full bg-gray-200 dark:bg-neutral-800 dark:text-white"
              />

              <TouchableOpacity
                disabled={!text.trim() || isPosting}
                onPress={() => {
                  addComment.mutate(text, {
                    onSuccess: () => setText(''),
                  });
                }}
                className="px-4 py-3 rounded-full bg-black dark:bg-white">
                {addComment.isPending ? (
                  <LoadingSpinner size="small" />
                ) : (
                  <Text className="text-white dark:text-black">Send</Text>
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
