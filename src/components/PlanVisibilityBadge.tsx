import Ionicons from '@expo/vector-icons/Ionicons';
import { Text, View } from 'react-native';

type Props = {
  visibility?: string | null;
  className?: string;
  textClassName?: string;
  iconSize?: number;
};

export default function PlanVisibilityBadge({
  visibility,
  className = '',
  textClassName = '',
  iconSize = 12,
}: Props) {
  if (visibility !== 'private') {
    return null;
  }

  return (
    <View
      className={[
        'shrink-0 flex-row items-center gap-1 rounded-full bg-amber-100 px-2 py-1 dark:bg-amber-900/40',
        className,
      ]
        .filter(Boolean)
        .join(' ')}>
      <Ionicons name="lock-closed" size={iconSize} color="#b45309" />
      <Text
        className={['text-[10px] font-semibold text-amber-700 dark:text-amber-200', textClassName]
          .filter(Boolean)
          .join(' ')}>
        Invite Only
      </Text>
    </View>
  );
}
