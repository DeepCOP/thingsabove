import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { LayoutChangeEvent, ScrollView, View } from 'react-native';
import DaysPicker from '../DaysPicker';

type Props = {
  days: any[];
  selectedDay: number | null;
  currentDayId?: string;
  completedDays: number[];
  startDate: string;
  onSelectDay: (day: number) => void;
};

type DayLayout = {
  width: number;
  x: number;
};

export function DaysCarousel({
  days,
  selectedDay,
  currentDayId,
  completedDays,
  startDate,
  onSelectDay,
}: Props) {
  const scrollViewRef = useRef<ScrollView>(null);
  const itemLayoutsRef = useRef<Record<string, DayLayout>>({});
  const [viewportWidth, setViewportWidth] = useState(0);
  const [contentWidth, setContentWidth] = useState(0);
  const [targetLayoutVersion, setTargetLayoutVersion] = useState(0);

  const selectedDayId = useMemo(
    () => days.find((day) => day.day_number === selectedDay)?.id,
    [days, selectedDay],
  );
  const targetDayId = currentDayId || selectedDayId;

  const handleViewportLayout = useCallback((event: LayoutChangeEvent) => {
    const nextWidth = event.nativeEvent.layout.width;

    setViewportWidth((previousWidth) =>
      Math.abs(previousWidth - nextWidth) < 1 ? previousWidth : nextWidth,
    );
  }, []);

  const handleContentSizeChange = useCallback((width: number) => {
    setContentWidth((previousWidth) =>
      Math.abs(previousWidth - width) < 1 ? previousWidth : width,
    );
  }, []);

  const handleDayLayout = useCallback(
    (dayId: string, event: LayoutChangeEvent) => {
      const { width, x } = event.nativeEvent.layout;
      const previousLayout = itemLayoutsRef.current[dayId];

      if (
        previousLayout &&
        Math.abs(previousLayout.width - width) < 1 &&
        Math.abs(previousLayout.x - x) < 1
      ) {
        return;
      }

      itemLayoutsRef.current[dayId] = { width, x };

      if (dayId === targetDayId) {
        setTargetLayoutVersion((version) => version + 1);
      }
    },
    [targetDayId],
  );

  useEffect(() => {
    if (!targetDayId || viewportWidth <= 0) {
      return;
    }

    const targetLayout = itemLayoutsRef.current[targetDayId];
    if (!targetLayout) {
      return;
    }

    const centeredOffset = targetLayout.x + targetLayout.width / 2 - viewportWidth / 2;
    const maxOffset = Math.max(contentWidth - viewportWidth, 0);
    const x = Math.max(0, Math.min(centeredOffset, maxOffset));
    const animationFrame = requestAnimationFrame(() => {
      scrollViewRef.current?.scrollTo({ x, animated: true });
    });

    return () => cancelAnimationFrame(animationFrame);
  }, [contentWidth, targetDayId, targetLayoutVersion, viewportWidth]);

  return (
    <ScrollView
      ref={scrollViewRef}
      horizontal
      showsHorizontalScrollIndicator={false}
      className="mb-5"
      onLayout={handleViewportLayout}
      onContentSizeChange={handleContentSizeChange}>
      <View className="flex-row gap-3 px-4">
        {days.map((d) => (
          <View key={d.id} onLayout={(event) => handleDayLayout(d.id, event)}>
            <DaysPicker
              isActive={d.day_number === selectedDay}
              isCurrentDay={currentDayId === d.id}
              completed={completedDays.includes(d.day_number)}
              day_number={d.day_number}
              startDate={startDate}
              setSelectedDayNumber={onSelectDay}
            />
          </View>
        ))}
      </View>
    </ScrollView>
  );
}
