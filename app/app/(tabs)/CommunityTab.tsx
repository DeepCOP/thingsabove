import LoadingSpinner from '@/src/components/LoadingSpinner';
import PrayerEmptyState from '@/src/components/prayer/PrayerEmptyState';
import { useFriends, usePendingFriendRequests } from '@/src/hooks/useFriends';
import { useProfile } from '@/src/hooks/useProfile';
import ChurchScreen from '@/src/screens/ChurchScreen';
import FriendsScreen from '@/src/screens/FriendsScreen';
import PrayerBoardScreen from '@/src/screens/PrayerBoardScreen';
import { useAuth } from '@/src/state/AuthContext';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { useEffect, useMemo, useState } from 'react';
import { ScrollView, Text, TouchableOpacity, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type CommunitySection = 'my-church' | 'prayer-board' | 'friends';

const COMMUNITY_SECTIONS: { key: CommunitySection; label: string }[] = [
  { key: 'my-church', label: 'My Church' },
  { key: 'prayer-board', label: 'Prayer Board' },
  { key: 'friends', label: 'Friends' },
];

function isCommunitySection(value: string | undefined): value is CommunitySection {
  return value === 'my-church' || value === 'prayer-board' || value === 'friends';
}

export default function CommunityTab() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const { session } = useAuth();
  const profileQuery = useProfile(session?.user?.id);
  const friendsQuery = useFriends(session?.user?.id);
  const pendingRequestsQuery = usePendingFriendRequests(session?.user?.id);
  const { section } = useLocalSearchParams<{ section?: string | string[] }>();
  const requestedSection = useMemo(
    () => (Array.isArray(section) ? section[0] : section),
    [section],
  );

  useEffect(() => {
    if (isCommunitySection(requestedSection)) {
      setActiveSection(requestedSection);
    }
  }, [requestedSection]);

  const churchId = profileQuery.data?.church?.id;

  const [activeSection, setActiveSection] = useState<CommunitySection>(
    churchId ? 'my-church' : 'prayer-board',
  );

  const renderContent = () => {
    if (!session) {
      return (
        <View className="flex-1 justify-center px-4">
          <View className="rounded-3xl border border-gray-200 bg-white px-5 py-8 dark:border-neutral-800 dark:bg-neutral-950">
            <Text className="text-center text-2xl font-semibold text-gray-900 dark:text-white">
              Join the community
            </Text>
            <Text className="mt-3 text-center text-sm leading-6 text-gray-600 dark:text-gray-400">
              Sign in to keep up with your church and share prayer requests with people who can pray
              with you.
            </Text>

            <TouchableOpacity
              className="mt-6 rounded-full bg-black px-5 py-3 dark:bg-white"
              onPress={() => router.push('/app/signin')}>
              <Text className="text-center font-semibold text-white dark:text-black">Sign In</Text>
            </TouchableOpacity>

            <TouchableOpacity
              className="mt-3 rounded-full border border-gray-300 px-5 py-3 dark:border-neutral-700"
              onPress={() => router.push('/app/signup')}>
              <Text className="text-center font-semibold text-gray-900 dark:text-white">
                Create Account
              </Text>
            </TouchableOpacity>
          </View>
        </View>
      );
    }

    if (activeSection === 'prayer-board') {
      return <PrayerBoardScreen />;
    }

    if (activeSection === 'friends') {
      return (
        <FriendsScreen
          friends={friendsQuery.data ?? []}
          isLoading={friendsQuery.isLoading || pendingRequestsQuery.isLoading}
          pendingCount={pendingRequestsQuery.data?.length ?? 0}
          onAddFriend={() => router.push('/app/add_friend')}
          onFriendRequests={() => router.push('/app/accept_friend')}
        />
      );
    }

    if (profileQuery.isLoading) {
      return (
        <View className="flex-1 items-center justify-center bg-white dark:bg-black">
          <LoadingSpinner />
        </View>
      );
    }

    if (profileQuery.isError) {
      return (
        <ScrollView
          className="flex-1 bg-white dark:bg-black"
          contentContainerStyle={{
            paddingHorizontal: 16,
            paddingTop: 16,
            paddingBottom: insets.bottom + 24,
          }}>
          <PrayerEmptyState
            icon="alert-circle-outline"
            title="Unable to load your church"
            description="Try again in a moment to open your church community."
            ctaLabel="Try Again"
            onCta={() => profileQuery.refetch()}
          />
        </ScrollView>
      );
    }

    if (!churchId) {
      return (
        <ScrollView
          className="flex-1 bg-white dark:bg-black"
          contentContainerStyle={{
            paddingHorizontal: 16,
            paddingTop: 16,
            paddingBottom: insets.bottom + 24,
          }}>
          <PrayerEmptyState
            icon="people-outline"
            title="Add your church to unlock My Church"
            description="Link your church in Profile to follow your church community, members, and devotional activity here."
            ctaLabel="Open Profile"
            onCta={() => router.navigate('/app/(tabs)/ProfileTab')}
          />
        </ScrollView>
      );
    }

    return <ChurchScreen churchId={churchId} />;
  };

  return (
    <View className="flex-1 bg-white dark:bg-black">
      <View
        className="border-b border-gray-200 px-4 pb-4 dark:border-neutral-800"
        style={{ paddingTop: insets.top + 8 }}>
        <Text className="text-center text-lg font-semibold text-gray-900 dark:text-white">
          Community
        </Text>

        <View className="mt-4 flex-row rounded-full bg-neutral-900 p-1">
          {COMMUNITY_SECTIONS.map((item) => {
            const isActive = item.key === activeSection;

            return (
              <TouchableOpacity
                key={item.key}
                className={`flex-1 items-center justify-center rounded-full px-3 py-2 ${
                  isActive ? 'bg-white' : ''
                }`}
                onPress={() => setActiveSection(item.key)}>
                <Text
                  className={`text-center text-sm font-semibold ${
                    isActive ? 'text-black' : 'text-gray-400'
                  }`}>
                  {item.label}
                </Text>
              </TouchableOpacity>
            );
          })}
        </View>
      </View>

      {renderContent()}
    </View>
  );
}
