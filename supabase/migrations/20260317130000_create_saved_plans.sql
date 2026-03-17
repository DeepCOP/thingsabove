create table if not exists public.saved_plans (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  plan_id uuid not null references public.devotional_plans(id) on delete cascade,
  created_at timestamptz default now(),
  unique (user_id, plan_id)
);

alter table public.saved_plans enable row level security;

create index if not exists idx_saved_plans_user on public.saved_plans(user_id);
create index if not exists idx_saved_plans_plan on public.saved_plans(plan_id);

create policy "users can view own saved plans"
on public.saved_plans
for select
using (auth.uid() = user_id);

create policy "users can save plans"
on public.saved_plans
for insert
with check (auth.uid() = user_id);

create policy "users can unsave plans"
on public.saved_plans
for delete
using (auth.uid() = user_id);
