create or replace function public.enqueue_plan_submission_screening()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
begin
  if new.status = 'submitted' then
    perform net.http_post(
      url := (select decrypted_secret from vault.decrypted_secrets where name = 'project_url')
        || '/functions/v1/screen-plan-submission',
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer ' || (
          select decrypted_secret
          from vault.decrypted_secrets
          where name = 'service-role-key'
        )
      ),
      body := jsonb_build_object(
        'submission_id', new.id
      )
    );
  end if;

  return new;
end;
$$;

drop trigger if exists enqueue_plan_submission_screening on public.plan_submissions;
create trigger enqueue_plan_submission_screening
  after insert on public.plan_submissions
  for each row
  execute procedure public.enqueue_plan_submission_screening();
