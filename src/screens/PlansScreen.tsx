import Dropdown from '@/src/components/DropDown';
import { MyPlansToggle } from '@/src/components/MyPlansToggle';
import Ionicons from '@expo/vector-icons/Ionicons';
import { Text, TouchableOpacity, useColorScheme, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import FindPlansList from '../components/plansList/FindPlansList';
import MyPlansList from '../components/plansList/MyPlansList';
import SavedPlansList from '../components/plansList/SavedPlansList';

type Props = {
  isGrid: boolean;
  sort: 'Recent' | 'Trending';
  activeTab: 'my-plans' | 'saved-plans' | 'completed-plans' | 'find-plans';
  isAuthenticated: boolean;
  notificationCount?: number;
  onToggleGrid: () => void;
  onChangeTab: (tab: 'my-plans' | 'saved-plans' | 'completed-plans' | 'find-plans') => void;
  onChangeSort: (sort: 'Recent' | 'Trending') => void;
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
  notificationCount = 0,
  onToggleGrid,
  onChangeTab,
  onChangeSort,
  onSearch,
  onNotifications,
  onPrayerBoard,
  onLogin,
  onContribute,
}: Props) {
  const colorScheme = useColorScheme();
  const insets = useSafeAreaInsets();

  return (
    <View className="flex-1 bg-gray-100 dark:bg-black px-4">
      {/* Header */}
      <View
        className="flex-row justify-between items-center mb-4"
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
              <Ionicons
                name="heart-outline"
                size={22}
                color={colorScheme === 'dark' ? '#fff' : '#222'}
              />
            </TouchableOpacity>
          )}
          {isAuthenticated && (
            <TouchableOpacity onPress={onNotifications} className="relative">
              {notificationCount > 0 && (
                <View
                  className="absolute -top-2 -right-2 min-w-[16px] h-4 rounded-full items-center justify-center px-1"
                  style={{ backgroundColor: '#ef4444' }}>
                  <Text className="text-[10px] leading-none text-white font-bold">
                    {notificationCount > 99 ? '99+' : notificationCount}
                  </Text>
                </View>
              )}
              <Ionicons
                name="notifications-outline"
                size={22}
                color={colorScheme === 'dark' ? '#fff' : '#222'}
              />
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

      <View className="flex-row items-center mb-3">
        <Text className="text-gray-700 dark:text-gray-200 mr-2">Sort by:</Text>
        <Dropdown
          value={sort}
          onChange={(v) => onChangeSort(v as 'Recent' | 'Trending')}
          options={['Recent', 'Trending']}
        />
      </View>

      {activeTab === 'find-plans' ? (
        <FindPlansList />
      ) : activeTab === 'saved-plans' ? (
        <SavedPlansList />
      ) : (
        <MyPlansList mode={activeTab === 'completed-plans' ? 'completed' : 'all'} />
      )}

      <TouchableOpacity
        onPress={onContribute}
        className="absolute bottom-4 right-4 flex-row items-center gap-1  px-4 py-2 rounded-full">
        <Text className="text-xs font-bold text-gray-800 dark:text-gray-300  underline">
          Have a plan you&apos;d like to contribute?
        </Text>
        <Ionicons name="arrow-forward" color={colorScheme === 'dark' ? '#fff' : '#000'} />
      </TouchableOpacity>
    </View>
  );
}
