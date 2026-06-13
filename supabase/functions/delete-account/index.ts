import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

type LogLevel = 'info' | 'warn' | 'error';

type SqlDeleteUserResult = {
  success?: boolean;
  deleted?: boolean;
  sqlstate?: string;
  message?: string;
  detail?: string | null;
  hint?: string | null;
  context?: string | null;
};

const logDeleteAccountEvent = (
  level: LogLevel,
  event: string,
  metadata: Record<string, unknown> = {},
) => {
  const payload = {
    scope: 'delete-account',
    level,
    event,
    ...metadata,
  };
  const message = JSON.stringify(payload);

  if (level === 'error') {
    console.error(message);
    return;
  }

  if (level === 'warn') {
    console.warn(message);
    return;
  }

  console.log(message);
};

const normalizeError = (error: unknown) => {
  if (error instanceof Error) {
    return { name: error.name, message: error.message };
  }

  if (error && typeof error === 'object') {
    const errorRecord = error as Record<string, unknown>;

    return {
      name: typeof errorRecord.name === 'string' ? errorRecord.name : undefined,
      message: typeof errorRecord.message === 'string' ? errorRecord.message : String(error),
      code: typeof errorRecord.code === 'string' ? errorRecord.code : undefined,
      status: typeof errorRecord.status === 'number' ? errorRecord.status : undefined,
      details: typeof errorRecord.details === 'string' ? errorRecord.details : undefined,
      hint: typeof errorRecord.hint === 'string' ? errorRecord.hint : undefined,
    };
  }

  return { message: String(error) };
};

const getReferenceCount = async (
  supabase: ReturnType<typeof createClient>,
  table: string,
  column: string,
  userId: string,
) => {
  const { count, error } = await supabase
    .from(table)
    .select('*', { count: 'exact', head: true })
    .eq(column, userId);

  return {
    table,
    column,
    count: count ?? 0,
    error: error ? normalizeError(error) : undefined,
  };
};

const getDeleteAccountReferenceCounts = (
  supabase: ReturnType<typeof createClient>,
  userId: string,
) =>
  Promise.all([
    getReferenceCount(supabase, 'profiles', 'id', userId),
    getReferenceCount(supabase, 'friends', 'requester_id', userId),
    getReferenceCount(supabase, 'friends', 'receiver_id', userId),
    getReferenceCount(supabase, 'plan_groups', 'created_by', userId),
    getReferenceCount(supabase, 'plan_group_members', 'user_id', userId),
    getReferenceCount(supabase, 'plan_progress', 'user_id', userId),
    getReferenceCount(supabase, 'day_items_progress', 'user_id', userId),
    getReferenceCount(supabase, 'comments', 'user_id', userId),
    getReferenceCount(supabase, 'notifications', 'user_id', userId),
    getReferenceCount(supabase, 'devotional_plans', 'author_id', userId),
    getReferenceCount(supabase, 'scripture_references', 'user_id', userId),
    getReferenceCount(supabase, 'scripture_references_draft', 'user_id', userId),
    getReferenceCount(supabase, 'reports', 'user_id', userId),
    getReferenceCount(supabase, 'plan_reactions', 'user_id', userId),
    getReferenceCount(supabase, 'plan_ratings', 'user_id', userId),
    getReferenceCount(supabase, 'saved_plans', 'user_id', userId),
    getReferenceCount(supabase, 'ai_notifications', 'user_id', userId),
    getReferenceCount(supabase, 'notification_preferences', 'user_id', userId),
    getReferenceCount(supabase, 'ai_triggers', 'user_id', userId),
    getReferenceCount(supabase, 'scripture_note_helpful_votes', 'user_id', userId),
    getReferenceCount(supabase, 'scripture_notes', 'user_id', userId),
    getReferenceCount(supabase, 'prayer_request_encouragements', 'user_id', userId),
    getReferenceCount(supabase, 'prayer_request_prayers', 'user_id', userId),
    getReferenceCount(supabase, 'prayer_requests', 'user_id', userId),
    getReferenceCount(supabase, 'plan_submissions', 'author_id', userId),
    getReferenceCount(supabase, 'church_invite_links', 'invited_by', userId),
  ]);

Deno.serve(async (req) => {
  const requestId = crypto.randomUUID();

  logDeleteAccountEvent('info', 'request_received', {
    request_id: requestId,
    method: req.method,
  });

  if (req.method !== 'POST') {
    logDeleteAccountEvent('warn', 'method_not_allowed', {
      request_id: requestId,
      method: req.method,
    });
    return new Response('Method not allowed', { status: 405 });
  }

  try {
    let parsedBody: unknown = null;
    let bodyParseError: unknown = null;

    try {
      parsedBody = await req.json();
    } catch (error) {
      bodyParseError = error;
    }

    if (bodyParseError) {
      logDeleteAccountEvent('warn', 'request_body_parse_failed', {
        request_id: requestId,
        error: normalizeError(bodyParseError),
      });
    }

    const body =
      parsedBody && typeof parsedBody === 'object' ? (parsedBody as Record<string, unknown>) : null;
    const userId = body && typeof body.user_id === 'string' ? body.user_id.trim() : '';

    if (!userId) {
      logDeleteAccountEvent('warn', 'missing_user_id', {
        request_id: requestId,
      });
      return new Response('user_id is required', { status: 400 });
    }

    // Get the authorization header from the request
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      logDeleteAccountEvent('warn', 'missing_authorization_header', {
        request_id: requestId,
        user_id: userId,
      });
      return new Response('Missing Authorization header', { status: 401 });
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

    if (!supabaseUrl || !serviceRoleKey) {
      logDeleteAccountEvent('error', 'missing_supabase_env', {
        request_id: requestId,
        user_id: userId,
        missing_supabase_url: !supabaseUrl,
        missing_service_role_key: !serviceRoleKey,
      });
      return new Response('Server is not configured', { status: 500 });
    }

    const supabase = createClient(supabaseUrl, serviceRoleKey);

    // Verify the JWT matches the requested user_id
    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser(authHeader.replace('Bearer ', ''));

    if (userError || !user) {
      logDeleteAccountEvent('error', 'auth_verification_failed', {
        request_id: requestId,
        user_id: userId,
        error: userError ? normalizeError(userError) : undefined,
        user_found: Boolean(user),
      });
      return new Response('Unauthorized', { status: 401 });
    }

    if (user.id !== userId) {
      logDeleteAccountEvent('warn', 'user_id_mismatch', {
        request_id: requestId,
        authenticated_user_id: user.id,
        requested_user_id: userId,
      });
      return new Response('Forbidden: cannot delete another user', { status: 403 });
    }

    // Clear push notification setup before deleting
    const { error: pushTokenError } = await supabase
      .from('profiles')
      .update({ expo_push_token: null })
      .eq('id', userId);

    if (pushTokenError) {
      logDeleteAccountEvent('warn', 'clear_push_token_failed', {
        request_id: requestId,
        user_id: userId,
        error: normalizeError(pushTokenError),
      });
    } else {
      logDeleteAccountEvent('info', 'push_token_cleared', {
        request_id: requestId,
        user_id: userId,
      });
    }

    const referenceCounts = await getDeleteAccountReferenceCounts(supabase, userId);

    logDeleteAccountEvent('info', 'pre_delete_reference_counts', {
      request_id: requestId,
      user_id: userId,
      references: referenceCounts,
    });

    logDeleteAccountEvent('info', 'delete_user_started', {
      request_id: requestId,
      user_id: userId,
    });

    // Delete the user from auth.users; the profile and related rows cascade-delete.
    const { error: deleteError } = await supabase.auth.admin.deleteUser(userId);

    if (deleteError) {
      logDeleteAccountEvent('error', 'delete_user_failed', {
        request_id: requestId,
        user_id: userId,
        error: deleteError.message,
        error_details: normalizeError(deleteError),
      });

      logDeleteAccountEvent('info', 'delete_user_sql_fallback_started', {
        request_id: requestId,
        user_id: userId,
      });

      const { data: sqlDeleteResult, error: sqlDeleteError } = await supabase.rpc(
        'delete_auth_user_with_diagnostics',
        { p_user_id: userId },
      );

      if (sqlDeleteError) {
        logDeleteAccountEvent('error', 'delete_user_sql_fallback_rpc_failed', {
          request_id: requestId,
          user_id: userId,
          error: sqlDeleteError.message,
          error_details: normalizeError(sqlDeleteError),
        });
        return new Response('Failed to delete account', { status: 500 });
      }

      const sqlDeleteDiagnostic = sqlDeleteResult as SqlDeleteUserResult | null;

      if (sqlDeleteDiagnostic?.success === true) {
        logDeleteAccountEvent('info', 'account_deleted_sql_fallback', {
          request_id: requestId,
          user_id: userId,
          diagnostic: sqlDeleteDiagnostic,
        });
        return Response.json({ success: true });
      }

      logDeleteAccountEvent('error', 'delete_user_sql_fallback_failed', {
        request_id: requestId,
        user_id: userId,
        diagnostic: sqlDeleteDiagnostic,
      });

      return new Response('Failed to delete account', { status: 500 });
    }

    logDeleteAccountEvent('info', 'account_deleted', {
      request_id: requestId,
      user_id: userId,
    });

    return Response.json({ success: true });
  } catch (error) {
    logDeleteAccountEvent('error', 'unexpected_error', {
      request_id: requestId,
      error: normalizeError(error),
    });

    return new Response('Unexpected error', { status: 500 });
  }
});
