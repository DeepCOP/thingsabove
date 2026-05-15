import { useAppStore } from '@/src/state/useAppStore';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import { useRef, useState } from 'react';
import {
  NativeScrollEvent,
  NativeSyntheticEvent,
  ScrollView,
  Text,
  TouchableOpacity,
  useColorScheme,
  useWindowDimensions,
  View,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

type OnboardingStep = {
  eyebrow: string;
  title: string;
  description: string;
  icon: keyof typeof Ionicons.glyphMap;
  bullets: string[];
};

const steps: OnboardingStep[] = [
  {
    eyebrow: 'Welcome to Things Above',
    title: 'Build a daily rhythm with Scripture.',
    description:
      'Find devotionals, follow reading plans, and return to the Word with a path that is simple to keep.',
    icon: 'book-outline',
    bullets: ['Discover plans that fit your season', 'Read Scripture alongside each devotional'],
  },
  {
    eyebrow: 'Stay on course',
    title: 'Keep your walk visible.',
    description:
      'Track your progress, return to unfinished days, and let each small act of faithfulness gather momentum.',
    icon: 'trail-sign-outline',
    bullets: ['See where you are in every plan', 'Pick up again without losing your place'],
  },
  {
    eyebrow: 'Grow together',
    title: 'Faith is steadier in community.',
    description:
      'Invite friends, pray for one another, and walk through devotionals together instead of alone.',
    icon: 'people-outline',
    bullets: ['Share plans with friends', 'Carry prayer requests with your community'],
  },
];

export default function Onboarding() {
  const router = useRouter();
  const colorScheme = useColorScheme();
  const { width } = useWindowDimensions();
  const pagerRef = useRef<ScrollView>(null);
  const completeOnboarding = useAppStore((state) => state.completeOnboarding);
  const [stepIndex, setStepIndex] = useState(0);
  const isLastStep = stepIndex === steps.length - 1;

  const finishOnboarding = () => {
    completeOnboarding();
    router.replace('/(tabs)/PlansTab');
  };

  const handlePrimaryAction = () => {
    if (isLastStep) {
      finishOnboarding();
      return;
    }

    const nextStepIndex = stepIndex + 1;
    setStepIndex(nextStepIndex);
    pagerRef.current?.scrollTo({ x: width * nextStepIndex, animated: true });
  };

  const handleMomentumScrollEnd = (event: NativeSyntheticEvent<NativeScrollEvent>) => {
    const nextStepIndex = Math.round(event.nativeEvent.contentOffset.x / width);
    setStepIndex(nextStepIndex);
  };

  return (
    <SafeAreaView className="flex-1 bg-white dark:bg-black">
      <View className="absolute -left-16 top-24 h-40 w-40 rounded-full bg-slate-100 dark:bg-neutral-900" />
      <View className="absolute -right-12 bottom-28 h-36 w-36 rounded-full bg-slate-100 dark:bg-neutral-900" />

      <View className="flex-1 py-4">
        <View className="flex-row items-center justify-between px-6">
          <Text className="text-sm font-semibold text-gray-500 dark:text-gray-400">
            {stepIndex + 1} of {steps.length}
          </Text>
          <TouchableOpacity onPress={finishOnboarding} accessibilityRole="button">
            <Text className="text-sm font-semibold text-gray-500 dark:text-gray-400">Skip</Text>
          </TouchableOpacity>
        </View>

        <ScrollView
          ref={pagerRef}
          horizontal
          pagingEnabled
          showsHorizontalScrollIndicator={false}
          onMomentumScrollEnd={handleMomentumScrollEnd}
          scrollEventThrottle={16}
          className="flex-1">
          {steps.map((step) => (
            <View key={step.title} style={{ width }} className="items-center justify-center px-6">
              <View className="mb-8 h-28 w-28 items-center justify-center rounded-full border border-gray-200 bg-white dark:border-neutral-800 dark:bg-neutral-950">
                <Ionicons
                  name={step.icon}
                  size={48}
                  color={colorScheme === 'dark' ? '#fff' : '#0F0D23'}
                />
              </View>

              <Text className="mb-3 text-center text-sm font-semibold uppercase tracking-[2px] text-gray-500 dark:text-gray-400">
                {step.eyebrow}
              </Text>
              <Text className="mb-4 text-center font-MerriWeather700Bold text-3xl leading-10 text-gray-900 dark:text-white">
                {step.title}
              </Text>
              <Text className="max-w-sm text-center text-base leading-7 text-gray-600 dark:text-gray-300">
                {step.description}
              </Text>

              <View className="mt-8 w-full max-w-sm gap-3">
                {step.bullets.map((bullet) => (
                  <View
                    key={bullet}
                    className="flex-row items-center rounded-2xl border border-gray-200 bg-white px-4 py-3 dark:border-neutral-800 dark:bg-neutral-950">
                    <View className="mr-3 h-8 w-8 items-center justify-center rounded-full bg-black dark:bg-white">
                      <Ionicons
                        name="checkmark"
                        size={18}
                        color={colorScheme === 'dark' ? '#000' : '#fff'}
                      />
                    </View>
                    <Text className="flex-1 text-sm font-semibold text-gray-800 dark:text-gray-100">
                      {bullet}
                    </Text>
                  </View>
                ))}
              </View>
            </View>
          ))}
        </ScrollView>

        <View className="px-6">
          <View className="mb-6 flex-row justify-center gap-2">
            {steps.map((step, index) => (
              <View
                key={step.title}
                className={`h-2 rounded-full ${
                  index === stepIndex
                    ? 'w-8 bg-black dark:bg-white'
                    : 'w-2 bg-gray-300 dark:bg-neutral-700'
                }`}
              />
            ))}
          </View>

          <TouchableOpacity
            className="rounded-2xl bg-black px-5 py-4 dark:bg-white"
            onPress={handlePrimaryAction}
            accessibilityRole="button">
            <Text className="text-center text-base font-bold text-white dark:text-black">
              {isLastStep ? 'Get Started' : 'Next'}
            </Text>
          </TouchableOpacity>
        </View>
      </View>
    </SafeAreaView>
  );
}
