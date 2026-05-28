const { version } = require('./package.json');

const androidAppLinkPaths = [
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

    ios: {
      supportsTablet: true,
      bundleIdentifier: 'life.thingsabove',
      associatedDomains: ['applinks:thingsabove.life'],
      infoPlist: {
        ITSAppUsesNonExemptEncryption: false,
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
          data: androidAppLinkPaths.map((pathPrefix) => ({
            scheme: 'https',
            host: 'thingsabove.life',
            pathPrefix,
          })),
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
          locationWhenInUsePermission:
            'Allow $(PRODUCT_NAME) to use your location for nearby features and local defaults.',
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
      router: {},
      eas: {
        projectId: 'de7e88d0-085e-40a2-90e9-c481ffaac58c',
      },
    },
  },
});
