-- Plan ratings (1-5 stars) with one rating per user per plan.

create table if not exists public.plan_ratings (
  id uuid primary key default gen_random_uuid(),
  plan_id uuid not null references public.devotional_plans(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  rating int not null check (rating between 1 and 5),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (plan_id, user_id)
);

alter table public.plan_ratings enable row level security;

drop policy if exists "users can view plan ratings" on public.plan_ratings;
create policy "users can view plan ratings"
  on public.plan_ratings
  for select
  using (true);

drop policy if exists "users can insert own plan ratings" on public.plan_ratings;
create policy "users can insert own plan ratings"
  on public.plan_ratings
  for insert
  with check (auth.uid() = user_id);

drop policy if exists "users can update own plan ratings" on public.plan_ratings;
create policy "users can update own plan ratings"
  on public.plan_ratings
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create index if not exists idx_plan_ratings_plan on public.plan_ratings(plan_id);
create index if not exists idx_plan_ratings_user on public.plan_ratings(user_id);

create or replace function public.upsert_plan_rating(
  p_plan_id uuid,
  p_rating int
)
returns void
language plpgsql
security definer
set search_path = public, auth, pg_catalog
as $$
declare
  v_user_id uuid;
begin
  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Not authenticated';
  end if;

  if p_rating < 1 or p_rating > 5 then
    raise exception 'Rating must be between 1 and 5';
  end if;

  insert into public.plan_ratings (plan_id, user_id, rating)
  values (p_plan_id, v_user_id, p_rating)
  on conflict (plan_id, user_id)
  do update set
    rating = excluded.rating,
    updated_at = now();
end;
$$;

create or replace function public.get_my_plan_rating(
  p_plan_id uuid
)
returns int
language sql
security definer
set search_path = public, auth, pg_catalog
as $$
  select pr.rating
  from public.plan_ratings pr
  where pr.plan_id = p_plan_id
    and pr.user_id = auth.uid()
  limit 1;
$$;
