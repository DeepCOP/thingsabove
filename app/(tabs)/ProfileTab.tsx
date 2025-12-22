import { useAuth } from '@/context/AuthContext';
import { View } from 'react-native';
import Account from '../../components/Account';
import Auth from '../../components/Auth';

export default function App() {
  const { session } = useAuth();
  return (
    <View>
      {session && session.user ? <Account key={session.user.id} session={session} /> : <Auth />}
    </View>
  );
}
