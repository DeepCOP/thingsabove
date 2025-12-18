import { useAuth } from '@/context/AuthContext';
import {
  ExternalPathString,
  Redirect,
  RelativePathString,
  useLocalSearchParams,
} from 'expo-router';
import { View } from 'react-native';
import Account from '../../components/Account';
import Auth from '../../components/Auth';

export default function App() {
  const { session } = useAuth();
  const { redirectTo } = useLocalSearchParams<{ redirectTo?: string }>();
  console.log(redirectTo);

  if (session) {
    return <Redirect href={(redirectTo as RelativePathString | ExternalPathString) ?? '/(tabs)'} />;
  }
  return (
    <View>
      {session && session.user ? <Account key={session.user.id} session={session} /> : <Auth />}
    </View>
  );
}
