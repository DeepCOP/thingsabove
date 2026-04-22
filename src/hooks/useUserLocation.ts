import { resolveApproximateLocationFromIp } from '@/src/api/queries';
import { saveUserLocation } from '@/src/api/mutations';
import { ProfileLocation } from '@/src/types/types';
import { useQueryClient } from '@tanstack/react-query';
import * as Device from 'expo-device';
import * as Location from 'expo-location';
import { useEffect, useState } from 'react';
import { useAuth } from '../state/AuthContext';

const LAST_KNOWN_LOCATION_MAX_AGE_MS = 15 * 60 * 1000;
const LAST_KNOWN_LOCATION_REQUIRED_ACCURACY_METERS = 1000;

type UserLocationStatus = 'idle' | 'resolving' | 'resolved' | 'error';

const getResolvedTimeZone = () => Intl.DateTimeFormat().resolvedOptions().timeZone || null;

async function reverseGeocode(coords: { latitude: number; longitude: number }) {
  try {
    const [address] = await Location.reverseGeocodeAsync(coords);

    return {
      city: address?.city ?? address?.district ?? null,
      region: address?.region ?? address?.subregion ?? null,
      country: address?.country ?? null,
      country_code: address?.isoCountryCode ?? null,
      timezone: address?.timezone ?? getResolvedTimeZone(),
    };
  } catch {
    return {
      city: null,
      region: null,
      country: null,
      country_code: null,
      timezone: getResolvedTimeZone(),
    };
  }
}

async function resolveDeviceLocation(): Promise<ProfileLocation | null> {
  if (!Device.isDevice) {
    return null;
  }

  const existingPermission = await Location.getForegroundPermissionsAsync();
  let finalStatus = existingPermission.status;

  if (finalStatus !== 'granted') {
    const requestedPermission = await Location.requestForegroundPermissionsAsync();
    finalStatus = requestedPermission.status;
  }

  if (finalStatus !== 'granted') {
    return null;
  }

  const servicesEnabled = await Location.hasServicesEnabledAsync();

  if (!servicesEnabled) {
    return null;
  }

  const lastKnown = await Location.getLastKnownPositionAsync({
    maxAge: LAST_KNOWN_LOCATION_MAX_AGE_MS,
    requiredAccuracy: LAST_KNOWN_LOCATION_REQUIRED_ACCURACY_METERS,
  });

  const position =
    lastKnown ??
    (await Location.getCurrentPositionAsync({
      accuracy: Location.Accuracy.Balanced,
      mayShowUserSettingsDialog: true,
    }));

  const place = await reverseGeocode({
    latitude: position.coords.latitude,
    longitude: position.coords.longitude,
  });

  return {
    source: 'device',
    latitude: position.coords.latitude,
    longitude: position.coords.longitude,
    accuracy_meters: position.coords.accuracy ?? null,
    city: place.city,
    region: place.region,
    country: place.country,
    country_code: place.country_code,
    timezone: place.timezone,
    captured_at: new Date(position.timestamp).toISOString(),
  };
}

async function resolveUserLocation(): Promise<ProfileLocation> {
  try {
    const deviceLocation = await resolveDeviceLocation();

    if (deviceLocation) {
      return deviceLocation;
    }
  } catch (error) {
    console.warn('Device location lookup failed, falling back to IP geolocation.', error);
  }

  return resolveApproximateLocationFromIp();
}

export function useUserLocation() {
  const { session } = useAuth();
  const queryClient = useQueryClient();

  const [location, setLocation] = useState<ProfileLocation | null>(null);
  const [status, setStatus] = useState<UserLocationStatus>('idle');
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const userId = session?.user?.id;

    if (!userId) {
      setLocation(null);
      setStatus('idle');
      setError(null);
      return;
    }

    let isCancelled = false;

    const syncUserLocation = async () => {
      setStatus('resolving');
      setError(null);

      try {
        const resolvedLocation = await resolveUserLocation();

        if (isCancelled) return;

        await saveUserLocation({ userId, location: resolvedLocation });

        if (isCancelled) return;

        setLocation(resolvedLocation);
        setStatus('resolved');
        await queryClient.invalidateQueries({ queryKey: ['profile', userId] });
      } catch (syncError) {
        if (isCancelled) return;

        setStatus('error');
        setError(
          syncError instanceof Error ? syncError.message : 'Unable to resolve user location.',
        );
      }
    };

    void syncUserLocation();

    return () => {
      isCancelled = true;
    };
  }, [queryClient, session?.user?.id]);

  return {
    location,
    status,
    error,
  };
}
