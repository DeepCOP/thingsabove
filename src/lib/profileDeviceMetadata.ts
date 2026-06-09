import * as Application from 'expo-application';
import Constants from 'expo-constants';
import * as Device from 'expo-device';
import { getLocales } from 'expo-localization';
import { Platform } from 'react-native';
import type { ProfileDeviceMetadataInput } from '../types/types';

const getPrimaryDeviceLocale = () => {
  const locale = getLocales()[0];

  return {
    deviceLanguageCode: locale?.languageCode ?? null,
    deviceLanguageTag: locale?.languageTag ?? null,
  };
};

export const getProfileDeviceMetadata = (): ProfileDeviceMetadataInput => ({
  appVersion: Application.nativeApplicationVersion ?? Constants.expoConfig?.version ?? null,
  deviceOs: Device.osName ?? Platform.OS,
  deviceOsVersion: Device.osVersion ?? null,
  ...getPrimaryDeviceLocale(),
});
