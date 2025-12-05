-- Plan Progress
create table if not exists public.plan_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  current_day int not null default 1,
  completed_days int[] default '{}',
  updated_at timestamptz default now(),
  created_at timestamptz default now(),
  unique (user_id, plan_id)
);

alter table public.plan_progress enable row level security;


create policy "users can view their own progress"
  on public.plan_progress
  for select
  using (auth.uid() = user_id);


create policy "users can insert their own progress"
  on public.plan_progress
  for insert
  with check (auth.uid() = user_id);

create policy "users can update their own progress"
  on public.plan_progress
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create index if not exists idx_progress_user on public.plan_progress(user_id);
create index if not exists idx_progress_plan on public.plan_progress(plan_id);