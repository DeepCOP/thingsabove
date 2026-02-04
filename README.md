# thingsabove

Devotional Bible

# 📖 Bible Devotional App

A modern Bible Devotional mobile application built with **React Native**, **Expo**, and **Supabase**, designed to deliver a YouVersion-style experience with devotional plans, Bible reading, reactions, comments, reporting, and offline support.

## 🛠️ Tech Stack

### **Mobile App**

- ⚛ React Native (Expo)
- 🎨 NativeWind (Tailwind CSS for React Native)
- 📦 React Query
- 🔥 Supabase (Auth, Database, Storage, RLS)
- 📚 TypeScript
- 🔔 Expo Notifications

### **Web Devotional Submission Editor**

- 🌐 Next.js
- ✍️ Rich-text editor (TipTap / Quill / Pell)
- 🔄 Supabase for content storage

---

## Get started

1. Install dependencies

   ```bash
   pnpm install
   ```

2. Start the app

   ```bash
   pnpm start
   ```

Follow the terminal prompts to:

- Sign in or continue anonymously
- Choose how to run the app

In the output, you'll find options to open the app in a

- [development build](https://docs.expo.dev/develop/development-builds/introduction/)
- [Android emulator](https://docs.expo.dev/workflow/android-studio-emulator/)
- [iOS simulator](https://docs.expo.dev/workflow/ios-simulator/)
- [Expo Go](https://expo.dev/go), a limited sandbox for trying out app development with Expo


In the Terminal, you'll find command lists:
-  example
   - s => to switch b/n development build and expo go to run the app on a physical device or emulator

## Supabase Database Migration

1. login with supabase cli
   ```bash
   pnpx supabase login
   ```
2. link your supabase project
   ```bash
   pnpx supabase link --project-ref YOUR_PROJECT_REF_ID
   ```
3. Run migrations
   ```bash
   pnpx supabase db reset --linked
   ```
4. Set Secrets
   ```bash
   pnpx supabase secrets set --env-file .env
   ```
5. Deploy Edge functions
   ```bash
   pnpx supabase functions deploy
   ```