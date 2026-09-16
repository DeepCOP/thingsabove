import { Link } from 'expo-router';
import { Text, View } from 'react-native';

export default function BibleAttribution({
  copyright,
  attributionUrl,
}: {
  copyright?: string;
  attributionUrl?: string;
}) {
  if (!copyright) return null;
  return (
    <View className="my-4">
      <Text className="text-xs leading-5 text-gray-500 dark:text-gray-400">{copyright}</Text>
      {attributionUrl === 'https://www.esv.org/' ? (
        <Link
          href="https://www.esv.org/"
          target="_blank"
          rel="noopener noreferrer"
          className="mt-1 text-xs text-blue-600 underline dark:text-blue-400">
          ESV.org
        </Link>
      ) : attributionUrl === 'https://docs.api.bible/' ? (
        <Link
          href="https://docs.api.bible/"
          target="_blank"
          rel="noopener noreferrer"
          className="mt-1 text-xs text-blue-600 underline dark:text-blue-400">
          API.Bible
        </Link>
      ) : null}
    </View>
  );
}
