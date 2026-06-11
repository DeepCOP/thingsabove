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
  const hasCenteredCurrentDayRef = useRef(false);
  const [viewportWidth, setViewportWidth] = useState(0);
  const [carouselWidth, setCarouselWidth] = useState(0);
  const [measuredDaysCount, setMeasuredDaysCount] = useState(0);

  const daysLayoutKey = useMemo(() => days.map((day) => day.id).join('|'), [days]);
  const targetDayId = currentDayId;

  const handleViewportLayout = useCallback((event: LayoutChangeEvent) => {
    const nextWidth = event.nativeEvent.layout.width;

    setViewportWidth((previousWidth) =>
      Math.abs(previousWidth - nextWidth) < 1 ? previousWidth : nextWidth,
    );
  }, []);

  const handleCarouselSizeChange = useCallback((width: number) => {
    setCarouselWidth((previousWidth) =>
      Math.abs(previousWidth - width) < 1 ? previousWidth : width,
    );
  }, []);

  const updateMeasuredDaysCount = useCallback(() => {
    setMeasuredDaysCount(
      days.reduce((count, day) => (itemLayoutsRef.current[day.id] ? count + 1 : count), 0),
    );
  }, [days]);

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
      updateMeasuredDaysCount();
    },
    [updateMeasuredDaysCount],
  );

  useEffect(() => {
    updateMeasuredDaysCount();
  }, [updateMeasuredDaysCount]);

  useEffect(() => {
    itemLayoutsRef.current = {};
    setMeasuredDaysCount(0);
    hasCenteredCurrentDayRef.current = false;
  }, [currentDayId, daysLayoutKey]);

  const centerCurrentDay = useCallback(() => {
    const hasMeasuredAllDays =
      measuredDaysCount >= days.length &&
      days.length > 0 &&
      days.every((day) => itemLayoutsRef.current[day.id]);

    if (currentDayId && hasCenteredCurrentDayRef.current) {
      return;
    }

    if (!targetDayId || viewportWidth <= 0 || carouselWidth <= 0 || !hasMeasuredAllDays) {
      return;
    }

    const targetLayout = itemLayoutsRef.current[targetDayId];
    if (!targetLayout) {
      return;
    }

    const centeredOffset = targetLayout.x + targetLayout.width / 2 - viewportWidth / 2;
    const maxOffset = Math.max(carouselWidth - viewportWidth, 0);
    const x = Math.max(0, Math.min(centeredOffset, maxOffset));
    const animationFrame = requestAnimationFrame(() => {
      scrollViewRef.current?.scrollTo({ x, animated: true });

      if (currentDayId) {
        hasCenteredCurrentDayRef.current = true;
      }
    });

    return () => cancelAnimationFrame(animationFrame);
  }, [carouselWidth, currentDayId, days, measuredDaysCount, targetDayId, viewportWidth]);

  useEffect(() => centerCurrentDay(), [centerCurrentDay]);

  return (
    <ScrollView
      ref={scrollViewRef}
      horizontal
      showsHorizontalScrollIndicator={false}
      className="mb-5"
      onLayout={handleViewportLayout}
      onContentSizeChange={handleCarouselSizeChange}>
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
