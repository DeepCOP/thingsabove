import { useRouter } from 'expo-router';
import { ReactNode } from 'react';
import { Text, TouchableOpacity, View } from 'react-native';
import UserAvatar from './UserAvatar';

type Props = {
  uri?: string | null;
  userId?: string | null;
  first_name?: string | null;
  last_name?: string | null;
  name?: string;
  subtitle?: ReactNode;
  size?: number;
  border?: boolean;
  onPress?: () => void;
  disabled?: boolean;
  trailing?: ReactNode;
  titleAside?: ReactNode;
  className?: string;
  contentClassName?: string;
  titleRowClassName?: string;
  titleClassName?: string;
  subtitleClassName?: string;
  activeOpacity?: number;
  children?: ReactNode;
};

function joinClasses(...classNames: (string | undefined | null | false)[]) {
  return classNames.filter(Boolean).join(' ');
}

function isTextLike(value: ReactNode) {
  return typeof value === 'string' || typeof value === 'number';
}

export default function ProfileIdentityRow({
  uri,
  userId,
  first_name,
  last_name,
  name,
  subtitle,
  size = 40,
  border = true,
  onPress,
  disabled = false,
  trailing,
  titleAside,
  className,
  contentClassName,
  titleRowClassName,
  titleClassName,
  subtitleClassName,
  activeOpacity = 0.7,
  children,
}: Props) {
  const router = useRouter();
  const fallbackName = [first_name, last_name].filter(Boolean).join(' ').trim();
  const displayName = name?.trim() || fallbackName || 'Unknown user';
  const hasSubtitle = subtitle !== undefined && subtitle !== null && subtitle !== '';
  const handlePress =
    onPress ??
    (userId
      ? () => {
          router.push(`/profile/${userId}`);
        }
      : undefined);

  const content = (
    <>
      <UserAvatar
        uri={uri}
        first_name={first_name}
        last_name={last_name}
        size={size}
        border={border}
      />

      <View className={joinClasses('flex-1', contentClassName)}>
        <View className={joinClasses('flex-row items-center gap-2', titleRowClassName)}>
          <Text
            className={joinClasses(
              'text-base font-semibold text-gray-900 dark:text-white',
              titleClassName,
            )}>
            {displayName}
          </Text>
          {titleAside}
        </View>

        {hasSubtitle ? (
          isTextLike(subtitle) ? (
            <Text
              className={joinClasses(
                'mt-1 text-sm text-gray-500 dark:text-gray-400',
                subtitleClassName,
              )}>
              {subtitle}
            </Text>
          ) : (
            <View className={joinClasses('mt-1', subtitleClassName)}>{subtitle}</View>
          )
        ) : null}

        {children}
      </View>

      {trailing}
    </>
  );

  if (handlePress) {
    return (
      <TouchableOpacity
        activeOpacity={activeOpacity}
        className={joinClasses('flex-row items-center gap-3', className)}
        disabled={disabled}
        onPress={handlePress}>
        {content}
      </TouchableOpacity>
    );
  }

  return <View className={joinClasses('flex-row items-center gap-3', className)}>{content}</View>;
}
