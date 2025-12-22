import { supabase } from '@/api/supabase';
import { Input } from '@rneui/themed';
import { useState } from 'react';
import { Alert, Text, TouchableOpacity, View } from 'react-native';

export default function SignUp() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [loading, setLoading] = useState(false);

  async function signUp() {
    setLoading(true);
    const { error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          first_name: firstName,
          last_name: lastName,
        },
      },
    });
    if (error) Alert.alert(error.message);
    setLoading(false);
  }

  return (
    <View className="flex-1 justify-center px-6">
      <Input label="First Name" value={firstName} onChangeText={setFirstName} />
      <Input label="Last Name" value={lastName} onChangeText={setLastName} />
      <Input label="Email" value={email} onChangeText={setEmail} />
      <Input label="Password" secureTextEntry value={password} onChangeText={setPassword} />

      <TouchableOpacity
        className="bg-indigo-700 p-3 rounded-lg mt-4"
        onPress={signUp}
        disabled={loading}>
        <Text className="text-white text-center font-bold">Sign Up</Text>
      </TouchableOpacity>
    </View>
  );
}
