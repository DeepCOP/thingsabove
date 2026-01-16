import Dropdown from '@/src/components/DropDown';
import { MyPlansToggle } from '@/src/components/MyPlansToggle';
import { Ionicons } from '@expo/vector-icons';
import { Text, TouchableOpacity, useColorScheme, View } from 'react-native';
import FindPlansList from '../components/plansList/FindPlansList';
import MyPlansList from '../components/plansList/MyPlansList';

type Props = {
  isGrid: boolean;
  sort: 'Recent' | 'Trending';
  activeTab: 'my-plans' | 'find-plans';
  isAuthenticated: boolean;
  onToggleGrid: () => void;
  onChangeTab: (tab: 'my-plans' | 'find-plans') => void;
  onChangeSort: (sort: 'Recent' | 'Trending') => void;
  onSearch: () => void;
  onLogin: () => void;
};

export default function PlansScreen({
  isGrid,
  sort,
  activeTab,
  isAuthenticated,
  onToggleGrid,
  onChangeTab,
  onChangeSort,
  onSearch,
  onLogin,
}: Props) {
  const colorScheme = useColorScheme();

  return (
    <View className="flex-1 bg-gray-100 dark:bg-black px-4 pt-12">
      {/* Header */}
      <View className="flex-row justify-between items-center mb-4">
        <TouchableOpacity onPress={onToggleGrid}>
          <Ionicons
            name={isGrid ? 'list-outline' : 'grid-outline'}
            size={24}
            color={colorScheme === 'dark' ? '#fff' : '#222'}
          />
        </TouchableOpacity>

        <View className="flex-row items-center gap-4">
          <Ionicons
            name="search"
            size={22}
            color={colorScheme === 'dark' ? '#fff' : '#222'}
            onPress={onSearch}
          />
          <Ionicons
            name="settings-outline"
            size={22}
            color={colorScheme === 'dark' ? '#fff' : '#222'}
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

      {activeTab === 'my-plans' ? <MyPlansList /> : <FindPlansList />}
    </View>
  );
}
