// app.config.js
const fs = require('fs');
const path = require('path');

function getGoogleServicesFile() {
  const env = process.env.GOOGLE_SERVICES_JSON;
  const defaultPath = path.resolve(__dirname, 'google-services.json');

  if (!env) {
    if (!fs.existsSync(defaultPath)) {
      throw new Error(`Missing google-services.json (and GOOGLE_SERVICES_JSON not set).`);
    }
    return defaultPath;
  }

  const asPath = path.resolve(__dirname, env);
  if (fs.existsSync(asPath)) return asPath;

  // Otherwise treat env as JSON (raw or base64)
  const outPath = path.resolve(__dirname, 'google-services.eas.json');
  const trimmed = env.trim();
  const content = trimmed.startsWith('{')
    ? trimmed
    : Buffer.from(trimmed, 'base64').toString('utf8');

  fs.writeFileSync(outPath, content);
  return outPath;
}

module.exports = ({ config }) => ({
  expo: {
    name: 'thingsabove',
    slug: 'thingsabove',
    version: '1.0.0',
    orientation: 'portrait',
    icon: './assets/images/icon.png',
    scheme: 'thingsabove',
    userInterfaceStyle: 'automatic',
    newArchEnabled: true,

    ios: {
      supportsTablet: true,
      bundleIdentifier: 'life.thingsabove',
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

      // Use env-provided file or write env JSON to disk.
      googleServicesFile: getGoogleServicesFile(),

      edgeToEdgeEnabled: true,
      predictiveBackGestureEnabled: false,
      package: 'life.thingsabove',
    },

    web: {
      output: 'static',
      favicon: './assets/images/favicon.png',
      bundler: 'metro',
    },

    plugins: [
      'expo-router',
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
      'expo-sqlite',
      'expo-secure-store',
      'expo-notifications',
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
