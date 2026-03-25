import type { ReactNode } from 'react';
import { Text } from 'react-native';

export default function FormRestrictionText({
  children,
  className,
}: {
  children: ReactNode;
  className?: string;
}) {
  const baseClassName = 'px-3 text-xs text-gray-500 dark:text-gray-400';

  return <Text className={`${baseClassName} ${className ?? ''}`.trim()}>{children}</Text>;
}
