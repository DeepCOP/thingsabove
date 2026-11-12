import { useEffect, useState } from 'react';
import { Image, ImageResizeMode, LayoutChangeEvent, View } from 'react-native';

type Props = {
  uri?: string | null;
  className?: string;
  resizeMode?: ImageResizeMode;
  placeholderClassName?: string;
  fitToWidth?: boolean;
  maxHeight?: number;
};

export default function PlanCoverImage({
  uri,
  className,
  resizeMode = 'cover',
  placeholderClassName,
  fitToWidth = false,
  maxHeight,
}: Props) {
  const [imageSize, setImageSize] = useState<{ uri: string; aspectRatio: number } | null>(null);
  const [layoutWidth, setLayoutWidth] = useState(0);

  useEffect(() => {
    if (!fitToWidth || !uri) return;

    let cancelled = false;

    Image.getSize(
      uri,
      (width, height) => {
        if (
          !cancelled &&
          Number.isFinite(width) &&
          Number.isFinite(height) &&
          width > 0 &&
          height > 0
        ) {
          setImageSize({ uri, aspectRatio: width / height });
        }
      },
      () => {
        // Keep the fallback ratio if the image dimensions cannot be loaded.
      },
    );

    return () => {
      cancelled = true;
    };
  }, [fitToWidth, uri]);

  const aspectRatio = imageSize && imageSize.uri === uri ? imageSize.aspectRatio : 16 / 9;
  const heightLimit =
    maxHeight !== undefined && Number.isFinite(maxHeight) && maxHeight > 0 ? maxHeight : undefined;
  const handleLayout =
    fitToWidth && heightLimit !== undefined
      ? (event: LayoutChangeEvent) => setLayoutWidth(event.nativeEvent.layout.width)
      : undefined;

  const imageStyle = fitToWidth
    ? {
        width: '100%' as const,
        // An explicit height keeps the frame full-width when a portrait cover reaches the cap.
        aspectRatio: heightLimit === undefined ? aspectRatio : undefined,
        height:
          heightLimit === undefined
            ? undefined
            : Math.min(layoutWidth > 0 ? layoutWidth / aspectRatio : heightLimit, heightLimit),
      }
    : undefined;

  if (uri) {
    return (
      <Image
        source={{ uri }}
        className={className}
        style={imageStyle}
        onLayout={handleLayout}
        resizeMode={fitToWidth ? 'contain' : resizeMode}
      />
    );
  }

  const baseClassName = className ?? '';
  const fallbackClassName =
    placeholderClassName ?? `${baseClassName} bg-gray-300 dark:bg-neutral-800`.trim();

  return <View className={fallbackClassName} style={imageStyle} onLayout={handleLayout} />;
}
