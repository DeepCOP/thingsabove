import { Text, TouchableOpacity, View } from 'react-native';

type Tab = {
  key: string;
  label: string;
};

type Props = {
  activeTab: string;
  onChange: (key: 'my-plans' | 'saved-plans' | 'completed-plans' | 'find-plans') => void;
};

const tabs: Tab[] = [
  { key: 'my-plans', label: 'My Plans' },
  { key: 'find-plans', label: 'Find Plans' },
  { key: 'saved-plans', label: 'Saved' },
  { key: 'completed-plans', label: 'Completed' },
];

export function MyPlansToggle({ activeTab, onChange }: Props) {
  return (
    <View className="flex-row bg-neutral-900 rounded-full p-1 mb-4">
      {tabs.map((tab) => {
        const isActive = activeTab === tab.key;

        return (
          <TouchableOpacity
            key={tab.key}
            onPress={() =>
              onChange(tab.key as 'my-plans' | 'saved-plans' | 'completed-plans' | 'find-plans')
            }
            className={`flex-1 rounded-full items-center justify-center px-1 py-2 ${
              isActive ? 'bg-white' : ''
            }`}>
            <Text
              className={`font-semibold text-sm text-center ${
                isActive ? 'text-black' : 'text-gray-400'
              }`}>
              {tab.label}
            </Text>
          </TouchableOpacity>
        );
      })}
    </View>
  );
}
