import { BIBLE_SOURCE_LABELS } from '@/src/bible/sources';
import { localizeBibleError, matchesVersionSearch } from '@/src/bible/versionPresentation';
import BibleVersionCover from '@/src/components/BibleVersionCover';
import { formatBibleVersionSize } from '@/src/lib/bibleVersionService';
import { useAuth } from '@/src/state/AuthContext';
import { useBible, type BibleVersionListItem } from '@/src/state/BibleContext';
import Ionicons from '@expo/vector-icons/Ionicons';
import { useNetInfo } from '@react-native-community/netinfo';
import { useRouter } from 'expo-router';
import { useEffect, useMemo, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  ActivityIndicator,
  Modal,
  Pressable,
  ScrollView,
  SectionList,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  useColorScheme,
  View,
} from 'react-native';

type Props = {
  mode: 'library' | 'catalog';
  onAddPress: () => void;
  onVersionPress: (id: string) => void;
  onRead: () => void;
};

const featured = ['NIV', 'NLT', 'ESV', 'CSB', 'NKJV', 'KJV'];
const adapterSections = [
  { key: 'offline', title: 'Offline' },
  { key: 'youversion', title: 'YouVersion' },
  { key: 'esv', title: 'ESV' },
  { key: 'apiBible', title: 'API.Bible' },
] as const;
const adapterFilters = [{ key: 'all', title: 'All' }, ...adapterSections] as const;
type AdapterFilter = (typeof adapterFilters)[number]['key'];
type ProviderSection = (typeof adapterSections)[number]['key'];

export default function BibleVersionsScreen({ mode, onAddPress, onVersionPress, onRead }: Props) {
  const { t, i18n } = useTranslation('bible');
  const filterTitle = (filter: (typeof adapterFilters)[number]) =>
    filter.key === 'all' ? t('all') : filter.key === 'offline' ? t('offline') : filter.title;
  const router = useRouter();
  const { session } = useAuth();
  const isGuest = !session;
  const {
    versions,
    setVersion,
    addVersion,
    removeVersion,
    loadingVersionId,
    versionsCatalogLoading,
    versionsCatalogError,
    refreshVersionsCatalog,
  } = useBible();
  const dark = useColorScheme() === 'dark';
  const { isConnected, isInternetReachable } = useNetInfo();
  const offline = isConnected === false || isInternetReachable === false;
  const [query, setQuery] = useState('');
  const [adapterFilter, setAdapterFilter] = useState<AdapterFilter>('all');
  const [modal, setModal] = useState<'providers' | null>(null);
  const [providerSection, setProviderSection] = useState<ProviderSection | null>(null);
  const [optionsId, setOptionsId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  useEffect(() => {
    if (isGuest && adapterFilter !== 'all' && adapterFilter !== 'offline') {
      setAdapterFilter('all');
    }
  }, [adapterFilter, isGuest]);
  const pending = useRef(new Set<string>());
  const mounted = useRef(true);
  useEffect(() => {
    mounted.current = true;
    return () => {
      mounted.current = false;
    };
  }, []);
  const [busyIds, setBusyIds] = useState(new Set<string>());
  const colors = {
    text: dark ? '#f6f7f9' : '#17202e',
    secondary: dark ? '#a8adb7' : '#626b79',
    card: dark ? '#151719' : '#f5f6f8',
    border: dark ? '#2b2d31' : '#dce0e6',
    added: dark ? '#222931' : '#e7ebf0',
    blue: '#2375f5',
    error: dark ? '#fca5a5' : '#b91c1c',
  };
  const run = async (id: string, operation: () => Promise<void>, after?: () => void) => {
    if (pending.current.has(id)) return;
    pending.current.add(id);
    setBusyIds(new Set(pending.current));
    setError(null);
    try {
      await operation();
      if (mounted.current) after?.();
    } catch (cause) {
      if (mounted.current) setError(cause instanceof Error ? cause.message : t('pleaseTryAgain'));
    } finally {
      pending.current.delete(id);
      if (mounted.current) setBusyIds(new Set(pending.current));
    }
  };
  const read = (entry: BibleVersionListItem) =>
    void run(entry.id, () => setVersion(entry.id), onRead);
  const providers = [
    ...new Set(
      versions.filter((v) => v.isOnline).map((v) => BIBLE_SOURCE_LABELS[v.source ?? 'offline']),
    ),
  ];
  const matches = useMemo(
    () => versions.filter((entry) => matchesVersionSearch(entry, query)),
    [versions, query],
  );
  const sortedMatches = useMemo(
    () =>
      [...matches].sort((a, b) => {
        const rank = (entry: BibleVersionListItem) => {
          const index = featured.indexOf(entry.shortLabel.toUpperCase());
          return index < 0 ? featured.length : index;
        };
        return rank(a) - rank(b) || a.label.localeCompare(b.label);
      }),
    [matches],
  );
  const sections =
    mode === 'library'
      ? [{ key: 'library', title: '', data: versions.filter((entry) => entry.isAdded), total: 0 }]
      : adapterSections
          .filter((section) => !isGuest || section.key === 'offline')
          .filter((section) => adapterFilter === 'all' || section.key === adapterFilter)
          .map((section) => {
            const entries = sortedMatches.filter(
              (entry) => (entry.source ?? 'offline') === section.key,
            );
            const showAll = adapterFilter !== 'all' || Boolean(query.trim());
            return {
              ...section,
              title: filterTitle(section),
              data: showAll ? entries : entries.slice(0, 6),
              total: entries.length,
            };
          });
  const optionEntry = versions.find((entry) => entry.id === optionsId);
  const busy = (entry: BibleVersionListItem) =>
    busyIds.has(entry.id) || entry.isDownloading || loadingVersionId === entry.id;
  const status = (entry: BibleVersionListItem) => (
    <View style={styles.status}>
      {entry.isOnline ? (
        <Ionicons
          name="globe-outline"
          size={mode === 'library' ? 21 : 14}
          color={mode === 'library' ? colors.blue : colors.secondary}
        />
      ) : null}
      <Text numberOfLines={1} style={[styles.statusText, { color: colors.secondary }]}>
        {entry.isOnline ? (
          <>
            <Text style={{ color: colors.blue }}>{t('online')}</Text>
            {` · ${BIBLE_SOURCE_LABELS[entry.source ?? 'offline']}`}
          </>
        ) : (
          `${formatBibleVersionSize(entry.installState?.sizeBytes ?? entry.sizeBytes)} · ${t(entry.isInstalled ? 'downloaded' : 'download')}`
        )}
      </Text>
    </View>
  );

  return (
    <View style={{ flex: 1 }}>
      <SectionList
        key={mode}
        sections={sections}
        keyExtractor={(entry) => entry.id}
        stickySectionHeadersEnabled={false}
        keyboardShouldPersistTaps="handled"
        keyboardDismissMode="on-drag"
        showsVerticalScrollIndicator={false}
        contentContainerStyle={styles.content}
        ListHeaderComponent={
          <>
            {mode === 'library' ? (
              <Text style={[styles.intro, { color: colors.secondary }]}>{t('libraryIntro')}</Text>
            ) : (
              <>
                <View
                  style={[
                    styles.search,
                    { backgroundColor: colors.card, borderColor: colors.border },
                  ]}>
                  <Ionicons name="search-outline" size={22} color={colors.secondary} />
                  <TextInput
                    accessibilityLabel={t('searchLabel')}
                    placeholder={t('searchPlaceholder')}
                    placeholderTextColor={colors.secondary}
                    value={query}
                    onChangeText={setQuery}
                    autoCapitalize="none"
                    autoCorrect={false}
                    returnKeyType="search"
                    style={[styles.searchInput, { color: colors.text }]}
                  />
                  {query ? (
                    <TouchableOpacity
                      accessibilityRole="button"
                      accessibilityLabel={t('clearSearch')}
                      onPress={() => setQuery('')}
                      style={styles.clearSearch}>
                      <Ionicons name="close-circle" size={19} color={colors.secondary} />
                    </TouchableOpacity>
                  ) : null}
                </View>
                <ScrollView
                  horizontal
                  showsHorizontalScrollIndicator={false}
                  keyboardShouldPersistTaps="handled"
                  contentContainerStyle={styles.filters}>
                  {adapterFilters.map((filter) => {
                    const selected = adapterFilter === filter.key;
                    return (
                      <TouchableOpacity
                        key={filter.key}
                        accessibilityRole="button"
                        accessibilityLabel={
                          filter.key === 'all'
                            ? t('showAllVersions')
                            : t('filterBy', { provider: filterTitle(filter) })
                        }
                        accessibilityState={{ selected }}
                        onPress={() => {
                          if (isGuest && filter.key !== 'all' && filter.key !== 'offline') {
                            router.push({
                              pathname: '/app/signin',
                              params: { returnTo: '/app/bible/versions' },
                            });
                            return;
                          }
                          setAdapterFilter(filter.key);
                        }}
                        style={[
                          styles.filterChip,
                          {
                            backgroundColor: selected ? colors.blue : 'transparent',
                            borderColor: selected ? colors.blue : colors.border,
                          },
                        ]}>
                        <Text
                          style={[
                            styles.filterLabel,
                            { color: selected ? '#ffffff' : colors.text },
                          ]}>
                          {filterTitle(filter)}
                        </Text>
                      </TouchableOpacity>
                    );
                  })}
                </ScrollView>
              </>
            )}
            {offline ? (
              <Text style={[styles.notice, { color: colors.secondary }]}>{t('offlineNotice')}</Text>
            ) : null}
            {isGuest ? (
              <View style={[styles.noticeBox, { borderColor: colors.border }]}>
                <Text style={[styles.noticeText, { color: colors.secondary }]}>
                  {t('guestNotice')}
                </Text>
                <TouchableOpacity
                  accessibilityRole="button"
                  onPress={() =>
                    router.push({
                      pathname: '/app/signin',
                      params: { returnTo: '/app/bible/versions' },
                    })
                  }>
                  <Text style={styles.link}>{t('signIn')}</Text>
                </TouchableOpacity>
              </View>
            ) : null}
            {error ? (
              <Text accessibilityRole="alert" style={[styles.notice, { color: colors.error }]}>
                {localizeBibleError(error, t, i18n.resolvedLanguage, 'actionError')}
              </Text>
            ) : null}
            {mode === 'catalog' && versionsCatalogError ? (
              <View style={[styles.noticeBox, { borderColor: colors.border }]}>
                <Text style={[styles.noticeText, { color: colors.secondary }]}>
                  {t('catalogError')}
                </Text>
                <TouchableOpacity
                  accessibilityRole="button"
                  disabled={versionsCatalogLoading}
                  onPress={() => void refreshVersionsCatalog()}>
                  <Text style={styles.link}>{t('retry')}</Text>
                </TouchableOpacity>
              </View>
            ) : null}
            {mode === 'catalog' && versionsCatalogLoading ? (
              <ActivityIndicator
                style={{ marginBottom: 14 }}
                color={colors.blue}
                accessibilityLabel={t('loadingVersions')}
              />
            ) : null}
          </>
        }
        renderSectionHeader={({ section }) =>
          section.title ? (
            <View style={styles.sectionHeader}>
              <Text style={[styles.sectionTitle, { color: colors.text }]}>{section.title}</Text>
              {
                <TouchableOpacity
                  accessibilityRole="button"
                  accessibilityLabel={
                    section.key === 'offline'
                      ? t('aboutOfflineVersions')
                      : t('aboutProviderVersions', { provider: section.title })
                  }
                  onPress={() => {
                    setProviderSection(section.key as ProviderSection);
                    setModal('providers');
                  }}
                  style={styles.provider}>
                  <Ionicons name="information-circle-outline" size={20} color={colors.secondary} />
                </TouchableOpacity>
              }
            </View>
          ) : null
        }
        renderItem={({ item: entry }) =>
          mode === 'library' ? (
            <View
              style={[
                styles.libraryCard,
                { backgroundColor: colors.card, borderColor: colors.border },
              ]}>
              <TouchableOpacity
                accessibilityRole="button"
                accessibilityLabel={t(entry.isOnline ? 'versionDetailsLabel' : 'readVersionLabel', {
                  version: entry.label,
                })}
                disabled={busy(entry)}
                onPress={() => (entry.isOnline ? onVersionPress(entry.id) : read(entry))}
                style={{ flex: 1 }}>
                <View style={styles.nameRow}>
                  <Text style={[styles.libraryAbbr, { color: colors.text }]}>
                    {entry.shortLabel}
                  </Text>
                  {entry.isActive ? <Text style={styles.active}>{t('current')}</Text> : null}
                </View>
                <Text style={[styles.libraryName, { color: colors.text }]}>{entry.label}</Text>
                {status(entry)}
              </TouchableOpacity>
              {busy(entry) ? (
                <ActivityIndicator color={colors.blue} style={{ marginHorizontal: 10 }} />
              ) : entry.isOnline ? (
                <TouchableOpacity
                  accessibilityRole="button"
                  accessibilityLabel={t('detailsFor', { version: entry.label })}
                  onPress={() => onVersionPress(entry.id)}
                  style={styles.iconButton}>
                  <Ionicons name="chevron-forward" size={23} color={colors.secondary} />
                </TouchableOpacity>
              ) : (
                <>
                  <Ionicons name="checkmark-circle" size={30} color="#2fca70" />
                  <TouchableOpacity
                    accessibilityRole="button"
                    accessibilityLabel={t('manageVersion', { version: entry.label })}
                    onPress={() => setOptionsId(entry.id)}
                    style={styles.iconButton}>
                    <Ionicons name="ellipsis-vertical" size={22} color={colors.secondary} />
                  </TouchableOpacity>
                </>
              )}
            </View>
          ) : (
            <View
              style={[
                styles.catalogCard,
                { backgroundColor: colors.card, borderColor: colors.border },
              ]}>
              <TouchableOpacity
                accessibilityRole="button"
                accessibilityLabel={t('detailsFor', { version: entry.label })}
                onPress={() => onVersionPress(entry.id)}
                style={styles.catalogBody}>
                <BibleVersionCover version={entry} />
                <View style={{ flex: 1, minWidth: 0 }}>
                  <Text numberOfLines={1} style={[styles.catalogAbbr, { color: colors.text }]}>
                    {entry.shortLabel}
                  </Text>
                  <Text numberOfLines={2} style={[styles.catalogName, { color: colors.text }]}>
                    {entry.label}
                  </Text>
                  {status(entry)}
                </View>
              </TouchableOpacity>
              <TouchableOpacity
                accessibilityRole="button"
                accessibilityLabel={
                  entry.isAdded
                    ? t('versionAdded', { version: entry.label })
                    : t(entry.isOnline ? 'addVersionLabel' : 'downloadVersionLabel', {
                        version: entry.label,
                      })
                }
                accessibilityState={{
                  disabled: entry.isAdded || busy(entry) || (offline && !entry.isOnline),
                  busy: busy(entry),
                }}
                disabled={entry.isAdded || busy(entry) || (offline && !entry.isOnline)}
                onPress={() => void run(entry.id, () => addVersion(entry.id))}
                style={[
                  styles.addButton,
                  {
                    backgroundColor: entry.isAdded ? colors.added : colors.blue,
                    opacity: offline && !entry.isOnline && !entry.isAdded ? 0.5 : 1,
                  },
                ]}>
                {busy(entry) ? (
                  <ActivityIndicator size="small" color={entry.isAdded ? colors.text : '#ffffff'} />
                ) : (
                  <Ionicons
                    name={entry.isAdded ? 'checkmark' : 'add'}
                    size={21}
                    color={entry.isAdded ? colors.text : '#ffffff'}
                  />
                )}
                <Text style={[styles.addLabel, { color: entry.isAdded ? colors.text : '#ffffff' }]}>
                  {t(entry.isAdded ? 'added' : entry.isDownloading ? 'loading' : 'add')}
                </Text>
              </TouchableOpacity>
            </View>
          )
        }
        renderSectionFooter={({ section }) => (
          <>
            {!section.data.length ? (
              <Text style={[styles.empty, { color: colors.secondary }]}>
                {mode === 'library'
                  ? t('emptyLibrary')
                  : query.trim()
                    ? t('noSearchResults')
                    : versionsCatalogLoading
                      ? t('loadingAvailableVersions')
                      : t('noVersions')}
              </Text>
            ) : null}
            {section.total > section.data.length ? (
              <TouchableOpacity
                accessibilityRole="button"
                accessibilityLabel={t('seeProviderVersions', { provider: section.title })}
                onPress={() => setAdapterFilter(section.key as AdapterFilter)}
                style={styles.seeAll}>
                <Text style={styles.link}>{t('seeAllVersions', { count: section.total })}</Text>
                <Ionicons name="chevron-forward" size={17} color={colors.blue} />
              </TouchableOpacity>
            ) : null}
          </>
        )}
        ListFooterComponent={
          mode === 'library' ? (
            <TouchableOpacity
              accessibilityRole="button"
              onPress={onAddPress}
              activeOpacity={0.8}
              style={styles.primaryButton}>
              <Ionicons name="add" size={26} color="#ffffff" />
              <Text style={styles.primaryText}>{t('addBibleVersion')}</Text>
            </TouchableOpacity>
          ) : null
        }
      />

      <Modal
        visible={modal !== null || Boolean(optionEntry)}
        transparent
        animationType="fade"
        onRequestClose={() => {
          setModal(null);
          setProviderSection(null);
          setOptionsId(null);
        }}>
        <Pressable
          style={styles.scrim}
          onPress={() => {
            setModal(null);
            setProviderSection(null);
            setOptionsId(null);
          }}>
          <Pressable
            style={[styles.sheet, { backgroundColor: colors.card, borderColor: colors.border }]}
            onPress={(event) => event.stopPropagation()}>
            <View style={styles.sheetHeader}>
              <Text style={[styles.sheetTitle, { color: colors.text }]}>
                {modal === 'providers'
                  ? providerSection === 'offline'
                    ? t('offlineVersions')
                    : t('onlineVersions')
                  : optionEntry?.shortLabel}
              </Text>
              <TouchableOpacity
                accessibilityRole="button"
                accessibilityLabel={t('close')}
                onPress={() => {
                  setModal(null);
                  setProviderSection(null);
                  setOptionsId(null);
                }}
                style={styles.iconButton}>
                <Ionicons name="close" size={23} color={colors.secondary} />
              </TouchableOpacity>
            </View>
            {modal === 'providers' ? (
              providerSection === 'offline' ? (
                <Text style={[styles.modalBody, { color: colors.secondary }]}>
                  {t('offlineDescription')}
                </Text>
              ) : (
                <Text style={[styles.modalBody, { color: colors.secondary }]}>
                  {t('onlineDescription')}
                  {providers.length
                    ? t('availableProviders', { providers: providers.join(', ') })
                    : ''}
                </Text>
              )
            ) : optionEntry ? (
              <>
                <TouchableOpacity
                  accessibilityRole="button"
                  style={styles.sheetAction}
                  onPress={() => {
                    setOptionsId(null);
                    read(optionEntry);
                  }}>
                  <Ionicons name="book-outline" size={22} color={colors.blue} />
                  <Text style={{ color: colors.text, fontSize: 16 }}>{t('readVersion')}</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  accessibilityRole="button"
                  style={styles.sheetAction}
                  onPress={() => {
                    setOptionsId(null);
                    onVersionPress(optionEntry.id);
                  }}>
                  <Ionicons name="information-circle-outline" size={22} color={colors.blue} />
                  <Text style={{ color: colors.text, fontSize: 16 }}>{t('versionDetails')}</Text>
                </TouchableOpacity>
                {optionEntry.canDelete ? (
                  <TouchableOpacity
                    accessibilityRole="button"
                    style={styles.sheetAction}
                    onPress={() => {
                      setOptionsId(null);
                      void run(optionEntry.id, () => removeVersion(optionEntry.id));
                    }}>
                    <Ionicons name="trash-outline" size={22} color={colors.text} />
                    <Text style={{ color: colors.text, fontSize: 16 }}>{t('removeVersion')}</Text>
                  </TouchableOpacity>
                ) : (
                  <Text style={[styles.notice, { color: colors.secondary }]}>
                    {t('includedVersion')}
                  </Text>
                )}
              </>
            ) : null}
          </Pressable>
        </Pressable>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  content: { paddingHorizontal: 18, paddingTop: 8, paddingBottom: 24 },
  intro: { fontSize: 16, lineHeight: 22, marginBottom: 22, paddingHorizontal: 3 },
  search: {
    height: 46,
    borderRadius: 16,
    borderWidth: 1,
    paddingHorizontal: 14,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  searchInput: { flex: 1, fontSize: 13, paddingVertical: 0, minWidth: 0 },
  clearSearch: { minHeight: 40, justifyContent: 'center' },
  filters: { gap: 8, paddingTop: 13, paddingBottom: 16 },
  filterChip: {
    minHeight: 44,
    borderRadius: 22,
    borderWidth: 1,
    paddingHorizontal: 16,
    alignItems: 'center',
    justifyContent: 'center',
  },
  filterLabel: { fontSize: 13, fontWeight: '500' },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    gap: 8,
    paddingHorizontal: 2,
    marginTop: 9,
    marginBottom: 13,
  },
  sectionTitle: { fontSize: 16, fontWeight: '600', flexShrink: 1 },
  provider: { flexDirection: 'row', alignItems: 'center', gap: 7, flexShrink: 1 },
  libraryCard: {
    borderWidth: 1,
    borderRadius: 18,
    paddingVertical: 17,
    paddingLeft: 16,
    paddingRight: 9,
    marginBottom: 12,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  nameRow: { flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap', gap: 9 },
  libraryAbbr: { fontSize: 18, fontWeight: '600' },
  libraryName: { fontSize: 15, lineHeight: 21, marginTop: 5, marginBottom: 3 },
  active: { fontSize: 11, fontWeight: '600', color: '#2375f5' },
  status: { flexDirection: 'row', alignItems: 'center', gap: 6 },
  statusText: { fontSize: 12, lineHeight: 18, flexShrink: 1 },
  iconButton: { width: 36, minHeight: 44, alignItems: 'center', justifyContent: 'center' },
  catalogCard: {
    borderWidth: 1,
    borderRadius: 17,
    padding: 10,
    marginBottom: 7,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 9,
  },
  catalogBody: { flex: 1, flexDirection: 'row', alignItems: 'center', gap: 12, minWidth: 0 },
  catalogAbbr: { fontSize: 15, fontWeight: '600', marginBottom: 3 },
  catalogName: { fontSize: 13, lineHeight: 17, marginBottom: 3 },
  addButton: {
    minWidth: 80,
    minHeight: 39,
    borderRadius: 15,
    paddingHorizontal: 10,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 4,
  },
  addLabel: { fontSize: 14, fontWeight: '600' },
  primaryButton: {
    minHeight: 54,
    borderRadius: 15,
    backgroundColor: '#2375f5',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 10,
    marginTop: 10,
  },
  primaryText: { color: '#ffffff', fontSize: 16, fontWeight: '600' },
  link: { fontSize: 14, fontWeight: '500', color: '#2375f5' },
  seeAll: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'flex-end',
    gap: 4,
    paddingVertical: 12,
    marginBottom: 4,
  },
  notice: { fontSize: 13, lineHeight: 19, marginBottom: 14 },
  noticeBox: {
    borderWidth: 1,
    borderRadius: 12,
    padding: 12,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    marginBottom: 14,
  },
  noticeText: { flex: 1, fontSize: 13, lineHeight: 19 },
  empty: { fontSize: 14, lineHeight: 21, paddingVertical: 14 },
  scrim: {
    flex: 1,
    backgroundColor: '#00000099',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 24,
  },
  sheet: {
    width: '100%',
    maxWidth: 440,
    maxHeight: '80%',
    borderRadius: 22,
    padding: 20,
    borderWidth: 1,
  },
  sheetHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginBottom: 12,
  },
  sheetTitle: { fontSize: 19, fontWeight: '600', flex: 1 },
  sheetAction: { minHeight: 48, flexDirection: 'row', alignItems: 'center', gap: 12 },
  modalBody: { fontSize: 15, lineHeight: 23 },
});
