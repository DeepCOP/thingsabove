# Devotional App

A Bible devotional mobile app built with React Native, Expo, and Supabase. It supports devotional plans, comments, reactions, reporting, group plans, and push notifications.

**Features**
- Devotional plans with daily content
- Reactions and reporting
- Comments in group plans
- Push notifications (occasional AI nudges)
- Supabase Auth, RLS, Storage

**Tech Stack**
- React Native (Expo)
- NativeWind
- React Query
- Supabase (Auth, DB, Storage, RLS)
- TypeScript
- Expo Notifications

**Requirements**
- Node.js 18+ and pnpm
- Supabase CLI
- Expo CLI (optional, but helpful)
- Android Studio or Xcode for simulators (optional)

**Environment Variables**
Create `.env` and set values shown in `.env.example`.

Required server-side values:
```
SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co
SUPABASE_SERVICE_ROLE_KEY=YOUR_SUPABASE_SERVICE_ROLE_KEY
SUPABASE_SECRET_KEY=YOUR_SUPABASE_SECRET_KEY
EXPO_ACCESS_TOKEN=YOUR_EXPO_ACCESS_TOKEN
GEMINI_API_KEY=YOUR_GEMINI_API_KEY
```

Required public values (used by the app):
```
EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY=YOUR_SUPABASE_PUBLISHABLE_KEY
EXPO_PUBLIC_SUPABASE_PROJECT_URL=https://YOUR_PROJECT_ID.supabase.co
```

## App Setup

1. Install dependencies.
```
pnpm install
```

2. Start the app.
```
pnpm start
```

Follow the Expo prompts to run on a device or simulator. Push notifications require a physical device.

## Push Notifications Setup

1. Ensure Expo Notifications is configured in `app.config.js` (the `expo-notifications` plugin and a valid `extra.eas.projectId` are required).
2. For Android, add your Firebase `google-services.json` to the project root and keep the path set in `app.config.js`.
3. Run the app on a physical device and grant notification permissions when prompted.
4. The app registers for push tokens in `src/hooks/usePushNotifications.tsx`; verify that the token logs in the console and can be sent via Expo.

## EAS Build (Development)

1. Install and log in to EAS:
```
pnpm add -g eas-cli
eas login
```
2. Configure EAS for the project (first time only):
```
eas build:configure
```
3. Build a development client:
```
eas build -p android --profile development
eas build -p ios --profile development
```
4. Install the build on a device and run with Expo:
```
pnpm start
```

## EAS Environment Variables (per build profile)

Set these in EAS for each environment you build (e.g. development, beta, production). You can do this in the Expo dashboard or via CLI.

Required app variables:
```
EXPO_PUBLIC_WEB_INTERFACE_URL
EXPO_PUBLIC_BASE_URL
EXPO_PUBLIC_SUPABASE_PROJECT_URL
EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY
```

Required file variable:
```
GOOGLE_SERVICES_JSON
```
Set `GOOGLE_SERVICES_JSON` to the **contents** of `google-services.json` (raw JSON or base64). This is required because `google-services.json` is not checked into git and EAS Build only uploads tracked files.

Example (CLI):
```
eas env:create --environment production --name EXPO_PUBLIC_WEB_INTERFACE_URL --value https://your-web-ui
eas env:create --environment production --name EXPO_PUBLIC_BASE_URL --value https://your-api
eas env:create --environment production --name EXPO_PUBLIC_SUPABASE_PROJECT_URL --value https://YOUR_PROJECT_ID.supabase.co
eas env:create --environment production --name EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY --value YOUR_KEY
eas env:create --environment production  --name GOOGLE_SERVICES_JSON --type file --value ./google-services.json 
```

## EAS Build (Production)

1. Build release binaries:
```
eas build -p android --profile production
eas build -p ios --profile production
```
2. Submit to stores:
```
eas submit -p android --profile production
eas submit -p ios --profile production
```

## Supabase Setup

1. Create a Supabase project.
Get the Project URL, anon key, and service role key from Settings -> API.

2. Log in and link the project.
```
pnpx supabase login
pnpx supabase link --project-ref YOUR_PROJECT_REF_ID
```

3. Run migrations.
```
pnpx supabase db push --linked
```
If you need a full reset (destructive), use `pnpx supabase db reset --linked`.

4. Set Edge Function secrets from `.env`.
```
pnpx supabase secrets set --env-file .env
```

5. Create Vault secrets for cron jobs.
Run in the Supabase SQL editor:
```
select vault.create_secret('project_url', 'https://YOUR_PROJECT_ID.supabase.co');
select vault.create_secret('service-role-key', 'YOUR_SUPABASE_SERVICE_ROLE_KEY');
```

6. Deploy Edge Functions.
```
pnpx supabase functions deploy
```

## Notification Pipeline Notes

Occasional AI notifications:
- `generate_ai_triggers` inserts AI triggers based on user behavior.
- `generate-ai-notifications` creates AI content.
- `send-occasional-notifications` sends via Expo.

