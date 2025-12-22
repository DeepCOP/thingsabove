/* eslint-disable react-hooks/exhaustive-deps */
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { useAuth } from '@/context/AuthContext';
import { useDayItemsProgress } from '@/hooks/useDayItemsProgress';
import { usePlanDay, usePlanProgress } from '@/hooks/usePLanProgress';
import { useFetchDevotionalPlan } from '@/hooks/usePlans';
import { BibleBook, useAppStore } from '@/store/useAppStore';
import { parseVerseRef } from '@/utils/utils';
import { Ionicons } from '@expo/vector-icons';
import dayjs from 'dayjs';
import { Stack, useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect, useMemo, useRef, useState } from 'react';
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

export default function PlanProgressScreen() {
  const insets = useSafeAreaInsets();
  const { planId } = useLocalSearchParams(); // plan ID
  const router = useRouter();
  const { setMissedDays } = useAppStore();
  const colorScheme = useColorScheme();
  const { session, loading: sessionLoading } = useAuth();

  const { planProgressQuery, daysQuery } = usePlanProgress(
    planId as string,
    session?.user?.id as string,
  );

  const planProgress = planProgressQuery.data;
  const days = daysQuery.data;
  const planQuery = useFetchDevotionalPlan(planId as string);
  const plan = planQuery.data;
  const [selectedDayNumber, setSelectedDay] = useState<number | null>(1);
  const { setSelectedBook, setItemId } = useAppStore();

  const { data: dayData, isLoading: dayLoading } = usePlanDay(
    days?.find((d) => d.day_number === selectedDayNumber)?.id ?? null,
  );

  const currentDayData = days?.find(
    (d) =>
      dayjs(planProgress?.created_at)
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
    scripture_refs: dayData?.scripture_refs || [],
  });

  const prevCompletedCount = useRef<number | null>(null);

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
    if (planProgress?.current_day) {
      setSelectedDay(currentDayData?.day_number || plan?.total_days || 1);
    }
  }, [currentDayData, planProgress, plan?.total_days]);

  useEffect(() => {
    if (dayItemsProgressQuery?.items) {
      return;
    }
    loadItems.mutate();
  }, [dayItemsProgressQuery]);

  const devotional = dayItemsProgressQuery?.items.find((item) => item.item_type === 'devotional');

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
        !planProgress?.completed_days?.includes(d.day_number) && d.day_number <= plan?.total_days
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
    return <ActivityIndicator size="large" style={{ marginTop: 40 }} />;
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
                  <TouchableOpacity
                    key={d.id}
                    onPress={() => setSelectedDay(d.day_number)}
                    className={`px-4 py-3 rounded-xl border ${
                      isActive
                        ? 'border-black dark:border-white bg-black/10 dark:bg-white/10'
                        : 'border-gray-300 dark:border-gray-700'
                    }`}>
                    {planProgress.completed_days?.includes(d.day_number) && (
                      <View className="absolute top-1 right-1 bg-green-900 rounded-full p-1 z-10">
                        <Ionicons name="checkmark" size={12} color="white" />
                      </View>
                    )}

                    <Text className="text-center font-semibold dark:text-white">
                      {d.day_number}
                    </Text>
                    <Text
                      className={`text-xs ${currentDayData?.id === d.id ? 'text-white bg-black p-1 font-bold rounded-full' : 'text-gray-500'} dark:text-gray-400 `}>
                      {dayjs(planProgress?.created_at)
                        .startOf('day')
                        .add(d.day_number - 1, 'day')
                        .format('MMM DD')}
                    </Text>
                  </TouchableOpacity>
                );
              })}
            </View>
          </ScrollView>

          {/* Day Title */}
          <View className="flex-row justify-between items-center mb-2">
            <Text className="text-xl font-bold dark:text-white">
              Day {selectedDayNumber} of {days.length}
            </Text>

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

          <View className="mt-4 space-y-6">
            {/* Devotional */}
            {devotional && (
              <TouchableOpacity
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

                        router.push(
                          `/devotional_detail/${plan.id}/${selectedDay?.id}/${devotional?.id}`,
                        );
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
            )}
            {/* Scripture Reference */}
            {dayItemsProgressQuery?.items.length && dayItemsProgressQuery?.items.length > 0 ? (
              dayItemsProgressQuery?.items?.map((data, index) => {
                if (data.item_type === 'devotional') {
                  return null;
                }
                return (
                  <TouchableOpacity
                    key={index}
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

                            router.push(
                              `/devotional_detail/${plan.id}/${selectedDay?.id}/${data.id}`,
                            );
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
            ) : loadItems.isPending ? (
              <ActivityIndicator size={'small'} />
            ) : (
              <View>
                <Text>Items Not Found</Text>
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
          zIndex: 10,
          paddingBottom: insets.bottom,
        }}>
        {dayItemsProgressQuery?.items && dayItemsProgressQuery?.items.length > 0 && (
          <TouchableOpacity
            className=" mt-10 mb-5 bg-black min-w-[80%] dark:bg-white py-4 rounded-full"
            onPress={() => {
              setItemId(dayItemsProgressQuery?.devotional.id || '');
              router.push(
                `/devotional_detail/${plan.id}/${selectedDay?.id}/${dayItemsProgressQuery?.devotional.id}`,
              );
            }}>
            <Text className="text-center text-white dark:text-black font-semibold text-lg">
              Start Reading
            </Text>
          </TouchableOpacity>
        )}
      </Animated.View>
    </>
  );
}
