import type { BibleVersionManifestEntry } from '@/src/bible/types';
import { Platform, Text, View } from 'react-native';

const colors: Record<string, string> = {
  NIV: '#47738a',
  NLT: '#9b2429',
  ESV: '#bf5835',
  NASB: '#153e69',
  CSB: '#927747',
  KJV: '#66386f',
  CUVS: '#356765',
  CUVT: '#356765',
  DRA: '#785647',
};
const palette = ['#47738a', '#66386f', '#356765', '#785647', '#153e69', '#927747'];

export default function BibleVersionCover({
  version,
  size = 'small',
}: {
  version: BibleVersionManifestEntry;
  size?: 'small' | 'large';
}) {
  const large = size === 'large';
  const label = version.shortLabel;
  const hash = [...label].reduce((sum, character) => sum + character.charCodeAt(0), 0);
  return (
    <View
      accessible={false}
      style={{
        width: large ? 84 : 46,
        height: large ? 94 : 54,
        borderRadius: large ? 13 : 8,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: colors[label.toUpperCase()] ?? palette[hash % palette.length],
        borderWidth: 1,
        borderColor: '#ffffff0d',
        paddingHorizontal: 3,
      }}>
      <Text
        numberOfLines={2}
        adjustsFontSizeToFit
        minimumFontScale={0.6}
        style={{
          color: '#fffaf4',
          textAlign: 'center',
          fontSize: large ? 28 : 17,
          fontFamily: Platform.select({ ios: 'Georgia', android: 'serif', default: 'Georgia' }),
        }}>
        {label}
      </Text>
    </View>
  );
}
