import { ScrollView, View } from 'react-native';
import DaysPicker from '../DaysPicker';

type Props = {
  days: any[];
  selectedDay: number | null;
  currentDayId?: string;
  completedDays: number[];
  startDate: string;
  onSelectDay: (day: number) => void;
};

export function DaysCarousel({
  days,
  selectedDay,
  currentDayId,
  completedDays,
  startDate,
  onSelectDay,
}: Props) {
  return (
    <ScrollView horizontal showsHorizontalScrollIndicator={false} className="mb-5">
      <View className="flex-row gap-3 px-4">
        {days.map((d) => (
          <DaysPicker
            key={d.id}
            isActive={d.day_number === selectedDay}
            isCurrentDay={currentDayId === d.id}
            completed={completedDays.includes(d.day_number)}
            day_number={d.day_number}
            startDate={startDate}
            setSelectedDayNumber={onSelectDay}
          />
        ))}
      </View>
    </ScrollView>
  );
}
