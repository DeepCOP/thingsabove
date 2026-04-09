import { Text, TouchableOpacity, View } from 'react-native';

type SkeletonBlockProps = {
  className: string;
};

function SkeletonBlock({ className }: SkeletonBlockProps) {
  return (
    <View className={`animate-pulse rounded-2xl bg-gray-200 dark:bg-neutral-800 ${className}`} />
  );
}

export function ChurchHeroCardSkeleton() {
  return (
    <View className="rounded-3xl border border-gray-200 bg-white p-5 dark:border-neutral-800 dark:bg-neutral-950">
      <View className="flex-row items-start justify-between gap-3">
        <View className="flex-1">
          <SkeletonBlock className="h-7 w-2/3" />
          <SkeletonBlock className="mt-3 h-4 w-1/2" />
          <SkeletonBlock className="mt-2 h-4 w-1/3" />
        </View>
        <SkeletonBlock className="h-7 w-24 rounded-full" />
      </View>
    </View>
  );
}

export function ChurchStatGridSkeleton() {
  return (
    <View className="flex-row flex-wrap gap-3">
      {[1, 2, 3, 4].map((item) => (
        <View key={item} className="w-[48%] rounded-2xl bg-gray-50 p-4 dark:bg-neutral-900">
          <SkeletonBlock className="h-3 w-20" />
          <SkeletonBlock className="mt-3 h-7 w-24" />
        </View>
      ))}
    </View>
  );
}

export function ChurchCardSkeleton({ rows = 2 }: { rows?: number }) {
  return (
    <View className="rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
      <SkeletonBlock className="h-5 w-36" />
      <View className="mt-3 gap-2">
        {Array.from({ length: rows }).map((_, index) => (
          <SkeletonBlock key={index} className="h-4 w-full" />
        ))}
      </View>
    </View>
  );
}

export function ChurchTopPlansListSkeleton() {
  return (
    <View className="rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
      <SkeletonBlock className="h-5 w-40" />
      <View className="mt-3 gap-3">
        {[1, 2, 3].map((item) => (
          <View
            key={item}
            className="flex-row items-center justify-between rounded-2xl bg-gray-50 px-4 py-3 dark:bg-neutral-900">
            <View className="flex-row items-center gap-3">
              <SkeletonBlock className="h-8 w-8 rounded-full" />
              <View>
                <SkeletonBlock className="h-4 w-36" />
                <SkeletonBlock className="mt-2 h-3 w-28" />
              </View>
            </View>
            <SkeletonBlock className="h-4 w-4" />
          </View>
        ))}
      </View>
    </View>
  );
}

export function ChurchMembersPreviewSkeleton() {
  return (
    <View className="rounded-2xl border border-gray-200 bg-white p-4 dark:border-neutral-800 dark:bg-neutral-950">
      <View className="flex-row items-center justify-between">
        <SkeletonBlock className="h-5 w-24" />
        <SkeletonBlock className="h-4 w-14" />
      </View>

      <View className="mt-4 flex-row flex-wrap gap-4">
        {[1, 2, 3, 4].map((item) => (
          <View key={item} className="items-center">
            <SkeletonBlock className="h-14 w-14 rounded-full" />
            <SkeletonBlock className="mt-2 h-3 w-10" />
          </View>
        ))}
      </View>
    </View>
  );
}

type ChurchSectionErrorCardProps = {
  title: string;
  description: string;
  onRetry?: () => void;
};

export function ChurchSectionErrorCard({
  title,
  description,
  onRetry,
}: ChurchSectionErrorCardProps) {
  return (
    <View className="rounded-2xl border border-red-200 bg-red-50 p-4 dark:border-red-950/60 dark:bg-red-950/20">
      <Text className="font-semibold text-red-800 dark:text-red-300">{title}</Text>
      <Text className="mt-1 text-sm text-red-700 dark:text-red-200">{description}</Text>
      {onRetry ? (
        <TouchableOpacity
          className="mt-4 self-start rounded-full bg-black px-4 py-2 dark:bg-white"
          onPress={onRetry}>
          <Text className="font-semibold text-white dark:text-black">Retry</Text>
        </TouchableOpacity>
      ) : null}
    </View>
  );
}
