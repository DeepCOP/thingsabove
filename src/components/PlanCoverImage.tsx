import { Image, ImageResizeMode, View } from 'react-native';

type Props = {
  uri?: string | null;
  className?: string;
  resizeMode?: ImageResizeMode;
  placeholderClassName?: string;
};

export default function PlanCoverImage({
  uri,
  className,
  resizeMode = 'cover',
  placeholderClassName,
}: Props) {
  if (uri) {
    return <Image source={{ uri }} className={className} resizeMode={resizeMode} />;
  }

  const baseClassName = className ?? '';
  const fallbackClassName =
    placeholderClassName ?? `${baseClassName} bg-gray-300 dark:bg-neutral-800`.trim();

  return <View className={fallbackClassName} />;
}
