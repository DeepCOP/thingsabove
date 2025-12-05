create table if not exists public.devotional_days (
  id uuid primary key default gen_random_uuid(),
  plan_id uuid references public.devotional_plans(id) on delete cascade,
  day_number int not null,
  content text not null,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique (plan_id, day_number)
);

alter table public.devotional_days enable row level security;


create policy "devotional_days are public read"
  on public.devotional_days
  for select
  using (true);

create policy "authors insert days"
  on public.devotional_days
  for insert
  with check (
    exists (
      select 1
      from public.devotional_plans p
      where p.id = plan_id 
      and p.author_id = auth.uid()
    )
  );

create policy "authors update days"
  on public.devotional_days
  for update
  using (
    exists (
      select 1
      from public.devotional_plans p
      where p.id = plan_id 
      and p.author_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from public.devotional_plans p
      where p.id = plan_id 
      and p.author_id = auth.uid()
    )
  );

create policy "authors delete days"
  on public.devotional_days
  for delete
  using (
    exists (
      select 1
      from public.devotional_plans p
      where p.id = plan_id 
      and p.author_id = auth.uid()
    )
  );


create index if not exists idx_devotional_days_plan_id 
  on public.devotional_days(plan_id);

create index if not exists idx_devotional_days_day_number 
  on public.devotional_days(day_number);