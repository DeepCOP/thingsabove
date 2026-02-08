
-- Enable pg_cron for scheduled jobs
create extension if not exists pg_cron;

-- Enable http extension for calling edge functions
create extension if not exists pg_net;

-- Enable Vault for secrets
create extension if not exists supabase_vault;

select
  cron.schedule(
  'daily-encouragement-generator',
    '0 6 * * *',
    $$
      select net.http_post(
        url := (select decrypted_secret from vault.decrypted_secrets where name = 'project_url') || '/functions/v1/generate-daily-notifications',
        headers := jsonb_build_object(
          'Content-Type', 'application/json',
          'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'service-role-key')
        ),
        body := jsonb_build_object('triggered_at', now())
      );
    $$
  );


select
  cron.schedule(
  'daily-encouragement-sender',
    '* * * * *',
    $$
      select net.http_post(
        url := (select decrypted_secret from vault.decrypted_secrets where name = 'project_url') || '/functions/v1/send-daily-encouragement',
        headers := jsonb_build_object(
          'Content-Type', 'application/json',
          'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'service-role-key')
        ),
        body := jsonb_build_object('triggered_at', now())
      );
    $$
  );



select
  cron.schedule(
    'queue_daily_notifications',
    '5 6 * * *',
    $$select queue_daily_notifications();$$
  );



select
  cron.schedule(
  'send-occasional-notifications',
    '5 * * * *',
    $$
      select net.http_post(
        url := (select decrypted_secret from vault.decrypted_secrets where name = 'project_url') || '/functions/v1/send-occasional-notifications',
        headers := jsonb_build_object(
          'Content-Type', 'application/json',
          'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'service-role-key')
        ),
        body := jsonb_build_object('triggered_at', now())
      );
    $$
  );

select
  cron.schedule(
  'generate-ai-notifications',
    '0 * * * *',
    $$
      select net.http_post(
        url := (select decrypted_secret from vault.decrypted_secrets where name = 'project_url') || '/functions/v1/generate-ai-notifications',
        headers := jsonb_build_object(
          'Content-Type', 'application/json',
          'Authorization', 'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'service-role-key')
        ),
        body := jsonb_build_object('triggered_at', now())
      );
    $$
  );


  select
  cron.schedule(
    'generate_ai_triggers',
    '0 6 * * *',
    $$select generate_ai_triggers();$$
  );
