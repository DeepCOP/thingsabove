import { useTranslation } from 'react-i18next';
import { GridCard, ListCard } from '@/src/components/DevoCard';
import LoadingSpinner from '@/src/components/LoadingSpinner';
import PlansSignInPrompt from '@/src/components/plansList/PlansSignInPrompt';
import { useMyPlanProgressPlans } from '@/src/hooks/usePlanProgress';
import { useSavedPlans, useToggleSavedPlan } from '@/src/hooks/useSavedPlans';
import { useAuth } from '@/src/state/AuthContext';
import { useAppStore } from '@/src/state/useAppStore';
import { MyPlanProgressPlan } from '@/src/types/types';
import { planMatchesSelectedTags } from '@/src/utils/planTags';
import { Ionicons } from '@expo/vector-icons';
import { router } from 'expo-router';
import { useMemo, useState } from 'react';
import { FlatList, Text, useColorScheme, View } from 'react-native';

export default function MyPlansList({
  listHeaderComponent,
  listFooterComponent,
  containterStyle,
  mode = 'all',
  showSaveButton = true,
  selectedTags = [],
}: {
  listHeaderComponent?: React.JSX.Element;
  listFooterComponent?: React.JSX.Element;
  containterStyle?: object;
  mode?: 'all' | 'completed';
  showSaveButton?: boolean;
  selectedTags?: string[];
}) {
  const { t } = useTranslation('plans');
  const { session, loading: sessionLoading } = useAuth();
  const myPlansQuery = useMyPlanProgressPlans(session?.user?.id);
  const colorScheme = useColorScheme();
  const { sort, isGrid } = useAppStore();
  const savedPlansQuery = useSavedPlans(session?.user?.id);
  const { toggleSavedPlan } = useToggleSavedPlan(session?.user?.id);
  const [refreshing, setRefreshing] = useState(false);

  const flatData = useMemo<MyPlanProgressPlan[]>(() => {
    if (!myPlansQuery.data) return [];

    return myPlansQuery.data;
  }, [myPlansQuery.data]);

  const visibleData = useMemo(() => {
    const modeFilteredData =
      mode !== 'completed'
        ? flatData.filter(
            (plan) =>
              (plan.completed_days ?? 0) <
              (typeof plan.total_days === 'number' ? plan.total_days : 0),
          )
        : flatData.filter(
            (plan) =>
              (plan.completed_days ?? 0) >=
              (typeof plan.total_days === 'number' ? plan.total_days : 0),
          );

    return modeFilteredData.filter((plan) => planMatchesSelectedTags(plan, selectedTags));
  }, [flatData, mode, selectedTags]);

  const savedPlanIds = useMemo(
    () =>
      (savedPlansQuery.data ?? [])
        .map((savedPlan) => savedPlan.id)
        .filter((planId): planId is string => typeof planId === 'string' && planId.length > 0),
    [savedPlansQuery.data],
  );

  const sortedPlans = useMemo(() => {
    if (sort === 'Recent') {
      return [...visibleData].sort((a, b) => {
        const timeA = a.started_at ? new Date(a.started_at).getTime() : undefined;
        const timeB = b.started_at ? new Date(b.started_at).getTime() : undefined;

        if (timeA !== undefined && timeB !== undefined) {
          return timeB - timeA;
        }

        if (timeA !== undefined) return -1;
        if (timeB !== undefined) return 1;

        return 0;
      });
    }

    if (sort === 'Trending') {
      return [...visibleData].sort(
        (planOne, planTwo) => (planTwo.helpful_count || 0) - (planOne.helpful_count || 0),
      );
    }

    return visibleData;
  }, [sort, visibleData]);

  const onRefresh = async () => {
    setRefreshing(true);
    await myPlansQuery.refetch();
    setRefreshing(false);
  };

  const EmptyPlans = () => (
    <View className="flex-1 items-center justify-center px-4">
      <View className="w-full max-w-72 bg-white dark:bg-neutral-900 border border-gray-200 dark:border-neutral-800 rounded-2xl px-6 py-8 items-center">
        <View className="w-14 h-14 rounded-full bg-gray-100 dark:bg-neutral-800 items-center justify-center mb-4">
          <Ionicons
            name="book-sharp"
            size={24}
            color={colorScheme === 'dark' ? '#E5E7EB' : '#6B7280'}
          />
        </View>
        {selectedTags.length > 0 ? (
          <>
            <Text className="text-lg font-semibold text-gray-900 dark:text-white mb-2 text-center">
              {t('noTagMatches')}
            </Text>
            <Text className="text-center text-gray-600 dark:text-gray-400">
              {t('clearFilterHint')}
            </Text>
          </>
        ) : mode === 'completed' ? (
          <>
            <Text className="text-lg font-semibold text-gray-900 dark:text-white mb-2 text-center">
              {t('noCompletedPlans')}
            </Text>
            <Text className="text-center text-gray-600 dark:text-gray-400">
              {t('noCompletedPlansHint')}
            </Text>
          </>
        ) : (
          <>
            <Text className="text-lg font-semibold text-gray-900 dark:text-white mb-2 text-center">
              {t('noMyPlans')}
            </Text>
            <Text className="text-center text-gray-600 dark:text-gray-400">
              {t('noMyPlansHint')}
            </Text>
          </>
        )}
      </View>
    </View>
  );

  if (!session && !sessionLoading) {
    return <PlansSignInPrompt title={t('signInForPlans')} hint={t('signInForPlansHint')} />;
  }

  if (myPlansQuery.isLoading || sessionLoading) {
    return <LoadingSpinner />;
  }

  return (
    <FlatList
      className="flex-1"
      showsVerticalScrollIndicator={false}
      data={sortedPlans}
      ListHeaderComponent={listHeaderComponent}
      ListFooterComponent={listFooterComponent}
      keyExtractor={(item) => item.progress_id!}
      refreshing={refreshing}
      onRefresh={onRefresh}
      ListEmptyComponent={<EmptyPlans />}
      key={isGrid ? 'grid' : 'list'}
      numColumns={isGrid ? 2 : 1}
      columnWrapperStyle={isGrid ? { gap: 12 } : undefined}
      contentContainerStyle={{
        flexGrow: 1,
        justifyContent: sortedPlans.length === 0 ? 'center' : undefined,
        paddingBottom: 40,
        ...containterStyle,
      }}
      renderItem={({ item }) => {
        const planId = item.plan_id as string | null;
        const isSaved = !!planId && savedPlanIds.includes(planId);
        const cardItem = {
          ...item,
          id: item.plan_id,
        };

        return isGrid ? (
          <GridCard
            item={cardItem}
            isSaved={isSaved}
            onToggleSave={
              showSaveButton
                ? () => planId && toggleSavedPlan(planId, isSaved, cardItem)
                : undefined
            }
            onPress={() =>
              router.push({
                pathname: '/app/plan_progress/[progressId]',
                params: {
                  groupId: item.group_id,
                  planId: item.plan_id,
                  progressId: item.progress_id!,
                },
              })
            }
          />
        ) : (
          <ListCard
            item={cardItem}
            isSaved={isSaved}
            onToggleSave={
              showSaveButton
                ? () => planId && toggleSavedPlan(planId, isSaved, cardItem)
                : undefined
            }
            onPress={() =>
              router.push({
                pathname: '/app/plan_progress/[progressId]',
                params: {
                  groupId: item.group_id,
                  planId: item.plan_id,
                  progressId: item.progress_id!,
                },
              })
            }
          />
        );
      }}
    />
  );
}
