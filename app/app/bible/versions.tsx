import BibleVersionDetails from '@/src/components/BibleVersionDetails';
import BibleVersionsScreen from '@/src/screens/BibleVersionsScreen';
import Ionicons from '@expo/vector-icons/Ionicons';
import { Stack, useFocusEffect, useRouter } from 'expo-router';
import { useCallback, useState } from 'react';
import {
  BackHandler,
  Keyboard,
  Modal,
  Pressable,
  StyleSheet,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

type VersionsView = { name: 'library' | 'catalog' } | { name: 'details'; versionId: string };

export default function BibleVersionsRoute() {
  const router = useRouter();
  const insets = useSafeAreaInsets();
  const dark = useColorScheme() === 'dark';
  const [views, setViews] = useState<VersionsView[]>([{ name: 'library' }]);
  const [isInfoVisible, setIsInfoVisible] = useState(false);
  const current = views[views.length - 1];
  const listMode = views.some((view) => view.name === 'catalog') ? 'catalog' : 'library';
  const background = dark ? '#090b0d' : '#ffffff';
  const foreground = dark ? '#f6f7f9' : '#17202e';
  const secondary = dark ? '#a8adb7' : '#626b79';
  const leave = useCallback(() => {
    if (router.canGoBack()) router.back();
    else router.replace('/app/(tabs)/BibleTab');
  }, [router]);
  const goBack = useCallback(() => {
    Keyboard.dismiss();
    if (views.length > 1)
      setViews((previous) => (previous.length > 1 ? previous.slice(0, -1) : previous));
    else leave();
  }, [leave, views.length]);
  useFocusEffect(
    useCallback(() => {
      const subscription = BackHandler.addEventListener('hardwareBackPress', () => {
        if (views.length <= 1) return false;
        goBack();
        return true;
      });
      return () => subscription.remove();
    }, [goBack, views.length]),
  );

  return (
    <View
      style={[
        styles.page,
        { backgroundColor: background, paddingTop: insets.top, paddingBottom: insets.bottom },
      ]}>
      <Stack.Screen options={{ headerShown: false, gestureEnabled: views.length === 1 }} />
      <View style={styles.frame}>
        <View style={styles.header}>
          <TouchableOpacity
            accessibilityRole="button"
            accessibilityLabel="Back"
            onPress={goBack}
            style={styles.headerButton}>
            <Ionicons name="chevron-back" size={29} color={foreground} />
          </TouchableOpacity>
          <Text accessibilityRole="header" style={[styles.title, { color: foreground }]}>
            {current.name === 'library'
              ? 'My Bible Versions'
              : current.name === 'catalog'
                ? 'Add Bible Version'
                : 'Version Details'}
          </Text>
          <View style={styles.headerButton}>
            {current.name === 'library' ? (
              <TouchableOpacity
                accessibilityRole="button"
                accessibilityLabel="About Bible versions"
                onPress={() => setIsInfoVisible(true)}
                style={styles.headerButton}>
                <Ionicons name="information-circle-outline" size={26} color={foreground} />
              </TouchableOpacity>
            ) : null}
          </View>
        </View>
        <View style={[styles.body, current.name === 'details' && styles.hidden]}>
          <BibleVersionsScreen
            mode={listMode}
            onAddPress={() => setViews([{ name: 'library' }, { name: 'catalog' }])}
            onVersionPress={(versionId) => {
              Keyboard.dismiss();
              setViews((previous) =>
                previous[previous.length - 1].name === 'details'
                  ? previous
                  : [...previous, { name: 'details', versionId }],
              );
            }}
            onRead={leave}
          />
        </View>
        {current.name === 'details' ? (
          <BibleVersionDetails
            key={current.versionId}
            versionId={current.versionId}
            onRemoved={goBack}
            onRead={leave}
          />
        ) : null}
      </View>
      <Modal
        visible={isInfoVisible}
        transparent
        animationType="fade"
        onRequestClose={() => setIsInfoVisible(false)}>
        <Pressable style={styles.scrim} onPress={() => setIsInfoVisible(false)}>
          <Pressable
            style={[styles.info, { backgroundColor: dark ? '#151719' : '#ffffff' }]}
            onPress={(event) => event.stopPropagation()}>
            <View style={styles.infoHeader}>
              <Text style={[styles.infoTitle, { color: foreground }]}>About Bible Versions</Text>
              <TouchableOpacity
                accessibilityRole="button"
                accessibilityLabel="Close version info"
                onPress={() => setIsInfoVisible(false)}
                style={styles.headerButton}>
                <Ionicons name="close" size={23} color={secondary} />
              </TouchableOpacity>
            </View>
            <Text style={[styles.infoText, { color: secondary }]}>
              Keep the translations you use in My Bible Versions. Downloaded versions work offline,
              and online versions stream text when you read. Adding a version saves it to your
              library; select Read this version to use it in the reader.
            </Text>
            <Text style={[styles.infoText, { color: secondary }]}>
              Different translations use different wording to convey the original text. Choose the
              version that helps you understand it best. Your highlights and notes stay connected to
              their Scripture references.
            </Text>
          </Pressable>
        </Pressable>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  page: { flex: 1 },
  frame: { flex: 1, width: '100%', maxWidth: 680, alignSelf: 'center' },
  header: {
    minHeight: 65,
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 9,
    paddingBottom: 5,
  },
  headerButton: { width: 44, height: 44, alignItems: 'center', justifyContent: 'center' },
  title: { flex: 1, fontSize: 20, fontWeight: '600', textAlign: 'center' },
  body: { flex: 1 },
  hidden: { display: 'none' },
  scrim: {
    flex: 1,
    backgroundColor: '#00000099',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 24,
  },
  info: { width: '100%', maxWidth: 440, borderRadius: 22, padding: 20 },
  infoHeader: { flexDirection: 'row', alignItems: 'center' },
  infoTitle: { flex: 1, fontSize: 19, fontWeight: '600' },
  infoText: { fontSize: 15, lineHeight: 23, marginTop: 12 },
});
