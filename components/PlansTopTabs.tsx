import { Text, TouchableOpacity, View } from 'react-native';

type Tab = {
  key: string;
  label: string;
};

type Props = {
  activeTab: string;
  onChange: (key: 'my-plans' | 'find-plans') => void;
};

const tabs: Tab[] = [
  { key: 'my-plans', label: 'My Plans' },
  { key: 'find-plans', label: 'Find Plans' },
];

export function PlansTopTabs({ activeTab, onChange }: Props) {
  return (
    <View className="flex-row bg-neutral-900 rounded-full p-1 mb-4">
      {tabs.map((tab) => {
        const isActive = activeTab === tab.key;

        return (
          <TouchableOpacity
            key={tab.key}
            onPress={() => onChange(tab.key as 'my-plans' | 'find-plans')}
            className={`px-5 py-2 rounded-full ${isActive ? 'bg-white' : ''}`}>
            <Text className={`font-semibold ${isActive ? 'text-black' : 'text-gray-400'}`}>
              {tab.label}
            </Text>
          </TouchableOpacity>
        );
      })}
    </View>
  );
}
