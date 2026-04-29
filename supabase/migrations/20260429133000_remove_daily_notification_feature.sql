do $$
declare
  v_job_id bigint;
begin
  for v_job_id in
    select jobid
    from cron.job
    where jobname in (
      'daily-encouragement-generator',
      'daily-encouragement-sender',
      'queue_daily_notifications'
    )
  loop
    perform cron.unschedule(v_job_id);
  end loop;
end
$$;


drop function if exists public.queue_daily_notifications();

drop table if exists public.ai_notifications;
drop table if exists public.ai_daily_messages;
