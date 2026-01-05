/* eslint-disable react-hooks/exhaustive-deps */
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import DayCommentsSection from '@/components/DayComment';
import { useAuth } from '@/context/AuthContext';
import { useDayItemsProgress } from '@/hooks/useDayItemsProgress';
import { useFetchDevotionalPlanById } from '@/hooks/useDevotionalPlans';
import { useDevotionalDays, usePlanDay, usePlanProgress } from '@/hooks/usePlanProgress';
import { BibleBook, useAppStore } from '@/store/useAppStore';
import { parseVerseRef, sortByItemKey } from '@/utils/utils';
import { Ionicons } from '@expo/vector-icons';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect, useMemo, useRef, useState } from 'react';

import DaysPicker from '@/components/DaysPicker';
import LoadingSpinner from '@/components/LoadingSpinner';
import { usePlanGroupMembers } from '@/hooks/usePlanGroup';
import { BottomSheetModal } from '@gorhom/bottom-sheet';
import {
  ActivityIndicator,
  Animated,
  Image,
  ScrollView,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';

dayjs.extend(utc);
export default function PlanProgressScreen() {
  const commentsSheetRef = useRef<BottomSheetModal>(null);
  const insets = useSafeAreaInsets();
  const { planId, groupId } = useLocalSearchParams(); // plan ID
  const router = useRouter();
  const { setMissedDays } = useAppStore();
  const colorScheme = useColorScheme();
  const { session, loading: sessionLoading } = useAuth();
  const { planProgressQuery } = usePlanProgress(
    planId as string,
    session?.user?.id as string,
    groupId as string,
  );
  const daysQuery = useDevotionalDays(planId as string);
  const planGroupMembersQuery = usePlanGroupMembers(groupId as string);
  const planProgress = planProgressQuery.data;
  const days = daysQuery.data;
  const planQuery = useFetchDevotionalPlanById(planId as string);
  const plan = planQuery.data;
  const [selectedDayNumber, setSelectedDay] = useState<number | null>(1);
  const { setSelectedBook, setItemId } = useAppStore();

  const { data: dayData, isLoading: dayLoading } = usePlanDay(
    days?.find((d) => d.day_number === selectedDayNumber)?.id ?? null,
  );

  const currentDayData = days?.find(
    (d) =>
      dayjs(planProgress?.start_date)
        .startOf('day')
        .add(d.day_number - 1, 'day')
        .format('MMM DD') === dayjs().startOf('day').format('MMM DD'),
  );

  const selectedDay = days?.find((d) => d.day_number === selectedDayNumber);

  const setFromVerseRef = (ref: string, setSelectedBook: (b: BibleBook) => void) => {
    const parsed = parseVerseRef(ref);
    if (!parsed) return;

    setSelectedBook({
      name: parsed.book,
      chapter: parsed.chapter,
      verseEnd: parsed.verseEnd,
      verseStart: parsed.verseStart,
    });
  };
  const { dayItemsProgressQuery, toggleMutation, loadItems } = useDayItemsProgress({
    user_id: session?.user?.id!,
    plan_id: planId as string,
    day_id: selectedDay?.id || '',
    group_id: groupId as string,
  });

  const dayItemsProgress = useMemo(() => {
    if (!dayItemsProgressQuery?.data) return null;
    const data = dayItemsProgressQuery?.data;

    return {
      items: [...data].sort((a, b) => {
        const getNumericPrefix = (key?: string | null) => {
          if (!key) return 0;
          const match = key.match(/^(\d+)/);
          return match ? Number(match[0]) : 0;
        };

        const numericA = getNumericPrefix(a.item_key);
        const numericB = getNumericPrefix(b.item_key);

        if (numericA === numericB) {
          return (a.item_key ?? '').localeCompare(b.item_key ?? '');
        }

        return numericA - numericB;
      }),
      devotional: {
        completed: data.find((i) => i.item_type === 'devotional' && i.item_key === 'main')
          ?.completed,
        id: data.find((i) => i.item_type === 'devotional' && i.item_key === 'main')?.id,
      },
      scriptures: [...(dayData?.scripture_refs || [])]
        .sort((a, b) => sortByItemKey(a, b))
        .map((ref) => ({
          ref,
          completed: data.find((i) => i.item_type === 'scripture' && i.item_key === ref)?.completed,
          id: data.find((i) => i.item_type === 'scripture' && i.item_key === ref)?.id,
        })),
    };
  }, [dayItemsProgressQuery?.data, dayData?.scripture_refs]);

  const prevCompletedCount = useRef<number | null>(null);
  const devotional = dayItemsProgress?.items.find((item) => item.item_type === 'devotional');

  useEffect(() => {
    if (!planProgress || !plan) return;

    const completedCount = planProgress.completed_days?.length ?? 0;

    if (prevCompletedCount.current === null) {
      prevCompletedCount.current = completedCount;
      return;
    }

    const justCompleted =
      prevCompletedCount.current < plan.total_days && completedCount === plan.total_days;

    if (justCompleted) {
      router.replace(`/plan_progress/${plan.id}/plan-complete`);
    }

    prevCompletedCount.current = completedCount;
  }, [planProgress?.completed_days?.length, plan?.total_days]);

  useEffect(() => {
    setSelectedDay(currentDayData?.day_number || 1);
  }, [currentDayData]);

  useEffect(() => {
    if (dayItemsProgress?.items) {
      return;
    }
    loadItems.mutate();
  }, [dayItemsProgress]);

  const missedDays = useMemo(() => {
    if (!planProgress || !plan) return null;
    return days?.filter((d) => {
      if (currentDayData) {
        return (
          !planProgress?.completed_days?.includes(d.day_number) &&
          d.day_number < currentDayData?.day_number
        );
      }

      return (
        !planProgress?.completed_days?.includes(d.day_number) &&
        dayjs(planProgress.start_date)
          .add(d.day_number - 1, 'day')
          .diff(dayjs().utc().startOf('day'), 'day') < 0
      );
    });
  }, [planProgress, currentDayData, plan]);

  if (
    planProgressQuery.isLoading ||
    daysQuery.isLoading ||
    planQuery.isLoading ||
    sessionLoading ||
    dayLoading
  ) {
    return <LoadingSpinner />;
  }

  if (!planProgress || !days || !plan) {
    return <ActivityIndicator size="large" style={{ marginTop: 40 }} />;
  }

  return (
    <>
      <Stack.Screen
        options={{
          title: plan?.title || 'Plan Progress',
        }}
      />
      <ScrollView className="flex-1 bg-white dark:bg-black">
        <View className="px-4">
          <Image
            source={{ uri: plan?.cover_image || undefined }}
            className="w-full h-60 rounded-2xl"
            resizeMode="cover"
          />
        </View>
        <View className="px-4 pt-4">
          {/* Header */}
          <Text className="text-2xl font-bold dark:text-white mb-4">{`Day ${selectedDayNumber}`}</Text>

          {/* Horizontal Days */}
          <ScrollView horizontal showsHorizontalScrollIndicator={false} className="mb-5">
            <View className="flex-row gap-3">
              {days.map((d) => {
                const isActive = d.day_number === selectedDayNumber;
                return (
                  <DaysPicker
                    key={d.id}
                    isActive={isActive}
                    isCurrentDay={currentDayData?.id === d.id}
                    completed={planProgress.completed_days?.includes(d.day_number) || false}
                    day_number={d.day_number}
                    startDate={planProgress?.start_date!}
                    setSelectedDayNumber={setSelectedDay}
                  />
                );
              })}
            </View>
          </ScrollView>

          {/* Day Title */}
          <View className="flex-row justify-between items-center mb-2">
            <Text className="text-xl font-bold dark:text-white">
              Day {selectedDayNumber} of {days.length}
            </Text>

            <View className="flex-row items-center">
              <TouchableOpacity
                onPress={() => commentsSheetRef.current?.expand()}
                className="px-4 py-2">
                <Ionicons
                  name="chatbubble-ellipses"
                  size={24}
                  color={colorScheme === 'dark' ? '#fff' : '#000'}
                />
              </TouchableOpacity>
              {missedDays && missedDays.length > 0 ? (
                <TouchableOpacity
                  className="px-3 py-1 border rounded-full border-green-500"
                  onPress={() => {
                    setMissedDays(missedDays);
                    router.push(`/plan_progress/${plan.id}/missedDays`);
                  }}>
                  <Text className="text-green-600 text-xs">{missedDays.length} Missed Days</Text>
                </TouchableOpacity>
              ) : (
                <TouchableOpacity className="px-3 py-1 border rounded-full border-green-500">
                  <Text className="text-green-600 text-xs">ON TRACK!</Text>
                </TouchableOpacity>
              )}
            </View>
          </View>
          {planGroupMembersQuery.isLoading ? (
            <ActivityIndicator size="small" />
          ) : (
            <View className="mt-4 flex-row items-center">
              {planGroupMembersQuery.data?.slice(0, 6).map((member, index) => {
                const avatarSize = 32;
                const overlap = 10;

                return (
                  <TouchableOpacity
                    onPress={() => {
                      router.push({
                        pathname: `/devotional_detail/[id]/participants`,
                        params: {
                          groupId: groupId,
                          totalDays: plan.total_days,
                          id: planId as string,
                        },
                      });
                    }}
                    key={member.id}
                    style={{
                      marginLeft: index === 0 ? 0 : -overlap,
                      zIndex: 100 - index,
                    }}>
                    {member.profiles.avatar_url ? (
                      <Image
                        source={{ uri: member.profiles.avatar_url }}
                        style={{
                          width: avatarSize,
                          height: avatarSize,
                          borderRadius: avatarSize / 2,
                          borderWidth: 2,
                          borderColor: 'white',
                        }}
                      />
                    ) : (
                      <View
                        style={{
                          width: avatarSize,
                          height: avatarSize,
                          borderRadius: avatarSize / 2,
                          backgroundColor: '#9CA3AF', // gray-400
                          borderWidth: 2,
                          borderColor: 'white',
                        }}
                      />
                    )}
                  </TouchableOpacity>
                );
              })}

              {planGroupMembersQuery.data && planGroupMembersQuery.data.length > 6 && (
                <View className="ml-2 px-2 py-1 rounded-full bg-gray-200 dark:bg-gray-800">
                  <Text className="text-xs dark:text-white">
                    +{planGroupMembersQuery.data.length - 6}
                  </Text>
                </View>
              )}
            </View>
          )}

          <View className="mt-4 space-y-6">
            {/* Devotional */}

            {/* Scripture Reference */}
            {dayItemsProgressQuery.isLoading || loadItems.isPending ? (
              <LoadingSpinner />
            ) : dayItemsProgress?.items.length && dayItemsProgress?.items.length > 0 ? (
              dayItemsProgress?.items?.map((data, index) => {
                if (data.item_type === 'devotional') {
                  return (
                    <TouchableOpacity
                      key={data.id}
                      className="flex-row items-center justify-between"
                      onPress={() => {
                        toggleMutation.mutate(
                          {
                            item_type: devotional?.item_type as 'devotional' | 'scripture',
                            item_key: devotional?.item_key || '',
                            completed: true,
                          },
                          {
                            onSuccess: () => {
                              setItemId(devotional?.id || '');

                              router.push({
                                pathname: `/devotional_detail/[id]/[dayId]/[itemId]`,
                                params: {
                                  groupId: groupId,
                                  id: plan.id,
                                  dayId: selectedDay?.id || '',
                                  itemId: devotional?.id || '',
                                },
                              });
                            },
                          },
                        );
                      }}>
                      <View className="flex-row items-center gap-3">
                        <TouchableOpacity
                          onPress={() =>
                            toggleMutation.mutate({
                              item_type: devotional?.item_type as 'devotional' | 'scripture',
                              item_key: devotional?.item_key || '',
                              completed: !devotional?.completed,
                            })
                          }
                          className={`rounded-full p-1 border mr-3 ${
                            devotional?.completed ? 'bg-black dark:bg-white' : 'border-gray-500'
                          }`}>
                          <Ionicons
                            name="checkmark"
                            size={12}
                            color={colorScheme === 'dark' ? 'black' : 'white'}
                          />
                        </TouchableOpacity>
                        <Text className="text-lg dark:text-white">
                          {devotional?.item_type === 'devotional'
                            ? 'Devotional'
                            : devotional?.item_key || 'Scripture'}
                        </Text>
                      </View>
                      <Ionicons
                        name="chevron-forward"
                        size={22}
                        color={colorScheme === 'dark' ? '#fff' : '#000'}
                      />
                    </TouchableOpacity>
                  );
                }
                return (
                  <TouchableOpacity
                    key={data.id}
                    className="flex-row items-center justify-between"
                    onPress={() => {
                      toggleMutation.mutate(
                        {
                          item_type: data.item_type as 'devotional' | 'scripture',
                          item_key: data.item_key || '',
                          completed: true,
                        },
                        {
                          onSuccess: () => {
                            setItemId(data.id || '');
                            setFromVerseRef(data.item_key || '', setSelectedBook);

                            router.push({
                              pathname: `/devotional_detail/[id]/[dayId]/[itemId]`,
                              params: {
                                groupId: groupId,
                                id: plan.id,
                                dayId: selectedDay?.id || '',
                                itemId: data.id || '',
                              },
                            });
                          },
                        },
                      );
                    }}>
                    <View className="flex-row items-center gap-3">
                      <TouchableOpacity
                        onPress={() =>
                          toggleMutation.mutate({
                            item_type: data.item_type as 'devotional' | 'scripture',
                            item_key: data.item_key || '',
                            completed: !data.completed,
                          })
                        }
                        className={`rounded-full p-1 border mr-3 ${
                          data.completed ? 'bg-black dark:bg-white' : 'border-gray-500'
                        }`}>
                        <Ionicons
                          name="checkmark"
                          size={12}
                          color={colorScheme === 'dark' ? 'black' : 'white'}
                        />
                      </TouchableOpacity>
                      <Text className="text-lg dark:text-white">
                        {data?.item_type === 'devotional'
                          ? 'Devotional'
                          : data?.item_key || 'Scripture'}
                      </Text>
                    </View>
                    <Ionicons
                      name="chevron-forward"
                      size={22}
                      color={colorScheme === 'dark' ? '#fff' : '#000'}
                    />
                  </TouchableOpacity>
                );
              })
            ) : (
              <View>
                <Text className="text-gray-800 dark:text-gray-200">Items Not Found</Text>
              </View>
            )}
          </View>
        </View>
      </ScrollView>
      {/* Footer Button */}
      <Animated.View
        className="items-center pb-4 bg-transparent"
        style={{
          position: 'absolute',
          bottom: 0,
          left: 0,
          right: 0,
          paddingBottom: insets.bottom,
        }}>
        {dayItemsProgress?.items && dayItemsProgress?.items.length > 0 && (
          <TouchableOpacity
            className=" mt-10 mb-5 bg-black min-w-[80%] dark:bg-white py-4 rounded-full"
            onPress={() => {
              setItemId(dayItemsProgress?.devotional.id || '');
              router.push({
                pathname: `/devotional_detail/[id]/[dayId]/[itemId]`,
                params: {
                  groupId: groupId,
                  id: plan.id,
                  dayId: selectedDay?.id || '',
                  itemId: dayItemsProgress?.devotional.id || '',
                },
              });
            }}>
            <Text className="text-center text-white dark:text-black font-semibold text-lg">
              Start Reading
            </Text>
          </TouchableOpacity>
        )}
      </Animated.View>
      <DayCommentsSection
        ref={commentsSheetRef}
        planId={plan.id}
        dayId={selectedDay?.id || ''}
        group_id={groupId as string}
      />
    </>
  );
}
