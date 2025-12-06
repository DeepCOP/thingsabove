-- Reports
create table if not exists public.reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  reason text not null,
  created_at timestamptz default now(),
);


alter table public.reports enable row level security;


create policy "admins can view reports"
  on public.reports
  for select
  using (auth.jwt() ->> 'role' = 'admin');

create policy "users can insert their own reports"
  on public.reports
  for insert
  with check (auth.uid() = user_id);

create policy "no updates on reports"
  on public.reports
  for update
  using (false);

create policy "no deletes on reports"
  on public.reports
  for delete
  using (false);


create index if not exists idx_reports_user_id 
  on public.reports(user_id);

create index if not exists idx_reports_plan_id 
  on public.reports(plan_id);