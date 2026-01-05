import { useComments, useRealtimeComments } from '@/hooks/useComments';
import { Ionicons } from '@expo/vector-icons';
import BottomSheet, {
  BottomSheetBackdrop,
  BottomSheetFlatList,
  BottomSheetView,
} from '@gorhom/bottom-sheet';
import dayjs from 'dayjs';
import { forwardRef, useMemo, useState } from 'react';
import { Image, Text, TextInput, TouchableOpacity, useColorScheme, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

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
        keyboardBehavior="interactive"
        backgroundStyle={{ backgroundColor: colorScheme === 'dark' ? '#171717' : '#fff' }}
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
        <BottomSheetView className="flex-1 px-4 h-full">
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
              keyExtractor={(item: {
                content: string;
                created_at: string;
                id: string;
                parent_id: string;
                user_id: string;
              }) => item.id}
              contentContainerStyle={{ paddingBottom: 80 }}
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
                  <View className="flex-row items-start gap-3 mb-4">
                    {/* Avatar */}
                    <Image
                      source={{ uri: item.avatar_url }}
                      className="w-10 h-10 rounded-full bg-gray-300"
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
            className="absolute bottom-0 left-0 right-0 px-4 py-3 bg-white dark:bg-black border-t border-gray-200 dark:border-neutral-800"
            style={{ marginBottom: insets.bottom + 5 || 12 }}>
            <View className="flex-row items-center gap-2">
              <TextInput
                value={text}
                onChangeText={setText}
                placeholder="Share your thoughts…"
                placeholderTextColor="#999"
                className="flex-1 px-4 py-3 rounded-full bg-gray-200 dark:bg-neutral-800 dark:text-white"
              />
              <TouchableOpacity
                disabled={!text.trim() || isPosting}
                onPress={() => {
                  addComment.mutate(text);
                  setText('');
                }}
                className="px-4 py-3 rounded-full bg-black dark:bg-white">
                <Text className="text-white dark:text-black">Send</Text>
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
