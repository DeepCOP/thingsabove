create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  content text not null,
  entity_type text check (entity_type in ('plan', 'day')),
  entity_id uuid not null,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);


alter table public.comments enable row level security;


create policy "comments readable by everyone"
  on public.comments
  for select
  using (true);

create policy "logged in users can insert comments"
  on public.comments
  for insert
  with check (auth.uid() = user_id);

create policy "comment owners can update"
  on public.comments
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


create policy "comment owners can delete"
  on public.comments
  for delete
  using (auth.uid() = user_id);


create index if not exists idx_comments_entity 
  on public.comments(entity_type, entity_id);

create index if not exists idx_comments_user_id 
  on public.comments(user_id);