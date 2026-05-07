create or replace function public.get_my_notifications()
returns table (
  id uuid,
  type text,
  title text,
  body text,
  data jsonb,
  is_read boolean,
  created_at timestamptz
)
language sql
security invoker
stable
as $$
  select
    n.id,
    n.type,
    n.title,
    n.body,
    n.data,
    n.is_read,
    n.created_at
  from public.notifications n
  where n.user_id = auth.uid()
    and n.is_read = false
  order by n.created_at desc;
$$;
