/** @type {import('tailwindcss').Config} */
module.exports = {
  // NOTE: Update this to include the paths to all files that contain Nativewind classes.
  content: ['./App.tsx', './components/**/*.{js,jsx,ts,tsx}', './app/**/*.{js,jsx,ts,tsx}'],
  presets: [require('nativewind/preset')],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: '#171A1FFF',
        verseNumber: '#565D6DFF',
        icon: {
          tint: '#1FB1F9FF',
        },
      },
      fontFamily: {
        'open-sans-regular': ['OpenSansRegular'],
        'open-sans-bold': ['OpenSansBold'],
        OpenSansSemiBold: 'OpenSansSemiBold',
        OpenSansRegularItalic: 'OpenSansRegularItalic',
        OpenSansSemiBoldItalic: 'OpenSansSemiBoldItalic',
        OpenSansBoldItalic: 'OpenSansBoldItalic',
        MerriWeather300Light: 'MerriWeather300Light',
        MerriWeather400Regular: 'MerriWeather400Regular',
        MerriWeather700Bold: 'MerriWeather700Bold',
        MerriWeather900Black: 'MerriWeather900Black',
      },
    },
  },
  plugins: [],
};
