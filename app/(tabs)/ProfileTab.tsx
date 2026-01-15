import { useAuth } from '@/src/state/AuthContext';
import { View } from 'react-native';
import Account from '../../src/components/Account';
import Auth from '../../src/components/Auth';

export default function App() {
  const { session } = useAuth();
  return (
    <View>
      {session && session.user ? <Account key={session.user.id} session={session} /> : <Auth />}
    </View>
  );
}
