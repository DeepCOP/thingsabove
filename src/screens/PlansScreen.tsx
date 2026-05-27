import Dropdown from '@/src/components/DropDown';
import { MyPlansToggle } from '@/src/components/MyPlansToggle';
import PlanTagFilterChips from '@/src/components/PlanTagFilterChips';
import Ionicons from '@expo/vector-icons/Ionicons';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import { Text, TouchableOpacity, useColorScheme, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import FindPlansList from '../components/plansList/FindPlansList';
import MyPlansList from '../components/plansList/MyPlansList';
import PrivatePlansList from '../components/plansList/PrivatePlansList';
import SavedPlansList from '../components/plansList/SavedPlansList';

type Props = {
  isGrid: boolean;
  sort: 'Recent' | 'Trending';
  activeTab: 'my-plans' | 'private-plans' | 'saved-plans' | 'completed-plans' | 'find-plans';
  isAuthenticated: boolean;
  tags: string[];
  selectedTags: string[];
  areTagsLoading?: boolean;
  notificationCount?: number;
  onToggleGrid: () => void;
  onChangeTab: (
    tab: 'my-plans' | 'private-plans' | 'saved-plans' | 'completed-plans' | 'find-plans',
  ) => void;
  onChangeSort: (sort: 'Recent' | 'Trending') => void;
  onToggleTag: (tag: string) => void;
  onClearTags: () => void;
  onSearch: () => void;
  onNotifications: () => void;
  onPrayerBoard: () => void;
  onLogin: () => void;
  onContribute: () => void;
};

export default function PlansScreen({
  isGrid,
  sort,
  activeTab,
  isAuthenticated,
  tags,
  selectedTags,
  areTagsLoading = false,
  notificationCount = 0,
  onToggleGrid,
  onChangeTab,
  onChangeSort,
  onToggleTag,
  onClearTags,
  onSearch,
  onNotifications,
  onPrayerBoard,
  onLogin,
  onContribute,
}: Props) {
  const colorScheme = useColorScheme();
  const insets = useSafeAreaInsets();
  const notificationLabel = notificationCount > 99 ? '99+' : String(notificationCount);

  return (
    <View className="flex-1 bg-gray-100 dark:bg-black px-4">
      {/* Header */}
      <View
        className="mb-4 flex-row items-center justify-between"
        style={{ marginTop: insets.top }}>
        <TouchableOpacity onPress={onToggleGrid}>
          <Ionicons
            name={isGrid ? 'list-outline' : 'grid-outline'}
            size={24}
            color={colorScheme === 'dark' ? '#fff' : '#222'}
          />
        </TouchableOpacity>

        <View className="flex-row items-center gap-4">
          {isAuthenticated && (
            <TouchableOpacity onPress={onPrayerBoard}>
              <MaterialCommunityIcons
                name="hands-pray"
                size={22}
                color={colorScheme === 'dark' ? '#fff' : '#222'}
              />
            </TouchableOpacity>
          )}
          {isAuthenticated && (
            <TouchableOpacity
              onPress={onNotifications}
              style={{ overflow: 'visible' }}
              className="relative h-8 w-8 items-center justify-center"
              hitSlop={10}>
              <Ionicons
                name="notifications-outline"
                size={22}
                color={colorScheme === 'dark' ? '#fff' : '#222'}
              />

              {notificationCount > 0 && (
                <View
                  className="absolute -right-2 -top-2 items-center justify-center  p-1"
                  style={{
                    backgroundColor: '#ef4444',
                    maxHeight: 28,
                    borderRadius: 14,
                    maxWidth: 28,
                    minHeight: 18,
                    minWidth: 18,
                    zIndex: 10,
                    overflow: 'visible',
                  }}>
                  <Text
                    allowFontScaling={false}
                    numberOfLines={1}
                    className="text-center text-[10px] font-bold text-white"
                    style={{
                      includeFontPadding: false,
                      lineHeight: 12,
                    }}>
                    {notificationLabel}
                  </Text>
                </View>
              )}
            </TouchableOpacity>
          )}
          <Ionicons
            name="search"
            size={22}
            color={colorScheme === 'dark' ? '#fff' : '#222'}
            onPress={onSearch}
          />
          {!isAuthenticated && (
            <TouchableOpacity onPress={onLogin}>
              <Ionicons
                name="person-add"
                size={22}
                color={colorScheme === 'dark' ? '#fff' : '#222'}
              />
            </TouchableOpacity>
          )}
        </View>
      </View>

      <MyPlansToggle activeTab={activeTab} onChange={onChangeTab} />

      <View className="mb-3 flex-row items-center">
        <Text className="mr-2 text-gray-700 dark:text-gray-200">Sort by:</Text>
        <Dropdown
          value={sort}
          onChange={(v) => onChangeSort(v as 'Recent' | 'Trending')}
          options={['Recent', 'Trending']}
        />
      </View>

      <PlanTagFilterChips
        tags={tags}
        selectedTags={selectedTags}
        isLoading={areTagsLoading}
        onToggleTag={onToggleTag}
        onClear={onClearTags}
      />

      {activeTab === 'find-plans' ? (
        <FindPlansList selectedTags={selectedTags} />
      ) : activeTab === 'private-plans' ? (
        <PrivatePlansList selectedTags={selectedTags} />
      ) : activeTab === 'saved-plans' ? (
        <SavedPlansList selectedTags={selectedTags} />
      ) : (
        <MyPlansList
          mode={activeTab === 'completed-plans' ? 'completed' : 'all'}
          showSaveButton={activeTab !== 'my-plans'}
          selectedTags={selectedTags}
        />
      )}

      <TouchableOpacity
        onPress={onContribute}
        className="absolute bottom-4 right-4 flex-row items-center gap-1 rounded-full px-4 py-2">
        <Text className="text-xs font-bold text-gray-800 underline dark:text-gray-300">
          Have a plan you&apos;d like to contribute?
        </Text>
        <Ionicons name="arrow-forward" color={colorScheme === 'dark' ? '#fff' : '#000'} />
      </TouchableOpacity>
    </View>
  );
}
