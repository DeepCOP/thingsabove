import AsyncStorage from '@react-native-async-storage/async-storage';
import 'react-native-get-random-values';
import { v4 as uuid } from 'uuid';

const DEVICE_ID_KEY = 'api-bible-fums-device-id';
const sessionId = uuid();
const sentTokens = new Set<string>();
let deviceIdPromise: Promise<string> | undefined;

const getDeviceId = () => {
  if (!deviceIdPromise) {
    deviceIdPromise = AsyncStorage.getItem(DEVICE_ID_KEY).then(async (stored) => {
      if (stored && /^[A-Za-z0-9_-]{8,200}$/.test(stored)) return stored;
      const next = uuid();
      await AsyncStorage.setItem(DEVICE_ID_KEY, next);
      return next;
    });
  }
  return deviceIdPromise;
};

/** Reports an API.Bible chapter view without identifying the reader. */
export const trackApiBibleView = (fumsToken?: string) => {
  if (!fumsToken || fumsToken.length > 2048 || sentTokens.has(fumsToken)) return;
  sentTokens.add(fumsToken);
  void getDeviceId()
    .then((deviceId) => {
      const url = new URL('https://fums.api.bible/f3');
      url.searchParams.set('t', fumsToken);
      url.searchParams.set('dId', deviceId);
      url.searchParams.set('sId', sessionId);
      return fetch(url, { method: 'GET' });
    })
    .catch(() => {
      // Fair-use reporting is best effort and must not affect reading.
      sentTokens.delete(fumsToken);
    });
};
