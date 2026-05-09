import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const EXPO_PUSH_URL = 'https://exp.host/--/api/v2/push/send';
const SUPPORTED_NOTIFICATION_TYPES = new Set(['group_day_completed']);

type NotificationRow = {
  id: string;
  user_id: string;
  type: string;
  title: string;
  body: string | null;
  data: Record<string, unknown> | null;
};

function logInfo(event: string, details: Record<string, unknown> = {}) {
  console.log(
    JSON.stringify({ scope: 'send-notification-push', level: 'info', event, ...details }),
  );
}

function logError(event: string, error: unknown, details: Record<string, unknown> = {}) {
  const normalizedError =
    error instanceof Error
      ? {
          name: error.name,
          message: error.message,
          stack: error.stack,
        }
      : {
          message: String(error),
        };

  console.error(
    JSON.stringify({
      scope: 'send-notification-push',
      level: 'error',
      event,
      ...details,
      error: normalizedError,
    }),
  );
}

Deno.serve(async (req) => {
  const requestId = crypto.randomUUID();

  if (req.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 });
  }

  try {
    const body = await req.json().catch(() => null);
    const notificationId =
      body && typeof body.notification_id === 'string' ? body.notification_id.trim() : '';

    if (!notificationId) {
      return new Response('notification_id is required', { status: 400 });
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    );

    const { data: notificationData, error: notificationError } = await supabase
      .from('notifications')
      .select('id, user_id, type, title, body, data')
      .eq('id', notificationId)
      .maybeSingle();
    const notification = notificationData as NotificationRow | null;

    if (notificationError || !notification) {
      logError(
        'notification_lookup_failed',
        notificationError ?? new Error('Notification not found'),
        {
          request_id: requestId,
          notification_id: notificationId,
        },
      );
      return new Response('Notification not found', { status: 404 });
    }

    if (!SUPPORTED_NOTIFICATION_TYPES.has(notification.type)) {
      logInfo('notification_type_ignored', {
        request_id: requestId,
        notification_id: notification.id,
        type: notification.type,
      });
      return new Response('Notification type ignored', { status: 200 });
    }

    const { data: preferenceData, error: preferenceError } = await supabase
      .from('notification_preferences')
      .select('group_day_completed')
      .eq('user_id', notification.user_id)
      .maybeSingle();
    const preference = preferenceData as { group_day_completed: boolean | null } | null;

    if (preferenceError) {
      logError('preference_lookup_failed', preferenceError, {
        request_id: requestId,
        notification_id: notification.id,
        user_id: notification.user_id,
      });
      return new Response('Preference lookup failed', { status: 500 });
    }

    if (notification.type === 'group_day_completed' && preference?.group_day_completed === false) {
      logInfo('push_preference_disabled', {
        request_id: requestId,
        notification_id: notification.id,
        user_id: notification.user_id,
        type: notification.type,
      });
      return new Response('Push disabled by preference', { status: 200 });
    }

    const { data: profileData, error: profileError } = await supabase
      .from('profiles')
      .select('expo_push_token')
      .eq('id', notification.user_id)
      .not('expo_push_token', 'is', null)
      .maybeSingle();
    const profile = profileData as { expo_push_token: string | null } | null;

    if (profileError) {
      logError('profile_lookup_failed', profileError, {
        request_id: requestId,
        notification_id: notification.id,
        user_id: notification.user_id,
      });
      return new Response('Profile lookup failed', { status: 500 });
    }

    const expoPushToken = profile?.expo_push_token?.trim();
    if (!expoPushToken) {
      logInfo('push_token_missing', {
        request_id: requestId,
        notification_id: notification.id,
        user_id: notification.user_id,
      });
      return new Response('No push token', { status: 200 });
    }

    const expoAccessToken = Deno.env.get('EXPO_ACCESS_TOKEN');
    const pushPayload = {
      to: expoPushToken,
      sound: 'default',
      channelId: 'default',
      title: notification.title,
      body: notification.body ?? '',
      data: {
        ...(notification.data ?? {}),
        notification_id: notification.id,
        type: notification.type,
      },
    };

    const response = await fetch(EXPO_PUSH_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(expoAccessToken ? { Authorization: `Bearer ${expoAccessToken}` } : {}),
      },
      body: JSON.stringify(pushPayload),
    });

    const result = await response.json().catch(() => null);

    if (!response.ok) {
      logError('expo_request_failed', new Error(`Expo responded with ${response.status}`), {
        request_id: requestId,
        notification_id: notification.id,
        result,
      });
      return new Response('Expo request failed', { status: 502 });
    }

    const ticket = Array.isArray(result?.data) ? result.data[0] : result?.data;
    if (ticket?.status === 'error') {
      logError('expo_ticket_error', new Error(ticket.message ?? 'Expo ticket error'), {
        request_id: requestId,
        notification_id: notification.id,
        details: ticket.details ?? null,
      });

      if (ticket.details?.error === 'DeviceNotRegistered') {
        await supabase
          .from('profiles')
          .update({ expo_push_token: null })
          .eq('id', notification.user_id)
          .eq('expo_push_token', expoPushToken);
      }

      return new Response('Expo ticket error', { status: 200 });
    }

    logInfo('push_sent', {
      request_id: requestId,
      notification_id: notification.id,
      ticket_id: ticket?.id ?? null,
    });

    return Response.json({
      notification_id: notification.id,
      ticket_id: ticket?.id ?? null,
    });
  } catch (error) {
    logError('unexpected_error', error, { request_id: requestId });
    return new Response('Unexpected error', { status: 500 });
  }
});
