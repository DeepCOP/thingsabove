import { BIBLE_SOURCE_LABELS } from '@/src/bible/sources';
import { localizeBibleError } from '@/src/bible/versionPresentation';
import BibleAttribution from '@/src/components/BibleAttribution';
import BibleVersionCover from '@/src/components/BibleVersionCover';
import { formatBibleVersionSize } from '@/src/lib/bibleVersionService';
import { useBible } from '@/src/state/BibleContext';
import Ionicons from '@expo/vector-icons/Ionicons';
import { useNetInfo } from '@react-native-community/netinfo';
import { useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  ActivityIndicator,
  Linking,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';

type BibleVersionDetailsProps = {
  versionId: string;
  onRemoved: () => void;
  onRead: () => void;
};

export default function BibleVersionDetails({
  versionId,
  onRemoved,
  onRead,
}: BibleVersionDetailsProps) {
  const { t, i18n } = useTranslation('bible');
  const {
    versions,
    addVersion,
    removeVersion,
    setVersion,
    loadingVersionId,
    loadVersionAttribution,
  } = useBible();
  const entry = versions.find((version) => version.id === versionId);
  const entryId = entry?.id;
  const entryCopyright = entry?.copyright;

  useEffect(() => {
    if (!entryId || entryCopyright) return;
    void loadVersionAttribution(entryId).catch(() => undefined);
  }, [entryCopyright, entryId, loadVersionAttribution]);

  const dark = useColorScheme() === 'dark';
  const { isConnected, isInternetReachable } = useNetInfo();
  const isOffline = isConnected === false || isInternetReachable === false;
  const [action, setAction] = useState<'add' | 'remove' | 'read' | 'link' | null>(null);
  const [error, setError] = useState<string | null>(null);
  const actionInProgress = useRef(false);
  const mounted = useRef(true);
  useEffect(() => {
    mounted.current = true;
    return () => {
      mounted.current = false;
    };
  }, []);
  const colors = {
    background: dark ? '#090b0d' : '#ffffff',
    card: dark ? '#151719' : '#f5f6f8',
    border: dark ? '#2b2d31' : '#dce0e6',
    outline: dark ? '#7b8595' : '#9aa3b0',
    text: dark ? '#f6f7f9' : '#17202e',
    secondary: dark ? '#a8adb7' : '#626b79',
    blue: '#2375f5',
    error: dark ? '#fca5a5' : '#b91c1c',
  };

  const performAction = async (
    nextAction: NonNullable<typeof action>,
    operation: () => Promise<void>,
    onSuccess?: () => void,
  ) => {
    if (actionInProgress.current) return;
    actionInProgress.current = true;
    setAction(nextAction);
    setError(null);
    try {
      await operation();
      if (mounted.current) onSuccess?.();
    } catch (cause) {
      if (mounted.current) setError(cause instanceof Error ? cause.message : t('pleaseTryAgain'));
    } finally {
      actionInProgress.current = false;
      if (mounted.current) setAction(null);
    }
  };

  if (!entry) {
    return (
      <View style={[styles.unavailable, { backgroundColor: colors.background }]}>
        <Ionicons name="book-outline" size={36} color={colors.secondary} />
        <Text style={[styles.sectionTitle, { color: colors.text }]}>{t('unavailableTitle')}</Text>
        <Text style={[styles.body, { color: colors.secondary, textAlign: 'center' }]}>
          {t('unavailableDescription')}
        </Text>
      </View>
    );
  }

  const provider = BIBLE_SOURCE_LABELS[entry.source ?? 'offline'];
  const busy = Boolean(action) || entry.isDownloading || loadingVersionId === entry.id;
  const addDisabled = entry.isAdded || busy || (isOffline && !entry.isOnline);
  const readDisabled = busy || (isOffline && entry.isOnline);
  const learnMoreUrl =
    entry.source === 'youversion' && /^\d+$/.test(entry.providerBibleId ?? '')
      ? `https://www.bible.com/versions/${entry.providerBibleId}`
      : entry.source === 'esv'
        ? 'https://www.esv.org/'
        : entry.source === 'apiBible'
          ? 'https://docs.api.bible/'
          : null;

  return (
    <ScrollView
      style={{ flex: 1, backgroundColor: colors.background }}
      contentContainerStyle={styles.content}
      showsVerticalScrollIndicator={false}>
      <View style={styles.summary}>
        <BibleVersionCover version={entry} size="large" />
        <View style={styles.summaryText}>
          <Text style={[styles.versionTitle, { color: colors.text }]}>{entry.label}</Text>
          <Text style={[styles.subtitle, { color: colors.secondary }]}>{entry.shortLabel}</Text>
          <Text style={[styles.subtitle, { color: colors.secondary }]}>
            {entry.isOnline
              ? t('providedBy', { provider })
              : entry.isInstalled
                ? t('storedOnDevice')
                : t('availableDownload')}
          </Text>
          <View style={styles.status}>
            <Ionicons
              name={entry.isOnline ? 'globe-outline' : 'download-outline'}
              size={22}
              color={colors.blue}
            />
            <Text style={[styles.subtitle, { color: colors.blue }]}>
              {t(entry.isOnline ? 'online' : entry.isInstalled ? 'downloaded' : 'offlineReading')}
            </Text>
          </View>
        </View>
      </View>

      <TouchableOpacity
        accessibilityRole="button"
        accessibilityState={{
          disabled: addDisabled,
          busy: action === 'add' || entry.isDownloading,
        }}
        disabled={addDisabled}
        activeOpacity={0.8}
        onPress={() => void performAction('add', () => addVersion(entry.id))}
        style={[
          styles.button,
          styles.addButton,
          { backgroundColor: colors.blue, opacity: addDisabled && !entry.isAdded ? 0.5 : 1 },
        ]}>
        {action === 'add' || entry.isDownloading ? (
          <ActivityIndicator size="small" color="#ffffff" />
        ) : (
          <Ionicons name={entry.isAdded ? 'checkmark' : 'add'} size={24} color="#ffffff" />
        )}
        <Text style={[styles.buttonText, { color: '#ffffff' }]}>
          {action === 'add' || entry.isDownloading
            ? entry.isOnline
              ? t('addingVersion')
              : t('downloading')
            : entry.isAdded
              ? t('addedToLibrary')
              : entry.isOnline
                ? t('addToLibrary')
                : t('downloadAndAdd')}
        </Text>
      </TouchableOpacity>

      {entry.isAdded ? (
        <TouchableOpacity
          accessibilityRole="button"
          accessibilityState={{ disabled: readDisabled, busy: action === 'read' }}
          disabled={readDisabled}
          activeOpacity={0.8}
          onPress={() => void performAction('read', () => setVersion(entry.id), onRead)}
          style={[
            styles.button,
            styles.readButton,
            {
              backgroundColor: colors.card,
              borderColor: colors.border,
              opacity: readDisabled ? 0.5 : 1,
            },
          ]}>
          {action === 'read' || loadingVersionId === entry.id ? (
            <ActivityIndicator size="small" color={colors.blue} />
          ) : (
            <Ionicons name="book-outline" size={22} color={colors.blue} />
          )}
          <Text style={[styles.buttonText, { color: colors.text }]}>{t('readVersion')}</Text>
        </TouchableOpacity>
      ) : null}

      {isOffline && (entry.isOnline || !entry.isInstalled) ? (
        <View style={[styles.feedback, { backgroundColor: colors.card }]}>
          <Ionicons name="cloud-offline-outline" size={20} color={colors.secondary} />
          <Text style={[styles.feedbackText, { color: colors.secondary }]}>
            {entry.isOnline ? t('offlineReadNotice') : t('offlineDownloadNotice')}
          </Text>
        </View>
      ) : null}

      {error || entry.installState?.error ? (
        <Text
          accessibilityRole="alert"
          style={[styles.feedbackText, styles.error, { color: colors.error }]}>
          {localizeBibleError(
            error ?? entry.installState?.error,
            t,
            i18n.resolvedLanguage,
            'actionError',
          )}
        </Text>
      ) : null}

      <View style={styles.about}>
        <Text style={[styles.sectionTitle, { color: colors.text }]}>{t('about')}</Text>
        <Text style={[styles.body, { color: colors.secondary }]}>
          {entry.description || entry.label}
        </Text>
      </View>
      <BibleAttribution copyright={entry.copyright} attributionUrl={entry.attributionUrl} />

      <View style={styles.feature}>
        <Ionicons
          name={entry.isOnline ? 'globe-outline' : 'download-outline'}
          size={27}
          color={colors.blue}
        />
        <View style={styles.featureText}>
          <Text style={[styles.featureTitle, { color: colors.text }]}>
            {entry.isOnline ? t('requiresConnection') : t('readWithoutConnection')}
          </Text>
          <Text style={[styles.featureDescription, { color: colors.secondary }]}>
            {entry.isOnline
              ? t('streamedFrom', { provider })
              : entry.isBundled
                ? t('includedWithApp')
                : t(entry.isInstalled ? 'storedSize' : 'downloadSize', {
                    size: formatBibleVersionSize(entry.installState?.sizeBytes ?? entry.sizeBytes),
                  })}
          </Text>
        </View>
      </View>

      <View style={styles.feature}>
        <Ionicons name="book-outline" size={27} color={colors.blue} />
        <View style={styles.featureText}>
          <Text style={[styles.featureTitle, { color: colors.text }]}>
            {t('highlightsAndNotes')}
          </Text>
          <Text style={[styles.featureDescription, { color: colors.secondary }]}>
            {t('highlightsDescription')}
          </Text>
        </View>
      </View>

      {learnMoreUrl ? (
        <TouchableOpacity
          accessibilityRole="link"
          accessibilityLabel={t('learnMoreLabel', { version: entry.label })}
          activeOpacity={0.7}
          disabled={busy}
          onPress={() => void performAction('link', () => Linking.openURL(learnMoreUrl))}
          style={styles.feature}>
          <Ionicons name="link-outline" size={27} color={colors.blue} />
          <View style={[styles.featureText, styles.learnMore]}>
            <Text style={[styles.featureTitle, { color: colors.text }]}>{t('learnMore')}</Text>
            <Ionicons name="open-outline" size={20} color={colors.secondary} />
          </View>
        </TouchableOpacity>
      ) : null}

      {!entry.isBundled && entry.isAdded ? (
        <TouchableOpacity
          accessibilityRole="button"
          accessibilityState={{ disabled: busy, busy: action === 'remove' }}
          disabled={busy}
          activeOpacity={0.8}
          onPress={() => void performAction('remove', () => removeVersion(entry.id), onRemoved)}
          style={[
            styles.button,
            styles.removeButton,
            { backgroundColor: colors.card, borderColor: colors.outline, opacity: busy ? 0.5 : 1 },
          ]}>
          {action === 'remove' ? (
            <ActivityIndicator size="small" color={colors.text} />
          ) : (
            <Ionicons name="trash-outline" size={22} color={colors.text} />
          )}
          <Text style={[styles.buttonText, { color: colors.text }]}>
            {t(action === 'remove' ? 'removing' : 'removeVersion')}
          </Text>
        </TouchableOpacity>
      ) : null}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  content: { paddingHorizontal: 20, paddingTop: 24, paddingBottom: 28 },
  unavailable: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 28, gap: 16 },
  summary: { flexDirection: 'row', alignItems: 'center', gap: 18, marginBottom: 28 },
  summaryText: { flex: 1, gap: 5 },
  versionTitle: { fontSize: 20, fontWeight: '600', lineHeight: 27 },
  subtitle: { fontSize: 15, lineHeight: 21 },
  status: { flexDirection: 'row', alignItems: 'center', gap: 8, marginTop: 2 },
  button: {
    minHeight: 52,
    borderRadius: 15,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 10,
    paddingHorizontal: 16,
    paddingVertical: 14,
  },
  addButton: { marginBottom: 12 },
  buttonText: { flexShrink: 1, fontSize: 16, fontWeight: '600', textAlign: 'center' },
  readButton: { borderWidth: 1, marginBottom: 4 },
  feedback: { borderRadius: 12, flexDirection: 'row', gap: 10, padding: 13, marginTop: 14 },
  feedbackText: { flexShrink: 1, fontSize: 14, lineHeight: 21 },
  error: { marginTop: 12 },
  about: { marginTop: 28, gap: 14, marginBottom: 25 },
  sectionTitle: { fontSize: 18, fontWeight: '600' },
  body: { fontSize: 16, lineHeight: 25 },
  feature: { flexDirection: 'row', alignItems: 'flex-start', gap: 22, marginBottom: 27 },
  featureText: { flex: 1, gap: 4 },
  featureTitle: { fontSize: 15, lineHeight: 22 },
  featureDescription: { fontSize: 14, lineHeight: 20 },
  learnMore: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  removeButton: { borderWidth: 1, marginTop: 10, minHeight: 58 },
});
