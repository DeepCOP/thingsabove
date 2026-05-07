create or replace function public.enqueue_group_day_completed_push()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
begin
  if new.type = 'group_day_completed' then
    perform net.http_post(
      url := (select decrypted_secret from vault.decrypted_secrets where name = 'project_url')
        || '/functions/v1/send-notification-push',
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer ' || (
          select decrypted_secret
          from vault.decrypted_secrets
          where name = 'service-role-key'
        )
      ),
      body := jsonb_build_object(
        'notification_id', new.id
      )
    );
  end if;

  return new;
end;
$$;

drop trigger if exists enqueue_group_day_completed_push on public.notifications;
create trigger enqueue_group_day_completed_push
  after insert on public.notifications
  for each row
  when (new.type = 'group_day_completed')
  execute function public.enqueue_group_day_completed_push();
