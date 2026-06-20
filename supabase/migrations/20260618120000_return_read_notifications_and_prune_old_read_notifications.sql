drop function if exists public.get_my_notifications();

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
  order by n.created_at desc;
$$;

create index if not exists idx_notifications_read_created_at
on public.notifications (created_at)
where is_read = true;

create or replace function public.prune_old_read_notifications()
returns integer
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_deleted_count integer;
begin
  delete from public.notifications n
  where n.is_read = true
    and n.created_at < now() - interval '30 days';

  get diagnostics v_deleted_count = row_count;

  return v_deleted_count;
end;
$$;

do $$
declare
  v_job_id bigint;
begin
  select jobid
    into v_job_id
  from cron.job
  where jobname = 'prune-old-read-notifications'
  limit 1;

  if v_job_id is not null then
    perform cron.unschedule(v_job_id);
  end if;
end
$$;

select
  cron.schedule(
    'prune-old-read-notifications',
    '15 3 * * *',
    $$select public.prune_old_read_notifications();$$
  );
