-- Add missing is_read column to ai_notifications (safe, no data loss)
ALTER TABLE IF EXISTS public.ai_notifications ADD COLUMN IF NOT EXISTS is_read boolean DEFAULT true;
ALTER TABLE IF EXISTS public.ai_daily_messages ADD COLUMN IF NOT EXISTS is_read boolean DEFAULT true;

-- Update get_my_notifications to include all 3 notification tables
CREATE OR REPLACE FUNCTION public.get_my_notifications()
RETURNS TABLE (
    id uuid,
    user_id uuid,
    type text,
    title text,
    body text,
    data jsonb,
    is_read boolean,
    created_at timestamptz,
    source_table text
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
BEGIN
    RETURN QUERY
    
    -- Regular notifications
    SELECT
        n.id,
        n.user_id,
        n.type,
        n.title,
        n.body,
        n.data,
        n.is_read,
        n.created_at,
        'notifications'::text as source_table
    FROM public.notifications n
    WHERE n.user_id = auth.uid()
      AND n.is_read = false
    
    UNION ALL
    
    -- AI Pending notifications
    SELECT
        an.id,
        an.user_id,
        'ai_pending'::text as type,
        an.title,
        an.body,
        an.data,
        an.is_read,
        an.created_at,
        'ai_notifications'::text as source_table
    FROM public.ai_notifications an
    WHERE an.user_id = auth.uid()
      AND an.is_read = false
    
    UNION ALL
    
    -- AI Daily messages
    SELECT
        adm.id,
        adm.user_id,
        'daily_message'::text as type,
        'Daily Message'::text as title,
        adm.content as body,
        jsonb_build_object('type', 'daily_message') as data,
        adm.is_read,
        adm.created_at,
        'ai_daily_messages'::text as source_table
    FROM public.ai_daily_messages adm
    WHERE adm.user_id = auth.uid()
      AND adm.is_read = false
    
    ORDER BY created_at DESC;
END;
$$;

-- Update mark_notification_read to work with all 3 tables
CREATE OR REPLACE FUNCTION public.mark_notification_read(p_notification_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
BEGIN
    -- Try regular notifications first
    UPDATE public.notifications
    SET is_read = true
    WHERE id = p_notification_id AND user_id = auth.uid();
    
    IF FOUND THEN RETURN; END IF;
    
    -- Try AI notifications
    UPDATE public.ai_notifications
    SET is_read = true
    WHERE id = p_notification_id AND user_id = auth.uid();
    
    IF FOUND THEN RETURN; END IF;
    
    -- Try AI daily messages
    UPDATE public.ai_daily_messages
    SET is_read = true
    WHERE id = p_notification_id AND user_id = auth.uid();
END;
$$;

-- Update unread count to include all tables
CREATE OR REPLACE FUNCTION public.unread_notifications_count()
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
DECLARE
    total_count integer;
BEGIN
    SELECT COALESCE(SUM(count), 0) INTO total_count
    FROM (
        SELECT COUNT(*) as count FROM public.notifications WHERE user_id = auth.uid() AND is_read = false
        UNION ALL
        SELECT COUNT(*) as count FROM public.ai_notifications WHERE user_id = auth.uid() AND is_read = false
        UNION ALL
        SELECT COUNT(*) as count FROM public.ai_daily_messages WHERE user_id = auth.uid() AND is_read = false
    ) combined;
    
    RETURN total_count;
END;
$$;