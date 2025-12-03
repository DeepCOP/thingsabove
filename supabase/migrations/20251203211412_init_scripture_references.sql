create table if not exists public.scripture_references (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  day_id uuid references public.devotional_days(id) on delete cascade,
  reference text[] default '{}',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);


alter table public.scripture_references enable row level security;


create policy "scripture refs public read"
  on public.scripture_references
  for select using (true);


create policy "authors manage scripture refs"
  on public.scripture_references
  for all
  using (
    exists (
      select 1
      from public.devotional_days d
      join public.devotional_plans p on d.plan_id = p.id
      where d.id = day_id
      and p.author_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from public.devotional_days d
      join public.devotional_plans p on d.plan_id = p.id
      where d.id = day_id
      and p.author_id = auth.uid()
    )
  );


  create index if not exists idx_scripture_refs_user_id 
  on public.scripture_references(user_id);