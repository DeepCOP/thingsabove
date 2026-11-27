const { execSync } = require('child_process');
const { version } = require('./package.json');

function getGitCommit() {
  // Set on EAS Build workers.
  if (process.env.EAS_BUILD_GIT_COMMIT_HASH) return process.env.EAS_BUILD_GIT_COMMIT_HASH;
  try {
    return execSync('git rev-parse HEAD', { stdio: ['ignore', 'pipe', 'ignore'] })
      .toString()
      .trim();
  } catch {
    return undefined;
  }
}

const easProjectId = 'de7e88d0-085e-40a2-90e9-c481ffaac58c';

const androidAppRoutes = [
  '/PlansTab',
  '/CommunityTab',
  '/BibleTab',
  '/ProfileTab',
  '/about-details',
  '/accept_friend',
  '/add_friend',
  '/bible',
  '/church',
  '/confirm-email',
  '/devotional_detail',
  '/invite',
  '/notifications',
  '/plan_progress',
  '/prayer',
  '/scripture_notes',
  '/search/devotionals',
  '/settings',
  '/signin',
  '/signup',
  '/profile',
];
const androidAppLinkPaths = ['/app', ...androidAppRoutes.map((pathPrefix) => `/app${pathPrefix}`)];
const defaultAppLinkHosts = ['thingsabove.life', 'beta.thingsabove.life'];
const configuredAppLinkHosts = process.env.EXPO_PUBLIC_APP_LINK_HOSTS?.split(',')
  .map((host) => host.trim())
  .filter(Boolean);
const appLinkHosts = configuredAppLinkHosts?.length ? configuredAppLinkHosts : defaultAppLinkHosts;
const androidAppLinkData = appLinkHosts.flatMap((host) =>
  androidAppLinkPaths.map((pathPrefix) => ({
    scheme: 'https',
    host,
    pathPrefix,
  })),
);
const googleIosUrlScheme = process.env.EXPO_PUBLIC_GOOGLE_IOS_URL_SCHEME;
const googleSignInPlugin = googleIosUrlScheme
  ? [['@react-native-google-signin/google-signin', { iosUrlScheme: googleIosUrlScheme }]]
  : [];
const locationWhenInUsePermission =
  '$(PRODUCT_NAME) uses your location to save your city, country, and time zone in your profile. ' +
  'For example, your time zone helps schedule devotional reminders and app notifications at appropriate local times.';

export default ({ config }) => ({
  expo: {
    name: 'Things Above',
    slug: 'thingsabove',
    version,
    orientation: 'portrait',
    icon: './assets/images/icon.png',
    scheme: 'thingsabove',
    userInterfaceStyle: 'automatic',
    newArchEnabled: true,

    runtimeVersion: {
      policy: 'fingerprint',
    },
    updates: {
      url: `https://u.expo.dev/${easProjectId}`,
      // Check on every launch, download in the background, apply on next cold start.
      checkAutomatically: 'ON_LOAD',
      fallbackToCacheTimeout: 0,
    },

    ios: {
      supportsTablet: true,
      bundleIdentifier: 'life.thingsabove',
      associatedDomains: appLinkHosts.map((host) => `applinks:${host}`),
      infoPlist: {
        ITSAppUsesNonExemptEncryption: false,
        NSLocationWhenInUseUsageDescription: locationWhenInUsePermission,
      },
      usesAppleSignIn: true,
      entitlements: {
        'com.apple.developer.applesignin': ['Default'],
      },
    },

    android: {
      adaptiveIcon: {
        backgroundColor: '#E6F4FE',
        foregroundImage: './assets/images/icon.png',
        monochromeImage: './assets/images/android-icon-monochrome.png',
      },

      // ✅ Now environment variable works
      googleServicesFile: process.env.GOOGLE_SERVICES_JSON || './google-services.json',

      edgeToEdgeEnabled: true,
      predictiveBackGestureEnabled: false,
      package: 'life.thingsabove',
      intentFilters: [
        {
          action: 'VIEW',
          autoVerify: true,
          data: androidAppLinkData,
          category: ['BROWSABLE', 'DEFAULT'],
        },
      ],
    },

    web: {
      output: 'static',
      favicon: './assets/images/favicon.png',
      bundler: 'metro',
    },

    plugins: [
      'expo-router',
      [
        'expo-location',
        {
          locationWhenInUsePermission,
        },
      ],
      [
        'expo-splash-screen',
        {
          image: './assets/images/splash-icon.png',
          imageWidth: 200,
          resizeMode: 'contain',
          backgroundColor: '#ffffff',
          dark: {
            backgroundColor: '#000000',
          },
        },
      ],
      [
        'expo-navigation-bar',
        {
          backgroundColor: '#0f172a',
          barStyle: 'light',
          borderColor: '#1f2937',
          visibility: 'visible',
          behavior: 'inset-swipe',
          position: 'relative',
        },
      ],
      'expo-font',
      'expo-secure-store',
      'expo-apple-authentication',
      ...googleSignInPlugin,
      [
        'expo-build-properties',
        {
          android: {
            enableMinifyInReleaseBuilds: true,
            enableShrinkResourcesInReleaseBuilds: true,
          },
          ios: {
            extraPods: [
              {
                name: 'GoogleUtilities',
                modular_headers: true,
              },
              {
                name: 'RecaptchaInterop',
                modular_headers: true,
              },
            ],
          },
        },
      ],
      [
        'expo-notifications',
        {
          icon: './assets/images/notification-icon.png',
        },
      ],
    ],

    experiments: {
      typedRoutes: true,
      reactCompiler: true,
    },

    owner: 'things-above',

    extra: {
      gitCommit: getGitCommit(),
      router: {},
      eas: {
        projectId: easProjectId,
      },
    },
  },
});
