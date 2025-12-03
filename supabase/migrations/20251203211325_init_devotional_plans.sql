-- Devotional Plans
create table if not exists public.devotional_plans (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text not null,
  cover_image text,
  tags text[] default '{}',
  total_days int not null default 1,
  author_id uuid references auth.users(id) on delete set null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()

);


alter table public.devotional_plans enable row level security;



create policy "plans are viewable by everyone"
  on public.devotional_plans
  for select
  using (true);


create policy "only authenticated users can create plans"
  on public.devotional_plans
  for insert
  with check (auth.uid() = author_id);

create policy "authors can update their plans"
  on public.devotional_plans
  for update
  using (auth.uid() = author_id)
  with check (auth.uid() = author_id);

create policy "authors can delete their plans"
  on public.devotional_plans
  for delete
  using (auth.uid() = author_id);