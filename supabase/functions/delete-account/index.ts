import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

Deno.serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 });
  }

  try {
    const body = await req.json().catch(() => null);
    const userId = body && typeof body.user_id === 'string' ? body.user_id.trim() : '';

    if (!userId) {
      return new Response('user_id is required', { status: 400 });
    }

    // Get the authorization header from the request
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response('Missing Authorization header', { status: 401 });
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    );

    // Verify the JWT matches the requested user_id
    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser(authHeader.replace('Bearer ', ''));

    if (userError || !user) {
      return new Response('Unauthorized', { status: 401 });
    }

    if (user.id !== userId) {
      return new Response('Forbidden: cannot delete another user', { status: 403 });
    }

    // Clear push notification setup before deleting
    await supabase.from('profiles').update({ expo_push_token: null }).eq('id', userId);

    // Delete the user from auth.users — the profile will cascade-delete
    const { error: deleteError } = await supabase.auth.admin.deleteUser(userId);

    if (deleteError) {
      console.error(
        JSON.stringify({
          scope: 'delete-account',
          level: 'error',
          event: 'delete_user_failed',
          user_id: userId,
          error: deleteError.message,
        }),
      );
      return new Response('Failed to delete account', { status: 500 });
    }

    console.log(
      JSON.stringify({
        scope: 'delete-account',
        level: 'info',
        event: 'account_deleted',
        user_id: userId,
      }),
    );

    return Response.json({ success: true });
  } catch (error) {
    const normalizedError =
      error instanceof Error
        ? { name: error.name, message: error.message }
        : { message: String(error) };

    console.error(
      JSON.stringify({
        scope: 'delete-account',
        level: 'error',
        event: 'unexpected_error',
        error: normalizedError,
      }),
    );

    return new Response('Unexpected error', { status: 500 });
  }
});
