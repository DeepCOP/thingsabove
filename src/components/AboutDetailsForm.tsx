import { searchChurches } from '@/src/api/queries';
import FormRestrictionText from '@/src/components/FormRestrictionText';
import {
  MAX_BIO_LENGTH,
  MAX_CHURCH_ADDRESS_LENGTH,
  MAX_CHURCH_NAME_LENGTH,
  MAX_CHURCH_WEBSITE_URL_LENGTH,
  MAX_NAME_LENGTH,
  ProfileDetailsFormErrors,
  ProfileDetailsFormValues,
} from '@/src/profileDetails';
import { Input } from '@rneui/themed';
import { useEffect, useState } from 'react';
import { ActivityIndicator, Text, TouchableOpacity, View, useColorScheme } from 'react-native';

type ChurchSearchResult = {
  id: string;
  name: string;
  address: string | null;
  website_url: string | null;
};

const MIN_CHURCH_QUERY_LENGTH = 2;
const SEARCH_DEBOUNCE_MS = 350;

export default function AboutDetailsForm({
  values,
  errors,
  onChange,
  disabled = false,
  showNameFields = true,
}: {
  values: ProfileDetailsFormValues;
  errors?: ProfileDetailsFormErrors;
  onChange: (patch: Partial<ProfileDetailsFormValues>) => void;
  disabled?: boolean;
  showNameFields?: boolean;
}) {
  const colorScheme = useColorScheme();
  const textColor = colorScheme === 'dark' ? '#F5F5F5' : '#424242';
  const placeholderColor =
    colorScheme === 'dark' ? 'rgba(156, 163, 175, 0.65)' : 'rgba(107, 114, 128, 0.55)';
  const [churchQuery, setChurchQuery] = useState('');
  const [churchResults, setChurchResults] = useState<ChurchSearchResult[]>([]);
  const [churchSearchError, setChurchSearchError] = useState<string | null>(null);
  const [isSearchingChurches, setIsSearchingChurches] = useState(false);
  const canEditChurch = !disabled;

  useEffect(() => {
    if (!canEditChurch) {
      setChurchResults([]);
      setChurchSearchError(null);
      setIsSearchingChurches(false);
      return;
    }

    const trimmedQuery = churchQuery.trim();
    if (trimmedQuery.length < MIN_CHURCH_QUERY_LENGTH) {
      setChurchResults([]);
      setChurchSearchError(null);
      setIsSearchingChurches(false);
      return;
    }

    let isActive = true;
    setChurchSearchError(null);
    setIsSearchingChurches(true);
    const timeout = setTimeout(() => {
      searchChurches(trimmedQuery)
        .then((results) => {
          if (!isActive) return;
          setChurchResults(results);
          setChurchSearchError(
            results.length === 0 ? 'No churches found. You can enter details below.' : null,
          );
        })
        .catch(() => {
          if (!isActive) return;
          setChurchResults([]);
          setChurchSearchError('Unable to search churches right now.');
        })
        .finally(() => {
          if (isActive) {
            setIsSearchingChurches(false);
          }
        });
    }, SEARCH_DEBOUNCE_MS);

    return () => {
      isActive = false;
      clearTimeout(timeout);
    };
  }, [canEditChurch, churchQuery]);

  const handleSelectChurch = (church: ChurchSearchResult) => {
    onChange({
      churchId: church.id,
      churchName: church.name,
      churchAddress: church.address ?? '',
      churchWebsiteUrl: church.website_url ?? '',
    });
    setChurchResults([]);
    setChurchSearchError(null);
  };

  return (
    <View>
      <View className="px-2 pt-2">
        <Text className="mb-3 text-lg font-semibold text-gray-900 dark:text-white">About You</Text>
      </View>

      {showNameFields ? (
        <>
          <Input
            label="First Name"
            value={values.firstName}
            onChangeText={(firstName) => onChange({ firstName })}
            editable={!disabled}
            autoCapitalize="words"
            errorMessage={errors?.firstName}
            style={{ color: textColor }}
            placeholder="First name"
            placeholderTextColor={placeholderColor}
            maxLength={MAX_NAME_LENGTH}
          />

          <Input
            label="Last Name"
            value={values.lastName}
            onChangeText={(lastName) => onChange({ lastName })}
            editable={!disabled}
            autoCapitalize="words"
            errorMessage={errors?.lastName}
            style={{ color: textColor }}
            placeholder="Last name"
            placeholderTextColor={placeholderColor}
            maxLength={MAX_NAME_LENGTH}
          />
        </>
      ) : null}

      <Input
        label="Bio or Favorite Verse"
        value={values.bio}
        onChangeText={(bio) => onChange({ bio })}
        editable={!disabled}
        errorMessage={errors?.bio}
        style={{ color: textColor }}
        placeholder="Share a short bio or your favorite verse"
        placeholderTextColor={placeholderColor}
        maxLength={MAX_BIO_LENGTH}
        multiline
        numberOfLines={4}
      />

      <Input
        label="Year You Believed"
        value={values.yearBelieved}
        onChangeText={(yearBelieved) => onChange({ yearBelieved })}
        editable={!disabled}
        keyboardType="number-pad"
        maxLength={4}
        errorMessage={errors?.yearBelieved}
        style={{ color: textColor }}
        placeholder="2020"
        placeholderTextColor={placeholderColor}
      />

      <Input
        label="Year You Were Baptized"
        value={values.yearBaptized}
        onChangeText={(yearBaptized) => onChange({ yearBaptized })}
        editable={!disabled}
        keyboardType="number-pad"
        maxLength={4}
        errorMessage={errors?.yearBaptized}
        style={{ color: textColor }}
        placeholder="2021"
        placeholderTextColor={placeholderColor}
      />

      <View className="px-2 pt-2">
        <Text className="mb-3 text-lg font-semibold text-gray-900 dark:text-white">Church</Text>
      </View>

      <Input
        label="Search and select your church"
        value={churchQuery}
        onChangeText={(nextQuery) => {
          setChurchQuery(nextQuery);
          if (values.churchId) {
            onChange({ churchId: null });
          }
        }}
        editable={canEditChurch}
        autoCapitalize="words"
        style={{ color: textColor }}
        placeholder="Type a name or address, then tap a result"
        placeholderTextColor={placeholderColor}
      />
      <FormRestrictionText className="-mt-4 mb-4">
        Enter at least {MIN_CHURCH_QUERY_LENGTH} characters to search.
      </FormRestrictionText>

      {isSearchingChurches ? (
        <View className="-mt-2 mb-3 px-2">
          <ActivityIndicator color={colorScheme === 'dark' ? '#F5F5F5' : '#111'} />
        </View>
      ) : null}

      {churchSearchError ? (
        <Text className="-mt-2 mb-3 px-3 text-sm text-gray-600 dark:text-gray-400">
          {churchSearchError}
        </Text>
      ) : null}

      {churchResults.length > 0 ? (
        <View className="mb-3 px-2">
          {churchResults.map((church) => (
            <TouchableOpacity
              key={church.id}
              onPress={() => handleSelectChurch(church)}
              className="mb-2 rounded-xl border border-gray-200 bg-white px-3 py-2 dark:border-neutral-800 dark:bg-neutral-950">
              <Text className="text-base font-semibold text-gray-900 dark:text-white">
                {church.name}
              </Text>
              {church.address ? (
                <Text className="mt-1 text-sm text-gray-600 dark:text-gray-400">
                  {church.address}
                </Text>
              ) : null}
              {church.website_url ? (
                <Text className="mt-1 text-sm text-blue-600 dark:text-blue-400">
                  {church.website_url}
                </Text>
              ) : null}
            </TouchableOpacity>
          ))}
        </View>
      ) : null}

      <Input
        label="Church Name"
        value={values.churchName}
        onChangeText={(churchName) => onChange({ churchId: null, churchName })}
        editable={canEditChurch}
        autoCapitalize="words"
        errorMessage={errors?.churchName}
        style={{ color: textColor }}
        placeholderTextColor={placeholderColor}
        maxLength={MAX_CHURCH_NAME_LENGTH}
      />
      <FormRestrictionText className="-mt-4 mb-4">
        Required when adding church details manually. Up to {MAX_CHURCH_NAME_LENGTH} characters.
      </FormRestrictionText>
      <Input
        label="Church Address"
        value={values.churchAddress}
        onChangeText={(churchAddress) => onChange({ churchId: null, churchAddress })}
        editable={canEditChurch}
        autoCapitalize="words"
        errorMessage={errors?.churchAddress}
        style={{ color: textColor }}
        placeholderTextColor={placeholderColor}
        maxLength={MAX_CHURCH_ADDRESS_LENGTH}
      />
      <Input
        label="Church Website URL"
        value={values.churchWebsiteUrl}
        onChangeText={(churchWebsiteUrl) => onChange({ churchId: null, churchWebsiteUrl })}
        editable={canEditChurch}
        autoCapitalize="none"
        autoCorrect={false}
        keyboardType="url"
        errorMessage={errors?.churchWebsiteUrl}
        style={{ color: textColor }}
        placeholder="https://example.org"
        placeholderTextColor={placeholderColor}
        maxLength={MAX_CHURCH_WEBSITE_URL_LENGTH}
      />
    </View>
  );
}
