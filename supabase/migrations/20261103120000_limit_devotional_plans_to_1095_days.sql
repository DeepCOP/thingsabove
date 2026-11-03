alter table public.devotional_plans
  add constraint devotional_plans_total_days_check
  check (total_days between 1 and 1095);

alter table public.devotional_days
  add constraint devotional_days_day_number_check
  check (day_number between 1 and 1095);

alter table public.devotional_days_draft
  add constraint devotional_days_draft_day_number_check
  check (day_number between 1 and 1095);

alter table public.plan_submissions
  drop constraint if exists plan_submissions_submitted_total_days_check;

alter table public.plan_submissions
  add constraint plan_submissions_submitted_total_days_check
  check (submitted_total_days between 1 and 1095);
